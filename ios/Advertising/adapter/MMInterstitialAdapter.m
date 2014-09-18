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

- (void) destroy{
  
    // Notification will fire when an ad causes the application to terminate or enter the background
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MillennialMediaAdWillTerminateApplication object:nil];
    
    // Notification will fire when an ad is tapped.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MillennialMediaAdWasTapped object:nil];
    
    // Notification will fire when an ad modal will appear.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MillennialMediaAdModalWillAppear object:nil];
    
    // Notification will fire when an ad modal did appear.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MillennialMediaAdModalDidAppear object:nil];
    
    // Notification will fire when an ad modal will dismiss.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MillennialMediaAdModalWillDismiss object:nil];

    // Notification will fire when an ad modal did dismiss.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MillennialMediaAdModalDidDismiss object:nil];
    
    [super destroy];
}

- (void) dealloc {
    
    [super dealloc];
}

- (id) initWithAdUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings
{
    
    if (self=[self init]) {
            
//            if(MMSDKinited==NULL){
//                MMSDKinited=@"i";
                [MMSDK setLogLevel:MMLOG_LEVEL_DEBUG];
                [MMSDK initialize]; //Initialize a Millennial Media session
                cached_=NO;
//            }
            isNeedToShow_=false;
        
        // Notification will fire when an ad causes the application to terminate or enter the background
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillTerminateFromAd:)
                                                     name:MillennialMediaAdWillTerminateApplication
                                                   object:nil];
        
        // Notification will fire when an ad is tapped.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(adWasTapped:)
                                                     name:MillennialMediaAdWasTapped
                                                   object:nil];
        
        // Notification will fire when an ad modal will appear.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(adModalWillAppear:)
                                                     name:MillennialMediaAdModalWillAppear
                                                   object:nil];
        
        // Notification will fire when an ad modal did appear.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(adModalDidAppear:)
                                                     name:MillennialMediaAdModalDidAppear
                                                   object:nil];
        
        // Notification will fire when an ad modal will dismiss.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(adModalWillDismiss:)
                                                     name:MillennialMediaAdModalWillDismiss
                                                   object:nil];
        
        // Notification will fire when an ad modal did dismiss.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(adModalDidDismiss:)
                                                     name:MillennialMediaAdModalDidDismiss
                                                   object:nil];

    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {
    
//        NSLog(@"show interstitial %@ %d",adUnitId_,[MMInterstitial isAdAvailableForApid:adUnitId_]);
    
        // check if interstitial ready
        if (cached_||[MMInterstitial isAdAvailableForApid:adUnitId_]) {
            cached_=NO;
            [MMInterstitial displayForApid:adUnitId_
                        fromViewController:rootController_
                           withOrientation:MMOverlayOrientationTypeAll
                              onCompletion:^(BOOL success, NSError *error) {
                                  if(success){
//                                      [delegate_ adAdapterWillPresent:self];
//                                      [delegate_ adAdapterDidPresent:self];
                                  }
                              }];
            
        } else {
            isNeedToShow_=YES;
        }
}

- (void) remove{

}

