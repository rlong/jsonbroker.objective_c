//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <Foundation/Foundation.h>

#import "JBHttpSecurityManager.h"


@interface JBHttpSecurityJanitor : NSObject {
    
    // httpSecurityManager
	JBHttpSecurityManager* _httpSecurityManager;
	//@property (nonatomic, retain) HttpSecurityManager* httpSecurityManager;
	//@synthesize httpSecurityManager = _httpSecurityManager;

}

-(void)start;


#pragma mark instance lifecycle 



-(id)initWithHttpSecurityManager:(JBHttpSecurityManager*) httpSecurityManager;


@end
