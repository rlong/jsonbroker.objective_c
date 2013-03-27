//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <stdio.h>

#import "JBLogUnitTest.h"

#import "JBLog.h"


@interface JBLogUnitTestLogConsumer : NSObject <JBLogConsumer> {
}
@end

@implementation JBLogUnitTestLogConsumer 

-(void)logMessage:(NSString*)message forFunction:(const char *)function atLevel:(NSString*)level {
	
	NSString* currentThreadName = [[NSThread currentThread] name];

	printf( "%s %s %s %s\n", [level UTF8String], [currentThreadName UTF8String], function, [message UTF8String] );
}

- (id)retain {
	return [super retain];
}

- (oneway void)release {
	[super release];
}

@end
	



@implementation JBLogUnitTest



- (void) setUp {
}

- (void) tearDown {
    
	
    [JBLog setLogConsumer:nil forCaller:__func__];
}



- (void) logMessages
{
	
	NSDate* now = nil;	
    Log_debugDate( now ); // first with nil
	now = [NSDate date];
	Log_debugDate( now ); // next with a valid value
	
	
	int x = 10;
    Log_debugInt( x );
	Log_infoInt( x );
	
	NSString* variable = @"value";
    Log_infoString( variable );
	variable = nil;
    Log_infoString( variable );

	Log_debug( @"debug message" );
    Log_warn( @"warning message" );
	
    Log_warnInt( x );
    Log_errorInt( x );
    
    Log_errorString( variable );

	Log_error( @"error message" );
}

-(void)testDefaultLog {
	[self logMessages];
}
-(void)testLogConsumer {
	
	[JBLog setLogConsumer:[[JBLogUnitTestLogConsumer alloc] init] forCaller:__func__];
	[self logMessages];
}


- (void) testDebugDate
{

	
	NSDate* now = nil;	
    Log_debugDate( now ); // first with nil
	now = [NSDate date];
	Log_debugDate( now ); // next with a valid value
}

- (void) testDebugInt
{

	
	int x = 10;
    Log_debugInt( x );
}

- (void) testInfoInt
{

	
	int x = 10;
    Log_infoInt( x );
}


- (void) testInfoString
{
	
	NSString* variable = @"value";
    Log_infoString( variable );
	variable = nil;
    Log_infoString( variable );
}


- (void) testDebug
{

	
    Log_debug( @"debug message" );

}


-(void)testWarn
{
    Log_warn( @"warning message" );
}




-(void)testWarnInt
{
	int x = 10;
    Log_warnInt( x );

}


-(void)testErrorInt
{
	int x = 10;
    Log_errorInt( x );

}

-(void)testErrorString
{
	NSString* variable = @"variable value";
    Log_errorString( variable );
}

-(void)testError
{
    Log_error( @"error message" );
}


//////////////////////////////////////////////////


@end


