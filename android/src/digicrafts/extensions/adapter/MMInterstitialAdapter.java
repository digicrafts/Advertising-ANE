package digicrafts.extensions.adapter;

import android.app.Activity;
import android.graphics.Rect;
import android.view.ViewGroup;
import com.millennialmedia.android.*;
import digicrafts.extensions.core.AbstractAdAdapter;
import digicrafts.extensions.core.AdManager;
import digicrafts.extensions.data.AdAdapterNetworkType;
import digicrafts.extensions.data.AdAdapterSize;

import java.util.Map;

/**
 * Created by tsangwailam on 6/9/14.
 */
public class MMInterstitialAdapter extends AbstractAdAdapter implements RequestListener{

    private MMInterstitial _adView;
    private Boolean _showAfterLoad;

    public MMInterstitialAdapter(Activity activity, String adUnitId, Map<String, Object> settings){


        if(activity!=null) {

            // init
            this.settings=settings;

            //
            if(!MMBannerAdapter.isInit){
                MMBannerAdapter.isInit=true;
                MMLog.setLogLevel(2);
                MMSDK.initialize(activity);
            }

            // Create an ad.
            _adView = new MMInterstitial(activity);

            // set apid
            _adView.setApid(adUnitId);

            // setup listener
            _adView.setListener(this);

        } else {

        }

    }

    @Override
    public String getNetworkType() {
        return AdAdapterNetworkType.MILLENNIALMEDIA;
    }


    @Override
    public void show(ViewGroup view, String position, Rect rect){
        if(_adView!=null) {

            // check if interstitial already loaded
            if(_adView.isAdAvailable()) {
                _isShow=true;
                _adView.display();
            } else {
                _showAfterLoad=true;
            }

        }
    }

    @Override
    public void load(){
        if(_adView!=null){

            // Set your metadata in the MMRequest object
            MMRequest request = new MMRequest();

            // Set extra paramter
            if((Boolean)settings.get("enableLocation")==true&& AdManager.location!=null){
                request.setUserLocation(AdManager.location);
            }
            String age = (String)settings.get("age");
            if(age != null && !age.isEmpty()){
                request.setAge(age);
            }

            // Add the MMRequest object to your MMAdView.
            _adView.setMMRequest(request);

            // Request an interstitial ad.
            _adView.fetch();
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
        callOnAdLoaded();
    }

    @Override
    public void requestCompleted(MMAd mmAd) {
        if(_showAfterLoad){
            _showAfterLoad=false;
            _isShow=true;
            _adView.display();
        }
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
