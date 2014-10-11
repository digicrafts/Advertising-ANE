package digicrafts.extensions.adapter;

import android.app.Activity;
import android.content.Intent;
import android.graphics.BitmapFactory;
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
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import digicrafts.extensions.core.AbstractAdAdapter;
import digicrafts.extensions.core.AdManager;
import digicrafts.extensions.data.AdAdapterNetworkType;
import digicrafts.extensions.data.AdAdapterSize;
import digicrafts.extensions.utils.ViewUtils;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Map;

/**
 * Created by tsangwailam on 20/8/14.
 */
public class BackFillBannerAdapter extends AbstractAdAdapter {

    private ImageView _adView;
    private String _link;
    private int _adWidth;
    private int _adHeight;
    private int _layouWidth;
    private int _layouHeight;
    private Boolean _loadCompleted;


    public BackFillBannerAdapter(final Activity activity, String size, String adUnitId, Map<String, Object> settings){

        if(activity!=null) {

            // set link
            _link=adUnitId;

            // URl for image
            String url;

            // init
            this.settings=settings;
            _loadCompleted=false;

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

            // Set size
            if(size.equals(AdAdapterSize.BANNER)) {
                _adWidth=320;
                _adHeight=50;
                url=settings.get("banner").toString();
            } else if(size.equals(AdAdapterSize.FULL_BANNER)) {
                _adWidth=480;
                _adHeight=60;
                url=settings.get("full_banner").toString();
            } else if(size.equals(AdAdapterSize.LEADERBOARD)){
                _adWidth=728;
                _adHeight=90;
                url=settings.get("leaderboard").toString();
            }else if(size.equals(AdAdapterSize.MEDIUM_RECTANGLE)){
                _adWidth=300;
                _adHeight=250;
                url=settings.get("medium_rectangle").toString();
            }else if(size.equals(AdAdapterSize.WIDE_SKYSCRAPER)){
                _adWidth=728;
                _adHeight=90;
                url=settings.get("leaderboard").toString();
            } else{
                Point res = ViewUtils.getScreenResolution(activity);
                int w = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, res.x, activity.getResources().getDisplayMetrics());
                int h =(int)TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, res.y, activity.getResources().getDisplayMetrics());

                if(w>=728) {
                    _adWidth=728;
                    _adHeight=90;
                    url=settings.get("leaderboard").toString();
                } else if(w>=480){
                    _adWidth=480;
                    _adHeight=60;
                    url=settings.get("full_banner").toString();
                } else {
                    _adWidth=320;
                    _adHeight=50;
                    url=settings.get("banner").toString();
                }
            }

            try {
                // Load image file
                InputStream ims = activity.getAssets().open(url);
                // load image as Drawable
                Drawable d = Drawable.createFromStream(ims, null);
                // set image to ImageView
                _adView.setImageDrawable(d);
                _loadCompleted=true;
            } catch (Exception error){
                _adView=null;
            }


        } else {

        }

    }

    @Override
    public String getNetworkType() {
        return AdAdapterNetworkType.BACKFILL;
    }


    @Override
    public void show(ViewGroup view, String position, Rect rect){
        if(_adView!=null&&_isLoaded)
            _show(_adView,view,position,rect.left,rect.top,RelativeLayout.LayoutParams.WRAP_CONTENT,RelativeLayout.LayoutParams.WRAP_CONTENT);
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
        if(_adView!=null) {
            _adView = null;
        }
        super.destroy();
    }

}
