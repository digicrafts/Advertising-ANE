//
//  InMobiInterstitial.h
//  Advertising
//
//  Created by Tsang Wai Lam on 8/9/14.
//
//

#import "AbstractAdAdapter.h"
#import <UIKit/UIKit.h>
#import "IMInterstitial.h"
#import  "IMInterstitialDelegate.h"
#import "IMError.h"

@interface InMobiInterstitialAdapter : AbstractAdAdapter <IMInterstitialDelegate> {
    
    IMInterstitial* adView_;
    
}
@property (nonatomic, retain) IMInterstitial* adView;

- (id) initWithAdUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings;
@end
