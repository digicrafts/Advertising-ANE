//
//  IAdInterstitialAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 30/8/14.
//
//

#import "IAdInterstitialAdapter.h"

@implementation IAdInterstitialAdapter

@synthesize adView=adView_;

- (void) dealloc {
    
    adView_.delegate=nil;
    self.adView=nil;
    
    [super dealloc];
}

- (void) destroy {
    
    [ADInterstitialAd release];
    adView_.delegate=nil;
    self.adView=nil;
    
    [super destroy];
}


- (id) initWithSettings:(NSDictionary*) settings{
    
    if (self=[self init]) {
        if(adView_==nil){
            
            // clean
            [ADInterstitialAd release];
            // create a new intersitial
            self.adView = [[ADInterstitialAd alloc] init];
            adView_.delegate=self;
       }
    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {
    

    
    if (adView_)
    {        
//        [delegate_ adLog:[NSString stringWithFormat:@"show loaded:%d isLoaded:%d",adView_.loaded,adView_.isLoaded]];
        
        if(adView_.isLoaded){
            [adView_ presentFromViewController:rootController_];
            [delegate_ adAdapterWillDismiss:self];
            [delegate_ adAdapterDidDismiss:self];
        } else {
            isNeedToShow_=YES;
        }
    }

}

- (void) remove{
    if(adView_){

    }
}

- (void) load:(NSDictionary*)settings {
    if(adView_){
//        rootController_.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeIAD;
}

#pragma mark - ADInterstitialViewDelegate

-(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd
{
    if(isNeedToShow_){
        isNeedToShow_=NO;
        [adView_ presentFromViewController:rootController_];
    }
    [delegate_ adAdapterDidReceiveAd:self];
}

// When this method is invoked, the application should remove the view from the screen and tear it down.
// The content will be unloaded shortly after this method is called and no new content will be loaded in that view.
// This may occur either when the user dismisses the interstitial view via the dismiss button or
// if the content in the view has expired.
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
//    [delegate_ adLog:@"iAd interstitialAd unload"];
//    NSLog(@"iAd interstitialAd unload");
    self.adView=nil;
    
    // fix problem of no event when dismiss interstitial with close button
    [delegate_ adAdapterWillDismiss:self];
    [delegate_ adAdapterDidDismiss:self];
}


// This method will be invoked when an error has occurred attempting to get advertisement content.
// The ADError enum lists the possible error codes.
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    [delegate_ adAdapter:self didFailToReceiveAdWithError:error.description];
}


- (void)interstitialAdWillLoad:(ADInterstitialAd *)interstitialAd
{
//    [delegate_ adLog:@"iAd interstitialAd interstitialAdWillLoad"];
//    NSLog(@"iAd interstitialAd interstitialAdWillLoad");
}

- (void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd
{
//    [delegate_ adLog:@"iAd interstitialAd interstitialAdActionDidFinish"];
//    [delegate_ adAdapterDidDismiss:self];
}

- (BOOL)interstitialAdActionShouldBegin:(ADInterstitialAd *)interstitialAd
                   willLeaveApplication:(BOOL)willLeave {
    if(willLeave){
        [delegate_ adAdapterWillLeaveApplication:self];
    }
    return YES; // YES allows the action to execute (NO would instead cancel the action).
}

// if you want to show iAd while pushing view controller just use
- (IBAction)onSearchClick:(id)sender {
//    if (interstitial.loaded) {
//        //        [interstitial presentFromViewController:self]; // deprecated in iOS 6.
////        [self requestInterstitialAdPresentation]; // it will load iAD Full screen mode.
//    }
//    // do whatever you want to do.

//    [delegate_ adLog:@"iAd interstitialAd onSearchClick"];
    
}


@end
