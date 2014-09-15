//
//  InMobiBannerAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 7/9/14.
//
//

#import "InMobiBannerAdapter.h"

@implementation InMobiBannerAdapter
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
            
            // init InMobi
            [InMobi initialize:adUnitId];
            
            // select size
            int adSize = [self getAdSize:size];
            
            self.adView = [[IMBanner alloc] initWithFrame:CGRectMake(0, 0, originWidth_, originHeight_)
                                                    appId:adUnitId
                                                   adSize:adSize];
            // set delegate
            adView_.delegate=self;
            
            // Set slot id
            NSString *slotIdString=[settings objectForKey:size];
            if([size isEqual:kAdAdapterSizeSMART_BANNER]){
                // for smart banner
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
                    slotIdString=[settings objectForKey:kAdAdapterSizeLEADERBOARD];
                } else {
                    if ([AbstractAdAdapter isLandscape]) {
                        slotIdString=[settings objectForKey:kAdAdapterSizeFULL_BANNER];
                    } else {
                        slotIdString=[settings objectForKey:kAdAdapterSizeBANNER];
                    }
                }
            }
                
            if(slotIdString!=nil){
                NSLog(@"InMobi banner size: %@ id: %@", size,slotIdString);
                [adView_ setSlotId:[slotIdString intValue]];
            }

        }
        
    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {
    
    [super showInPosition:position offsetX:x offsetY:y];

    if(adView_&&ready_){
        [self show_:adView_ withPosition:position width:originWidth_ height:originHeight_ offsetX:offsetX_ offsetY:offsetY_];
    }
}

- (void) remove{
    [super remove];
    if(adView_){
        [adView_ removeFromSuperview];
    }
}

- (void) refresh{    
    if(adView_){
        [adView_ loadBanner];
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeINMOBI;
}


#pragma mark - Helper

- (int) getAdSize:(NSString*)size{
    
    if([size isEqualToString:kAdAdapterSizeBANNER]){
        originWidth_=320;
        originHeight_=50;
        return IM_UNIT_320x50;
    } else if([size isEqualToString:kAdAdapterSizeFULL_BANNER]){
        originWidth_=468;
        originHeight_=60;
        return IM_UNIT_468x60;
    } else if([size isEqualToString:kAdAdapterSizeLEADERBOARD]){
        originWidth_=728;
        originHeight_=90;
        return IM_UNIT_728x90;
    } else if([size isEqualToString:kAdAdapterSizeMEDIUM_RECTANGLE]){
        originWidth_=300;
        originHeight_=250;
        return IM_UNIT_300x250;
    } else if([size isEqualToString:kAdAdapterSizeWIDE_SKYSCRAPER]){
        originWidth_=160;
        originHeight_=600;
        return IM_UNIT_120x600;
    }
    
    // for smart banner
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
//        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
//            originWidth_=1024;
//            originHeight_=50;
//            return IM_UNIT_728x90;
//        } else {
            originWidth_=728;
            originHeight_=90;
            return IM_UNIT_728x90;
//        }
    }
    else {
        if ([AbstractAdAdapter isLandscape]) {
            originWidth_=468;
            originHeight_=60;
            return IM_UNIT_468x60;
        } else {
            originWidth_=320;
            originHeight_=50;
            return IM_UNIT_320x50;
        }
    }
}

#pragma mark - IMBannerDelegate


- (void)bannerDidReceiveAd:(IMBanner *)banner {
//    NSLog(@"Finished loading banner ad.");
    ready_=YES;
    if(visible_==NO&&isNeedToShow_){
        [self show_:adView_ withPosition:position_ width:originWidth_ height:originHeight_ offsetX:offsetX_ offsetY:offsetY_];
    }
    [delegate_ adAdapterDidReceiveAd:self];
}
- (void)banner:(IMBanner *)banner didFailToReceiveAdWithError:(IMError *)error {
    NSString *errorMessage = [NSString stringWithFormat:@"Loading banner ad failed. Error code: %ld, message: %@", (long)[error code], [error localizedDescription]];
    NSLog(@"%@", errorMessage);
    [delegate_ adAdapter:self didFailToReceiveAdWithError:error.description];
}

-(void)bannerDidInteract:(IMBanner *)banner withParams:(NSDictionary *)dictionary {

}
- (void)bannerWillPresentScreen:(IMBanner *)banner {
    [delegate_ adAdapterWillPresent:self];
}
- (void)bannerWillDismissScreen:(IMBanner *)banner {
    [delegate_ adAdapterWillDismiss:self];
}
- (void)bannerDidDismissScreen:(IMBanner *)banner {
    [delegate_ adAdapterDidDismiss:self];
}
- (void)bannerWillLeaveApplication:(IMBanner *)banner {
    [delegate_ adAdapterWillLeaveApplication:self];
}

@end
