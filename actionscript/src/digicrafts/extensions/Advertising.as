/**
 * Created by tsangwailam on 30/7/14.
 */
package digicrafts.extensions {
import air.net.URLMonitor;

import digicrafts.extensions.Advertising;
import digicrafts.extensions.adapter.InMobiAdapter;
import digicrafts.extensions.adapter.MillennialMediaAdapter;
import digicrafts.extensions.core.AbstractAdaper;
import digicrafts.extensions.core.Ad;
import digicrafts.extensions.core.AdBanner;
import digicrafts.extensions.core.AdInterstitial;
import digicrafts.extensions.core.AdSettings;
import digicrafts.extensions.data.AdNetworkType;
import digicrafts.extensions.data.AdSize;
import digicrafts.extensions.events.AdEvent;
import digicrafts.extensions.core.ad_internal;

import flash.desktop.NativeApplication;
import flash.events.Event;

import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.events.TimerEvent;
import flash.external.ExtensionContext;
import flash.external.ExtensionContext;
import flash.net.URLRequest;
import flash.system.Capabilities;
import flash.utils.Dictionary;
import flash.utils.Timer;
import flash.utils.getTimer;

/** @see digicrafts.extensions.events.AdEvent Dispatched when a banner created and load. */
[Event(name="bannerDidLoad", type="digicrafts.extensions.events.AdEvent")]

/** Dispatched when the banner fail to load. */
[Event(name="bannerDidFail", type="digicrafts.extensions.events.AdEvent")]

/** Dispatched when a interstitial created and load. */
[Event(name="interstitialDidLoad", type="digicrafts.extensions.events.AdEvent")]

/** Dispatched when the interstitial fail to load. */
[Event(name="interstitialDidFail", type="digicrafts.extensions.events.AdEvent")]

public class Advertising extends EventDispatcher{

    /**
     * Set if the apps is publish in kindle store
     */
    public static var isKindleStore:Boolean=false;
    /**
     * Indicate if it is ios device
     */
    public static var isIOS:Boolean=false;
    /**
     * Indicate if it is android device
     */
    public static var isAndroid:Boolean=false;
    /**
     * Default refresh rate of the banner
     */
    public static var defaultBannerRefresh:int=30;
    /**
     *
     */
    public static var logLevel:int=0;

    /**
     * @private static
     */
    private static var _instance:Advertising;
    private static var _allowInstance:Boolean=false;
    private static var _extensionContext:ExtensionContext = null;
    private static var _defaultSettings:AdSettings;
    private static var _testMode:Boolean;
    private static var _timeout:int=30000;

    /**
     * @private
     */
    private var mCurrentInterstitialId:String;
    private var mBannerDictionary:Dictionary;
    private var mInterstitialDictionary:Dictionary;
    private var mTimer:Timer;
    private var mLastTimer:Number;
    private var mInternetMonitor:URLMonitor;

    /**
     * Advertising Air native extension allows you to monetize your mobile with different advertising
     * network in an easier way.<br><br>
     *
     * Note that this class is a singleton. Do not try to instantiate it, but call
     * <code>getInstance()</code> instead.<br><br>
     *
     * @see AdEvent
     */
    public function Advertising() {

        if(!_allowInstance){
            throw new Error("Error: Instantiation failed: Use Advertising.getInstance() instead of new.");
        } else {

            if ( !_extensionContext && Capabilities.os.indexOf("x86_64")==-1)
            {
                log(0,"Create Advertising Extension Instance.");

                // Create extension context instance
                _extensionContext = ExtensionContext.createExtensionContext("digicrafts.extensions.Advertising","Advertising");

                if(_extensionContext) {

                    // Add listener
                    _extensionContext.addEventListener(StatusEvent.STATUS, _handleStatusEvents, false, 0, true);
                    NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, _handleActivate, false, 0, true);
                    NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, _handleDeactivate, false, 0, true);

                    // init var
                    testMode = false;
                    isAndroid = (Capabilities.manufacturer.indexOf("Android") != -1);
                    isIOS = (Capabilities.manufacturer.indexOf("iOS") != -1);
                    mBannerDictionary = new Dictionary(true);
                    mInterstitialDictionary = new Dictionary(true);

                    // init extension
                    _extensionContext.call('ext_initialize');

                    // Create timer
                    mTimer=new Timer(500);
                    mTimer.addEventListener(TimerEvent.TIMER, _handleTimerEvent);

                    // Create connection monitor
                    // Setup internet monitor
                    var url:URLRequest = new URLRequest("http://www.google.com");
                    url.method = "HEAD";
                    mInternetMonitor = new URLMonitor(url);
                    mInternetMonitor.pollInterval=4000;
                    mInternetMonitor.addEventListener(StatusEvent.STATUS, _handleCheckInternetConnection);
                    mInternetMonitor.start();

                    log(0, "Advertising Extension Instance Ready.");
                    // fake activate event right here because we miss it on the first app load
                    _handleActivate(null);


                } else {
                    throw new Error("Error: Instantiation failed: Extension can't created.");
                }
            }
        }
    }

    /**
     * Clean up the ANE
     */
    public function dispose():void {
        if(mTimer){
            mTimer.stop();
            mTimer.removeEventListener(TimerEvent.TIMER, _handleTimerEvent);
        }
        NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, _handleActivate);
        NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE, _handleDeactivate);
        destroyAllBanner();
        destroyAllInterstitial();
        _extensionContext.dispose();
        _instance.mBannerDictionary=null;
        _instance.mInterstitialDictionary=null;
        _instance=null;
    }

