//
//  BackFillInterstitialAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 10/10/14.
//
//

#import "AbstractAdAdapter.h"
#import <QuartzCore/QuartzCore.h>

@interface BackFillInterstitialAdapter : AbstractAdAdapter {
    
    NSString *linkURL_;
    UIButton *closeButton_;
    UIButton *adView_;
    
}
@property (nonatomic, retain) NSString *linkURL;
@property (nonatomic, retain) UIButton *adView;

- (id) initWithLink:(NSString*) link settings:(NSDictionary*) settings;


@end
