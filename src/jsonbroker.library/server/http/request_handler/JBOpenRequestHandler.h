//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>



#import "JBHttpRequest.h"

#import "JBRequestHandler.h"


@interface JBOpenRequestHandler : NSObject <JBRequestHandler> {
    
	// processors
	NSMutableDictionary* _processors;
	//@property (nonatomic, retain) NSMutableDictionary* processors;
	//@synthesize processors = _processors;
    
}

+(NSString*)REQUEST_URI;

-(void)addHttpProcessor:(id<JBRequestHandler>)processor;




@end
