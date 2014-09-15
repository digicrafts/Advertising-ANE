//
//  AdManager.h
//  Advertisting
//
//  Created by Tsang Wai Lam on 25/8/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AbstractAdAdapter.h"

typedef void(^AdManagerCallback)(NSString*, NSString*);

@interface AdManager : NSObject <AdAdapterDelegate> {
    
    bool testMode_;
    UIViewController* rootController_;
    NSMutableDictionary *bannerIndex_;
    NSMutableDictionary *interstitialIndex_;
    AbstractAdAdapter *lastAdapter_;
    AdManagerCallback callback_;
    
}
@property (nonatomic, assign) bool testMode;
@property (nonatomic, retain) UIViewController* rootController;
@property (nonatomic, retain) NSMutableDictionary *bannerIndex;
@property (nonatomic, retain) NSMutableDictionary *interstitialIndex;
@property (nonatomic, retain) AbstractAdAdapter *lastAdapter;
@property (nonatomic, copy) AdManagerCallback callback;

//@property (nonatomic, copy) MopubEventHandler eventHandler;
//@property (nonatomic, assign) CGRect containerFrame;


- (id) initWithContiner:(UIViewController*)controller;
- (void) create:(NSString*)uid size:(NSString*) size network:(NSString*) network adUnitId:(NSString*)adUnitId settings:(NSDictionary*)settings;
- (AbstractAdAdapter*) load:(NSString*)uid size:(NSString*) size network:(NSString*) network adUnitId:(NSString*)adUnitId setting:(NSDictionary*)settings;
- (void) show:(NSString*)uid size:(NSString*) size network:(NSString*) network adUnitId:(NSString*)adUnitId setting:(NSDictionary*)settings position:(NSString*) position x:(int)x y:(int)y;
- (void) remove:(NSString*)uid;
- (void) pause:(NSString*)uid;
- (void) resume:(NSString*)uid;
- (void) destroy:(NSString*)uid;


@end
