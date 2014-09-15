package digicrafts.extensions.adapter;

import android.app.Activity;
import android.graphics.Rect;
import android.util.Log;
import android.view.ViewGroup;
import com.inmobi.commons.InMobi;
import com.inmobi.monetization.IMErrorCode;
import com.inmobi.monetization.IMInterstitial;
import com.inmobi.monetization.IMInterstitialListener;
import com.millennialmedia.android.*;
import digicrafts.extensions.core.AbstractAdAdapter;
import digicrafts.extensions.data.AdAdapterNetworkType;

import java.util.Map;

/**
 * Created by tsangwailam on 6/9/14.
 */
public class InMobiInterstitialAdapter extends AbstractAdAdapter implements IMInterstitialListener{

    private IMInterstitial _adView;
    private Boolean _showAfterLoad;

    public InMobiInterstitialAdapter(Activity activity, String adUnitId, Map<String, Object> settings){


        if(activity!=null) {

            // init
            this.settings=settings;

            //
            if(!InMobiBannerAdapter.isInit){
                InMobiBannerAdapter.isInit=true;
                InMobi.initialize(activity,adUnitId);
            }

            // Create an ad.
            _adView = new IMInterstitial(activity,adUnitId);

            // setup listener
            _adView.setIMInterstitialListener(this);

        } else {

        }

    }

    @Override
    public String getNetworkType() {
        return AdAdapterNetworkType.INMOBI;
    }


    @Override
    public void show(ViewGroup view, String position, Rect rect){
        if(_adView!=null) {

            // check if interstitial already loaded
            if(_adView.getState()==IMInterstitial.State.READY) {
                _isShow=true;
                _adView.show();
            } else {
                _showAfterLoad=true;
            }

        }
    }

    @Override
    public void load(){
        if(_adView!=null){
            _adView.loadInterstitial();
        }
    }

    @Override
    public void destroy(){
        if(_adView!=null) {
            _adView.setIMInterstitialListener(null);
            _adView = null;
        }
        super.destroy();
    }

// Listener Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    @Override
    public void onInterstitialFailed(IMInterstitial imInterstitial, IMErrorCode imErrorCode) {
        callOnAdFailedToLoad(imErrorCode.toString());
    }

    @Override
    public void onInterstitialLoaded(IMInterstitial imInterstitial) {
        if (_showAfterLoad) {
            _showAfterLoad = false;
            _isShow = true;
            _adView.show();
        }
        callOnAdLoaded();
    }

    @Override
    public void onShowInterstitialScreen(IMInterstitial imInterstitial) {
        callOnAdWillPresent();
        callOnAdDidPresent();
    }

    @Override
    public void onDismissInterstitialScreen(IMInterstitial imInterstitial) {
        callOnAdWillDismiss();
        callOnAdDidDismiss();
    }

    @Override
    public void onInterstitialInteraction(IMInterstitial imInterstitial, Map<String, String> stringStringMap) {

    }

    @Override
    public void onLeaveApplication(IMInterstitial imInterstitial) {
        callOnWillLeaveApplication();
    }

}
