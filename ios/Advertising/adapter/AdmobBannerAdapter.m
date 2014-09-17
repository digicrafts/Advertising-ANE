//
//  AdmobBannerAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 29/8/14.
//
//

#import "AdmobBannerAdapter.h"
#import <AdSupport/AdSupport.h>
#include <CommonCrypto/CommonDigest.h>

@implementation AdmobBannerAdapter

@synthesize adView=adView_;

- (void) dealloc {
    adView_.rootViewController=nil;
    adView_.delegate=nil;
    self.adView=nil;
    
    [super dealloc];
}

- (void) destroy {
    
    adView_.rootViewController=nil;
    adView_.delegate=nil;
    self.adView=nil;
    
    [super destroy];
}


- (id) initWithSize:(NSString*)size adUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings{
    
    if (self=[self init]) {
        if(adView_==nil){
            
            self.adUnitId=adUnitId;
            self.adView = [[GADBannerView alloc] initWithAdSize:[self getAdSize:size]];
            
            adView_.adUnitID=adUnitId;
            adView_.delegate=self;
         
        }
    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y
{    
    [super showInPosition:position offsetX:x offsetY:y];
    
    adView_.rootViewController=rootController_;
    
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

- (void) load:(NSDictionary*)settings{
    
    if(adView_){
        
        adView_.rootViewController=rootController_;
        
        // Fix problem on loading smart banner in landscape mode
        if([size_ isEqual:kAdAdapterSizeSMART_BANNER]){
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                adView_.frame=CGRectMake(0, 0, rootController_.view.frame.size.width, 90);
            else
                adView_.frame=CGRectMake(0, 0, rootController_.view.frame.size.width, 32);
        }
        
        GADRequest *request = [GADRequest request];

        // Set Test Mode
        if(testMode_){
            
            // get device ID;
            NSString *deviceID=[self admobDeviceID_];
            
            // create arary to hold test device
            NSMutableArray *testDevices=[NSMutableArray array];

            // Enable test ads on simulators.
            [testDevices addObject:GAD_SIMULATOR_ID];
            [testDevices addObject:deviceID];
            
            // set the test devices
            request.testDevices = testDevices;

        }        
        
        // load the request
        [self.adView loadRequest:request];
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeADMOB;
}


#pragma mark - Helper

- (GADAdSize) getAdSize:(NSString*)size{
    
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
        return kGADAdSizeBanner;
    } else if([size isEqualToString:kAdAdapterSizeFULL_BANNER]){
        originWidth_=468;
        originHeight_=60;
        return kGADAdSizeFullBanner;
    } else if([size isEqualToString:kAdAdapterSizeLEADERBOARD]){
        originWidth_=728;
        originHeight_=90;
        return kGADAdSizeLeaderboard;
    } else if([size isEqualToString:kAdAdapterSizeMEDIUM_RECTANGLE]){
        originWidth_=300;
        originHeight_=250;
        return kGADAdSizeMediumRectangle;
    } else if([size isEqualToString:kAdAdapterSizeWIDE_SKYSCRAPER]){
        originWidth_=160;
        originHeight_=600;
        return kGADAdSizeSkyscraper;
    }
    
    // auto select portrait/landscape
    if([AbstractAdAdapter isLandscape]){
        originWidth_=rootController_.view.frame.size.width;
        originHeight_=-1;
        return kGADAdSizeSmartBannerLandscape;
    } else {
        originWidth_=rootController_.view.frame.size.width;
        originHeight_=-1;
        return kGADAdSizeSmartBannerPortrait;
    }

}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    ready_=YES;
    if(visible_==NO&&isNeedToShow_){
        if(originHeight_>0)
            [self show_:adView_ withPosition:position_ width:originWidth_ height:originHeight_ offsetX:offsetX_ offsetY:offsetY_];
        else
            [self show_:adView_ withPosition:position_ width:originWidth_ height:bannerView.frame.size.height offsetX:offsetX_ offsetY:offsetY_];
    }
    [delegate_ adAdapterDidReceiveAd:self];
}
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    [delegate_ adAdapter:self didFailToReceiveAdWithError:error.debugDescription];
}
- (void)adViewWillPresentScreen:(GADBannerView *)bannerView
{
    [delegate_ adAdapterWillPresent:self];
    [delegate_ adAdapterDidPresent:self];
}
- (void)adViewDidDismissScreen:(GADBannerView *)bannerView
{
    [delegate_ adAdapterDidDismiss:self];
}
- (void)adViewWillDismissScreen:(GADBannerView *)bannerView
{
    [delegate_ adAdapterWillDismiss:self];
}
- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView
{
    NSLog(@"adViewWillLeaveApplication");
//    [delegate_ adAdapterDidReceiveAd:self];    
}

@end
