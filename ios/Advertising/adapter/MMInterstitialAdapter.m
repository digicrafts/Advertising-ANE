//
//  MMInterstitialAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 7/9/14.
//
//

#import "MMInterstitialAdapter.h"

@implementation MMInterstitialAdapter

//static NSString* MMSDKinited = nil;

- (void) dealloc {
    
    [super dealloc];
}

- (id) initWithAdUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings
{
    
    if (self=[self init]) {
            
//            if(MMSDKinited==NULL){
//                MMSDKinited=@"i";
//                [MMSDK setLogLevel:MMLOG_LEVEL_DEBUG];
                [MMSDK initialize]; //Initialize a Millennial Media session
                
//            }        
            isNeedToShow_=false;

    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {
    
//        NSLog(@"show interstitial %@ %d",adUnitId_,[MMInterstitial isAdAvailableForApid:adUnitId_]);
    
        // check if interstitial ready
        if ([MMInterstitial isAdAvailableForApid:adUnitId_]) {
            [MMInterstitial displayForApid:adUnitId_
                        fromViewController:rootController_
                           withOrientation:MMOverlayOrientationTypeAll
                              onCompletion:^(BOOL success, NSError *error) {
                                  if(success){
                                      [delegate_ adAdapterWillPresent:self];
                                      [delegate_ adAdapterDidPresent:self];
                                  }
                              }];
            
        } else {
            isNeedToShow_=YES;
        }
}

- (void) remove{

}

- (void) refresh{
    
    if(![MMInterstitial isAdAvailableForApid:adUnitId_]){

        //MMRequest Object
        MMRequest *request = [MMRequest request];
        
        //Replace YOUR_APID with the APID provided to you by Millennial Media
        [MMInterstitial fetchWithRequest:request
                                    apid:adUnitId_
                            onCompletion:^(BOOL success, NSError *error) {
                                        NSLog(@"refresh interstitial complete");
                                if (success) {
                                    NSLog(@"MMInterstitial available");
                                    if(isNeedToShow_){
                                        isNeedToShow_=NO;
                                        [MMInterstitial displayForApid:adUnitId_
                                                    fromViewController:rootController_
                                                       withOrientation:MMOverlayOrientationTypeAll
                                                          onCompletion:^(BOOL success, NSError *error) {
                                                              if(success){
                                                                  [delegate_ adAdapterWillPresent:self];
                                                                  [delegate_ adAdapterDidPresent:self];
                                                              }
                                                          }];
                                    }
                                    [delegate_ adAdapterDidReceiveAd:self];
                                }
                                else {
                                    NSLog(@"MMInterstitial Error fetching ad: %@", error);
                                    [delegate_ adAdapter:self didFailToReceiveAdWithError:error.description];
                                }
                            }];
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeMILLENNIALMEDIA;
}


@end
