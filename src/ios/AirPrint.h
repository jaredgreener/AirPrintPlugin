//
//  AirPrint.h
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface AirPrint : CDVPlugin {
    NSString* successCallback;
    NSString* failCallback;
    NSString* printHTML;
    
    //Options
    NSInteger dialogLeftPos;
    NSInteger dialogTopPos;
}

@property (nonatomic, copy) NSString* successCallback;
@property (nonatomic, copy) NSString* failCallback;
@property (nonatomic, copy) NSString* printHTML;

//Print Settings
@property NSInteger dialogLeftPos;
@property NSInteger dialogTopPos;

//Print HTML
- (void) print:(CDVInvokedUrlCommand*)command;

//Find out whether printing is supported on this platform.
- (void) isPrintingAvailable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