// Private Static Function
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Return the instance of Advertising singleton
     * @return
     *
     */
    public static function getInstance():Advertising
    {
        if(_instance==null){
            _allowInstance=true;
            _instance=new Advertising();
            _allowInstance=false;
        }
        return _instance;
    }

// Public Static Function
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Check if the extension is supported
     */
    public static function isSupported():Boolean
    {
        getInstance();
        return (_extensionContext!=null);
    }

    /**
     * Test mode enabled/disabled
     */
    public static function get timeout():int {return _timeout}
    public static function set timeout(value:int):void
    {
        _timeout=value*1000;
    }

    /**
     * Test mode enabled/disabled
     */
    public static function get testMode():Boolean {return _testMode}
    public static function set testMode(value:Boolean):void
    {
        getInstance();
        if(isSupported()&&value!=_testMode){
            _testMode=value;
            _extensionContext.call("ext_testMode",value);
        }
    }

    /**
     * (Optional) Initializes the default settings by key pair object.
     * @param options
     */
    public static function init(options:Object):void
    {
        // check if already init
        if(_defaultSettings==null)
            _defaultSettings=new AdSettings(options);
    }

    /**
     * Get a banner Ads with specified id.
     * @param id Id of the banner. If not specify or null, a random id will be generated.
     * @param size Size of the banner.
     * @param setting (Optional) Setting for running the banner. Use default setting if not specified
     * @return
     */
    public static function getBanner(id:String,size:String=AdSize.BANNER,setting:AdSettings=null):AdBanner
    {
        if(isSupported()){

            if(!AdSize.ad_internal::VALID_BANNER_SIZE[size])
                throw new Error("[Advertising ANE] invalid banner size: "+size);

            // check if banner id exist
            if(_instance.mBannerDictionary[id]) {

                log(0,'Banner id "'+id+'" already exist.');

            } else {

                if(setting==null && _defaultSettings==null){

                    log(0,'No setting specified and default setting null.');

                } else {

                    // create the banner instance
                    Ad.ad_internal::allowInstance=true;
                    var banner:AdBanner = new AdBanner(setting, id, size);
                    Ad.ad_internal::allowInstance=false;
                    // add the banner to dictionary
                    _instance.mBannerDictionary[id] = banner;

                }

            }
            return _instance.mBannerDictionary[id];
        }

        return null;
    }

    /**
     * Create an interstitial Ads
     * @param id Id of the banner. If not specify or null, a random id will be generated.
     * @param setting Setting for running the interstitial. Use default setting if not specified
     * @return
     */
    public static function getInterstitial(id:String=null,setting:AdSettings=null):AdInterstitial
    {
        if(isSupported()){

            // check if banner id exist
            if(_instance.mInterstitialDictionary[id]) {

                log(0,'Get Intersitial with id: '+id);

            } else {

                log(0,'Create Intersitial with id: '+id);

                // create the Intersitial instance
                Ad.ad_internal::allowInstance=true;
                var intersitial:AdInterstitial = new AdInterstitial(setting, id);
                Ad.ad_internal::allowInstance=false;
                // add the Intersitial to dictionary
                _instance.mInterstitialDictionary[id] = intersitial;
            }
            return _instance.mInterstitialDictionary[id];
        }
        return null;
    }

    /**
     * Display the banner in position
     * @param id Id of the banner that want to display.
     * @param position The position of the banner
     * @param refresh Timer to refresh the ads in second. Zero means don't auto refresh. -1 means use Advertising.defaultBannerRefresh.
     * @param offsetX
     * @param offsetY
     */
    public static function showBanner(id:String, position:String, refresh:int=-1, offsetX:int=0, offsetY:int=0):void
    {
        if(isSupported()){

            // get the banner
            var banner:AdBanner=_instance.mBannerDictionary[id];

            // check if banner id exist
            if(banner) {

                banner.show(position,refresh,offsetX,offsetY);

            } else {

                log(0,'Banner id '+id+'not exist');
            }
        }
    }

    /**
     * Display the banner in x/y position
     * @param id Id of the banner that want to display.
     * @param x The x coordination where to display the banner
     * @param y The y coordination where to display the banner
     * @param refresh Timer to refresh the ads in second. Zero means don't auto refresh. -1 means use Advertising.defaultBannerRefresh.
     */
