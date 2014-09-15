//
//  IAdInterstitialAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 30/8/14.
//
//

#import "IAdInterstitialAdapter.h"

@implementation IAdInterstitialAdapter

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


- (id) initWithSettings:(NSDictionary*) settings{
    
    if (self=[self init]) {
        
        if(adView_==nil){
//            self.contentContainer=[UIView initWithFrame:CGRectMake(0, 0, 1024, 768);

//            [ADInterstitialAd release];
//            self.adView = [[ADInterstitialAd alloc] init];
//            adView_.delegate=self;
//            rootController_.shouldPresentInterstitialAd=YES;
            rootController_.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
//            [rootController_ requestInterstitialAdPresentation];
            
        }
    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {
    
    [rootController_ requestInterstitialAdPresentation];
    if (adView_.loaded)
    {
        [adView_ presentFromViewController:rootController_];
    } else {
        isNeedToShow_=YES;
    }
    
}

- (void) remove{
    if(adView_){

    }
}

- (void) refresh{
    if(adView_){

    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeIAD;
}

#pragma mark - ADInterstitialViewDelegate

-(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd
{
    NSLog(@"iAd interstitialAd interstitialAdDidLoad");
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
    NSLog(@"iAd interstitialAd unload");
    self.adView=nil;
}


// This method will be invoked when an error has occurred attempting to get advertisement content.
// The ADError enum lists the possible error codes.
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    [delegate_ adAdapter:self didFailToReceiveAdWithError:error.description];
}


- (void)interstitialAdWillLoad:(ADInterstitialAd *)interstitialAd
{
    NSLog(@"iAd interstitialAd interstitialAdWillLoad");
}

- (void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd
{
    [delegate_ adAdapterDidDismiss:self];
}

// if you want to show iAd while pushing view controller just use
- (IBAction)onSearchClick:(id)sender {
//    if (interstitial.loaded) {
//        //        [interstitial presentFromViewController:self]; // deprecated in iOS 6.
////        [self requestInterstitialAdPresentation]; // it will load iAD Full screen mode.
//    }
//    // do whatever you want to do.
}

@end
