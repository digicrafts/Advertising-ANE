//
//  IAdBannerAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 30/8/14.
//
//

#import "AbstractAdAdapter.h"
#import <iAd/iAd.h>

@interface IAdBannerAdapter : AbstractAdAdapter <ADBannerViewDelegate> {

    ADBannerView *adView_;
    
}
@property (nonatomic, retain) ADBannerView* adView;

- (id) initWithSize:(NSString*)size settings:(NSDictionary*) settings;

@end
