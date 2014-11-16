package digicrafts.extensions.adapter;

import android.app.Activity;
import android.graphics.Rect;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.AdSize;
import digicrafts.extensions.core.AbstractAdAdapter;
import digicrafts.extensions.core.AdManager;
import digicrafts.extensions.data.AdAdapterNetworkType;
import digicrafts.extensions.data.AdAdapterSize;

import java.util.ArrayList;
import java.util.Map;

/**
 * Created by tsangwailam on 20/8/14.
 */
public class AdmobBannerAdapter extends AbstractAdAdapter {

    private AdView _adView;

    public AdmobBannerAdapter(Activity activity, String size, String adUnitId, Map<String, Object> settings){


        if(activity!=null) {

            // init
            this.settings=settings;

            // Create an ad.
            _adView = new AdView(activity);
            _adView.setAdUnitId(adUnitId);

            // Set size
            if(size.equals(AdAdapterSize.BANNER))
                _adView.setAdSize(AdSize.BANNER);
            else if(size.equals(AdAdapterSize.FULL_BANNER))
                _adView.setAdSize(AdSize.FULL_BANNER);
            else if(size.equals(AdAdapterSize.LEADERBOARD))
                _adView.setAdSize(AdSize.LEADERBOARD);
            else if(size.equals(AdAdapterSize.MEDIUM_RECTANGLE))
                _adView.setAdSize(AdSize.MEDIUM_RECTANGLE);
            else if(size.equals(AdAdapterSize.WIDE_SKYSCRAPER))
                _adView.setAdSize(AdSize.WIDE_SKYSCRAPER);
            else
                _adView.setAdSize(AdSize.SMART_BANNER);

            // setup listener
            _adView.setAdListener(new AdListener() {
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
//                    _adView.getParent().
//                    _adView.invalidate();
                    callOnAdLoaded();
                }
            });

        } else {

        }

    }

    @Override
    public String getNetworkType() {
        return AdAdapterNetworkType.ADMOB;
    }


    @Override
    public void show(ViewGroup view, String position, Rect rect){
        if(_adView!=null)
            _show(_adView,view,position,rect.left,rect.top,RelativeLayout.LayoutParams.WRAP_CONTENT,RelativeLayout.LayoutParams.WRAP_CONTENT);
    }

    @Override
//    public void remove(ViewGroup view){
//        if(_adView!=null && _adView.getParent() == view) {
//            _adView.pause();
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
            // Create an ad request. Check logcat output for the hashed device ID to
            // get test ads on a physical device.
            AdRequest.Builder builder = new AdRequest.Builder().addTestDevice(AdRequest.DEVICE_ID_EMULATOR);

            Log.d("AdvertistingANE","AdMob test id:"+AdManager.deviceID + " test mode: "+AdManager.testMode);

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




            // Start loading the ad in the background.
            _adView.loadAd(adRequest);
        }
    }

    @Override
    public void pause(){
        if(_adView!=null)
            _adView.pause();
    }

    @Override
    public void resume(){
        if(_adView!=null)
            _adView.resume();
    }

    @Override
    public void destroy(){
        if(_adView!=null) {
            _adView.setAdListener(null);
            _adView.destroy();
            _adView = null;
        }
        super.destroy();
    }

}
