//
//  AdmobBannerAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 29/8/14.
//
//

#import "AbstractAdAdapter.h"
#import "GADBannerView.h"
#import "GADRequest.h"

@class GADBannerView;

@interface AdmobBannerAdapter : AbstractAdAdapter <GADBannerViewDelegate>{
    
    GADBannerView* adView_;
    
}
@property (nonatomic, retain) GADBannerView* adView;

- (id) initWithSize:(NSString*)size adUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings;
    
@end
