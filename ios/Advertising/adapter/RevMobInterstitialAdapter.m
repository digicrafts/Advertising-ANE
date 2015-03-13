//
//  AdmobInterstitialAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 31/8/14.
//
//

#import "RevMobInterstitialAdapter.h"

@implementation RevmobInterstitialAdapter{
    BOOL isLoaded_;
}
@synthesize adView=adView_;

- (void) dealloc {
    
    if(adView_){
        adView_.delegate=nil;
        self.adView=nil;
    }
    [super dealloc];
}

- (void) destroy {
    
    if(adView_){
        adView_.delegate=nil;
        self.adView=nil;
    }
    
    [super destroy];
}


- (id) initWithAdUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings{
    
    if (self=[self init]) {

        if(adView_==nil){
            
            isLoaded_=false;
            
            self.adUnitId=adUnitId;
            [RevMobAds startSessionWithAppID:adUnitId];
            
        }

    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {
    if(adView_){
        
        // Set test mode
        [RevMobAds session].testingMode=testMode_;
        
        // check if already loaded
        if(isLoaded_){
            [adView_ showAd];
        } else {
            isNeedToShow_=YES;
        }

    }
}

- (void) remove{
}

- (void) load:(NSDictionary*)settings {

    if(adView_==nil){
        self.adView = [[RevMobAds session] fullscreen];
        adView_.delegate=self;
    }
    
    if(adView_){
        [delegate_ adLog:@"loadAd"];
        [adView_ loadAd];
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeREVMOB;
}

#pragma mark - RevMobAdsDelegate

- (void)revmobAdDidFailWithError:(NSError *)error {
    NSLog(@"Ad failed with error: %@", error);
    [delegate_ adAdapter:self didFailToReceiveAdWithError:error.debugDescription];
}

- (void)revmobAdDidReceive {
    NSLog(@"Ad loaded successfullly");
    if(isNeedToShow_){
        isNeedToShow_=NO;
        [adView_ showAd];
    }
    [delegate_ adAdapterDidReceiveAd:self];
}

- (void)revmobAdDisplayed {
    NSLog(@"Ad displayed");
    [delegate_ adAdapterWillPresent:self];
    [delegate_ adAdapterDidPresent:self];
}

- (void)revmobUserClickedInTheAd {
    NSLog(@"User clicked in the ad");
    [delegate_ adAdapterWillLeaveApplication:self];
    if(adView_){
        adView_.delegate=nil;
        self.adView=nil;
    }
}

- (void)revmobUserClosedTheAd {
    NSLog(@"User closed the ad");
    [delegate_ adAdapterDidDismiss:self];
    if(adView_){
        adView_.delegate=nil;
        self.adView=nil;
    }
}


@end
