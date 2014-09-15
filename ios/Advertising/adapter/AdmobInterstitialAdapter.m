//
//  AdmobInterstitialAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 31/8/14.
//
//

#import "AdmobInterstitialAdapter.h"

@implementation AdmobInterstitialAdapter
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
            
            self.adView = [[GADInterstitial alloc] init];
            self.adUnitId=adUnitId;
            adView_.adUnitID=adUnitId;
            adView_.delegate=self;
        }
    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {
    if(adView_){
        if(adView_.isReady){
            [adView_ presentFromRootViewController:rootController_];
        } else {
            isNeedToShow_=YES;
        }
    }
}

- (void) remove{
//    if(adView_){
//        [adView_ removeFromSuperview];
//    }
}

- (void) refresh{
    
    if(adView_){
        
        NSLog(@"adapter refresh %d", [adView_ hasBeenUsed]);
        
        // check if already used and clean
        if([adView_ hasBeenUsed]){
            
            // clean current interstitial
            adView_.delegate=nil;
            self.adView=nil;
            
            // creat a new one
            self.adView = [[GADInterstitial alloc] init];
            adView_.adUnitID=adUnitId_;
            adView_.delegate=self;
            
        }
        
        GADRequest *request = [GADRequest request];
        
        if(testMode_){
            
            // get device ID;
            NSString *deviceID=[self admobDeviceID_];
            
            NSLog(@"Test Mode %@", deviceID);
            // create arary to hold test device
            NSMutableArray *testDevices=[NSMutableArray array];

            // Enable test ads on simulators.
            [testDevices addObject:GAD_SIMULATOR_ID];
            [testDevices addObject:deviceID];

            // set the test devices
            request.testDevices = testDevices;
//            request.testDevices = @[deviceID];
        }
        
        // load the request
        [self.adView loadRequest:request];
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeADMOB;
}

#pragma mark - GADBannerViewDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    if(isNeedToShow_){
        isNeedToShow_=NO;
        [adView_ presentFromRootViewController:rootController_];
    }
    [delegate_ adAdapterWillDismiss:self];
}

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    [delegate_ adAdapter:self didFailToReceiveAdWithError:error.debugDescription];    
}
- (void)interstitialWillPresentScreen:(GADInterstitial *)interstitial{
    [delegate_ adAdapterWillPresent:self];
    [delegate_ adAdapterDidPresent:self];
}
- (void)interstitialWillDismissScreen:(GADInterstitial *)interstitial
{
    [delegate_ adAdapterWillDismiss:self];
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    [delegate_ adAdapterDidDismiss:self];
}
- (void)interstitialWillLeaveApplication:(GADInterstitial *)interstitial
{
    NSLog(@"interstitialWillLeaveApplication");
}


@end
