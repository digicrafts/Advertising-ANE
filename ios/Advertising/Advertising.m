/*
 * Advertising.m
 * Advertising
 *
 * Created by Tsang Wai Lam on 26/8/14.
 * Copyright (c) 2014 __MyCompanyName__. All rights reserved.
 */

#import "Advertising.h"
#import "AdManager.h"
#import <iAd/iAd.h>

AdManager *adManager_;

/* AdvertisingExtInitializer()
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 * Please note: this should be same as the <initializer> specified in the extension.xml 
 */
void AdvertisingExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    NSLog(@"Entering AdvertisingExtInitializer()");

    *extDataToSet = NULL;
    *ctxInitializerToSet = &ContextInitializer;
    *ctxFinalizerToSet = &ContextFinalizer;

    NSLog(@"Exiting AdvertisingExtInitializer()");
}

/* AdvertisingExtFinalizer()
 * The extension finalizer is called when the runtime unloads the extension. However, it may not always called.
 *
 * Please note: this should be same as the <finalizer> specified in the extension.xml 
 */
void AdvertisingExtFinalizer(void* extData) 
{
    NSLog(@"Entering AdvertisingExtFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting AdvertisingExtFinalizer()");
    return;
}

/* ContextInitializer()
 * The context initializer is called when the runtime creates the extension context instance.
 */
void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"Entering ContextInitializer()");
    
    /* The following code describes the functions that are exposed by this native extension to the ActionScript code.
     */
    static FRENamedFunction func[] = 
    {
        MAP_FUNCTION(ext_initialize, NULL),
        MAP_FUNCTION(ext_testMode, NULL),
//        MAP_FUNCTION(ext_create, NULL),
        MAP_FUNCTION(ext_load, NULL),
        MAP_FUNCTION(ext_show, NULL),
        MAP_FUNCTION(ext_remove, NULL),
        MAP_FUNCTION(ext_pause, NULL),
        MAP_FUNCTION(ext_resume, NULL),
        MAP_FUNCTION(ext_destroy, NULL),
    };
    
    *numFunctionsToTest = sizeof(func) / sizeof(FRENamedFunction);
    *functionsToSet = func;
    
    NSLog(@"Exiting ContextInitializer()");
}

/* ContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void ContextFinalizer(FREContext ctx) 
{
    NSLog(@"Entering ContextFinalizer()");
    
    adManager_=nil;

    // Nothing to clean up.
    NSLog(@"Exiting ContextFinalizer()");
    return;
}


/* This is a TEST function that is being included as part of this template. 
 *
 * Users of this template are expected to change this and add similar functions 
 * to be able to call the native functions in the ANE from their ActionScript code
 */
ANE_FUNCTION(ext_initialize)
{
    
    if(adManager_==nil){
        
        // get root view controller
        UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        
        // create a new admanager
        adManager_=[[AdManager alloc] initWithContiner:rootViewController];
        
        // add callback
        adManager_.callback=^(NSString* event, NSString* level) {
            dispatchStatusEvent(ctx, event, level);
        };
        
//        ADBannerView *v= [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
//        [rootViewController.view addSubview:v];

    }
    
	return nil;
}

ANE_FUNCTION(ext_testMode)
{
    if(adManager_){
        uint32_t testMode = TRUE;
        FREGetObjectAsBool(argv[0], &testMode);
    
        [adManager_ setTestMode:testMode];
    }
	return nil;
}

//ANE_FUNCTION(ext_create)
//{
//    if(adManager_){
//        
//        // get the parameters
//        uint32_t length = 0;
//        const uint8_t *uidString = NULL;
//        FREGetObjectAsUTF8( argv[0], &length, &uidString);
//        const uint8_t *sizeString = NULL;
//        FREGetObjectAsUTF8( argv[1], &length, &sizeString);
//        const uint8_t *networkString = NULL;
//        FREGetObjectAsUTF8( argv[2], &length, &networkString);
//        const uint8_t *adUnitIdString = NULL;
//        FREGetObjectAsUTF8( argv[3], &length, &adUnitIdString);
//        
//        // create the ads instance
//        [adManager_
//         load:[NSString stringWithUTF8String:(char *)uidString]
//         size:[NSString stringWithUTF8String:(char *)sizeString]
//         network:[NSString stringWithUTF8String:(char *)networkString]
//         adUnitId:[NSString stringWithUTF8String:(char *)adUnitIdString]
//         settings:FREConvertSettings(argv[4])];
//        
//    }
//    
//	return nil;
//}

