/**
 * Created by tsangwailam on 11/8/14.
 */
package digicrafts.extensions.adapter {
import digicrafts.extensions.core.AbstractAdaper;
import digicrafts.extensions.data.AdNetworkType;

public class AmazonAdapter extends AbstractAdaper {

    public function AmazonAdapter(appKey:String, priority:int=0, weight:int=0) {
        super(AdNetworkType.AMAZON,priority,weight,appKey);
    }
}
}
