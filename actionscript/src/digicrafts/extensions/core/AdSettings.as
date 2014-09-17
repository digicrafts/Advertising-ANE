/**
 * Created by tsangwailam on 7/8/14.
 */
package digicrafts.extensions.core {

import digicrafts.extensions.Advertising;
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
        _index = 0;

//        //
//        if(options!=null){
//
//            if(options is Array){
//
//            } else {
//
//                // Loop the options and get the settings
//                for (var key:String in options) {
//
//                    //
//                    var priority:int = -1;
//                    var weight:int = -1;
//                    var id:String;
//                    if (isFinite(options["priority"])) priority = options["priority"];
//                    if (isFinite(options["weight"])) priority = options["weight"];
//
//                    //
//                    switch (key) {
//                        case AdNetworkType.ADMOB:
//                            add(new AdMobAdapter(id), priority, weight);
//                            break;
//                        case AdNetworkType.IAD:
//                            add(new AdMobAdapter(id), priority, weight);
//                            break;
//                        case AdNetworkType.AMAZON:
//                            add(new AdMobAdapter(id), priority, weight);
//                            break;
//                    }
//                }
//            }
//        }

    }

    /**
     * Add a new adapter to the settings.
     * @param adapter
     * @param priority
     * @param weight
     */
    public function add(adapter:AbstractAdaper,priority:int=-1,weight:int=1):void
    {
        trace('add',adapter.network,priority,weight);

        // ignore iad in android devices
        if(Advertising.isAndroid&&adapter.network==AdNetworkType.IAD){


        } else {

            // create a setting object
            var setting:AdSetting = new AdSetting();
            setting.priority = priority;
            setting.weight = weight;
            setting.adapter = adapter;

            // add to the settings array
            _settings.push(setting);

            // update the priority
            _updatePriority();
            _updateWeight();
        }
    }

    /**
     *
     * @return
     */
    public function clone():AdSettings
    {
        var settings:AdSettings=new AdSettings();

        // add the settings
        for each(var s:AdSetting in _settings){

            // ignore iad in android devices
            if(Advertising.isAndroid&&s.adapter.network==AdNetworkType.IAD){


            } else {
                // create a setting object
                var setting:AdSetting = new AdSetting();
                setting.priority = s.priority;
                setting.weight = s.weight;
                setting.adapter = s.adapter;
                settings._settings.push(setting);
            }
        }


        return settings;
    }

    /**
     * Get the next adapter use to display the ads.
     * @return
     */
    ad_internal function nextAdapter():void
    {
        if(_settings.length>0) {

            // get current setting
            var current_setting:AdSetting = _settings[_index];
            // increase weight of current setting
            current_setting.currentWeight++;

            var index:int = _index;
            var count:int = _settings.length;
            var loop:Boolean = true;
            var noreset:Boolean = true;

            while(loop&&noreset) {

                // add the index
                index++;
                if (index >= _settings.length) index = 0;

                var setting:AdSetting = _settings[index];
                if (setting.currentWeight < setting.weight) {
                    _index = index;
                    loop = false;
                }
                count--;
                if(count<=0) {
                    noreset = false;
                    _index = index;
                }
            }
//            print debug info
//            trace("index",_index);
//            for(var i:int=0;i<_settings.length;i++){
//                var  setting:AdSetting=_settings[i];
//                trace(i,setting.adapter.network,setting.priority,setting.weight,setting.currentWeight);
//            }

            // reset all weight
            if(!noreset){
                for each(var s:AdSetting in _settings)
                    s.currentWeight=0;
            }
        }
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
//        trace('_updatePriority');
        if(_settings){
            _settings.sort(_sortOnPriority);
        }

//        for(var i:int=0;i<_settings.length;i++){
//            var  setting:AdSetting=_settings[i];
//            trace(i,setting.adapter.network,setting.priority,setting.weight);
//        }
    }

    /**
     * Update the weight of each adapter.
     */
    private function _updateWeight():void
    {

    }

}
}