/**
 * Created by tsangwailam on 7/8/14.
 */
package digicrafts.extensions.core {

import digicrafts.extensions.adapter.AdMobAdapter;
import digicrafts.extensions.data.AdNetworkType;

public class AdSettings {

    private var _settings:Vector.<AdSetting>;
    private var _index:int;

    /**
     * Constructor
     */
    public function AdSettings(options:Object=null){

        // create a vector to hold the setting
        _settings = new Vector.<AdSetting>();

        //
        if(options!=null){

            if(options is Array){

            } else {

                // Loop the options and get the settings
                for (var key:String in options) {

                    //
                    var priority:int = -1;
                    var weight:int = -1;
                    var id:String;
                    if (isFinite(options["priority"])) priority = options["priority"];
                    if (isFinite(options["weight"])) priority = options["weight"];

                    //
                    switch (key) {
                        case AdNetworkType.ADMOB:
                            add(new AdMobAdapter(id, priority, weight));
                            break;
                        case AdNetworkType.IAD:
                            add(new AdMobAdapter(id, priority, weight));
                            break;
                        case AdNetworkType.AMAZON:
                            add(new AdMobAdapter(id, priority, weight));
                            break;
                    }
                }
            }
        }

    }

    /**
     * Add a new adapter to the settings.
     * @param adapter
     * @param priority
     * @param weight
     */
    public function add(adapter:AbstractAdaper,priority:int=-1,weight:int=-1):void
    {

        var setting:AdSetting=new AdSetting();
        setting.priority=priority;
        setting.weight=weight;
        setting.adapter=adapter;

        // add to the settings array
        _settings.push(setting);

        // update the priority
        _updatePriority();
        _updateWeight();

    }

    /**
     *
     * @return
     */
    public function clone():AdSettings
    {
        var settings:AdSettings=new AdSettings();

        // add the settings
        for each(var s:AdSetting in _settings)
           settings.add(s.adapter,s.priority,s.weight);

        return settings;
    }

    /**
     * Get the next adapter use to display the ads.
     * @return
     */
    ad_internal function nextAdapter():void
    {
        _index++;
        if(_index>=_settings.length) _index=0;
    }

    /**
     * Get the next adapter use to display the ads.
     * @return
     */
    ad_internal function getCurrentAdapter():AbstractAdaper
    {
        if(_settings.length>0) {
            if (_index < _settings.length)
                return _settings[_index].adapter;
            else
                return _settings[0].adapter;
        } else {
            throw new Error("Please add any adapter");
        }
    }


// Private Function
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Funtion use to sort adapter by priority.
     * @param a
     * @param b
     * @return
     */
    private function _sortOnPriority(a:AdSetting, b:AdSetting):Number {

        var aPriority:Number = a.priority;
        var bPriority:Number = b.priority;

        if(aPriority > bPriority) {
            return 1;
        } else if(aPriority < bPriority) {
            return -1;
        }

        return 0;
    }

    /**
     * Update the order of the adapters.
     */
    private function _updatePriority():void
    {
        if(_settings){
            _settings.sort(_sortOnPriority);
        }
    }

    /**
     * Update the weight of each adapter.
     */
    private function _updateWeight():void
    {

    }

}
}

//import digicrafts.extensions.core.AbstractAdaper;
///**
// * @private
// * Private class to hold the setting of each ads.
// */
//class AdSetting {
//    public var priority:int=-1;
//    public var weight:int=-1;
//    public var adapter:AbstractAdaper;
//}

