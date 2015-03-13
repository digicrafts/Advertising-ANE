/**
 * Created by tsangwailam on 3/8/14.
 */
package digicrafts.extensions.events {
import digicrafts.extensions.core.Ad;

import flash.events.Event;

public class AdEvent extends Event {

    /**
     * Event type for ad loaded.
     */
    public static const AD_LOADED:String="onAdLoaded";
    /**
     * Event type for ad will going to show on screen.
     */
    public static const AD_WILL_PRESENT:String="onAdWillPresent";
    /**
     * Event type for ad did show on screen.
     */
    public static const AD_DID_PRESENT:String="onAdDidPresent";
    /**
     * Event type for ad will remove from screen.
     */
    public static const AD_WILL_DISMISS:String="onAdWillDismiss";
    /**
     * Event type for ad did remove from screen.
     */
    public static const AD_DID_DISMISS:String="onAdDidDismiss";
    /**
     * Event type for ad did fail to load.
     */
    public static const AD_FAILED_TO_LOAD:String="onAdFailedToLoad";
    /**
     * Event type for ad did fail to load.
     */
    public static const WILL_LEAVE_APPLICATION:String="onWillLeaveApplication";
    /**
     * Event type for ad did fail to load.
     */
    public static const AD_ACTION:String="onAdAction";
    /**
     * Event type for video ad started.
     */
    public static const AD_VIDEO_START:String="onAdVideoStart";
    /**
     * Event type for video ad finish.
     */
    public static const AD_VIDEO_END:String="onAdVideoEnd";

    /**
     * Store the data for the event
     */
    public var data:*;

    /**
     * Store the ad instance responded for the event if any
     */
    public var ad:Ad;

    /**
     * @param type
     * @param bubbles
     * @param data
     */
    public function AdEvent(type:String, bubbles:Boolean = false, data:Object = null, ad:Ad = null) {

        this.data = data;
        this.ad = ad;

        super(type, bubbles, false);
    }
}
}
