/**
 * Created by tsangwailam on 11/8/14.
 */
package digicrafts.extensions.adapter {
import digicrafts.extensions.adapter.*;
import digicrafts.extensions.core.AbstractAdaper;
import digicrafts.extensions.data.AdNetworkType;

public class IAdAdapter extends AbstractAdaper {

    public function IAdAdapter(priority:int=0, weight:int=0) {
        super(AdNetworkType.IAD,priority,weight);
    }

}
}
