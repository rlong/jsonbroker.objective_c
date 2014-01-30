//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> // for UIWebViewDelegate, UIWebView


@interface JBIosWebViewShower : NSObject <UIWebViewDelegate> {
    
}

+(JBIosWebViewShower*)setup:(UIWebView *)webView;

@end
