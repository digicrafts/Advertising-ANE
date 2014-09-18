package digicrafts.extensions.core;

import android.app.Activity;
import android.graphics.Rect;
import android.location.Location;
import android.util.Log;
import android.widget.Button;
import android.widget.RelativeLayout;
import com.adobe.fre.FREContext;
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
    public static Location location;

//    public static AdAdapterListener listener;

// Private var
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    private FREContext _context;
    private Activity _activity;
    private RelativeLayout _container;
    private Map<String, AdAdapterInterface> _adapterMap;
    private Map<String, AdAdapterInterface> _cleanAdapterMap;

// Constructor
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     */
    public AdManager(FREContext context) {

        _context = context;
        _activity = context.getActivity();
        _adapterMap = new HashMap<String, AdAdapterInterface>();
        _cleanAdapterMap = new HashMap<String, AdAdapterInterface>();
        _container = ViewUtils.getContainerView(_activity);

        // use for fix the bug for banner not display at first start
        if(dummy==null) dummy=new Button(_activity);
    }

    /**
     *
     */
    public void dispose()
    {

        if(_cleanAdapterMap !=null) {
            _cleanAdapterMap.clear();
            _cleanAdapterMap = null;
        }

        if(_adapterMap !=null) {
            _adapterMap.clear();
            _adapterMap = null;
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
     * @param uid
     * @param size
     * @param network
     * @param settings
     */
    public AdAdapterInterface load(String uid, String size, String network, String adUnitId, Map<String, Object> settings)
    {

        // Get existing adapter
        AdAdapterInterface adapter = _adapterMap.get(uid);

        // Check if the id exist
        if(adapter == null){

            // create the adapter
            adapter = _createAdapter(uid, size, network, adUnitId, settings);
            adapter.load();

        } else {

            // check if they are the same banner
            if(adapter.getNetworkType().equals(network)) {

                adAdapterListener.onLog("equal network: " + network + " isshow: " + adapter.isShow() + " isload: " + adapter.isLoaded() + " uid: " + uid);

                // if interstitial, load again
                if (size.equals(AdAdapterSize.INTERSTITIAL)){

                    // check if it is shown
                    if(adapter.isShow())
                        adapter.load();
                } else {
                // if banner, check if it is loaded

                    if(adapter.isLoaded()){
                        adAdapterListener.onAdLoaded(uid,size,network);
                    } else {
                        adapter.load();
                    }
                }

            } else {

                if(adapter.isLoaded()){

                    // put in hash map
                    _cleanAdapterMap.put(uid, adapter);

                } else {

                    // clean not ready adapter
                    adapter.setListener(null);
                    adapter.pause();
                    adapter.remove();
                    _adapterMap.remove(uid);
                }

                // clean adapter
//                _adapterMap.remove(id);
//                _lastAdapter=adapter;
//                _lastAdapter.setListener(null);
//                _lastAdapter.remove();
//                _lastAdapter.pause();

                // create new adapter
                adapter = _createAdapter(uid, size, network, adUnitId, settings);

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
        AdAdapterInterface adapter = _adapterMap.get(id);

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

        for (Map.Entry<String, AdAdapterInterface> entry : _adapterMap.entrySet()) {
            // Get existing adapter
            AdAdapterInterface adapter = entry.getValue();
            // pause the adapter
            adapter.pause();
        }

    }

    public void resumeAll()
    {

        for (Map.Entry<String, AdAdapterInterface> entry : _adapterMap.entrySet()) {
            // Get existing adapter
            AdAdapterInterface adapter = entry.getValue();
            // pause the adapter
            adapter.resume();
        }

    }


    public void destroy(String id)
    {

        // Get existing adapter
        AdAdapterInterface adapter = _adapterMap.get(id);

        // Check if the id exist
        if(adapter != null){

            // clean adapter
            adapter.destroy();
            _adapterMap.remove(id);

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


    /**
     *
     * @param uid
     * @param size
     * @param network
     * @param error
     * @return
     */
    private String buildEvent(String uid, String size, String network, String error){

        if(error==null)
            return "{\"uid\":\""+uid+"\",\"size\":\""+size+"\",\"network\":\""+network+"\"}";

        return "{\"uid\":\""+uid+"\",\"size\":\""+size+"\",\"network\":\""+network+"\",\"error\":\""+error+"\"}";
    }


// Private Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    private AdAdapterInterface _createAdapter(String id, String size, String network, String adUnitId, Map<String, Object> settings) {

//        Log.d("AdManager","_createAdapter: "+network+" size: "+size);

        // AdAdapter instance
        AdAdapterInterface adapter = null;

//        Log.d("AdManager","adUnitId: "+adUnitId+" type: "+network+" size: "+size);

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

            // set the parameters
            adapter.setId(id);
            adapter.setSize(size);
            adapter.setListener(adAdapterListener);

            // put in hash map
            _adapterMap.put(id, adapter);
        }

        // return the adapter
        return adapter;
    }

    /**
     * Listener object
     */
    AdAdapterListener adAdapterListener = new AdAdapterListener() {
        @Override
        public void onAdLoaded(String uid, String size, String network) {
            AdAdapterInterface adapter = _cleanAdapterMap.get(uid);
            if(adapter!=null){
                // clean not ready adapter
                adapter.setListener(null);
                adapter.pause();
                adapter.remove();
                _cleanAdapterMap.remove(uid);
            }
            _context.dispatchStatusEventAsync("onAdLoaded",buildEvent(uid,size,network,null));
        }

        @Override
        public void onAdFailedToLoad(String uid, String size, String network, String error) {
            _context.dispatchStatusEventAsync("onAdFailedToLoad",buildEvent(uid,size,network,error));
        }

        @Override
        public void onAdWillPresent(String uid, String size, String network) {
            _context.dispatchStatusEventAsync("onAdWillPresent",buildEvent(uid,size,network,null));
        }

        @Override
        public void onAdDidPresent(String uid, String size, String network) {
            _context.dispatchStatusEventAsync("onAdDidPresent",buildEvent(uid,size,network,null));
        }

        @Override
        public void onAdWillDismiss(String uid, String size, String network) {
            _context.dispatchStatusEventAsync("onAdWillDismiss",buildEvent(uid,size,network,null));
        }

        @Override
        public void onAdDidDismiss(String uid, String size, String network) {
            _context.dispatchStatusEventAsync("onAdDidDismiss",buildEvent(uid,size,network,null));
        }

        @Override
        public void onWillLeaveApplication(String uid, String size, String network) {
            _context.dispatchStatusEventAsync("onWillLeaveApplication",buildEvent(uid,size,network,null));
        }

        @Override
        public void onLog(String msg) {
            _context.dispatchStatusEventAsync("LOGGING",msg);
        }
    };


}
