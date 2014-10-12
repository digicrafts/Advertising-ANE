/**
 * Created by tsangwailam on 19/7/14.
 */
package {

import digicrafts.extensions.Advertising;
import digicrafts.extensions.core.AdSettings;
import digicrafts.extensions.data.AdPosition;
import digicrafts.extensions.data.AdSize;
import digicrafts.extensions.adapter.*;
import digicrafts.extensions.events.AdEvent;

import flash.display.Sprite;
import flash.events.Event;
import flash.utils.setTimeout;

public class banner extends Sprite {

    /**
     *
     */
    public function banner() {

        super();

        addEventListener(Event.ADDED_TO_STAGE,function(e:Event):void{

            setTimeout(init,3000);

        });

    }

    public function init():void{
        /**
         * Create a setting instance for the banner
         */
        var settings:AdSettings= new AdSettings();

        // Manual create adapter
        // AdMob
        var adMob:AdMobAdapter=new AdMobAdapter('ca-app-pub-xxxxxxxxxxx');//android
        // Amazon
        var amazon:AmazonAdapter=new AmazonAdapter('YOUR_APP_ID');
        // iAd
        var iAd:IAdAdapter=new IAdAdapter();
        // MillennialMedia
        var mm:MillennialMediaAdapter=new MillennialMediaAdapter("YOUR_APP_ID");//banner
        mm.rectangle = "YOUR_SLOT_ID_1";//square
        mm.interstitial = "YOUR_SLOT_ID_2";//interstitial
        // InMobi
        var inmobi:InMobiAdapter=new InMobiAdapter("YOUR_APP_ID");
        inmobi.interstitial="YOUR_SLOT_ID_INTERSTITIAL";// interstitial
        inmobi.banner="YOUR_SLOT_ID_BANNER"; //banner
        inmobi.full_banner="YOUR_SLOT_ID_FULL";
        inmobi.leaderboard="YOUR_SLOT_ID_LEADERBOARD";
        inmobi.medium_rectangle="YOUR_SLOT_ID_RECTANGLE";
        // Back fill
        var backfill:BackFillAdapter=new BackFillAdapter("http://LINK_TO_AD");
        backfill.banner="BANNER.png";


        // Add adapter to the settings object
        settings.add(iAd,0,1);
        settings.add(adMob,1,2);
        settings.add(amazon);
        settings.add(mm);
        settings.add(inmobi);
        settings.add(backfill);

        // Enable test mode
//        Advertising.testMode=true;

        /**
         * Create a banner and show immediately on top. Refresh every 30 s.
         */
        Advertising.getBanner('BANNER_1',AdSize.BANNER,settings).show(AdPosition.TOP,30);

        /**
         * Create a rectangle banner and show immediately on bottom. Don' refresh
         */
        Advertising.getBanner('BANNER_2',AdSize.MEDIUM_RECTANGLE,settings).show(AdPosition.BOTTOM);

    }

}
}
