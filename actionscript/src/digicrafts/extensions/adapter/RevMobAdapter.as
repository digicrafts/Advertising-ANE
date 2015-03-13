/**
 * Created by tsangwailam on 11/8/14.
 */
package digicrafts.extensions.adapter {

import digicrafts.extensions.data.AdNetworkType;
import digicrafts.extensions.core.AbstractAdaper;

public class RevMobAdapter extends AbstractAdaper {

    public var enableLocation:Boolean=false;
    public var testDevices:Vector.<String>;

    /**
     * Constructor
     * @param id
     * @param priority
     * @param weight
     */
    public function RevMobAdapter(adUnitId:String) {

        testDevices=new Vector.<String>();

        super(AdNetworkType.REVMOB,adUnitId);
    }

    /**
     *
     * @return
     */
    override protected function getPropertiesArray():Vector.<String> {
        var properties:Vector.<String>=super.getPropertiesArray();
        properties.push("enableLocation");
        properties.push("testDevices");
        return properties;
    }

    /**
     *
     * @return
     */
    override protected function getPropertiesTypeArray():Vector.<String> {
        var properties:Vector.<String>=super.getPropertiesTypeArray();
        properties.push("boolean");
        properties.push("array_string");
        return properties;
    }
}
}
