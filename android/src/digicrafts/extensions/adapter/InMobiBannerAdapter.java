package digicrafts.extensions.adapter;

import android.app.Activity;
import android.graphics.Rect;
import android.util.Log;
import android.util.TypedValue;
import android.view.ViewGroup;
import com.inmobi.commons.InMobi;
import com.inmobi.monetization.IMBanner;
import com.inmobi.monetization.IMBannerListener;
import com.inmobi.monetization.IMErrorCode;
import digicrafts.extensions.core.AbstractAdAdapter;
import digicrafts.extensions.core.AdManager;
import digicrafts.extensions.data.AdAdapterNetworkType;
import digicrafts.extensions.data.AdAdapterSize;

import java.util.Map;

/**
 * Created by tsangwailam on 6/9/14.
 */
public class InMobiBannerAdapter extends AbstractAdAdapter implements IMBannerListener{

    public static Boolean isInit = false;
    private IMBanner _adView;
    private int _adWidth;
    private int _adHeight;
    private int _layouWidth;
    private int _layouHeight;

    public InMobiBannerAdapter(Activity activity, String size, String adUnitId, Map<String, Object> settings){


        if(activity!=null) {

            // init
            this.settings=settings;

            //
//            if(!InMobiBannerAdapter.isInit){
//                InMobiBannerAdapter.isInit=true;
                InMobi.initialize(activity,adUnitId);
//            }

            // set debug message
            if(AdManager.testMode){
                InMobi.setLogLevel(InMobi.LOG_LEVEL.DEBUG);
            }

            int s;
            // Set size
            if(size.equals(AdAdapterSize.BANNER)) {
                _adWidth=320;
                _adHeight=50;
                s=IMBanner.INMOBI_AD_UNIT_320X50;
            } else if(size.equals(AdAdapterSize.FULL_BANNER)) {
                _adWidth=468;
                _adHeight=60;
                s=IMBanner.INMOBI_AD_UNIT_468X60;
            } else if(size.equals(AdAdapterSize.LEADERBOARD)){
                _adWidth=728;
                _adHeight=90;
                s=IMBanner.INMOBI_AD_UNIT_728X90;
            }else if(size.equals(AdAdapterSize.MEDIUM_RECTANGLE)){
                _adWidth=300;
                _adHeight=250;
                s=IMBanner.INMOBI_AD_UNIT_300X250;
            }else if(size.equals(AdAdapterSize.WIDE_SKYSCRAPER)){
                _adWidth=728;
                _adHeight=90;
                s=IMBanner.INMOBI_AD_UNIT_120X600;
            } else{
                _adWidth=320;
                _adHeight=50;
                s=IMBanner.INMOBI_AD_UNIT_320X50;
            }

            // get the layout width/height
            _layouWidth=(int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, _adWidth, activity.getResources().getDisplayMetrics());
            _layouHeight=(int)TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, _adHeight, activity.getResources().getDisplayMetrics());


            // Set the slot id
            if(settings.get(size)!=null){

                long slotid = Long.parseLong((String)settings.get(size),10);

                // create the banner view
                if(slotid>0)
                    _adView = new IMBanner(activity,slotid);
            }

            // create the banner view if not valid
            if(_adView==null)
                _adView = new IMBanner(activity,adUnitId,s);

            // setup listener
            _adView.setIMBannerListener(this);

        } else {

        }

    }

    @Override
    public String getNetworkType() {
        return AdAdapterNetworkType.INMOBI;
    }


    @Override
    public void show(ViewGroup view, String position, Rect rect){
        if(_adView!=null)
            _show(_adView,view,position,rect.left,rect.top, _layouWidth, _layouHeight);
    }

    @Override
    public void remove(){
        if(_adView.getParent() !=null) {
            ((ViewGroup)_adView.getParent()).removeView(_adView);
        }
    }

    @Override
    public void load(){
        if(_adView!=null){
            _adView.setRefreshInterval(-1);
            _adView.loadBanner();
        }
    }

    @Override
    public void destroy(){
        if(_adView!=null) {
            _adView.setIMBannerListener(null);
            _adView.destroy();
            _adView = null;
        }
        super.destroy();
    }

// Listener Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    @Override
    public void onBannerRequestFailed(IMBanner imBanner, IMErrorCode imErrorCode) {

        String error = "OTHER";
        if (imErrorCode == IMErrorCode.INTERNAL_ERROR) {
            error="INTERNAL_ERROR";
        } else if (imErrorCode == IMErrorCode.INVALID_REQUEST) {
            error="INVALID_REQUEST";
        } else if (imErrorCode == IMErrorCode.NETWORK_ERROR) {
            error="NETWORK_ERROR";
        } else if (imErrorCode == IMErrorCode.NO_FILL) {
            error="NO_FILL";
        } else {
            error="OTHER";
        }
        callOnAdFailedToLoad(error);
    }

    @Override
    public void onBannerRequestSucceeded(IMBanner imBanner) {
        callOnAdLoaded();
    }

    @Override
    public void onBannerInteraction(IMBanner imBanner, Map<String, String> stringStringMap) {

    }

    @Override
    public void onShowBannerScreen(IMBanner imBanner) {
        callOnAdWillPresent();
        callOnAdDidPresent();
    }

    @Override
    public void onDismissBannerScreen(IMBanner imBanner) {
        callOnAdWillDismiss();
        callOnAdDidDismiss();
    }

    @Override
    public void onLeaveApplication(IMBanner imBanner) {
        callOnWillLeaveApplication();
    }

}
