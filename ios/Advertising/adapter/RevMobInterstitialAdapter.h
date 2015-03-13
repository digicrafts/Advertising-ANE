//
//  AdmobInterstitialAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 31/8/14.
//
//

#import "AbstractAdAdapter.h"
#import <RevMobAds/RevMobAds.h>

@interface RevmobInterstitialAdapter : AbstractAdAdapter <RevMobAdsDelegate>{
    
    RevMobFullscreen* adView_;
    
}
@property (nonatomic, retain) RevMobFullscreen* adView;

- (id) initWithAdUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings;

@end
