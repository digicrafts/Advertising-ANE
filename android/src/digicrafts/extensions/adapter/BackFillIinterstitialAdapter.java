package digicrafts.extensions.adapter;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Point;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import digicrafts.extensions.core.AbstractAdAdapter;
import digicrafts.extensions.data.AdAdapterNetworkType;
import digicrafts.extensions.data.AdAdapterPosition;
import digicrafts.extensions.data.AdAdapterSize;
import digicrafts.extensions.utils.ViewUtils;

import java.io.InputStream;
import java.util.Map;

/**
 * Created by tsangwailam on 20/8/14.
 */
public class BackFillIinterstitialAdapter extends AbstractAdAdapter {

    private RelativeLayout _container;
    private ImageView _closeButton;
    private ImageView _adView;
    private String _link;
    private int _adWidth;
    private int _adHeight;
    private int _buttonWidth;
    private int _buttonHeight;
    private Boolean _loadCompleted;


    public BackFillIinterstitialAdapter(final Activity activity, String adUnitId, Map<String, Object> settings){

        if(activity!=null) {

            // set link
            _link=adUnitId;

            // URl for image
            String url="";

            // init
            this.settings=settings;
            _loadCompleted=false;

            // Create container
            _container = new RelativeLayout(activity);
            _container.setTag("INTERSTITIAL_VIEW");
            _container.setId(99);
            _container.setBackgroundColor(Color.argb(200,0,0,0));

            // Create an ad.
            _adView = new ImageView(activity);
            _adView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if(_link!=null&&_link!=""){
                        Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(_link));
                        activity.startActivity(browserIntent);
                    }
                }
            });

            // Lod the ad image
            try {
                url=settings.get("interstitial").toString();
                // Load image file
                InputStream ims = activity.getAssets().open(url);
                // load image as Drawable
                Drawable d = Drawable.createFromStream(ims, null);
                // get the size
                _adWidth=d.getIntrinsicWidth();
                _adHeight=d.getIntrinsicHeight();
                // set image to ImageView
                _adView.setImageDrawable(d);
                _loadCompleted=true;
            } catch (Exception error){
                _adView=null;
            }

            Log.d("DEBUG","load banner: "+url);

            // Create close button.
            _closeButton = new ImageView(activity);
            _closeButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    remove();
                }
            });

            // Load the ad image
            try {
                url=settings.get("interstitialCloseButton").toString();
                // Load image file
                InputStream ims = activity.getAssets().open(url);
                // load image as Drawable
                Drawable d = Drawable.createFromStream(ims, null);
                // get the size
                _buttonWidth=d.getIntrinsicWidth();
                _buttonHeight=d.getIntrinsicHeight();
                // set image to ImageView
                _closeButton.setImageDrawable(d);
            } catch (Exception error){

            }
            _container.addView(_adView,ViewUtils.getViewPositionParams("center",0,0,_adWidth,_adHeight,0));
            _container.addView(_closeButton,ViewUtils.getViewPositionParams("top_right",0,0,_buttonWidth,_buttonHeight,0));

        } else {

        }

    }

    @Override
    public String getNetworkType() {
        return AdAdapterNetworkType.BACKFILL;
    }


    @Override
    public void show(ViewGroup view, String position, Rect rect){
        if(_container!=null) {
            _show(_container, view, "float", 0, 0, RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);
//            _show(_container, view, "float", 0, 0, 300, 300);
        }

    }

    @Override
    public void remove(){
        if(_container.getParent() !=null) {
            ((ViewGroup)_container.getParent()).removeView(_container);
        }
    }

    @Override
    public void load(){
        if(_adView!=null){
            if(_loadCompleted) {
                _isLoaded=true;
                callOnAdLoaded();
            } else {
                _isLoaded=false;
                callOnAdFailedToLoad("Error loading file.");
            }
        }
    }

    @Override
    public void destroy(){

        remove();

        if(_container!=null) {
            _container = null;
        }
        super.destroy();
    }

}
