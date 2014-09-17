package digicrafts.extensions.adapter;

import android.app.Activity;
import android.graphics.Point;
import android.graphics.Rect;
import android.util.Log;
import android.util.TypedValue;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import com.amazon.device.ads.AdSize;
import com.millennialmedia.android.*;
import digicrafts.extensions.core.AbstractAdAdapter;
import digicrafts.extensions.core.AdManager;
import digicrafts.extensions.data.AdAdapterNetworkType;
import digicrafts.extensions.data.AdAdapterSize;
import digicrafts.extensions.utils.ViewUtils;

import java.util.ArrayList;
import java.util.Map;

/**
 * Created by tsangwailam on 6/9/14.
 */
public class MMBannerAdapter extends AbstractAdAdapter implements RequestListener{

    public static Boolean isInit = false;
    private MMAdView _adView;
    private int _adWidth;
    private int _adHeight;
    private int _layouWidth;
    private int _layouHeight;

    public MMBannerAdapter(Activity activity, String size, String adUnitId, Map<String, Object> settings){

        if(activity!=null) {

            // init
            this.settings=settings;

            //
            if(!MMBannerAdapter.isInit){
                MMBannerAdapter.isInit=true;
                // Set debug mode
                if(AdManager.testMode) MMLog.setLogLevel(2);
                MMSDK.initialize(activity);
            }

            // Create an ad.
            _adView = new MMAdView(activity);
            _adView.setApid(adUnitId);

            // Set size
            if(size.equals(AdAdapterSize.BANNER)) {
                _adWidth=320;
                _adHeight=50;
            } else if(size.equals(AdAdapterSize.FULL_BANNER)) {
                _adWidth=480;
                _adHeight=60;
            } else if(size.equals(AdAdapterSize.LEADERBOARD)){
                _adWidth=728;
                _adHeight=90;
            }else if(size.equals(AdAdapterSize.MEDIUM_RECTANGLE)){
                _adWidth=300;
                _adHeight=250;
            }else if(size.equals(AdAdapterSize.WIDE_SKYSCRAPER)){
                _adWidth=728;
                _adHeight=90;
            } else{
                Point res = ViewUtils.getScreenResolution(activity);
                int w = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, res.x, activity.getResources().getDisplayMetrics());
                int h =(int)TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, res.y, activity.getResources().getDisplayMetrics());

                if(w>=728) {
                    _adWidth=728;
                    _adHeight=90;
                } else if(w>=480){
                    _adWidth=480;
                    _adHeight=60;
                } else {
                    _adWidth=320;
                    _adHeight=50;
                }

//                Log.d("DEBUG","w: " + w + " h: " + h + " _adWidth: " + _adWidth + " _adHeight: " + _adHeight);
            }

            // Set the ad view width/height
            _adView.setWidth(_adWidth);
            _adView.setHeight(_adHeight);

            // get the layout width/height
            _layouWidth=(int)TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, _adWidth, activity.getResources().getDisplayMetrics());
            _layouHeight=(int)TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, _adHeight, activity.getResources().getDisplayMetrics());

            // setup listener
            _adView.setListener(this);

        }
    }

    @Override
    public String getNetworkType() {
        return AdAdapterNetworkType.MILLENNIALMEDIA;
    }


    @Override
    public void show(ViewGroup view, String position, Rect rect){
        if(_adView!=null){
            _show(_adView, view, position, rect.left, rect.top, _layouWidth, _layouHeight);
        }

    }

    @Override
//    public void remove(ViewGroup view){
    public void remove(){
        if(_adView.getParent() !=null) {
            ((ViewGroup)_adView.getParent()).removeView(_adView);
        }
    }

    @Override
    public void load(){
        callLog("MM Load: " + _adView);

        if(_adView!=null){

            // Set your metadata in the MMRequest object
            MMRequest request = new MMRequest();

            // Set extra paramter
            if((Boolean)settings.get("enableLocation")==true&&AdManager.location!=null){
                request.setUserLocation(AdManager.location);
            }
            String age = (String)settings.get("age");
            if(age != null && !age.isEmpty()){
                request.setAge(age);
            }

            // Add the MMRequest object to your MMAdView.
            _adView.setMMRequest(request);

            // Sets the id to preserve your ad on configuration changes.
            _adView.setId(MMSDK.getDefaultAdId());

            // Get ads
            _adView.getAd();
        }
    }

    @Override
    public void destroy(){
        if(_adView!=null) {
            _adView.setListener(null);
            _adView = null;
        }
        super.destroy();
    }

// Listener Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    @Override
    public void MMAdOverlayLaunched(MMAd mmAd) {
        callOnAdWillPresent();
        callOnAdDidPresent();
    }

    @Override
    public void MMAdOverlayClosed(MMAd mmAd) {
        callOnAdWillDismiss();
        callOnAdDidDismiss();
    }

    @Override
    public void MMAdRequestIsCaching(MMAd mmAd) {

    }

    @Override
    public void requestCompleted(MMAd mmAd) {
        callOnAdLoaded();
    }

    @Override
    public void requestFailed(MMAd mmAd, MMException e) {
        callOnAdFailedToLoad(e.getLocalizedMessage());
    }

    @Override
    public void onSingleTap(MMAd mmAd) {

    }

}
