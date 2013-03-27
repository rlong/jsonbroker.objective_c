//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "UIWebView+NoBounce.h"


@implementation UIWebView (NoBounce)

-(void)stopBounce {
	
	// vvv http://stackoverflow.com/questions/500761/stop-uiwebview-from-bouncing-vertically
	for (id subview in self.subviews) {
		if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
			((UIScrollView *)subview).bounces = NO;
		}
	}
	// ^^^ http://stackoverflow.com/questions/500761/stop-uiwebview-from-bouncing-vertically
	
}


@end
