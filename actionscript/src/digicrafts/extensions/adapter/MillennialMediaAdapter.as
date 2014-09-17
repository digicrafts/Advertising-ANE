/**
 * Created by tsangwailam on 11/8/14.
 */
package digicrafts.extensions.adapter {
import digicrafts.extensions.adapter.*;
import digicrafts.extensions.core.AbstractAdaper;
import digicrafts.extensions.data.AdNetworkType;

public class MillennialMediaAdapter extends AbstractAdaper {

    public var interstitial:String='';
    public var rectangle:String='';

    public var enableLocation:Boolean=false;
    public var age:String='';

    public function MillennialMediaAdapter(appid:String) {
        super(AdNetworkType.MILLENNIALMEDIA,appid);
    }

    /**
     *
     * @return
     */
    override protected function getPropertiesArray():Vector.<String> {
        var properties:Vector.<String>=super.getPropertiesArray();
        properties.push("interstitial");
        properties.push("rectangle");
        properties.push("age");
        properties.push("enableLocation");
        return properties;
    }

    /**
     *
     * @return
     */
    override protected function getPropertiesTypeArray():Vector.<String> {
        var properties:Vector.<String>=super.getPropertiesTypeArray();
        properties.push("string");
        properties.push("string");
        properties.push("string");
        properties.push("boolean");
        return properties;
    }
}
}
