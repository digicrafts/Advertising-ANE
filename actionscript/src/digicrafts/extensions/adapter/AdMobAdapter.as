/**
 * Created by tsangwailam on 11/8/14.
 */
package digicrafts.extensions.adapter {

import digicrafts.extensions.core.ad_internal;
import digicrafts.extensions.data.AdNetworkType;
import digicrafts.extensions.core.AbstractAdaper;

public class AdMobAdapter extends AbstractAdaper {

    public var testDevices:Vector.<String>;

    /**
     * Constructor
     * @param id
     * @param priority
     * @param weight
     */
    public function AdMobAdapter(adUnitId:String, priority:int=0, weight:int=0) {

        testDevices=new Vector.<String>();

        super(AdNetworkType.ADMOB,priority,weight,adUnitId);
    }

    /**
     *
     * @return
     */
    override protected function getPropertiesArray():Vector.<String> {
        var properties:Vector.<String>=super.getPropertiesArray();
        properties.push("testDevices");
        return properties;
    }

    /**
     *
     * @return
     */
    override protected function getPropertiesTypeArray():Vector.<String> {
        var properties:Vector.<String>=super.getPropertiesTypeArray();
        properties.push("array_string");
        return properties;
    }
}
}
