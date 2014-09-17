//
//  AbstractAdAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 29/8/14.
//
//

#import "AbstractAdAdapter.h"
#import <AdSupport/AdSupport.h>
#include <CommonCrypto/CommonDigest.h>

@implementation AbstractAdAdapter

@synthesize delegate=delegate_;
@synthesize ready=ready_;
@synthesize visible=visible_;
@synthesize testMode=testMode_;
@synthesize uid=uid_;
@synthesize adUnitId=adUnitId_;
@synthesize size=size_;
@synthesize position=position_;
@synthesize contentContainer=contentContainer_;
@synthesize rootController=rootController_;
@synthesize layoutConstraint=layoutConstraint_;
@synthesize originWidth=originWidth_;
@synthesize originHeight=originHeight_;
@synthesize offsetX=offsetX_;
@synthesize offsetY=offsetY_;


+ (BOOL) isLandscape
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    return (screenBounds.size.width>screenBounds.size.height);
}

- (id) init {
    
    visible_=NO;
    ready_=NO;
    isNeedToShow_=NO;
    
    return [super init];
}

- (void) dealloc {
    
    visible_=FALSE;
    ready_=FALSE;
    isNeedToShow_=NO;
    self.uid=nil;
    self.adUnitId=nil;
    self.size=nil;
    self.contentContainer=nil;
    self.rootController=nil;
    self.layoutConstraint=nil;
    self.delegate=nil;
    
    [super dealloc];
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {
    self.position=position;
    self.offsetX=x;
    self.offsetY=y;
    isNeedToShow_=YES;
}

- (void) remove{
    visible_=NO;
    [contentContainer_ removeFromSuperview];
}

- (void) load:(NSDictionary*)settings{
    
}

- (void) pause{
    
}

- (void) resume
{
    
}

- (void) destroy
{
    visible_=FALSE;
    ready_=FALSE;
    isNeedToShow_=NO;    
    self.delegate=nil;
}

- (NSString*) getNetworkType{
    return kNetworkTypeNone;
}

#pragma mark - Helper

/* show view in position */
- (void) show_:(UIView*)adView withPosition:(NSString*) position width: (int) w  height:(int) h offsetX: (int) x offsetY:(int) y;
{
//    NSLog(@"adapter show %f %f %f %f", rootController_.view.frame.origin.x, rootController_.view.frame.origin.y, rootController_.view.frame.size.width, rootController_.view.frame.size.height);
    
//    NSLog(@"AbstrackAdAdapter show_ %d %d %d %d",x,y,offsetX_,offsetY_);
    
    isNeedToShow_=NO;
    visible_=YES;
    
    // create content container view
    if(contentContainer_==nil){
        self.contentContainer=[[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        [contentContainer_ setBackgroundColor:[UIColor blackColor]];
        contentContainer_.translatesAutoresizingMaskIntoConstraints = NO;
    }

    // add the contentContainer view
    if (![contentContainer_ isDescendantOfView:rootController_.view]) {
        [rootController_.view addSubview:contentContainer_];
    }
    
    // set position constraint
    [self layoutConstraint_:contentContainer_ withPosition:position width:w height:h offsetX:x offsetY:y];
    
    // add the adview to container
    if (![adView isDescendantOfView:rootController_.view]) {
        [contentContainer_ addSubview:adView];
    }
        
}

/* layout the view */
- (void) layoutConstraint_:(UIView*)view withPosition:(NSString*) position width: (int) w  height:(int) h offsetX: (float) x offsetY:(float) y;
{
    // remove constraint
    if(layoutConstraint_){
        [rootController_.view removeConstraints:layoutConstraint_];
        self.layoutConstraint=nil;
    }
    
    // Reset position
    CGRect originalFrame=view.frame;
    originalFrame.origin.x=0;
    originalFrame.origin.y=0;
    if(w<=0){
        originalFrame.size.width=rootController_.view.frame.size.width;
    } else {
        originalFrame=CGRectMake(0, 0, w, h);
    }
    view.frame=originalFrame;
    
//    NSLog(@"layoutConstraint_ position: %@",position);
//    NSLog(@"layoutConstraint_ %f %f %f %f", rootController_.view.frame.origin.x, rootController_.view.frame.origin.y, rootController_.view.frame.size.width, rootController_.view.frame.size.height);
//    NSLog(@"layoutConstraint_ %f %f %f %f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
//          
//    view.autoresizesSubviews=YES;
    
    //
    NSMutableArray *constraint= [NSMutableArray array];
    
    // set width
    if(w>0)
        [constraint addObject:
         [NSLayoutConstraint constraintWithItem:view
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:0
                                       constant:w]];
    else
        [constraint addObject:
         [NSLayoutConstraint constraintWithItem:view
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:rootController_.view
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:1.0
                                       constant:0]];
    // fixed height
    [constraint addObject:
     [NSLayoutConstraint constraintWithItem:view
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:0
                                   constant:h]];

    
    if([position rangeOfString:kAdAdapterPositionTop].location != NSNotFound) {
        
        // align top
        [constraint addObject:
         [NSLayoutConstraint constraintWithItem:view
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:rootController_.view
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0
                                       constant:y]];
        
    } else if([position rangeOfString:kAdAdapterPositionBottom].location != NSNotFound) {
        
        // align bottom
        [constraint addObject:
         [NSLayoutConstraint constraintWithItem:view
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:rootController_.view
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0
                                       constant:y]];
        
    } else {
        // align center Y
        [constraint addObject:
         [NSLayoutConstraint constraintWithItem:view
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:rootController_.view
                                      attribute:NSLayoutAttributeCenterY
                                     multiplier:1.0
                                       constant:y]];
    }
    
    if([position rangeOfString:kAdAdapterPositionRight].location != NSNotFound) {
        // align right
        [constraint addObject:
         [NSLayoutConstraint constraintWithItem:view
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:rootController_.view
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1.0
                                       constant:x]];
        
    } else if([position rangeOfString:kAdAdapterPositionLeft].location != NSNotFound) {
        // align left
        [constraint addObject:
         [NSLayoutConstraint constraintWithItem:view
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:rootController_.view
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1.0
                                       constant:x]];
    } else {
        // align center X
        [constraint addObject:
         [NSLayoutConstraint constraintWithItem:view
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:rootController_.view
                                      attribute:NSLayoutAttributeCenterX
                                     multiplier:1.0
                                       constant:x]];
    }
    
    self.layoutConstraint=[NSArray arrayWithArray:constraint];
    
    // Add layout constraint
    [rootController_.view addConstraints:self.layoutConstraint];
    
}

/* get admob device id */
- (NSString *) admobDeviceID_
{
    NSUUID* adid = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    const char *cStr = [adid.UUIDString UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest );

    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

@end
