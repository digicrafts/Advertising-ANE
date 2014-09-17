package digicrafts.extensions.core;

/**
 * Created by tsangwailam on 22/8/14.
 */
public interface AdAdapterListener {

    public void onAdLoaded(String uid, String size, String network);
    public void onAdFailedToLoad(String uid, String size, String network, String error);
    public void onAdWillPresent(String uid, String size, String network);
    public void onAdDidPresent(String uid, String size, String network);
    public void onAdWillDismiss(String uid, String size, String network);
    public void onAdDidDismiss(String uid, String size, String network);
    public void onWillLeaveApplication(String uid, String size, String network);
    public void onLog(String msg);

}
