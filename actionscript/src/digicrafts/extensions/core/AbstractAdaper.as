/**
 * Created by tsangwailam on 3/8/14.
 */
package digicrafts.extensions.core {
public class AbstractAdaper extends Object{

    public var network:String;
    public var adUnitId:String;

    /**
     *
     * @param type
     * @param priority
     * @param weight
     * @param adUnitId
     */
    public function AbstractAdaper(network:String, adUnitId:String="") {

        this.network=network;
        this.adUnitId=adUnitId;
    }

    /**
     *
     * @return
     */
    protected function getPropertiesArray():Vector.<String> {

        var properties:Vector.<String>=new Vector.<String>();

        properties.push("network");
        properties.push("adUnitId");

        return properties;
    }

    /**
     *
     * @return
     */
    protected function getPropertiesTypeArray():Vector.<String> {

        var properties:Vector.<String>=new Vector.<String>();

        properties.push("string");
        properties.push("string");

        return properties;
    }

    ad_internal function getFREArray():Array
    {
        var settingFREArray:Array=[];

        settingFREArray.push(this.getPropertiesArray());
        settingFREArray.push(this.getPropertiesTypeArray());
        settingFREArray.push(this);

        return settingFREArray;
    }

    ad_internal function needInternet():Boolean
    {
        return true;
    }

}
}

