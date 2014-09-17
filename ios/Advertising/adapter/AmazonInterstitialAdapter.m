//
//  AmazonInterstitialAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 7/9/14.
//
//

#import "AmazonInterstitialAdapter.h"

@implementation AmazonInterstitialAdapter

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


- (id) initWithAdUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings{
    
    if (self=[self init]) {
        
        if(adView_==nil){
            
            // Set the ad unit id
            [[AmazonAdRegistration sharedRegistration] setAppKey:adUnitId];
            
            // Create an AmazonAdView instance
            self.adView = [AmazonAdInterstitial amazonAdInterstitial];
            
            // Register the ViewController with the delegate to receive callbacks.
            adView_.delegate = self;
            
        }
    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {
    
//    NSLog(@"amazon showInPosition %d",[adView_ isReady]);
    
    if([adView_ isReady]){
        [adView_ presentFromViewController:rootController_];
    } else {
        isNeedToShow_=YES;
    }
}

- (void) remove{
}

- (void) load:(NSDictionary*)settings{

    NSLog(@"amazon refresh %d %d",[adView_ isShowing],[adView_ isReady]);
    
    if(adView_&&![adView_ isShowing]&&![adView_ isReady]){
        
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
        [adView_ load:options];
        
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeAMAZON;
}

#pragma mark - AmazonAdInterstitialDelegate

- (UIViewController*) viewControllerForPresentingModalView {
    return rootController_;
}


- (void)interstitialDidLoad:(AmazonAdInterstitial *)interstitial
{
    if(isNeedToShow_){
        isNeedToShow_=NO;
        [adView_ presentFromViewController:rootController_];
    }
    [delegate_ adAdapterDidReceiveAd:self];
}

- (void)interstitialDidFailToLoad:(AmazonAdInterstitial *)interstitial withError:(AmazonAdError *)error
{
    [delegate_ adAdapter:self didFailToReceiveAdWithError:@"amazon error"];
}

- (void)interstitialWillPresent:(AmazonAdInterstitial *)interstitial
{
    [delegate_ adAdapterWillPresent:self];
}

- (void)interstitialDidPresent:(AmazonAdInterstitial *)interstitial
{
     [delegate_ adAdapterDidPresent:self];
}

- (void)interstitialWillDismiss:(AmazonAdInterstitial *)interstitial
{
    [delegate_ adAdapterWillDismiss:self];
}

- (void)interstitialDidDismiss:(AmazonAdInterstitial *)interstitial
{
    [delegate_ adAdapterDidDismiss:self];
}

@end
