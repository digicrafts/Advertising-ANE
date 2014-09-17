//
//  MMBannerAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 7/9/14.
//
//

#import "MMBannerAdapter.h"

static NSString* MMSDKinited = nil;

@implementation MMBannerAdapter
@synthesize adView=adView_;

- (void) dealloc {
    
    adView_.rootViewController=nil;
    self.adView=nil;
    
    [super dealloc];
}

- (void) destroy {
    
    adView_.rootViewController=nil;
    self.adView=nil;
    
    [super destroy];
}


- (id) initWithSize:(NSString*)size adUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings{
    
    if (self=[self init]) {
        if(adView_==nil){
            
            if(MMSDKinited){
                
            } else {

                MMSDKinited=@"i";
                [MMSDK setLogLevel:MMLOG_LEVEL_DEBUG];
                [MMSDK initialize]; //Initialize a Millennial Media session
                
            }
            
            self.adView = [[MMAdView alloc] initWithFrame:[self getAdSize:size]
                                                     apid:adUnitId
                                       rootViewController:nil];
        }
    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {
    
    [super showInPosition:position offsetX:x offsetY:y];
    adView_.rootViewController=rootController_;
    if(adView_&&ready_){
      [self show_:adView_ withPosition:position width:originWidth_ height:originHeight_ offsetX:x offsetY:y];
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
        
        adView_.rootViewController=rootController_;
        
        //MMRequest Object
        MMRequest *request = [MMRequest request];
        
        // Get extra parameter
        NSString *age=[settings objectForKey:@"age"];
        if(age)
            request.age=[NSNumber numberWithInt:[age intValue]];
        
        // load the request
        [adView_ getAdWithRequest:request onCompletion:^(BOOL success, NSError *error) {
            
            if (success) {
                ready_=YES;
                if(visible_==NO&&isNeedToShow_){
                    [self show_:adView_ withPosition:position_ width:originWidth_ height:originHeight_ offsetX:offsetX_ offsetY:offsetY_];
                }
                [delegate_ adAdapterDidReceiveAd:self];
            } else {
                [delegate_ adAdapter:self didFailToReceiveAdWithError:error.description];
            }
        }];
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeMILLENNIALMEDIA;
}


#pragma mark - Helper

- (CGRect) getAdSize:(NSString*)size{
    
    if([size isEqualToString:kAdAdapterSizeBANNER]){
        originWidth_=320;
        originHeight_=50;
        return CGRectMake(0, 0, 320, 50);
    } else if([size isEqualToString:kAdAdapterSizeFULL_BANNER]){
        originWidth_=480;
        originHeight_=60;
        return CGRectMake(0, 0, 480, 60);
    } else if([size isEqualToString:kAdAdapterSizeLEADERBOARD]){
        originWidth_=728;
        originHeight_=90;
        return CGRectMake(0, 0, 728, 90);
    } else if([size isEqualToString:kAdAdapterSizeMEDIUM_RECTANGLE]){
        originWidth_=300;
        originHeight_=250;
        return CGRectMake(0, 0, 300, 250);
    } else if([size isEqualToString:kAdAdapterSizeWIDE_SKYSCRAPER]){
        originWidth_=160;
        originHeight_=600;
        return CGRectMake(0, 0, 160, 600);
    }
    
    // for smart banner
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
//        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
//            originWidth_=1024;
//            originHeight_=90;
//        } else {
            originWidth_=728;
            originHeight_=90;
//        }
    }
    else {
        if ([AbstractAdAdapter isLandscape]) {
            originWidth_=480;
            originHeight_=60;
        } else {
            originWidth_=320;
            originHeight_=50;
        }
    }
    return CGRectMake(0, 0, originWidth_, originHeight_);
}

@end
