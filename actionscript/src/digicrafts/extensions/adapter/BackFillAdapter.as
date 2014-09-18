/**
 * Created by tsangwailam on 11/8/14.
 */
package digicrafts.extensions.adapter {

import digicrafts.extensions.core.AbstractAdaper;
import digicrafts.extensions.data.AdNetworkType;

public class BackFillAdapter extends AbstractAdaper {

    public var url:String="";
    public var interstitial:String='';
    public var banner:String='';
    public var smart_banner:String='';
    public var full_banner:String='';
    public var leaderboard:String='';
    public var medium_rectangle:String='';

    public function BackFillAdapter(url:String,banner:String="") {

        this.url=url;
        this.banner=banner;

        super(AdNetworkType.BACKFILL);
    }
}
}