ANE_FUNCTION(ext_load)
{
    
    if(adManager_){
        
        // get the parameters
        uint32_t length = 0;
        const uint8_t *uidString = NULL;
        FREGetObjectAsUTF8( argv[0], &length, &uidString);
        const uint8_t *sizeString = NULL;
        FREGetObjectAsUTF8( argv[1], &length, &sizeString);
        const uint8_t *networkString = NULL;
        FREGetObjectAsUTF8( argv[2], &length, &networkString);
        const uint8_t *adUnitIdString = NULL;
        FREGetObjectAsUTF8( argv[3], &length, &adUnitIdString);
        const uint8_t *positionString = NULL;
        FREGetObjectAsUTF8( argv[5], &length, &positionString);
        
        // get root view controller
        UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        adManager_.rootController=rootViewController;
        
        // create the ads instance
        [adManager_
         load:[NSString stringWithUTF8String:(char *)uidString]
         size:[NSString stringWithUTF8String:(char *)sizeString]
         network:[NSString stringWithUTF8String:(char *)networkString]
         adUnitId:[NSString stringWithUTF8String:(char *)adUnitIdString]
         setting:FREConvertSettings(argv[4])
         ];
    }
    
    return nil;
}


ANE_FUNCTION(ext_show)
{

    if(adManager_){
        
        // get the parameters
        uint32_t length = 0;
        const uint8_t *uidString = NULL;
        FREGetObjectAsUTF8( argv[0], &length, &uidString);
        const uint8_t *sizeString = NULL;
        FREGetObjectAsUTF8( argv[1], &length, &sizeString);
        const uint8_t *networkString = NULL;
        FREGetObjectAsUTF8( argv[2], &length, &networkString);
        const uint8_t *adUnitIdString = NULL;
        FREGetObjectAsUTF8( argv[3], &length, &adUnitIdString);
        const uint8_t *positionString = NULL;
        FREGetObjectAsUTF8( argv[5], &length, &positionString);
        uint32_t x = 0;
        FREGetObjectAsUint32(argv[6], &x);
        uint32_t y = 0;
        FREGetObjectAsUint32(argv[7], &y);
        
        // get root view controller
        UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;        
        adManager_.rootController=rootViewController;        
        
        // create the ads instance
        [adManager_
         show:[NSString stringWithUTF8String:(char *)uidString]
         size:[NSString stringWithUTF8String:(char *)sizeString]
         network:[NSString stringWithUTF8String:(char *)networkString]
         adUnitId:[NSString stringWithUTF8String:(char *)adUnitIdString]
         setting:FREConvertSettings(argv[4])
         position:[NSString stringWithUTF8String:(char *)positionString]
         x:x
         y:y];
        
    }
    
	return nil;
}

ANE_FUNCTION(ext_remove)
{
    
    if(adManager_){
        
        // get the parameters
        uint32_t length = 0;
        const uint8_t *uidString = NULL;
        FREGetObjectAsUTF8( argv[0], &length, &uidString);
        
        [adManager_ remove:[NSString stringWithUTF8String:(char *)uidString]];
        
    }
	return nil;
}

ANE_FUNCTION(ext_pause)
{
    
    if(adManager_){
        
        // get the parameters
        uint32_t length = 0;
        const uint8_t *uidString = NULL;
        FREGetObjectAsUTF8( argv[0], &length, &uidString);
        
        [adManager_ pause:[NSString stringWithUTF8String:(char *)uidString]];
        
    }
	return nil;
}

ANE_FUNCTION(ext_resume)
{
    if(adManager_){
        
        // get the parameters
        uint32_t length = 0;
        const uint8_t *uidString = NULL;
        FREGetObjectAsUTF8( argv[0], &length, &uidString);
        
        [adManager_ resume:[NSString stringWithUTF8String:(char *)uidString]];
        
    }
	return nil;
}

