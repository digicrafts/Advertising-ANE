package digicrafts.extensions.core;

import android.graphics.Rect;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import com.google.android.gms.ads.AdRequest;
import digicrafts.extensions.data.AdAdapterPosition;
import digicrafts.extensions.data.AdAdapterSize;
import digicrafts.extensions.utils.ViewUtils;

import java.util.ArrayList;
import java.util.Map;

/**
 * Created by tsangwailam on 22/8/14.
 */
public class AbstractAdAdapter implements AdAdapterInterface{

    private String _uid;
    private String _size;

    protected Boolean _isShow=false;
    protected Boolean _isLoaded=false;
    protected AdAdapterListener listener;
    protected Map<String,Object> settings;

// Protected Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////


    protected void _show(View view, ViewGroup container, String position, int x, int y, int w, int h){

        // Remove it if already on screen
        if(view.getParent()==container){
            container.removeView(view);
        }

        // check if there any interstitial view on top
        int interstitialID = -1;
        View checkView = container.getChildAt(container.getChildCount()-1);
        if(checkView!=null){
            if(checkView.getTag()=="INTERSTITIAL_VIEW"){
                interstitialID=9;
            }
        }

        // Show the view in position
        if(position.equals(AdAdapterPosition.FLOAT)||_size.equals(AdAdapterSize.INTERSTITIAL)){
            container.addView(view, ViewUtils.getViewParams(x, y, w, h));
        } else {
            container.addView(view, ViewUtils.getViewPositionParams(position,x,y,w,h,0));
            view.setTranslationX(x);
            view.setTranslationY(y);
        }

        // Bring the interstitial back to top
        if(interstitialID>0){
            checkView.bringToFront();
        }

        // Deal with bug that first load not display correctly
        if(AdManager.dummy.getParent()!=container){
            FrameLayout.LayoutParams f = new FrameLayout.LayoutParams(2,2);
            f.leftMargin=10;
            f.topMargin=10;
            container.addView(AdManager.dummy,f);
        }
    }

// Override Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * @return
     */
    public Boolean isShow()
    {
        return _isShow;
    }

    /**
     *
     * @return
     */
    public Boolean isLoaded()
    {
        return _isLoaded;
    }

    /**
     *
     * @return
     */
    public String getId()
    {
        return _uid;
    }

    public void setId(String uid)
    {
        this._uid=uid;
    }

    /**
     *
     * @return
     */
    public String getSize() {
        return _size;
    }

    public void setSize(String size)
    {
        this._size=size;
    }

    /**
     *
     * @return
     */
    public String getNetworkType() {
        return null;
    }

    @Override
    public void show(ViewGroup view, String position, Rect rect){}

    @Override
//    public void remove(ViewGroup view){}
    public void remove(){}

    @Override
    public void load(){}

    @Override
    public void pause(){}

    @Override
    public void resume(){}

    @Override
    public void destroy(){
        this.listener=null;
    }

// Listener Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * @param listener
     */
    public void setListener(AdAdapterListener listener) {

        this.listener = listener;
    }


    /**
     *
     */
    public void callOnAdLoaded() {
        _isLoaded=true;
        if(listener!=null) listener.onAdLoaded(_uid, this.getSize(), this.getNetworkType());
    }

    /**
     *
     */
    public void callOnAdFailedToLoad(String error) {
        if(listener!=null) listener.onAdFailedToLoad(_uid, this.getSize(), this.getNetworkType(),error);
    }

    /**
     *
     */
    public void callOnWillLeaveApplication() {

        if(listener!=null) listener.onWillLeaveApplication(_uid, this.getSize(), this.getNetworkType());
    }

    /**
     *
     */
    public void callOnAdWillPresent() {

        if(listener!=null) listener.onAdWillPresent(_uid, this.getSize(), this.getNetworkType());
    }

    /**
     *
     */
    public void callOnAdDidPresent() {

        if(listener!=null) listener.onAdDidPresent(_uid, this.getSize(), this.getNetworkType());
    }

    /**
     *
     */
    public void callOnAdWillDismiss() {

        if(listener!=null) listener.onAdWillDismiss(_uid, this.getSize(), this.getNetworkType());
    }

    /**
     *
     */
    public void callOnAdDidDismiss() {

        if(listener!=null) listener.onAdDidDismiss(_uid, this.getSize(), this.getNetworkType());
    }


    /**
     *
     */
    public void callLog(String msg) {

        if(listener!=null) listener.onLog(msg);
    }

}
