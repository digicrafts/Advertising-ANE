/**
 * Created by tsangwailam on 11/8/14.
 */
package digicrafts.extensions.adapter {

import digicrafts.extensions.core.AbstractAdaper;
import digicrafts.extensions.data.AdNetworkType;

public class InMobiAdapter extends AbstractAdaper {

    public var interstitial:String='';
    public var banner:String='';
    public var smart_banner:String='';
    public var full_banner:String='';
    public var leaderboard:String='';
    public var medium_rectangle:String='';

    public function InMobiAdapter(appId:String) {
        super(AdNetworkType.INMOBI,appId);
    }

    /**
     *
     * @return
     */
    override protected function getPropertiesArray():Vector.<String> {
        var properties:Vector.<String>=super.getPropertiesArray();
        properties.push("interstitial");
        properties.push("banner");
        properties.push("smart_banner");
        properties.push("full_banner");
        properties.push("leaderboard");
        properties.push("medium_rectangle");
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
        properties.push("string");
        properties.push("string");
        properties.push("string");
        return properties;
    }
}
}
