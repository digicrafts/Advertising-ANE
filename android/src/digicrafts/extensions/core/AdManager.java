package digicrafts.extensions.core;

import android.app.Activity;
import android.graphics.Rect;
import android.util.Log;
import android.widget.Button;
import android.widget.RelativeLayout;
import com.inmobi.commons.InMobi;
import com.inmobi.monetization.IMBanner;
import digicrafts.extensions.adapter.*;
import digicrafts.extensions.data.AdAdapterNetworkType;
import digicrafts.extensions.data.AdAdapterSize;
import digicrafts.extensions.utils.ViewUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * Created by tsangwailam on 14/8/14.
 */
public class AdManager {

    private static final String TAG = AdManager.class.getName();

// Public Static var
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    public static Boolean testMode = false;
    public static String packageName = "";
    public static String appKey = "";
    public static String deviceID = "";
    public static Button dummy;
    public static AdAdapterListener listener;

// Private var
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    private Activity _activity;
    private RelativeLayout _container;
    private Map<String, AdAdapterInterface> _bannerMap;
    private Map<String, AdAdapterInterface> _interstitialMap;
    private AdAdapterInterface _lastAdapter;
    private AdAdapterInterface _currentAdapter;

// Constructor
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     */
    public AdManager(Activity activity) {

        _activity = activity;
        _bannerMap = new HashMap<String, AdAdapterInterface>();
        _container = ViewUtils.getContainerView(activity);

        // use for fix the bug for banner not display at first start
        if(dummy==null) dummy=new Button(_activity);
    }

    /**
     *
     */
    public void dispose()
    {

        if(_interstitialMap !=null) {

            _interstitialMap.clear();
            _interstitialMap = null;
        }

        if(_bannerMap !=null) {
            _bannerMap.clear();
            _bannerMap = null;
        }

        if(_container !=null){
            _container.removeAllViews();
            _container = null;
        }

    }

// Public Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * @param id
     * @param size
     * @param network
     * @param settings
     */
    public void create(String id, String size, String network, String adUnitId, Map<String, Object> settings)
    {
        // Get existing adapter
        AdAdapterInterface adapter = _bannerMap.get(id);

        // Check if the id exist
        if(adapter == null){
            adapter = _createAdapter(id, size, network, adUnitId, settings);
            adapter.load();
        }
    }

    /**
     *
     * @param id
     * @param size
     * @param network
     * @param settings
     */
    public AdAdapterInterface load(String id, String size, String network, String adUnitId, Map<String, Object> settings)
    {

        // Get existing adapter
        AdAdapterInterface adapter = _bannerMap.get(id);

        // Check if the id exist
        if(adapter == null){

            // create the adapter
            adapter = _createAdapter(id, size, network, adUnitId, settings);
            adapter.load();

        } else {

            // check if they are the same banner
            if(adapter.getNetworkType().equals(network)){

                log("equal network: " + network + " isshow: " +adapter.isShow() + " id: " + id);

                // if interstitial, lo
                if(size.equals(AdAdapterSize.INTERSTITIAL)&&adapter.isShow())
                    adapter.load();

            } else {

                // clean adapter
                _bannerMap.remove(id);
                _lastAdapter=adapter;
                _lastAdapter.setListener(null);
                _lastAdapter.remove();
                _lastAdapter.pause();

                // create new adapter
                adapter = _createAdapter(id, size, network, adUnitId, settings);

                // refresh the ad
                adapter.load();

            }
        }


        return adapter;
    }

    /**
     *
     * @param id
     * @param size
     * @param network
     * @param settings
     * @param position
     * @param rect
     */
    public void show(String id, String size, String network, String adUnitId, Map<String, Object> settings, String position, Rect rect)
    {

        // load the adapter
        AdAdapterInterface adapter = load(id,size,network,adUnitId,settings);

        // show the adapter
        if(adapter!=null)
            adapter.show(_container, position, rect);
    }

    /**
     *
     * @param id
     */
    public void remove(String id)
    {

        // Get existing adapter
        AdAdapterInterface adapter = _bannerMap.get(id);

//        Log.d("DEBUG","remove");
//        Log.d("DEBUG",id);
//        Log.d("DEBUG",adapter.toString());

        // Check if the id exist
        if(adapter != null){

            // remove the adapter
            adapter.remove();
        }

    }

