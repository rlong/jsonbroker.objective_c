//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBIosWebViewHelper.h"

@implementation JBIosWebViewHelper


+(void)stopBounce:(UIWebView*)webView {
	
	// vvv http://stackoverflow.com/questions/500761/stop-uiwebview-from-bouncing-vertically
	for (id subview in webView.subviews) {
		if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
			((UIScrollView *)subview).bounces = NO;
		}
	}
	// ^^^ http://stackoverflow.com/questions/500761/stop-uiwebview-from-bouncing-vertically
	
}


+(void)setIndicatorStyle:(UIScrollViewIndicatorStyle)indicatorStyle forWebView:(UIWebView*)webView {

    for (id subview in webView.subviews) {
		if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView *)subview;
            [scrollView setIndicatorStyle:indicatorStyle];
		}
	}

}

@end
