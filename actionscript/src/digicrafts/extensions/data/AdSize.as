/**
 * Created by tsangwailam on 3/8/14.
 */
package digicrafts.extensions.data {
import digicrafts.extensions.core.ad_internal;

public class AdSize {

    /**
     * Size 320x50.
     */
    public static const BANNER:String           = "banner"; //320x50
    /**
     * Smart Size.
     * @see https://developers.google.com/mobile-ads-sdk/docs/admob/smart-banners
     */
    public static const SMART_BANNER:String     = "smart_banner"; // smart
    /**
     * 468x60 ads.
     */
    public static const FULL_BANNER:String      = "full_banner"; // 468x60
    /**
     * 728x90 ads.
     */
    public static const LEADERBOARD:String      = "leaderboard"; // 728x90
    /**
     * 728x90 ads.
     */
    public static const WIDE_SKYSCRAPER:String  = "wide_skyscraper"; // 728x90
    /**
     * 300x250 ads.
     */
    public static const MEDIUM_RECTANGLE:String = "medium_rectangle"; // 300x250
    /**
     * Fullscreen Ads.
     */
    public static const INTERSTITIAL:String     = "interstitial"; // full screen

// Internal

    ad_internal static const VALID_BANNER_SIZE:Object = {
        "banner":true,
        "smart_banner":true,
        "full_banner":true,
        "leaderboard":true,
        "wide_skyscraper":true,
        "medium_rectangle":true
    }

}
}
