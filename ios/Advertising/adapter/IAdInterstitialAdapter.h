//
//  IAdInterstitialAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 30/8/14.
//
//

#import "AbstractAdAdapter.h"
#import <iAd/iAd.h>

@interface IAdInterstitialAdapter : AbstractAdAdapter <ADInterstitialAdDelegate> {
    
    ADInterstitialAd* adView_;
    
}
@property (nonatomic, retain) ADInterstitialAd* adView;

- (id) initWithSettings:(NSDictionary*) settings;

@end
