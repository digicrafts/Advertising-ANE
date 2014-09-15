//
//  AmazonBannerAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 29/8/14.
//
//

#import "AbstractAdAdapter.h"
#import <AmazonAd/AmazonAdView.h>
#import <AmazonAd/AmazonAdRegistration.h>
#import <AmazonAd/AmazonAdOptions.h>

@interface AmazonBannerAdapter : AbstractAdAdapter <AmazonAdViewDelegate>{
    
    AmazonAdView* adView_;
    
}
@property (nonatomic, retain) AmazonAdView* adView;

- (id) initWithSize:(NSString*)size adUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings;
@end
