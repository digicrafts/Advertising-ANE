//
//  BackFillAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 8/10/14.
//
//

#import "AbstractAdAdapter.h"

@interface BackFillBannerAdapter : AbstractAdAdapter {
    
    NSString *linkURL_;
    UIButton *bannerView_;

}
@property (nonatomic, retain) NSString *linkURL;
@property (nonatomic, retain) UIButton *bannerView;

- (id) initWithSize:(NSString*)size link:(NSString*) link settings:(NSDictionary*) settings;

@end
