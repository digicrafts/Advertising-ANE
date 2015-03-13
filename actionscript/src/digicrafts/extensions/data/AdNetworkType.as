/**
 * Created by tsangwailam on 13/8/14.
 */
package digicrafts.extensions.data {
import digicrafts.extensions.core.ad_internal;

public class AdNetworkType {

    public static const IAD:String              ='iad';
    public static const ADMOB:String            ='admob';
    public static const MILLENNIALMEDIA:String  ='millennialmedia';
    public static const AMAZON:String           ='amazon';
    public static const INMOBI:String           ='inmobi';
    public static const SAMSUNG:String          ='samsung';
    public static const BACKFILL:String         ='backfill';
    public static const ADCOLONY:String         ='adcolony';
    public static const PLAYHAVEN:String        ='playhaven';
    public static const UNITY:String            ='unity';
    public static const REVMOB:String           ='revmob';
    public static const CHARTBOOST:String       ='chartboost';

    ad_internal static const OFFLINE_NETWORK:Object = {
        'backfill':true
    }

}
}
