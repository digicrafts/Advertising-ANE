//
//  BackFillAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 8/10/14.
//
//

#import "BackFillBannerAdapter.h"

@implementation BackFillBannerAdapter

@synthesize linkURL=linkURL_;
@synthesize bannerView=bannerView_;


- (void) dealloc {
    
    self.linkURL=nil;
    self.bannerView=nil;
    
    [super dealloc];
}


- (id) initWithSize:(NSString*)size link:(NSString*) link settings:(NSDictionary*) settings {
    
    if (self=[self init]) {
    
        CGRect rect;
        NSString* url;
        
        if([size isEqualToString:kAdAdapterSizeBANNER]){
            originWidth_=320;
            originHeight_=50;
            if([settings objectForKey:@"banner"]){
                url=[settings objectForKey:@"banner"];
            }
        } else if([size isEqualToString:kAdAdapterSizeFULL_BANNER]){
            originWidth_=480;
            originHeight_=60;
            if([settings objectForKey:@"full_banner"]){
                url=[settings objectForKey:@"full_banner"];
            }
        } else if([size isEqualToString:kAdAdapterSizeLEADERBOARD]){
            originWidth_=728;
            originHeight_=90;
            if([settings objectForKey:@"leaderboard"]){
                url=[settings objectForKey:@"leaderboard"];
            }
        } else if([size isEqualToString:kAdAdapterSizeMEDIUM_RECTANGLE]){
            originWidth_=300;
            originHeight_=250;
            if([settings objectForKey:@"medium_rectangle"]){
                url=[settings objectForKey:@"medium_rectangle"];
            }
        } else if([size isEqualToString:kAdAdapterSizeWIDE_SKYSCRAPER]){
            originWidth_=160;
            originHeight_=600;
            if([settings objectForKey:@"banner"]){
                url=[settings objectForKey:@"banner"];
            }
        } else {
            
            // for smart banner
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
                originWidth_=728;
                originHeight_=90;
                if([settings objectForKey:@"leaderboard"]){
                    url=[settings objectForKey:@"leaderboard"];
                }
            }
            else {
                if ([AbstractAdAdapter isLandscape]) {
                    originWidth_=480;
                    originHeight_=60;
                    if([settings objectForKey:@"full_banner"]){
                        url=[settings objectForKey:@"full_banner"];
                    }
                } else {
                    originWidth_=320;
                    originHeight_=50;
                    if([settings objectForKey:@"banner"]){
                        url=[settings objectForKey:@"banner"];
                    }
                }
            }
        }
        
        if(url){
            // create rect
            rect = CGRectMake(0, 0, originWidth_, originHeight_);
            
            // Get the action link
            self.linkURL = link;        
            
            // Get and create the UIImage for the banenr
            NSString* imageFile = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], url];
            UIImage* img=[UIImage imageWithContentsOfFile:imageFile];
            
            // Create the UIButton for the banner
            self.bannerView = [UIButton buttonWithType:UIButtonTypeCustom];
            [bannerView_ setImage:img forState:UIControlStateNormal];
            [bannerView_ addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
            [bannerView_ setFrame:rect];
        }
        
    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y
{
    [super showInPosition:position offsetX:x offsetY:y];
    
    if(bannerView_){
        [self show_:bannerView_ withPosition:position width:originWidth_ height:originHeight_ offsetX:offsetX_ offsetY:offsetY_];
    }
}

- (void) remove{
    [super remove];
    if(bannerView_){
        [bannerView_ removeFromSuperview];
    }
}

- (void) load:(NSDictionary*)settings{
    if(bannerView_){
        ready_=YES;
        [delegate_ adAdapterDidReceiveAd:self];
    } else {
        [delegate_ adAdapter:self didFailToReceiveAdWithError:@"Error loading image"];
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeBACKFILL;
}

- (IBAction)openURL:(id)sender
{
    
    if (linkURL_!=nil) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkURL_]];
    }

}

@end
