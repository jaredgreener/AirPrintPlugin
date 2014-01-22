//
//  AirPrint.m
//
//

#import "AirPrint.h"

@interface AirPrint (Private)
-(void) doPrint;
-(void) callbackWithFuntion:(NSString *)function withData:(NSString *)value;
- (BOOL) isPrintServiceAvailable;
@end

@implementation AirPrint

@synthesize successCallback, failCallback, printHTML, dialogTopPos, dialogLeftPos;

/*
 Is printing available. Callback returns true/false if printing is available/unavailable.
 */
- (void) isPrintingAvailable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options{
    NSUInteger argc = [arguments count];
	
	if (argc < 1) {
		return;
	}
    
    
    NSString *callBackFunction = [arguments objectAtIndex:0];
    [self callbackWithFuntion:callBackFunction withData:
     [NSString stringWithFormat:@"{available: %@}", ([self isPrintServiceAvailable] ? @"true" : @"false")]];
    
}

- (void) print:(CDVInvokedUrlCommand*)command
{
    NSUInteger argc = [command.arguments count];
	
	if (argc < 1) {
		return;
	}
    self.printHTML = [command.arguments objectAtIndex:0];
    
    
    if (argc >= 2){
        self.dialogLeftPos = [[command.arguments objectAtIndex:1] intValue];
    }
    
    if (argc >= 3){
        self.dialogTopPos = [[command.arguments objectAtIndex:2] intValue];
    }
        if (argc >= 4){
            self.successCallback = [command.arguments objectAtIndex:3];
        }
    
        if (argc >= 5){
            self.failCallback = [command.arguments objectAtIndex:4];
        }
    
    [self doPrint];
    
}

- (void) doPrint{
    if (![self isPrintServiceAvailable]){
        [self callbackWithFuntion:self.failCallback withData: @"{success: false, available: false}"];
        
        return;
    }
    
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
    
    if (!controller){
        return;
    }
    
	if ([UIPrintInteractionController isPrintingAvailable]){
		//Set the priner settings
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        controller.printInfo = printInfo;
        controller.showsPageRange = YES;
        
        
        //Set the base URL to be the www directory.
        NSString *dbFilePath = [[NSBundle mainBundle] pathForResource:@"www" ofType:nil ];
        NSURL *baseURL = [NSURL fileURLWithPath:dbFilePath];
        
        //Load page into a webview and use its formatter to print the page
		UIWebView *webViewPrint = [[UIWebView alloc] init];
		[webViewPrint loadHTMLString:printHTML baseURL:baseURL];
        
        //Get formatter for web (note: margin not required - done in web page)
		UIViewPrintFormatter *viewFormatter = [webViewPrint viewPrintFormatter];
        controller.printFormatter = viewFormatter;
        controller.showsPageRange = NO;
        
        
		void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
		^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed || error) {
                [self callbackWithFuntion:self.failCallback withData:
                 [NSString stringWithFormat:@"{success: false, available: true, error: \"%@\"}", error.localizedDescription]];
			}
            else{
                [self callbackWithFuntion:self.successCallback withData: @"{success: true, available: true}"];
            }
        };
        
        /*
         If iPad, and if button offsets passed, then show dilalog originating from offset
         */
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
            dialogTopPos != 0 && dialogLeftPos != 0) {
            [controller presentFromRect:CGRectMake(self.dialogLeftPos, self.dialogTopPos, 0, 0) inView:self.webView animated:YES completionHandler:completionHandler];
        } else {
            [controller presentAnimated:YES completionHandler:completionHandler];
        }
    }
}

-(BOOL) isPrintServiceAvailable{
    
    Class myClass = NSClassFromString(@"UIPrintInteractionController");
    if (myClass) {
        UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
        return (controller != nil) && [UIPrintInteractionController isPrintingAvailable];
    }
    
    
    return NO;
}

#pragma mark -
#pragma mark Return messages

-(void) callbackWithFuntion:(NSString *)function withData:(NSString *)value{
    if (!function || [@"" isEqualToString:function]){
        return;
    }
    
    NSString* jsCallBack = [NSString stringWithFormat:@"%@(%@);", function, value];
    [self writeJavascript: jsCallBack];
}

@end
