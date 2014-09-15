package digicrafts.extensions.adapter;

import android.app.Activity;
import android.graphics.Rect;
import android.util.Log;
import android.view.ViewGroup;
import com.amazon.device.ads.*;
import digicrafts.extensions.core.AbstractAdAdapter;
import digicrafts.extensions.core.AdAdapterInterface;
import digicrafts.extensions.core.AdManager;
import digicrafts.extensions.data.AdAdapterNetworkType;

import java.util.Map;

/**
 * Created by tsangwailam on 20/8/14.
 */
public class AmazonInterstitialAdapter extends AbstractAdAdapter implements AdListener {

    private InterstitialAd _interstitialAd;
    private Boolean _showAfterLoad;

// Constructor
/////////////////////////////////////////////////////////////////////////////////////////////////////////


    public AmazonInterstitialAdapter(Activity activity, String adUnitId, Map<String, Object> settings){

        if(activity!=null) {

            // init
            this.settings=settings;

            // Set the appId
            AdRegistration.setAppKey(adUnitId);

            _interstitialAd = new InterstitialAd(activity);
            _interstitialAd.setListener(this);


        } else {

        }
    }


// Override public methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    @Override
    public String getNetworkType() {
        return AdAdapterNetworkType.AMAZON;
    }

    @Override
    public void show(ViewGroup view, String position, Rect rect){

        if(_interstitialAd!=null){

            Log.d("AMAZON","isLoading: "+_interstitialAd.isLoading()+"isShowing: "+_interstitialAd.isShowing()+"isAdShowing: "+InterstitialAd.isAdShowing());

            if(_interstitialAd.isLoading()){
                _showAfterLoad=true;
            } else {
                _isShow=true;
                _interstitialAd.showAd();
            }

        }
    }

    @Override
    public void load(){
        if(_interstitialAd!=null){

            // For debugging purposes enable logging, but disable for production builds.
            AdRegistration.enableLogging(AdManager.testMode);
            // For debugging purposes flag all ad requests as tests, but set to false for production builds.
            AdRegistration.enableTesting(AdManager.testMode);

            _isShow=false;

            _interstitialAd.loadAd();
        }
    }

    @Override
    public void destroy(){
        if(_interstitialAd!=null){
            _interstitialAd.setListener(null);
            _interstitialAd=null;
        }
        super.destroy();
    }


// Listener Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    @Override
    public void onAdLoaded(Ad ad, AdProperties adProperties) {
        if(_showAfterLoad){
            _showAfterLoad=false;
            _isShow=true;
            _interstitialAd.showAd();
        }
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
    public void onAdCollapsed(Ad ad) {

    }

    @Override
    public void onAdDismissed(Ad ad) {
        callOnAdWillDismiss();
        callOnAdDidDismiss();
    }

}