ANE_FUNCTION(ext_destroy)
{
    
    if(adManager_){
        
        // get the parameters
        uint32_t length = 0;
        const uint8_t *uidString = NULL;
        FREGetObjectAsUTF8( argv[0], &length, &uidString);
        
        [adManager_ destroy:[NSString stringWithUTF8String:(char *)uidString]];
        
    }
	return nil;
}

#pragma mark - Helper

void dispatchStatusEvent(FREContext ctx, NSString *eventType, NSString *eventLevel) {
    
    if (ctx == NULL) {
        return;
    }
    const uint8_t* levelCode = (const uint8_t*) [eventLevel UTF8String];
    const uint8_t* eventCode = (const uint8_t*) [eventType UTF8String];
    FREDispatchStatusEventAsync(ctx,eventCode,levelCode);
}

NSDictionary* FREConvertSettings(FREObject input){
    
//    NSLog(@"FREConvertSettings start");
    // define var
    FREObject keyArray;
    FREObject typeArray;
    FREObject valueArray;

    // get the array
    FREGetArrayElementAt(input, 0, &keyArray);
    FREGetArrayElementAt(input, 1, &typeArray);
    FREGetArrayElementAt(input, 2, &valueArray);
    
    // create a NSDictionary
    NSMutableDictionary *dictionary= [NSMutableDictionary dictionary];
    

//    NSLog(@"FREConvertSettings loop");
    
    // loop each value
    uint32_t keyLength = 0;
    const uint8_t *key = nil;
    uint32_t valueLength = 0;
    const uint8_t *value = nil;
    uint32_t l;
    FREGetArrayLength(keyArray, &l);
    for(int32_t i=0; i <=l; i++){

        FREObject keyObject = nil;
        FREObject valueObject = nil;
        FREObjectType valueType = FRE_TYPE_NULL;
        
//        NSLog(@"Property %d %d",i,l);
        
        // get the property key
        FREGetArrayElementAt(keyArray, i, &keyObject);
        FREGetObjectAsUTF8(keyObject, &keyLength, &key);
        NSString *pKey = [NSString stringWithUTF8String:(char *)key];

//        NSLog(@"key: %@",pKey);
        
        // get the value object
        FREGetObjectProperty(valueArray, key, &valueObject, NULL);
        
        // get the value type
        FREGetObjectType(valueObject, &valueType);
        
//        NSLog(@"each:");
        
        if(valueType == FRE_TYPE_STRING){
            
            // get the value string
            FREGetObjectAsUTF8(valueObject, &valueLength, &value);

//        NSLog(@"value: %@",[NSString stringWithUTF8String:(char *)value]);
            
            // insert to dictionary
            [dictionary setObject:[NSString stringWithUTF8String:(char *)value] forKey:pKey];
            
        } else if(valueType == FRE_TYPE_NUMBER){

            // get the value number
            uint32_t value_number=0;
            FREGetObjectAsUint32(valueObject, &value_number);
            
            // insert to dictionary
            [dictionary setObject:[NSNumber numberWithInt:value_number] forKey:pKey];

            
        } else if(valueType == FRE_TYPE_BOOLEAN){
            
            uint32_t value_boolean = TRUE;
            FREGetObjectAsBool(valueObject, &value_boolean);
            
            // insert to dictionary
            [dictionary setObject:[NSNumber numberWithInt:value_boolean] forKey:pKey];
            
        } else if(valueType == FRE_TYPE_ARRAY){
            
            NSMutableArray *array = [NSMutableArray array];
            uint32_t arrayValueLength = 0;
            const uint8_t *arrayValueString = nil;
            FREObject arrayValueObject;
            
            // loop
            uint32_t al;
            FREGetArrayLength(valueObject, &al);
            for(int32_t j=0; j <=al; j++){
                FREGetArrayElementAt(valueObject, j, &arrayValueObject);
                FREGetObjectAsUTF8(arrayValueObject, arrayValueLength, &arrayValueString);
                [array addObject:[NSString stringWithUTF8String:(char *)arrayValueString]];
            }
            
            // insert to dictionary
            [dictionary setObject:array forKey:pKey];
            
        }
        
    }
    
    return dictionary;
}


