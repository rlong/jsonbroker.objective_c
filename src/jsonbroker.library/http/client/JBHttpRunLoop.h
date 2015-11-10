// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

@class JBHttpAsyncCall;

@interface JBHttpRunLoop : NSObject {

    // runLoop
	NSRunLoop* _runLoop;
	//@property (nonatomic, retain) NSRunLoop* runLoop;
	//@synthesize runLoop = _runLoop;
    
    
	// runLoopInitialised
	NSConditionLock* _runLoopInitialised;
	//@property (nonatomic, retain) NSConditionLock* runLoopInitialised;
	//@synthesize runLoopInitialised = _runLoopInitialised;


}



+(JBHttpRunLoop*)getInstance;

-(NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error;

-(void)startAsynchronousRequest:(JBHttpAsyncCall *)asyncCall;

@end
