//
//  IAdBannerAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 30/8/14.
//
//

#import "IAdBannerAdapter.h"

@implementation IAdBannerAdapter

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


- (id) initWithSize:(NSString*)size settings:(NSDictionary*) settings{
    
    if (self=[self init]) {
        
        if(adView_==nil){
            
            // On iOS 6 ADBannerView introduces a new initializer, use it when available.
            if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
                self.adView = [[ADBannerView alloc] initWithAdType:[self getADAdType:size]];
            } else {
                self.adView = [[ADBannerView alloc] init];
            }

            [adView_ setTranslatesAutoresizingMaskIntoConstraints:YES];
            [adView_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin];
            adView_.delegate=self;
            
        }
    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {
    
    [super showInPosition:position offsetX:x offsetY:y];
    
    //
    if ([AbstractAdAdapter isLandscape]) {
        adView_.currentContentSizeIdentifier=ADBannerContentSizeIdentifierLandscape;
    } else {
        adView_.currentContentSizeIdentifier=ADBannerContentSizeIdentifierPortrait;
    }
    
    if([size_ isEqualToString:kAdAdapterSizeBANNER]){
        originWidth_=320;
        adView_.currentContentSizeIdentifier=ADBannerContentSizeIdentifier320x50;
//    } else if([size_ isEqualToString:kAdAdapterSizeFULL_BANNER]){
//        originWidth_=480;
//        originHeight_=60;
//        adView_.currentContentSizeIdentifier=ADBannerContentSizeIdentifier480x32;
    } else if([size_ isEqualToString:kAdAdapterSizeLEADERBOARD]){
        originWidth_=728;
        originHeight_=90;
        adView_.currentContentSizeIdentifier=ADBannerContentSizeIdentifierPortrait;
    } else if([size_ isEqualToString:kAdAdapterSizeMEDIUM_RECTANGLE]){
        originWidth_=300;
        originHeight_=250;
    } else if([size_ isEqualToString:kAdAdapterSizeWIDE_SKYSCRAPER]){
        originWidth_=160;
        originHeight_=600;
    } else {
        originWidth_=rootController_.view.frame.size.width;
    }
    

    [adView_ sizeToFit];
    
//    NSLog(@"showInPosition ready_:%d x:%d y%d w2:%d h2:%d loaded:%d",ready_,offsetX_,offsetY_,originWidth_,originHeight_,[adView_ isBannerLoaded]);
    
    //
    if(adView_){
        if(originWidth_>0)
            [self show_:adView_ withPosition:position width:originWidth_ height:adView_.frame.size.height offsetX:x offsetY:y];
        else
            [self show_:adView_ withPosition:position width:adView_.frame.size.width height:adView_.frame.size.height offsetX:x offsetY:y];
    }
}

- (void) remove{
    [super remove];
    if(adView_){
        [adView_ removeFromSuperview];
    }
}

- (void) load:(NSDictionary*)settings {
    if(adView_){
        ready_=NO;
        if(adView_.isBannerLoaded){
            
        }
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeIAD;
}


#pragma mark - Helper

- (ADAdType) getADAdType:(NSString*)size{

    if([size isEqualToString:kAdAdapterSizeMEDIUM_RECTANGLE]) {     
        return ADAdTypeMediumRectangle;
    }
    return ADAdTypeBanner;
}

#pragma mark - ADBannerViewDelegate

- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [delegate_ adAdapter:self didFailToReceiveAdWithError:error.description];
}

- (void) bannerViewActionDidFinish:(ADBannerView *)banner {
    [delegate_ adAdapterWillDismiss:self];
    [delegate_ adAdapterDidDismiss:self];
}

- (void) bannerViewDidLoadAd:(ADBannerView *)banner {
    ready_=YES;
    if(visible_==NO&&isNeedToShow_){
        [self show_:adView_ withPosition:position_ width:originWidth_ height:banner.frame.size.height offsetX:offsetX_ offsetY:offsetY_];
    }
    [delegate_ adAdapterDidReceiveAd:self];
}

- (void) bannerViewWillLoadAd:(ADBannerView *)banner {
    NSLog(@"bannerViewWillLoadAd visible:%d needtoshow:%d",visible_,isNeedToShow_);
}

@end
