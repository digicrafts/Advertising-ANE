//
//  AmazonInterstitialAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 7/9/14.
//
//

#import "AbstractAdAdapter.h"
#import <AmazonAd/AmazonAdRegistration.h>
#import <AmazonAd/AmazonAdOptions.h>
#import <AmazonAd/AmazonAdInterstitial.h>

@interface AmazonInterstitialAdapter : AbstractAdAdapter <AmazonAdInterstitialDelegate>{
    
    AmazonAdInterstitial* adView_;
      
}
@property (nonatomic, retain) AmazonAdInterstitial* adView;

- (id) initWithAdUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings;

@end
