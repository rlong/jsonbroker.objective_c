//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



@class JBHttpSecurityManager;
#import "JBRequestHandler.h"


@interface JBAuthRequestHandler : NSObject <JBRequestHandler> {

    // processors
	NSMutableDictionary* _processors;
	//@property (nonatomic, retain) NSMutableDictionary* processors;
	//@synthesize processors = _processors;
    
	// securityManager
	JBHttpSecurityManager* _securityManager;
	//@property (nonatomic, retain) HttpSecurityManager* securityManager;
	//@synthesize securityManager = _securityManager;

}


-(void)addRequestHandler:(id<JBRequestHandler>)processor;


#pragma mark instance lifecycle

-(id)initWithSecurityManager:(JBHttpSecurityManager*)httpSecurityManager;

@end
