/**
 * Created by tsangwailam on 11/8/14.
 */
package digicrafts.extensions.adapter {
import digicrafts.extensions.adapter.*;
import digicrafts.extensions.core.AbstractAdaper;
import digicrafts.extensions.data.AdNetworkType;

import flash.display.BitmapData;

public class InHouseAdapter extends AbstractAdaper {

    public var bitmap:BitmapData;

    public function InHouseAdapter(link:String,priority:int, weight:int) {

//        this.bitmap=bmp;

        super(AdNetworkType.BITMAP,priority,weight);
    }
}
}
