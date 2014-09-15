/**
 * Created by tsangwailam on 3/8/14.
 */
package digicrafts.extensions.core {

import digicrafts.extensions.Advertising;
import digicrafts.extensions.core.AbstractAdaper;
import digicrafts.extensions.core.ad_internal;
import digicrafts.extensions.core.ad_internal;
import digicrafts.extensions.core.ad_internal;
import digicrafts.extensions.core.ad_internal;
import digicrafts.extensions.data.AdSize;

import flash.events.EventDispatcher;


public class Ad extends EventDispatcher {

    private var _setting:AdSettings;
    private var _id:String;
    private var _size:String=AdSize.BANNER;
    private var _visible:Boolean=false;
    private var _currentAdapter:AbstractAdaper;

    /**
     * Instance of AdSettings class. Store the config of the ads.
     */
    public function get setting ():AdSettings {return _setting}

    /**
     * The id of the ads instance.
     */
    public function get id ():String {return _id}

    /**
     *
     */
    public function get size ():String {return _size}

    /**
     * Visibility of the ads.
     */
    public function get visible ():Boolean {return _visible}

    /**
     * Set when the banner is ready to display.
     */
    public function get isLoading ():Boolean {return ad_internal::loading}

    /**
     * Set when the banner is ready to display.
     */
    public function get isReady ():Boolean {return ad_internal::ready}

    /**
     * The current network adapter use to show the ads.
     */
    public function get currentAdapter ():AbstractAdaper { return _currentAdapter}

    /**
     *  internal var
     */
    ad_internal static var allowInstance:Boolean=false;
    ad_internal var uid:int = -1;
    ad_internal var refresh:int = 0;  // Frequency to show ads
    ad_internal var frequency:int = 1;  // Frequency to show ads
    ad_internal var maxCount:int = 0;   // Store the max display count
    ad_internal var callCount:int = 0;  // Store the count which calling show()
    ad_internal var showCount:int = 0;  // Store the count which actually show the ads
    ad_internal var loadingcount:Number = 0;
    ad_internal var timecount:Number = 0;
    ad_internal var ready:Boolean=false;
    ad_internal var loading:Boolean=false;

    /**
     * Abstract class for a basic ads.
     * @param setting
     * @param id
     */
    public function Ad(setting:AdSettings, id:String, size:String=AdSize.BANNER) {

        if(ad_internal::allowInstance){
            if(setting)
                _setting=setting.clone();
            _id=id;
            _size=size;
            ad_internal::loading=true;
            Advertising.ad_internal::extCreate(this);
            super();
        } else {
            throw new Error("Please use Advertising.getBanner or Advertisting.getInterstitial to create instance of ads");
        }

    }

// Public Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Destroy the ads and release resources use by the ads.
     */
    public function destroy():void
    {
        remove();
        Advertising.ad_internal::extDestroy(this);
    }

    /**
     * Remove the ads from the screen.
     */
    public function remove():void
    {
        if(_visible) {
            _visible = false;
            Advertising.ad_internal::extRemove(this);
        }
    }

    /**
     * Refresh current ads.
     */
    public function refresh():void
    {

    }

    /**
     * Switch to next adapter.
     */
    public function next():void
    {
        _next();
    }

// Internal Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    ad_internal function timeAdvanced(t:Number):void
    {

//        trace("time offset",t,
//                "timecount",ad_internal::timecount,
//                "loadingcount",ad_internal::loadingcount,
//                "loading",ad_internal::loading,
//                "visible",_visible,
//                "refresh",ad_internal::refresh);

        // if visible and need to be refresh
        if(_visible&&ad_internal::refresh>0){

            if(ad_internal::ready)
            {
                ad_internal::timecount += t;
                if (ad_internal::timecount > ad_internal::refresh)
                    _next();
            }

        }

        if(ad_internal::loading) {
        // if in loading state
        trace('check loading count',ad_internal::loadingcount,Advertising.timeout);
            ad_internal::loadingcount +=t;
            if (ad_internal::loadingcount > Advertising.timeout)
                _next();
        }
    }

// Private Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////


    /**
     *
     * @param position
     * @param x
     * @param y
     * @param w
     * @param h
     */
    protected function _show(position:String, x:int=0, y:int=0):void
    {
        trace("AD _show",position,x,y);
        ad_internal::callCount++;
        _visible=true;
//        ad_internal::ready=false;
        Advertising.ad_internal::extShow(this, position, x, y );
    }


    protected function _load():void
    {
        trace("AD _load");
        ad_internal::ready=false;
        Advertising.ad_internal::extLoad(this);
    }

    /**
     *
     */
    protected function _next():void
    {
        trace("AD _next",setting);
        if(setting){
            ad_internal::ready=false;
            ad_internal::loading = true;
            ad_internal::timecount = 0;
            ad_internal::loadingcount = 0;
            setting.ad_internal::nextAdapter();
        }

    }
}
}
