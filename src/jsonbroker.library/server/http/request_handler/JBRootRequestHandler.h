//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//




#import <Foundation/Foundation.h>


#import "JBRequestHandler.h"

@interface JBRootRequestHandler : NSObject <JBRequestHandler> {
    
    // httpProcessors
	NSMutableArray* _httpProcessors;
	//@property (nonatomic, retain) NSMutableArray* httpProcessors;
	//@synthesize httpProcessors = _httpProcessors;
    
    
    // defaultProcessor
	id<JBRequestHandler> _defaultProcessor;
	//@property (nonatomic, retain) id<HttpProcessor> defaultProcessor;
	//@synthesize defaultProcessor = _defaultProcessor;


    
}

-(void)addRequestHandler:(id<JBRequestHandler>)httpProcessor;


#pragma mark instance lifecycle 

-(id)init;
-(id)initWithDefaultProcessor:(id<JBRequestHandler>)defaultProcessor;

@end
