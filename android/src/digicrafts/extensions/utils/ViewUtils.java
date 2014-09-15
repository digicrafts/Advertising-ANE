package digicrafts.extensions.utils;

import android.app.Activity;
import android.graphics.Point;
import android.graphics.Rect;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import digicrafts.extensions.data.AdAdapterPosition;

public class ViewUtils {

    public static Point getScreenResolution(Activity activity)
    {
        // get the layout width/height
        DisplayMetrics dm = new DisplayMetrics();
        activity.getWindowManager().getDefaultDisplay().getMetrics(dm);

        // create point
        Point p = new Point();
        p.set(dm.widthPixels,dm.heightPixels);

        return p;
    }

    /**
     *
     * @param v
     * @param rect
     */
    public static void positionAndResizeView(View v, Rect rect)
    {
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(v.getLayoutParams().width, v.getLayoutParams().height);
        params.setMargins(rect.left, rect.top, 0, 0);
        v.setLayoutParams(params);
    }

    /**
     *
     * @param act
     * @return
     */
    public static RelativeLayout getContainerView(Activity act)
    {
        // create a new relative layout
        RelativeLayout rl = new RelativeLayout(act);

        // fint the root view of the activity
        ViewGroup fl = (ViewGroup)act.findViewById(android.R.id.content);
        fl = (ViewGroup)fl.getChildAt(0);
        Log.d("DEBUG", "w: " + fl.getWidth() + "h: " + fl.getHeight());

        // Params
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(-1, -1);
//        new FrameLayout.LayoutParams(-1, -1);
        // add to the root view of the activity
        fl.addView(rl, params);

        return rl;
    }


    public static RelativeLayout.LayoutParams getViewPositionParams(String alignment, int offsetX, int offsetY, int w, int h)
    {

        // create a layout params
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(w,h);

        // alignment vertical rule
        if(alignment.contains("top")){
            params.addRule(RelativeLayout.ALIGN_PARENT_TOP);
        } else if(alignment.contains("bottom")){
            params.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        } else {
            params.addRule(RelativeLayout.CENTER_VERTICAL);
        }

        // alignment horizontal rule
        if(alignment.contains("left")){
            params.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        } else if(alignment.contains("right")){
            params.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
        } else {
            params.addRule(RelativeLayout.CENTER_HORIZONTAL);
        }

        return params;
    }


    public static RelativeLayout.LayoutParams getViewParams(int x, int y, int w, int h)
    {
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(w, h);
        params.setMargins(x, y, 0, 0);
        return params;
    }

}
