/**
 * Created by tsangwailam on 3/8/14.
 */
package digicrafts.extensions.core {

import digicrafts.extensions.data.AdPosition;
import digicrafts.extensions.data.AdSize;

public class AdInterstitial extends Ad{

    public function AdInterstitial(setting:AdSettings, id:String) {
        super(setting, id, AdSize.INTERSTITIAL);
    }

    /**
     * Display the ads in position on the screen
     * @param frequency
     * @param maxCount
     */
    public function show(frequency:uint=0,maxCount:uint=0):void
    {

        // Set the frequency and max count
        if(frequency>0) ad_internal::frequency=frequency;
        if(maxCount>0) ad_internal::maxCount=maxCount;

        _show(AdPosition.FLOAT,0,0);
    }

    /**
     * @override
     */
    override protected function _next():void
    {
        super._next();

        if(setting&&ad_internal::retry<20) {
            _load();
        }
    }

}
}
