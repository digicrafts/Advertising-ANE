package digicrafts.extensions.adapter;

import android.app.Activity;
import android.graphics.Rect;
import android.util.Log;
import android.view.ViewGroup;
import com.google.android.gms.ads.*;
import digicrafts.extensions.core.AbstractAdAdapter;
import digicrafts.extensions.core.AdAdapterInterface;
import digicrafts.extensions.core.AdManager;
import digicrafts.extensions.data.AdAdapterNetworkType;

import java.util.ArrayList;
import java.util.Map;

/**
 * Created by tsangwailam on 20/8/14.
 */
public class AdmobInterstitialAdapter extends AbstractAdAdapter {

    private InterstitialAd _interstitialAd;
    private Boolean _showAfterLoad;


// Constructor
/////////////////////////////////////////////////////////////////////////////////////////////////////////


    public AdmobInterstitialAdapter(Activity activity, String adUnitId, Map<String, Object> settings){

        if(activity!=null) {

            // init
            this.settings=settings;

            // Create an ad.
            _interstitialAd = new InterstitialAd(activity);
            _interstitialAd.setAdUnitId(adUnitId);
            _showAfterLoad=false;

            // setup listener
            _interstitialAd.setAdListener(new AdListener() {
                @Override
                public void onAdClosed() {
                    super.onAdClosed();
                    callOnAdWillDismiss();
                    callOnAdDidDismiss();
                }

                @Override
                public void onAdFailedToLoad(int errorCode) {
                    super.onAdFailedToLoad(errorCode);

                    String error = "no";

                    if(errorCode==AdRequest.ERROR_CODE_INTERNAL_ERROR)
                        error="ERROR_CODE_INTERNAL_ERROR";
                    else if(errorCode==AdRequest.ERROR_CODE_INVALID_REQUEST)
                        error="ERROR_CODE_INVALID_REQUEST";
                    else if(errorCode==AdRequest.ERROR_CODE_NETWORK_ERROR)
                        error="ERROR_CODE_NETWORK_ERROR";
                    else if(errorCode==AdRequest.ERROR_CODE_NO_FILL)
                        error="ERROR_CODE_NO_FILL";

                    callOnAdFailedToLoad(error);
                }

                @Override
                public void onAdLeftApplication() {
                    super.onAdLeftApplication();
                    callOnWillLeaveApplication();
                }

                @Override
                public void onAdOpened() {
                    super.onAdOpened();
                    callOnAdWillPresent();
                    callOnAdDidPresent();
                }

                @Override
                public void onAdLoaded() {
                    super.onAdLoaded();
                    if(_showAfterLoad){
                        _showAfterLoad=false;
                        _isShow=true;
                        _interstitialAd.show();
                    }
                    callOnAdLoaded();
                }
            });

        } else {

        }
    }


// Override public methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    @Override
    public String getNetworkType() {
        return AdAdapterNetworkType.ADMOB;
    }

    @Override
    public void show(ViewGroup view, String position, Rect rect){

        Log.d("DEBUG","_interstitialAd: "+_interstitialAd.toString());

        if(_interstitialAd!=null){

            Log.d("DEBUG", "_interstitialAd: " + _interstitialAd.isLoaded());

            // check if interstitial already loaded
            if(_interstitialAd.isLoaded()) {
                _isShow=true;
                _interstitialAd.show();
            } else {
                _showAfterLoad=true;
            }
        }
    }

    @Override
    public void load(){
        if(_interstitialAd!=null){
            // Create an ad request. Check logcat output for the hashed device ID to
            // get test ads on a physical device.
            AdRequest.Builder builder = new AdRequest.Builder().addTestDevice(AdRequest.DEVICE_ID_EMULATOR);

            if(AdManager.testMode){
                builder.addTestDevice(AdManager.deviceID);
            }

            // Add extra test devices
            if(settings != null){
                ArrayList<String> devices = (ArrayList<String>) settings.get("testDevices");
                if(devices != null) {
                    for (String device : devices)
                        builder.addTestDevice(device);
                }
            }

            // Set Location
            if(AdManager.location != null && (Boolean)settings.get("enableLocation") == true){
                builder.setLocation(AdManager.location);
            }

            AdRequest adRequest = builder.build();

            _isShow=false;

            // Start loading the ad in the background.
            _interstitialAd.loadAd(adRequest);
        }
    }

    @Override
    public void destroy(){
        if(_interstitialAd!=null){
            _interstitialAd.setAdListener(null);
            _interstitialAd=null;
        }
        super.destroy();
    }


// Override listener
/////////////////////////////////////////////////////////////////////////////////////////////////////////

}