//    public static function showBannerXY(id:String,x:Number,y:Number,refresh:int=-1):void
//    {
//        if(isSupported()){
//
//            // get the banner
//            var banner:AdBanner=_instance.mBannerDictionary[id];
//
//            // check if banner id exist
//            if(banner) {
//
//                banner.showXY(x,y,refresh);
//
//            } else {
//
//                log(0,'Banner id '+id+'not exist');
//            }
//        }
//    }

    /**
     * Remove the banner with specify id from the screen
     * @param id Id of the banner that want to remove.
     */
    public static function removeBanner(id:String):void
    {
        if(isSupported()){

            // get the banner
            var banner:AdBanner=_instance.mBannerDictionary[id];

            // check if banner id exist
            if(banner) {

                banner.remove();

            } else {

                log(0,'Banner id '+id+'not exist');
            }
        }
    }

    /**
     * Remove all the banner from the screen
     */
    public static function removeAllBanner():void
    {
        if(isSupported()){
            for each(var banner:AdBanner in _instance.mBannerDictionary){
                banner.remove();
            }
        }
    }

    /**
     * Display the interstitial
     * @param id Id of the interstitial that want to display.
     * @param frequency Frequency to display ads. Value 0 means show every time.
     * @param maxCount The max count of the ads display. Value 0 means no limit.
     */
    public static function showInterstitial(id:String,frequency:uint=1,maxCount:uint=0):void
    {
        if(isSupported()){

            // remove current interstitial
            removeInterstitial();

            // get the Intersitial
            var intersitial:AdInterstitial=_instance.mInterstitialDictionary[id];

            // check if Intersitial id exist
            if(intersitial) {

                _instance.mCurrentInterstitialId=id;
                intersitial.show(frequency,maxCount);

            } else {

                log(0,'Intersitial id '+id+'not exist');
            }
        }
    }

    /**
     * Remove the current interstitial on the screen
     */
    public static function removeInterstitial():void
    {
        if(isSupported()&&_instance.mCurrentInterstitialId){

            // get the banner
            var intersitial:AdInterstitial=_instance.mInterstitialDictionary[_instance.mCurrentInterstitialId];

            // check if banner id exist
            if(intersitial) {

                intersitial.remove();

            } else {

                log(0,'No interstitial exist');
            }
        }
    }

    /**
     * Destroy the banner with specify id
     * @param id Id of the banner that want to destroy.
     * @return
     */
    public static function destroyBanner(id:String):Boolean
    {
        if(isSupported()){

            // get the banner
            var banner:AdBanner=_instance.mBannerDictionary[id];

            // check if banner id exist
            if(banner) {

                _instance.mBannerDictionary[id]=null;
                banner.destroy();
                delete _instance.mBannerDictionary[id];

            } else {

                log(0,'Banner id '+id+'not exist');
            }
        }
        return false;
    }

    /**
     * Destroy the interstitial with specify id
     * @param id Id of the interstitial that want to destroy.
     * @return
     */
    public static function destroyInterstitial(id:String):AdInterstitial
    {
        if(isSupported()){

            // remove current interstitial
            removeInterstitial();

            // get the Intersitial
            var intersitial:AdInterstitial=_instance.mInterstitialDictionary[id];

            // check if Intersitial id exist
            if(intersitial) {

                _instance.mInterstitialDictionary[id]=null;
                intersitial.destroy();
                delete _instance.mInterstitialDictionary[id];

            } else {

                log(0,'Intersitial id '+id+'not exist');
            }
        }
        return null;
    }

    /**
     * Destroy all the banner
     */
    public static function destroyAllBanner():void
    {
        if(isSupported()){

            if(_extensionContext){
                for(var id:String in _instance.mBannerDictionary){
                    var banner:AdBanner=_instance.mBannerDictionary[id];
                    if(banner) {
                        banner.remove();
                        _instance.mBannerDictionary[id] = null;
                        banner.destroy();
                        delete _instance.mBannerDictionary[id];
                    }
                }
            }
        }
    }

    /**
     * Destroy all the interstitial
     */
    public static function destroyAllInterstitial():void
    {
        if(isSupported()){
            for(var id:String in _instance.mInterstitialDictionary){
                var intersitial:AdInterstitial=_instance.mInterstitialDictionary[id];
                intersitial.remove();
                _instance.mInterstitialDictionary[id]=null;
                intersitial.destroy();
                delete _instance.mInterstitialDictionary[id];
            }
        }
    }