    public void pauseAll()
    {

        for (Map.Entry<String, AdAdapterInterface> entry : _bannerMap.entrySet()) {
            // Get existing adapter
            AdAdapterInterface adapter = entry.getValue();
            // pause the adapter
            adapter.pause();
        }

    }

    public void resumeAll()
    {

        for (Map.Entry<String, AdAdapterInterface> entry : _bannerMap.entrySet()) {
            // Get existing adapter
            AdAdapterInterface adapter = entry.getValue();
            // pause the adapter
            adapter.resume();
        }

    }


    public void destroy(String id)
    {

        // Get existing adapter
        AdAdapterInterface adapter = _bannerMap.get(id);

        // Check if the id exist
        if(adapter != null){

            // clean adapter
            adapter.destroy();
            _bannerMap.remove(id);

        }

    }

// Static Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * @param message
     */
    public static void log(String message) {
        Log.d(TAG, message);
    }

// Private Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    private AdAdapterInterface _createAdapter(String id, String size, String network, String adUnitId, Map<String, Object> settings) {


        Log.d("AdManager","_createAdapter: "+network+" size: "+size);

        // AdAdapter instance
        AdAdapterInterface adapter = null;
//        // Get the ad unitId
//        String adUnitId = (String) settings.get("adUnitId");

        Log.d("AdManager","adUnitId: "+adUnitId+" type: "+network+" size: "+size);

        // Select differ network
        if (size.equals(AdAdapterSize.INTERSTITIAL)){
            if(network.equals(AdAdapterNetworkType.ADMOB)) {

                adapter = new AdmobInterstitialAdapter(_activity, adUnitId, settings);

            } else if(network.equals(AdAdapterNetworkType.AMAZON)) {

                adapter = new AmazonInterstitialAdapter(_activity, adUnitId, settings);

            } else if(network.equals(AdAdapterNetworkType.MILLENNIALMEDIA)) {

                adapter = new MMInterstitialAdapter(_activity, adUnitId, settings);

            } else if(network.equals(AdAdapterNetworkType.INMOBI)) {

                adapter = new InMobiInterstitialAdapter(_activity, adUnitId, settings);

            }
        } else {
            if(network.equals(AdAdapterNetworkType.ADMOB)) {

                adapter = new AdmobBannerAdapter(_activity, size, adUnitId, settings);

            } else if(network.equals(AdAdapterNetworkType.AMAZON)) {

                adapter = new AmazonBannerAdapter(_activity, size, adUnitId, settings);

            } else if(network.equals(AdAdapterNetworkType.MILLENNIALMEDIA)) {

                adapter = new MMBannerAdapter(_activity, size, adUnitId, settings);

            } else if(network.equals(AdAdapterNetworkType.INMOBI)) {

                adapter = new InMobiBannerAdapter(_activity, size, adUnitId, settings);

            }
        }

        if(adapter!=null) {

            // set the id
            adapter.setId(id);
            adapter.setSize(size);

            // if there last adapter
            if(_lastAdapter!=null){
                _currentAdapter=adapter;
                _currentAdapter.setListener(
                        new AdAdapterListener() {
                            @Override
                            public void onAdLoaded(String uid, String size, String network) {
                                _lastAdapter.destroy();
                                _lastAdapter=null;
                                listener.onAdLoaded(uid,size,network);
                                _currentAdapter.setListener(listener);
                                _currentAdapter=null;
                            }

                            @Override
                            public void onAdFailedToLoad(String uid, String size, String network, String error) {
                                _lastAdapter.destroy();
                                _lastAdapter=null;
                                listener.onAdFailedToLoad(uid,size,network,error);
                                _currentAdapter.setListener(listener);
                                _currentAdapter=null;
                            }

                            @Override
                            public void onAdWillPresent(String uid, String size, String network) {

                            }

                            @Override
                            public void onAdDidPresent(String uid, String size, String network) {

                            }

                            @Override
                            public void onAdWillDismiss(String uid, String size, String network) {

                            }

                            @Override
                            public void onAdDidDismiss(String uid, String size, String network) {

                            }

                            @Override
                            public void onWillLeaveApplication(String uid, String size, String network) {

                            }
                    });
            } else {
                adapter.setListener(listener);
            }

            // put in hash map
            _bannerMap.put(id, adapter);
        }

        // return the adapter
        return adapter;
    }

}
