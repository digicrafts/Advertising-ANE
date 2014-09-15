/**
 * Created by tsangwailam on 3/8/14.
 */
package digicrafts.extensions.core {
public class AbstractAdaper extends Object{

    public var network:String;
    public var priority:int=0;
    public var weight:int=0;
    public var adUnitId:String;

    /**
     *
     * @param type
     * @param priority
     * @param weight
     * @param adUnitId
     */
    public function AbstractAdaper(network:String, priority:int, weight:int, adUnitId:String="") {

        this.network=network;
        this.priority=priority;
        this.weight=weight;
        this.adUnitId=adUnitId;
    }

    /**
     *
     * @return
     */
    protected function getPropertiesArray():Vector.<String> {

        var properties:Vector.<String>=new Vector.<String>();

        properties.push("network");
        properties.push("priority");
        properties.push("weight");
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
        properties.push("int");
        properties.push("int");
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

