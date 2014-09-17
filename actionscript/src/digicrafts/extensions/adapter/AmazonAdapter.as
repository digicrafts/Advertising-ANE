/**
 * Created by tsangwailam on 11/8/14.
 */
package digicrafts.extensions.adapter {
import digicrafts.extensions.core.AbstractAdaper;
import digicrafts.extensions.data.AdNetworkType;

public class AmazonAdapter extends AbstractAdaper {

    public var enableGeoLocation:Boolean=false;
    public var age:int=0;

    public function AmazonAdapter(appKey:String) {
        super(AdNetworkType.AMAZON,appKey);
    }

    /**
     *
     * @return
     */
    override protected function getPropertiesArray():Vector.<String> {
        var properties:Vector.<String>=super.getPropertiesArray();
        properties.push("enableGeoLocation");
        properties.push("age");
        return properties;
    }

    /**
     *
     * @return
     */
    override protected function getPropertiesTypeArray():Vector.<String> {
        var properties:Vector.<String>=super.getPropertiesTypeArray();
        properties.push("boolean");
        properties.push("int");
        return properties;
    }
}
}
