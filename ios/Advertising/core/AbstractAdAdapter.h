//
//  AbstractAdAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 29/8/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kNetworkTypeNone                @"none"
#define kNetworkTypeIAD                 @"iad"
#define kNetworkTypeADMOB               @"admob"
#define kNetworkTypeMILLENNIALMEDIA     @"millennialmedia"
#define kNetworkTypeAMAZON              @"amazon"
#define kNetworkTypeINMOBI              @"inmobi"
#define kNetworkTypeBACKFILL            @"backfill"


#define kAdAdapterSizeINTERSTITIAL     @"interstitial" //interstitial
#define kAdAdapterSizeBANNER           @"banner" //320x50
#define kAdAdapterSizeSMART_BANNER     @"smart_banner" // smart
#define kAdAdapterSizeFULL_BANNER      @"full_banner" // 468x60
#define kAdAdapterSizeLEADERBOARD      @"leaderboard" // 728x90
#define kAdAdapterSizeWIDE_SKYSCRAPER  @"wide_skyscraper" // 160x600
#define kAdAdapterSizeMEDIUM_RECTANGLE @"medium_rectangle" // 300x250

#define kAdAdapterPositionTop          @"top"
#define kAdAdapterPositionBottom       @"bottom"
#define kAdAdapterPositionLeft         @"left"
#define kAdAdapterPositionRight        @"right"
#define kAdAdapterPositionCenter       @"center"

@protocol AdAdapterDelegate;

#pragma mark - AbstractAdAdapter

@interface AbstractAdAdapter : NSObject {
    
    id<AdAdapterDelegate> delegate_;
    NSString *uid_;
    NSString *adUnitId_;
    NSString *size_;
    NSString *position_;
    BOOL ready_;
    BOOL visible_;
    BOOL isNeedToShow_;
    BOOL testMode_;
    UIView *contentContainer_;
    UIViewController *rootController_;
    NSArray *layoutConstraint_;
    int originWidth_;
    int originHeight_;
    int offsetX_;
    int offsetY_;
}
@property (nonatomic, retain) id<AdAdapterDelegate> delegate;
@property (nonatomic, assign) BOOL ready;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) BOOL testMode;
@property (nonatomic, retain) NSString* uid;
@property (nonatomic, retain) NSString* adUnitId;
@property (nonatomic, retain) NSString* size;
@property (nonatomic, retain) NSString* position;
@property (nonatomic, retain) UIView* contentContainer;
@property (nonatomic, retain) UIViewController* rootController;
@property (nonatomic, retain) NSArray* layoutConstraint;
@property (nonatomic, assign) int originWidth;
@property (nonatomic, assign) int originHeight;
@property (nonatomic, assign) int offsetX;
@property (nonatomic, assign) int offsetY;

+ (BOOL) isLandscape;
- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y;
- (void) remove;
- (void) load:(NSDictionary*)settings;
- (void) pause;
- (void) resume;
- (void) destroy;
- (NSString*) getNetworkType;

// helper
- (void) show_:(UIView*)view withPosition:(NSString*) position width: (int) w  height:(int) h offsetX: (int) x offsetY:(int) y;
- (NSString *) admobDeviceID_;

@end

#pragma mark - AdAdapterDelegate

@protocol AdAdapterDelegate

@optional
///**
// * Event type for ad loaded.
// */
//public static const AD_LOADED:String="onAdLoaded";
///**
// * Event type for ad will going to show on screen.
// */
//public static const AD_WILL_PRESENT:String="onAdWillPresent";
///**
// * Event type for ad did show on screen.
// */
//public static const AD_DID_PRESENT:String="onAdDidPresent";
///**
// * Event type for ad will remove from screen.
// */
//public static const AD_WILL_DISMISS:String="onAdWillDismiss";
///**
// * Event type for ad did remove from screen.
// */
//public static const AD_DID_DISMISS:String="onAdDidDismiss";
///**
// * Event type for ad did fail to load.
// */
//public static const AD_FAILED_TO_LOAD:String="onAdFailedToLoad";
///**
// * Event type for ad did fail to load.
// */
//public static const WILL_LEAVE_APPLICATION:String="onWillLeaveApplication";
///**
// * Event type for ad did fail to load.
// */
//public static const AD_ACTION:String="onAdAction";
- (void)adAdapterDidReceiveAd:(AbstractAdAdapter *)adapter;
- (void)adAdapter:(AbstractAdAdapter *)adapter didFailToReceiveAdWithError:(NSString *)error;
- (void)adAdapterDidPresent:(AbstractAdAdapter *)adapter;
- (void)adAdapterWillPresent:(AbstractAdAdapter *)adapter;
- (void)adAdapterDidDismiss:(AbstractAdAdapter*)adapter;
- (void)adAdapterWillDismiss:(AbstractAdAdapter *)adapter;
- (void)adAdapterWillLeaveApplication:(AbstractAdAdapter*)adapter;
- (void)adLog:(NSString*)msg;

@end