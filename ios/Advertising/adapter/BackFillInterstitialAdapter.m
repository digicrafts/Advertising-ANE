//
//  BackFillInterstitialAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 10/10/14.
//
//

#import "BackFillInterstitialAdapter.h"

@implementation BackFillInterstitialAdapter

@synthesize linkURL=linkURL_;
@synthesize adView=adView_;

- (void) dealloc {
    
    self.linkURL=nil;
    self.adView=nil;
    
    [super dealloc];
}


- (id) initWithLink:(NSString*) link settings:(NSDictionary*) settings
{
    if (self=[self init]) {
        
//        CGRect rect;
        NSString* url;
        if([settings objectForKey:@"interstitial"]){
            url=[settings objectForKey:@"interstitial"];
        }

        NSString* close_button_url=@"";
        if([settings objectForKey:@"interstitialCloseButton"]){
            close_button_url=[settings objectForKey:@"interstitialCloseButton"];
        }

        if(url && ![url isEqualToString:@""]){
            
            // Get the action link
            self.linkURL = link;
            
            // Create Container
            self.contentContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            [contentContainer_ setTranslatesAutoresizingMaskIntoConstraints:NO];
            [contentContainer_ setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
            contentContainer_.layer.zPosition = MAXFLOAT;
            
            // Get and create the UIImage for the banenr
            NSString* imageFile = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], url];
            UIImage* img=[UIImage imageWithContentsOfFile:imageFile];
            
            // Create the UIButton for the banner
            self.adView = [UIButton buttonWithType:UIButtonTypeCustom];
            [adView_ setImage:img forState:UIControlStateNormal];
            [adView_ addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
            [adView_ setFrame:CGRectMake(0, 0, [img size].width, [img size].height)];
            [adView_ setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            // Create the UIButton for close
            closeButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeButton_ setImage:[UIImage imageNamed:close_button_url] forState:UIControlStateNormal];
            [closeButton_ setTranslatesAutoresizingMaskIntoConstraints:NO];
            [closeButton_ addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
            
            // Add to view
            [contentContainer_ addSubview:adView_];
            [contentContainer_ addSubview:closeButton_];
            
            // Add Contraint to container
            NSLayoutConstraint* topConstraint=[NSLayoutConstraint constraintWithItem:closeButton_ attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentContainer_ attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
            NSLayoutConstraint* rightConstraint=[NSLayoutConstraint constraintWithItem:closeButton_ attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:contentContainer_ attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
            [contentContainer_ addConstraints:@[topConstraint,rightConstraint]];

            // Add Contraint to container
            NSLayoutConstraint* vCenterConstraint=[NSLayoutConstraint constraintWithItem:adView_ attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentContainer_ attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
            NSLayoutConstraint* hCenterConstraint=[NSLayoutConstraint constraintWithItem:adView_ attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentContainer_ attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
            [contentContainer_ addConstraints:@[vCenterConstraint,hCenterConstraint]];
            
        }
        
    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y
{
    if(contentContainer_){
        
        // add the contentContainer view
        if (![contentContainer_ isDescendantOfView:rootController_.view]) {
            
            [rootController_.view addSubview:contentContainer_];
            
            // Add Contraint to container
            NSLayoutConstraint* topConstraint=[NSLayoutConstraint constraintWithItem:contentContainer_ attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rootController_.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
            NSLayoutConstraint* bottomConstraint=[NSLayoutConstraint constraintWithItem:contentContainer_ attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:rootController_.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            NSLayoutConstraint* leftConstraint=[NSLayoutConstraint constraintWithItem:contentContainer_ attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:rootController_.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
            NSLayoutConstraint* rightConstraint=[NSLayoutConstraint constraintWithItem:contentContainer_ attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rootController_.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
            [rootController_.view addConstraints:@[topConstraint,bottomConstraint,leftConstraint,rightConstraint]];
            [delegate_ adAdapterWillPresent:self];
            [delegate_ adAdapterDidPresent:self];
            
        }
   
    }
}

- (void) remove{
    [super remove];
    if(contentContainer_){
        [delegate_ adAdapterWillDismiss:self];
        [contentContainer_ removeFromSuperview];
        [delegate_ adAdapterDidDismiss:self];
    }
}

- (void) load:(NSDictionary*)settings{
    if(!ready_){
        if(contentContainer_){
            ready_=YES;
            [delegate_ adAdapterDidReceiveAd:self];
        } else {
            [delegate_ adAdapter:self didFailToReceiveAdWithError:@"Error loading image"];
        }
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeBACKFILL;
}

- (IBAction)openURL:(id)sender
{
    [delegate_ adAdapterWillLeaveApplication:self];
    
    if (linkURL_!=nil) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkURL_]];
    }
    
    [self remove];
}

@end
