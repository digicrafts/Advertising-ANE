//
//  InMobiBannerAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 7/9/14.
//
//

#import "AbstractAdAdapter.h"
#import "IMBanner.h"
#import "IMBannerDelegate.h"
#import "IMInterstitial.h"
#import "IMInterstitialDelegate.h"
#import "IMIncentivisedDelegate.h"
#import "IMNative.h"
#import "IMNativeDelegate.h"
#import "IMError.h"
#import "InMobiAnalytics.h"


@interface InMobiBannerAdapter : AbstractAdAdapter <IMBannerDelegate>{
    
    IMBanner* adView_;
    
}
@property (nonatomic, retain) IMBanner* adView;

- (id) initWithSize:(NSString*)size adUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings;

@end
