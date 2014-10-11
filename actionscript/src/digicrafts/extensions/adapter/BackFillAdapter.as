/**
 * Created by tsangwailam on 11/8/14.
 */
package digicrafts.extensions.adapter {

import digicrafts.extensions.core.AbstractAdaper;
import digicrafts.extensions.data.AdNetworkType;

public class BackFillAdapter extends AbstractAdaper {

    /**
     * URL of the banner action
     */
    public var link:String="";
    /**
     * URL of the banner action for IOS. This will override the value of url in IOS device.
     */
    public var iosLink:String="";
    /**
     * URL of the banner action for Android. This will override the value of url in Android device.
     */
    public var androidLink:String="";
    /**
     * URL of the banner action for Kindle. This will override the value of url in Kindle device.
     */
    public var kindleLink:String="";
    /**
     * URL of the image for interstitial.
     */
    public var interstitial:String='';
    /**
     * URL of the image for interstitial.
     */
    public var interstitialCloseButton:String='close_button.png';
    /**
     * URL of the image for banner size AdSize.BANNER (320x50)
     */
    public var banner:String='';
    /**
     * URL of the image for banner size AdSize.FULL_BANNER (468x60)
     */
    public var full_banner:String='';
    /**
     * URL of the image for banner size AdSize.LEADERBOARD (728x90)
     */
    public var leaderboard:String='';
    /**
     * URL of the image for banner size AdSize.MEDIUM_RECTANGLE (300x250)
     */
    public var medium_rectangle:String='';

    /**
     *
     * @param url
     * @param banner
     */
    public function BackFillAdapter(link:String,banner:String="") {

        this.link=link;
        this.banner=banner;

        super(AdNetworkType.BACKFILL);
    }

    /**
     *
     * @return
     */
    override protected function getPropertiesArray():Vector.<String> {
        var properties:Vector.<String>=super.getPropertiesArray();
        properties.push("interstitial");
        properties.push("interstitialCloseButton");
        properties.push("banner");
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