// Private Static Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    ad_internal static function get internetAvailabile():Boolean
    {
        if(isSupported())
            return _instance.mInternetMonitor.available;
        return false;
    }

    ad_internal static function extCreate(ad:Ad):void
    {
        // check if banner id exist
        if(_extensionContext&&ad) {

            // get the current adapter
            var adapter:AbstractAdaper=ad.setting.ad_internal::getCurrentAdapter();

            var adUnitId:String=getAdUnitId(adapter,ad.size);

            _extensionContext.call('ext_create',ad.id, ad.size, adapter.network, adUnitId, adapter.ad_internal::getFREArray());

        }
    }

    ad_internal static function extLoad(ad:Ad):void
    {
        // check if banner id exist
        if(_extensionContext&&ad) {

            // get the current adapter
            var adapter:AbstractAdaper=ad.setting.ad_internal::getCurrentAdapter();

            var adUnitId:String=getAdUnitId(adapter,ad.size);

            trace("extLoad",adapter.network,ad.size,adapter.adUnitId);

            _extensionContext.call('ext_load',ad.id, ad.size, adapter.network, adUnitId, adapter.ad_internal::getFREArray());
        }
    }

    ad_internal static function extShow(ad:Ad, position:String, x:int=0, y:int=0, w:int=0, h:int=0):void
    {
        // check if banner id exist
        if(_extensionContext&&ad) {

            // get the current adapter
            var adapter:AbstractAdaper=ad.setting.ad_internal::getCurrentAdapter();

            var adUnitId:String=getAdUnitId(adapter,ad.size);

            trace("extShow",adapter.network,ad.size,adapter.adUnitId,x,y);

            _extensionContext.call('ext_show',ad.id, ad.size, adapter.network, adUnitId, adapter.ad_internal::getFREArray(), position, x, y);
        }
    }

    ad_internal static function extRemove(ad:Ad):void
    {
        // check if banner id exist
        if(_extensionContext&&ad) {
            _extensionContext.call('ext_remove',ad.id);
        }
    }

    ad_internal static function extDestroy(ad:Ad):void
    {
        // check if banner id exist
        if(_extensionContext&&ad) {
            _extensionContext.call('ext_destroy',ad.id);
        }
    }

