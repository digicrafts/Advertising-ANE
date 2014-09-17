/**
 * Created by tsangwailam on 11/8/14.
 */
package digicrafts.extensions.adapter {
import digicrafts.extensions.adapter.*;
import digicrafts.extensions.core.AbstractAdaper;
import digicrafts.extensions.data.AdNetworkType;

import flash.display.BitmapData;

public class BackFillAdapter extends AbstractAdaper {

    public var bitmap:BitmapData;

    public function BackFillAdapter(link:String) {

//        this.bitmap=bmp;

        super(AdNetworkType.BACKFILL);
    }
}
}
