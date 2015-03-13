//
//  RevmobBanner.m
//  Advertising
//
//  Created by Tsang Wai Lam on 27/1/15.
//
//

#import "RevMobBannerAdapter.h"

@implementation RevMobBannerAdapter {
    BOOL isLoaded_;
}
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


- (id) initWithSize:(NSString*)size adUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings {
    
    if (self=[self init]) {
        
        if(adView_==nil){

            self.size=size;
            self.adUnitId=adUnitId;
            [RevMobAds startSessionWithAppID:adUnitId];
        }
        
    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {
    
//    [delegate_ adLog:[NSString stringWithFormat:@"show %@",adView_]];
    
    [self getAdSize:size_];
    [super showInPosition:position offsetX:x offsetY:y];
    
    if(adView_){
        if(isLoaded_){
            [self show_:adView_ withPosition:position width:originWidth_ height:originHeight_ offsetX:offsetX_ offsetY:offsetY_];
        } else {
            isNeedToShow_=YES;
        }
    } else {
        [delegate_ adAdapter:self didFailToReceiveAdWithError:@"Ad need some warm up!"];
    }

}

- (void) remove{
    [super remove];
    if(adView_){
        [adView_ removeFromSuperview];
    }
}

- (void) load:(NSDictionary*)settings {
    isLoaded_=NO;
    if(adView_==nil){
        self.adView = [[RevMobAds session] bannerView];
        adView_.delegate=self;
    }    
    [adView_ loadAd];

}

- (NSString*) getNetworkType{
    return kNetworkTypeREVMOB;
}

#pragma mark - Helper

- (void) getAdSize:(NSString*)size{
    
    //#define kAdAdapterSizeINTERSTITIAL     @"interstitial" //interstitial
    //#define kAdAdapterSizeBANNER           @"banner" //320x50
    //#define kAdAdapterSizeSMART_BANNER     @"smart_banner" // smart
    //#define kAdAdapterSizeFULL_BANNER      @"ull_banner" // 468x60
    //#define kAdAdapterSizeLEADERBOARD      @"leaderboard" // 728x90
    //#define kAdAdapterSizeWIDE_SKYSCRAPER  @"wide_skyscraper" // 160x600
    //#define kAdAdapterSizeMEDIUM_RECTANGLE @"medium_rectangle" // 300x250
    
    if([size isEqualToString:kAdAdapterSizeBANNER]){
        originWidth_=320;
        originHeight_=50;
    } else if([size isEqualToString:kAdAdapterSizeFULL_BANNER]){
        originWidth_=468;
        originHeight_=60;
    } else if([size isEqualToString:kAdAdapterSizeLEADERBOARD]){
        originWidth_=728;
        originHeight_=90;
    } else if([size isEqualToString:kAdAdapterSizeMEDIUM_RECTANGLE]){
        originWidth_=300;
        originHeight_=250;
    } else if([size isEqualToString:kAdAdapterSizeWIDE_SKYSCRAPER]){
        originWidth_=160;
        originHeight_=600;
    }
    
    // auto select portrait/landscape
    if([AbstractAdAdapter isLandscape]){
        originWidth_=rootController_.view.frame.size.width;
        originHeight_=50;
    } else {
        originWidth_=rootController_.view.frame.size.width;
        originHeight_=50;
    }
    
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
            [adView_ setFrame:CGRectMake(0, 0, originWidth_, originHeight_)];
            [delegate_ adLog:[NSString stringWithFormat:@"loaded ad %@ %f %f %d %d",adView_,adView_.frame.origin.x,adView_.frame.origin.y,originWidth_,originHeight_]];
        [self show_:adView_ withPosition:position_ width:originWidth_ height:originHeight_ offsetX:offsetX_ offsetY:offsetY_];
        
//        [rootController_.view addSubview:adView_];

    }
    isLoaded_=YES;
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
}

- (void)revmobUserClosedTheAd {
    NSLog(@"User closed the ad");
    [delegate_ adAdapterDidDismiss:self];
}


@end
