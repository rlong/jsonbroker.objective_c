//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> // for UIWebView

@interface JBIosWebViewHelper : NSObject


+(void)stopBounce:(UIWebView*)webView;

+(void)setIndicatorStyle:(UIScrollViewIndicatorStyle)indicatorStyle forWebView:(UIWebView*)webView;

@end
