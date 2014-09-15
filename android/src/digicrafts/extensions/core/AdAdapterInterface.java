package digicrafts.extensions.core;

import android.graphics.Rect;
import android.view.ViewGroup;

/**
 * Created by tsangwailam on 22/8/14.
 */
public interface AdAdapterInterface {

    public String getId();
    public void setId(String id);
    public Boolean isShow();
//    public Boolean isLoaded();
    public String getSize();
    public void setSize(String size);
    public String getNetworkType();
    public void show(ViewGroup view, String position, Rect rect);
//    public void remove(ViewGroup view);
    public void remove();
    public void load();
    public void pause();
    public void resume();
    public void destroy();
    public void setListener(AdAdapterListener listener);

}
