//
//  RevmobBanner.h
//  Advertising
//
//  Created by Tsang Wai Lam on 27/1/15.
//
//

#import "AbstractAdAdapter.h"
#import <RevMobAds/RevMobAds.h>

@interface RevMobBannerAdapter : AbstractAdAdapter <RevMobAdsDelegate>{
    
    RevMobBannerView* adView_;
}
@property (nonatomic, retain) RevMobBannerView* adView;

- (id) initWithSize:(NSString*)size adUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings;

@end