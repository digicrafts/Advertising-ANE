//
//  InMobiInterstitial.m
//  Advertising
//
//  Created by Tsang Wai Lam on 8/9/14.
//
//

#import "InMobiInterstitialAdapter.h"

@implementation InMobiInterstitialAdapter
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
            
            // init InMobi
            [InMobi initialize:adUnitId];
            
            // Create an AmazonAdView instance
            self.adView = [[IMInterstitial alloc] initWithAppId:adUnitId];
            
            // Register the ViewController with the delegate to receive callbacks.
            adView_.delegate = self;
            
            // Set slot id
            NSString *slotIdString=[settings objectForKey:kAdAdapterSizeINTERSTITIAL];
            if(slotIdString!=nil){
                NSLog(@"InMobi Interstitial %@", slotIdString);
                [adView_ setSlotId:[slotIdString intValue]];
            }
            
            
        }
    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {
    
    if (adView_.state == kIMInterstitialStateReady){
        [adView_ presentInterstitialAnimated:YES];
    } else {
        isNeedToShow_=YES;
    }
}

- (void) remove{
}

- (void) refresh{
    
    if(adView_){
        [adView_ loadInterstitial];
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeINMOBI;
}

#pragma mark - IMInterstitialDelegate

- (void)interstitialDidReceiveAd:(IMInterstitial *)ad {
//    NSLog(@"Loaded interstitial ad");
    ready_=YES;
    if(isNeedToShow_){
        isNeedToShow_=NO;
        [adView_ presentInterstitialAnimated:YES];
    }
    [delegate_ adAdapterDidReceiveAd:self];
}

- (void)interstitial:(IMInterstitial *)ad didFailToReceiveAdWithError:(IMError *)error {
    NSString *errorMessage = [NSString stringWithFormat:@"Loading ad failed. Error code: %ld, message: %@",(long) [error code], [error localizedDescription]];
//    NSLog(@"%@", errorMessage);
    [delegate_ adAdapter:self didFailToReceiveAdWithError:errorMessage];
}

- (void)interstitialWillPresentScreen:(IMInterstitial *)ad {
    [delegate_ adAdapterWillPresent:self];
}
- (void)interstitialWillDismissScreen:(IMInterstitial *)ad {
    [delegate_ adAdapterWillDismiss:self];
}
- (void)interstitialDidDismissScreen:(IMInterstitial *)ad {
    [delegate_ adAdapterDidDismiss:self];
}
- (void)interstitialWillLeaveApplication:(IMInterstitial *)ad {
    [delegate_ adAdapterWillLeaveApplication:self];
}
-(void)interstitialDidInteract:(IMInterstitial *)ad withParams:(NSDictionary *)dictionary {
    NSLog(@"Interaction with Interstitial happened with params: %@",[dictionary description]);
}

@end
