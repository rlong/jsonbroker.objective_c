//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBWebUIDelegate.h"
#import "JBLog.h"

@implementation JBWebUIDelegate

static NSArray* _EMPTY_CONTEXT_MENU = nil; 

+(void)initialize {
	
    _EMPTY_CONTEXT_MENU = [[NSArray array] retain];
	
}


- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems {
    
    Log_enteredMethod();
    
    return _EMPTY_CONTEXT_MENU;
    
}


@end