// Private Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Select unitId for each network
     * @param adapter
     * @return
     */
    private static function getAdUnitId(adapter:AbstractAdaper,size:String):String
    {
        var adUnitId:String=adapter.adUnitId;

        if(adapter.network==AdNetworkType.MILLENNIALMEDIA){

            var mm_adapter:MillennialMediaAdapter=adapter as MillennialMediaAdapter;

            if(size==AdSize.INTERSTITIAL&&mm_adapter.interstitial!=null&&mm_adapter.interstitial!='')
                adUnitId=mm_adapter.interstitial;
            else if(size==AdSize.MEDIUM_RECTANGLE&&mm_adapter.rectangle!=null&&mm_adapter.rectangle!='')
                adUnitId=mm_adapter.rectangle;

        }
//        else if(adapter.network==AdNetworkType.INMOBI){
//
//            var in_adapter:InMobiAdapter=adapter as InMobiAdapter;
//
//            if(size==AdSize.INTERSTITIAL&&in_adapter.interstitial!=null&&in_adapter.interstitial!='')
//                adUnitId=in_adapter.interstitial;
//            else if(size==AdSize.BANNER&&in_adapter.banner!=null&&in_adapter.banner!='')
//                adUnitId=in_adapter.banner;
//            else if(size==AdSize.FULL_BANNER&&in_adapter.full_banner!=null&&in_adapter.full_banner!='')
//                adUnitId=in_adapter.full_banner;
//            else if(size==AdSize.LEADERBOARD&&in_adapter.leaderboard!=null&&in_adapter.leaderboard!='')
//                adUnitId=in_adapter.leaderboard;
//            else if(size==AdSize.MEDIUM_RECTANGLE&&in_adapter.medium_rectangle!=null&&in_adapter.medium_rectangle!='')
//                adUnitId=in_adapter.medium_rectangle;
//
//        }

        return adUnitId;
    }

    /**
     * @private
     * @param code
     */
    private static function _error(code:int):void
    {

    }

    /**
     * @private
     * @param level
     * @param arg
     */
    protected static function log(level:int,...arg:Array):void {

        if(level<=logLevel) {
            arg.unshift("[AdvertisingANE]");
            trace.apply(null, arg);
        }
    }

// Private Handler Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @private
     * @param e
     *
     */
    private function _handleStatusEvents(e:StatusEvent):void
    {

        log(0,'events',e.code,e.level);

        var ad:Ad;
        var event:AdEvent;
        var data:Object=JSON.parse(e.level);

        // get the banner
        if(data&&data.uid&&data.size){
            if(data.size==AdSize.INTERSTITIAL)
                ad=getInterstitial(data.uid);
            else
                ad=getBanner(data.uid);
        }


        // for different event
        switch (e.code) {
            case "LOGGING":
                log(0,e.level);
            case AdEvent.AD_LOADED:
                if(ad) {
                    ad.ad_internal::loading=false;
                    ad.ad_internal::ready=true;
                }
                break;
            case AdEvent.AD_FAILED_TO_LOAD:
                if(ad) {
                    ad.ad_internal::ready=false;
                    ad.next();
                }
                break;
            case AdEvent.AD_DID_DISMISS:
                if(ad&&ad.size==AdSize.INTERSTITIAL) {
                    ad.ad_internal::ready=false;
                    ad.next();
                }
                break;
        }

        // create the event
        event = new AdEvent(e.code.toString(), false, data);

        if (event) dispatchEvent(event);
    }

    private function _handleTimerEvent(event:TimerEvent):void {

        // calculate time offset
        var t:Number=getTimer();
        var timeOffset:Number=t-mLastTimer;

        // Call each banner timeAdvanced
        for each(var banner:AdBanner in _instance.mBannerDictionary){
            banner.ad_internal::timeAdvanced(timeOffset);
        }

        mLastTimer=t;

    }

    /**
     *
     * @param event
     */
    private function _handleCheckInternetConnection(event:Event):void {

    }

    /**
     *
     * @param event
     */
    private function _handleActivate(event:Event):void {
        if(mTimer) {
            mLastTimer=getTimer();
            mTimer.start();
        }
        if (isSupported() && isAndroid)
            _extensionContext.call("activate");
    }

    /**
     *
     * @param event
     */
    private function _handleDeactivate(event:Event):void {
        if(mTimer) mTimer.stop();
        if (isSupported() && isAndroid)
            _extensionContext.call("deactivate");
    }

}
}
