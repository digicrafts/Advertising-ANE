package digicrafts.extensions;

import android.graphics.Rect;
import android.provider.Settings;

import android.util.Log;
import android.util.TypedValue;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.inmobi.commons.InMobi;
import com.inmobi.monetization.IMBanner;
import digicrafts.extensions.core.AbstractAdAdapter;
import digicrafts.extensions.core.AdAdapterListener;
import digicrafts.extensions.core.AdManager;


import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;

public class AdvertisingContext extends FREContext {

	private static final String TAG = AdvertisingContext.class.getName();

    private List<AdvertisingFunction<?>> _methods;

    // AdManager
    private AdManager _adManager;

	@Override
	public void dispose() {
        if(_adManager!=null){
            _adManager.dispose();
            _adManager=null;
        }
	}

    /**
     *
     */
    public AdvertisingContext() {

        super();

        // create list to hold the functions
        _methods = new ArrayList<AdvertisingFunction<?>>();

        try {

            //
            _methods.add(new AdvertisingFunction<Void>("ext_initialize") {
                public Void onCall(AdvertisingContext context, Object[] args) {

                    // create a AdManager Instance
                    _adManager=new AdManager(context.getActivity());
                    // init static var
                    AdManager.packageName = context.getActivity().getPackageName();
//                    // Get hash key
//                    try {
//                        PackageInfo info = context.getActivity().getPackageManager().getPackageInfo(AdManager.packageName, PackageManager.GET_SIGNATURES);
//                        for (Signature signature : info.signatures) {
//                            MessageDigest md = MessageDigest.getInstance("SHA");
//                            md.update(signature.toByteArray());
//                            AdManager.appKey=Base64.encodeToString(md.digest(), Base64.DEFAULT);
//                            Log.e("MY KEY HASH:", AdManager.appKey);
//                        }
//                    } catch (PackageManager.NameNotFoundException e) {
//                        e.printStackTrace();
//                    } catch (NoSuchAlgorithmException e) {
//                        e.printStackTrace();
//                    }
                    // Get device id
                    String android_id = Settings.Secure.getString(context.getActivity().getContentResolver(), Settings.Secure.ANDROID_ID);
                    AdManager.deviceID=md5(android_id).toUpperCase();
                    AdManager.listener=adAdapterListener;
                    return null;
                }
            });

            //
            _methods.add(new AdvertisingFunction<Void>("ext_testMode", Boolean.class) {
                public Void onCall(AdvertisingContext context, Object[] args) {
                    AdManager.testMode=(Boolean) args[0];
                    return null;
                }
            });

            //
            _methods.add(new AdvertisingFunction<Void>("ext_create", String.class, String.class, String.class, String.class, AbstractAdAdapter.class) {
                public Void onCall(AdvertisingContext context, Object[] args) {

                    // create the banner
                    _adManager.create(
                            (String) args[0],
                            (String) args[1],
                            (String) args[2],
                            (String) args[3],
                            (Map<String, Object>) args[4]);

                    return null;
                }
            });

            //
            _methods.add(new AdvertisingFunction<Void>("ext_load", String.class, String.class, String.class, String.class, AbstractAdAdapter.class) {
                public Void onCall(AdvertisingContext context, Object[] args) {

                    // show the banner
                    _adManager.load(
                            (String) args[0],
                            (String) args[1],
                            (String) args[2],
                            (String) args[3],
                            (Map<String, Object>) args[4]);

                    return null;
                }
            });

            //
            _methods.add(new AdvertisingFunction<Void>("ext_show", String.class, String.class, String.class, String.class, AbstractAdAdapter.class, String.class, Integer.class, Integer.class) {
                public Void onCall(AdvertisingContext context, Object[] args) {


                    // get the layout width/height
                    int x=(int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, (Integer) args[6], context.getActivity().getResources().getDisplayMetrics());
                    int y=(int)TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, (Integer) args[7], context.getActivity().getResources().getDisplayMetrics());

                    // get the rect
                    Rect rect = new Rect(x,y,100,100);

                    // show the banner
                    _adManager.show(
                            (String) args[0],
                            (String) args[1],
                            (String) args[2],
                            (String) args[3],
                            (Map<String, Object>) args[4],
                            (String) args[5],
                            rect);

                    return null;
                }
            });

            //
            _methods.add(new AdvertisingFunction<Void>("ext_remove", String.class) {
                public Void onCall(AdvertisingContext context, Object[] args) {
                    _adManager.remove((String) args[0]);
                    return null;
                }
            });

            //
            _methods.add(new AdvertisingFunction<Void>("ext_destroy", String.class) {
                public Void onCall(AdvertisingContext context, Object[] args) {
                    _adManager.destroy((String) args[0]);
                    return null;
                }
            });

            _methods.add(new AdvertisingFunction<Void>("activate", String.class) {
                public Void onCall(AdvertisingContext context, Object[] args) {
                    if(_adManager!=null){
                        _adManager.pauseAll();
                    }
                    return null;
                }
            });

            _methods.add(new AdvertisingFunction<Void>("deactivate", String.class) {
                public Void onCall(AdvertisingContext context, Object[] args) {
                    if(_adManager!=null){
                        _adManager.resumeAll();
                    }
                    return null;
                }
            });

        } catch (Exception e) {

            e.printStackTrace();

        }
    }

	@Override
	public Map<String, FREFunction> getFunctions() {
		
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();

        // add functions to map
        for (AdvertisingFunction<?> func : _methods)
            functionMap.put(func.getName(), func);
	    
		return functionMap;
	}

