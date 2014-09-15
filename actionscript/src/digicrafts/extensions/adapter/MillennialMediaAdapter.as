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

    public function MillennialMediaAdapter(id:String, priority:int=0, weight:int=0) {
        super(AdNetworkType.MILLENNIALMEDIA,priority,weight,id);
    }

    /**
     *
     * @return
     */
    override protected function getPropertiesArray():Vector.<String> {
        var properties:Vector.<String>=super.getPropertiesArray();
        properties.push("interstitial");
        properties.push("rectangle");
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
        return properties;
    }
}
}
