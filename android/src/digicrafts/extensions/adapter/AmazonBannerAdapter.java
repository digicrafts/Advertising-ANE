package digicrafts.extensions.adapter;

import android.app.Activity;
import android.graphics.Point;
import android.graphics.Rect;

import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;

import android.widget.RelativeLayout;
import com.amazon.device.ads.*;

import digicrafts.extensions.core.AbstractAdAdapter;
import digicrafts.extensions.core.AdAdapterInterface;
import digicrafts.extensions.core.AdManager;
import digicrafts.extensions.data.AdAdapterNetworkType;
import digicrafts.extensions.data.AdAdapterPosition;
import digicrafts.extensions.data.AdAdapterSize;
import digicrafts.extensions.utils.ViewUtils;

import java.util.ArrayList;
import java.util.Map;

/**
 * Created by tsangwailam on 20/8/14.
 */
public class AmazonBannerAdapter extends AbstractAdAdapter implements AdListener {

    public static Boolean isInit = false;
    private AdLayout _adView;
    private int originalWidth_;
    private int originalHeight_;

    public AmazonBannerAdapter(Activity activity, String size, String adUnitId, Map<String, Object> settings){

        if(activity!=null) {

            // init
            this.settings=settings;

            // Set the appId
            if(!AmazonBannerAdapter.isInit) {

                AmazonBannerAdapter.isInit = true;
                // For debugging purposes enable logging, but disable for production builds.
                AdRegistration.enableLogging(AdManager.testMode);
                // For debugging purposes flag all ad requests as tests, but set to false for production builds.
                AdRegistration.enableTesting(AdManager.testMode);
                // Set app key
                AdRegistration.setAppKey(adUnitId);
            }

            // Create and set size
            AdSize adsize = null;
            if(size.equals(AdAdapterSize.BANNER)) {
                originalWidth_=320;
                originalHeight_=50;
                adsize = AdSize.SIZE_320x50;
            } else if(size.equals(AdAdapterSize.FULL_BANNER)) {
                originalWidth_=600;
                originalHeight_=90;
                adsize = AdSize.SIZE_600x90;
            } else if(size.equals(AdAdapterSize.LEADERBOARD)) {
                originalWidth_=728;
                originalHeight_=90;
                adsize = AdSize.SIZE_728x90;
            } else if(size.equals(AdAdapterSize.MEDIUM_RECTANGLE)) {
                originalWidth_=300;
                originalHeight_=250;
                adsize = AdSize.SIZE_300x250;
            } else {

                Point res = ViewUtils.getScreenResolution(activity);
                int w = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, res.x, activity.getResources().getDisplayMetrics());
                int h = (int)TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, res.y, activity.getResources().getDisplayMetrics());

                if(w>=728){
                    originalWidth_=728;
                    originalHeight_=90;
                    adsize = AdSize.SIZE_728x90;
                } else {
                    originalWidth_=320;
                    originalHeight_=50;
                    adsize = AdSize.SIZE_320x50;
                }

            }

            // Programmatically create the AmazonAdLayout
            if(adsize==null)
                _adView=new AdLayout(activity);
            else
                _adView=new AdLayout(activity, adsize);

            // get the correct pixel value
            originalWidth_ = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, originalWidth_, activity.getResources().getDisplayMetrics());
            originalHeight_ = (int)TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, originalHeight_, activity.getResources().getDisplayMetrics());

            // Add default layout
            _adView.setLayoutParams(ViewUtils.getViewPositionParams(AdAdapterPosition.BOTTOM,0,0,originalWidth_,originalHeight_));

            // add listener
            _adView.setListener(this);

        } else {

        }

    }

    @Override
    public String getNetworkType() {
        return AdAdapterNetworkType.AMAZON;
    }


    @Override
    public void show(ViewGroup view, String position, Rect rect){
        if(_adView!=null) {

            if(position.equals(AdAdapterSize.SMART_BANNER))
                _show(_adView,view,position,rect.left,rect.top, RelativeLayout.LayoutParams.WRAP_CONTENT,RelativeLayout.LayoutParams.WRAP_CONTENT);
            else
                _show(_adView,view,position,rect.left,rect.top, originalWidth_, originalHeight_);
        }
    }

    @Override
//    public void remove(ViewGroup view){
//        if(_adView!=null && _adView.getParent() == view) {
//            view.removeView(_adView);
//        }
//    }
    public void remove(){
        if(_adView.getParent() !=null) {
            ((ViewGroup)_adView.getParent()).removeView(_adView);
        }
    }

    @Override
    public void load(){
        if(_adView!=null){

            AdTargetingOptions opt = new AdTargetingOptions();

            if((Boolean)settings.get("enableGeoLocation"))
                opt.enableGeoLocation(true);
            if((Integer)settings.get("age")>0)
                opt.setAge((Integer)settings.get("age"));

            _adView.loadAd(opt);
        }
    }

    @Override
    public void destroy(){
        if(_adView!=null) {
            _adView.destroy();
            _adView = null;
        }
        super.destroy();
    }

// Listener Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    @Override
    public void onAdLoaded(Ad ad, AdProperties adProperties) {
        callOnAdLoaded();
    }

    @Override
    public void onAdFailedToLoad(Ad ad, AdError adError) {
        callOnAdFailedToLoad(adError.getMessage());
    }

    @Override
    public void onAdExpanded(Ad ad) {
        callOnAdWillPresent();
        callOnAdDidPresent();
    }

    @Override
    public void onAdCollapsed(Ad ad) {}

    @Override
    public void onAdDismissed(Ad ad) {
        callOnAdWillDismiss();
        callOnAdDidDismiss();
    }

}
