//
//  AmazonBannerAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 29/8/14.
//
//

#import "AmazonBannerAdapter.h"

@implementation AmazonBannerAdapter

@synthesize adView=adView_;

- (void) dealloc {
    
    adView_.delegate=nil;
    self.adView=nil;
    
    [super dealloc];
}

- (void) destroy {
    
    adView_.delegate=nil;
    self.adView=nil;
    
    [super destroy];
}


- (id) initWithSize:(NSString*)size adUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings{
    
    if (self=[self init]) {        
        
        if(adView_==nil){
            
            // Set the ad unit id
            [[AmazonAdRegistration sharedRegistration] setAppKey:adUnitId];
            
            // Create an AmazonAdView instance
            self.adView = [AmazonAdView amazonAdViewWithAdSize:[self getAdSize:size]];
            
            // Register the ViewController with the delegate to receive callbacks.
            adView_.delegate = self;

            
        }
    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y
{
    [super showInPosition:position offsetX:x offsetY:y];
    
    if(adView_&&ready_){
        [self show_:adView_ withPosition:position width:adView_.frame.size.width height:adView_.frame.size.height offsetX:x offsetY:y];
    }
}

- (void) remove{
    [super remove];
    if(adView_){
        [adView_ removeFromSuperview];
    }
}

- (void) load:(NSDictionary*)settings {
    if(adView_){        
        
        // Set the adOptions.
        AmazonAdOptions *options = [AmazonAdOptions options];
        
        // Turn on isTestRequest to load a test ad
        if(testMode_)
            options.isTestRequest = YES;
        
        // Get extra parameter
        Boolean enableLocation=[settings objectForKey:@"enableGeoLocation"];
        if(enableLocation)
            options.usesGeoLocation=YES;
        NSNumber *age=[settings objectForKey:@"age"];
        if(age)
            options.age=age;

        // Call loadAd
        [adView_ loadAd:options];
        
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeAMAZON;
}


#pragma mark - Helper

- (CGSize) getAdSize:(NSString*)size{
    
    if([size isEqualToString:kAdAdapterSizeBANNER]){
        return AmazonAdSize_320x50;
    } else if([size isEqualToString:kAdAdapterSizeFULL_BANNER]){
        return AmazonAdSize_320x50;
    } else if([size isEqualToString:kAdAdapterSizeLEADERBOARD]){
        return AmazonAdSize_728x90;
    } else if([size isEqualToString:kAdAdapterSizeMEDIUM_RECTANGLE]){
        return AmazonAdSize_300x250;
    } else if([size isEqualToString:kAdAdapterSizeWIDE_SKYSCRAPER]){
        return AmazonAdSize_1024x50;
    }
    
    // for smart banner
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        if ([AbstractAdAdapter isLandscape]){
            return AmazonAdSize_1024x50;
        }        else {
            return AmazonAdSize_728x90;
        }
    }
    else {
        return AmazonAdSize_320x50;
    }

}


#pragma mark - AmazonAdInterstitialDelegate

- (UIViewController*) viewControllerForPresentingModalView {
    return rootController_;
}

- (void)adViewDidLoad:(AmazonAdView *)view {
    ready_=YES;
    if(visible_==NO&&isNeedToShow_){
        [self show_:adView_ withPosition:position_ width:view.frame.size.width height:view.frame.size.height offsetX:offsetX_ offsetY:offsetY_];
    }
    
    [delegate_ adAdapterDidReceiveAd:self];
}

- (void)adViewDidFailToLoad:(AmazonAdView *)view withError:(AmazonAdError *)error {
    [delegate_ adAdapter:self didFailToReceiveAdWithError:@"amazon error"];
}

- (void)adViewDidCollapse:(AmazonAdView *)view {
    [delegate_ adAdapterWillDismiss:self];
}

- (void)adViewWillExpand:(AmazonAdView *)view {
    [delegate_ adAdapterWillPresent:self];
}

@end