// Callback Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     */
///**
// * Event type for ad loaded.
// */
//public static const AD_LOADED:String="onAdLoaded";
///**
// * Event type for ad will going to show on screen.
// */
//public static const AD_WILL_PRESENT:String="onAdWillPresent";
///**
// * Event type for ad did show on screen.
// */
//public static const AD_DID_PRESENT:String="onAdDidPresent";
///**
// * Event type for ad will remove from screen.
// */
//public static const AD_WILL_DISMISS:String="onAdWillDismiss";
///**
// * Event type for ad did remove from screen.
// */
//public static const AD_DID_DISMISS:String="onAdDidDismiss";
///**
// * Event type for ad did fail to load.
// */
//public static const AD_FAILED_TO_LOAD:String="onAdFailedToLoad";
///**
// * Event type for ad did fail to load.
// */
//public static const WILL_LEAVE_APPLICATION:String="onWillLeaveApplication";
///**
// * Event type for ad did fail to load.
// */
//public static const AD_ACTION:String="onAdAction";

    AdAdapterListener adAdapterListener = new AdAdapterListener() {
        @Override
        public void onAdLoaded(String uid, String size, String network) {
            dispatchStatusEventAsync("onAdLoaded",buildEvent(uid,size,network,null));
        }

        @Override
        public void onAdFailedToLoad(String uid, String size, String network, String error) {
            dispatchStatusEventAsync("onAdFailedToLoad",buildEvent(uid,size,network,error));
        }

        @Override
        public void onAdWillPresent(String uid, String size, String network) {
            dispatchStatusEventAsync("onAdWillPresent",buildEvent(uid,size,network,null));
        }

        @Override
        public void onAdDidPresent(String uid, String size, String network) {
            dispatchStatusEventAsync("onAdDidPresent",buildEvent(uid,size,network,null));
        }

        @Override
        public void onAdWillDismiss(String uid, String size, String network) {
            dispatchStatusEventAsync("onAdWillDismiss",buildEvent(uid,size,network,null));
        }

        @Override
        public void onAdDidDismiss(String uid, String size, String network) {
            dispatchStatusEventAsync("onAdDidDismiss",buildEvent(uid,size,network,null));
        }

        @Override
        public void onWillLeaveApplication(String uid, String size, String network) {
            dispatchStatusEventAsync("onWillLeaveApplication",buildEvent(uid,size,network,null));
        }
    };

// Private Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    private String buildEvent(String uid, String size, String network, String error){

        if(error==null)
            return "{\"uid\":\""+uid+"\",\"size\":\""+size+"\",\"network\":\""+network+"\"}";

        return "{\"uid\":\""+uid+"\",\"size\":\""+size+"\",\"network\":\""+network+"\",\"error\":\""+error+"\"}";
    }

// Public Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * @param message
     */
    public void log(String message) {
        Log.d(TAG, message);
        dispatchStatusEventAsync("LOGGING", message);
    }

    /**
     *
     * @param s
     * @return
     */
    public String md5(String s) {
        try {
            // Create MD5 Hash
            MessageDigest digest = java.security.MessageDigest.getInstance("MD5");
            digest.update(s.getBytes());
            byte messageDigest[] = digest.digest();

            // Create Hex String
            StringBuffer hexString = new StringBuffer();
            for (int i=0; i<messageDigest.length; i++)
                hexString.append(Integer.toHexString(0xFF & messageDigest[i]));
            return hexString.toString();

        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return "";
    }

}
