// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBExceptionHelper.h"

@implementation JBExceptionHelper



+(NSException*)getRootCause:(NSException*)e {
    
    
    while( [e isKindOfClass:[BaseException class]] ) { 
        
        BaseException* be = (BaseException*)e;
        
        // end of the line ?
        if( nil == [be cause] ) { 
            
            return be;
            
        }
    }
    
    return e;
        
    
}

+(JBJsonArray*)getStackTrace:(NSException*)e {
    
    e = [self getRootCause:e];
    
    if( NO ) {
        
        
        NSArray* stack = [e callStackReturnAddresses];
        
        JBJsonArray* answer = [[JBJsonArray alloc] initWithCapacity:[stack count]];
        [answer autorelease];
        
        for( NSNumber* n in stack ) {
            NSString* frameAddress = [NSString stringWithFormat:@"0x%lx", [n longValue]];
            [answer add:frameAddress];
        }
        
        return answer;
        
    } else {

        NSArray* callStackSymbols = [e callStackSymbols];
        JBJsonArray* answer = [[JBJsonArray alloc] initWithCapacity:[callStackSymbols count]];
        [answer autorelease];
        
        for( NSString* callStackSymbol in callStackSymbols ) {
            callStackSymbol = [callStackSymbol stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [answer add:callStackSymbol];
        }
        
        return answer;

    }


}

+(NSString*)getAtosCommand:(NSException*)e { 
    
    e = [self getRootCause:e];
    
    NSProcessInfo* processInfo = [NSProcessInfo processInfo];
	NSArray* arguments = [processInfo arguments];
	NSString* executable = [arguments objectAtIndex:0];
	
	NSMutableString* answer = [[NSMutableString alloc] initWithFormat:@"/usr/bin/atos -o \"%@\"", executable];
    [answer autorelease];
	
	
	NSArray* stack = [e callStackReturnAddresses];
	for( NSNumber* n in stack ) {
		[answer appendFormat:@"  0x%lx", [n longValue]];
	}
    //	[stack release];
	
    return answer;
    
}

@end