- (void) load:(NSDictionary*)settings {
    
    if(![MMInterstitial isAdAvailableForApid:adUnitId_]){

        //MMRequest Object
        MMRequest *request = [MMRequest request];
        
        // Set extra parameters
        NSString *age=[settings objectForKey:@"age"];
        if(age)
            request.age=[NSNumber numberWithInt:[age intValue]];

        //Replace YOUR_APID with the APID provided to you by Millennial Media
        [MMInterstitial fetchWithRequest:request
                                    apid:adUnitId_
                            onCompletion:^(BOOL success, NSError *error) {
                                if (success) {
                                    [delegate_ adAdapterDidReceiveAd:self];
                                    if(isNeedToShow_){
                                        isNeedToShow_=NO;
                                        [MMInterstitial displayForApid:adUnitId_
                                                    fromViewController:rootController_
                                                       withOrientation:MMOverlayOrientationTypeAll
                                                          onCompletion:^(BOOL success, NSError *error) {
                                                              if(success){
//                                                                  [delegate_ adAdapterWillPresent:self];
//                                                                  [delegate_ adAdapterDidPresent:self];
                                                              }
                                                          }];
                                    } else {
                                        cached_=YES;
                                    }
                                }
                                else {
                                    if ([error.description rangeOfString:@"already cached"].location == NSNotFound) {
                                        [delegate_ adAdapter:self didFailToReceiveAdWithError:error.description];
                                    } else {
                                        [delegate_ adAdapterDidReceiveAd:self];
                                        if(isNeedToShow_){
                                            isNeedToShow_=NO;
                                            [MMInterstitial displayForApid:adUnitId_
                                                        fromViewController:rootController_
                                                           withOrientation:MMOverlayOrientationTypeAll
                                                              onCompletion:^(BOOL success, NSError *error) {
                                                                  if(success){
//                                                                      [delegate_ adAdapterWillPresent:self];
//                                                                      [delegate_ adAdapterDidPresent:self];
                                                                  }
                                                              }];
                                        } else {
                                            cached_=YES;
                                        }
                                    }
                                }
                            }];
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeMILLENNIALMEDIA;
}

#pragma mark - Millennial Media Notification Methods

- (void)adWasTapped:(NSNotification *)notification {
//    NSLog(@"AD WAS TAPPED");
//    NSLog(@"TAPPED AD IS TYPE %@", [[notification userInfo] objectForKey:MillennialMediaAdTypeKey]);
//    NSLog(@"TAPPED AD APID IS %@", [[notification userInfo] objectForKey:MillennialMediaAPIDKey]);
//    NSLog(@"TAPPED AD IS OBJECT %@", [[notification userInfo] objectForKey:MillennialMediaAdObjectKey]);
    
//    if ([[notification userInfo] objectForKey:MillennialMediaAdObjectKey] == _bannerAdView) {
//        NSLog(@"TAPPED AD IS THE _bannerAdView INSTANCE VARIABLE");
//    }
}

- (void)applicationWillTerminateFromAd:(NSNotification *)notification {
//    NSLog(@"AD WILL OPEN SAFARI");
    // No User Info is passed for this notification
    [delegate_ adAdapterWillLeaveApplication:self];
}

- (void)adModalWillDismiss:(NSNotification *)notification {
//    NSLog(@"AD MODAL WILL DISMISS");
//    NSLog(@"AD IS TYPE %@", [[notification userInfo] objectForKey:MillennialMediaAdTypeKey]);
//    NSLog(@"AD APID IS %@", [[notification userInfo] objectForKey:MillennialMediaAPIDKey]);
//    NSLog(@"AD IS OBJECT %@", [[notification userInfo] objectForKey:MillennialMediaAdObjectKey]);
    [delegate_ adAdapterWillDismiss:self];
}

- (void)adModalDidDismiss:(NSNotification *)notification {
//    NSLog(@"AD MODAL DID DISMISS");
//    NSLog(@"AD IS TYPE %@", [[notification userInfo] objectForKey:MillennialMediaAdTypeKey]);
//    NSLog(@"AD APID IS %@", [[notification userInfo] objectForKey:MillennialMediaAPIDKey]);
//    NSLog(@"AD IS OBJECT %@", [[notification userInfo] objectForKey:MillennialMediaAdObjectKey]);
    [delegate_ adAdapterDidDismiss:self];
}

- (void)adModalWillAppear:(NSNotification *)notification {
//    NSLog(@"AD MODAL WILL APPEAR");
//    NSLog(@"AD IS TYPE %@", [[notification userInfo] objectForKey:MillennialMediaAdTypeKey]);
//    NSLog(@"AD APID IS %@", [[notification userInfo] objectForKey:MillennialMediaAPIDKey]);
//    NSLog(@"AD IS OBJECT %@", [[notification userInfo] objectForKey:MillennialMediaAdObjectKey]);
    [delegate_ adAdapterWillPresent:self];
}

- (void)adModalDidAppear:(NSNotification *)notification {
//    NSLog(@"AD MODAL DID APPEAR");
//    NSLog(@"AD IS TYPE %@", [[notification userInfo] objectForKey:MillennialMediaAdTypeKey]);
//    NSLog(@"AD APID IS %@", [[notification userInfo] objectForKey:MillennialMediaAPIDKey]);
//    NSLog(@"AD IS OBJECT %@", [[notification userInfo] objectForKey:MillennialMediaAdObjectKey]);
    [delegate_ adAdapterDidPresent:self];
}

@end
