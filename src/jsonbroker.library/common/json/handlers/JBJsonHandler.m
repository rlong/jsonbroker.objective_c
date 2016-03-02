// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBJsonArray.h"
#import "JBJsonArrayHandler.h"
#import "JBJsonBooleanHandler.h"
#import "JBJsonHandler.h"
#import "JBJsonInput.h"
#import "JBJsonNullHandler.h"
#import "JBJsonNumberHandler.h"
#import "JBJsonObject.h"
#import "JBJsonObjectHandler.h"
#import "JBJsonDataInput.h"
#import "JBJsonStringHandler.h"
#import "JBJsonStringOutput.h"
#import "JBObjectTracker.h"



@implementation JBJsonHandler



+(JBJsonHandler*)getHandlerForObject:(id)object {
	
	if( nil == object ) {
		return [JBJsonNullHandler getInstance];		
	}
	
	
	////////////////////////////////////////////////////////////////////////
	
	
	if( [object isKindOfClass:[JBJsonArray class]] ) { 
		return [JBJsonArrayHandler getInstance];
	}
	
	if( [object isKindOfClass:[NSNumber class]] ) { 
        
        NSNumber* number = (NSNumber*)object;
        
        const char* objCType = [number objCType];
        
        /// vvv http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
        
        if (strcmp(objCType, @encode(BOOL)) == 0) {
            
        /// ^^^ http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
            
            return [JBJsonBooleanHandler getInstance];
        }
        
		return [JBJsonNumberHandler getInstance];
	}
	
	if( [object isKindOfClass:[JBJsonObject class]] ) { 
		return [JBJsonObjectHandler getInstance];
	}
	
	if( [object isKindOfClass:[NSString class]] ) { 
		return [JBJsonStringHandler getInstance];
	}
	
	////////////////////////////////////////////////////////////////////////
    
    Class clazz = [object class];
    
    NSString* technicalError = [NSString stringWithFormat:@"unsupported type; NSStringFromClass(clazz) = %@", NSStringFromClass(clazz)];
    
    BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
    @throw  e;
    
	
	
}

+(JBJsonHandler*)getHandlerForTokenBeginning:(char)tokenBeginning { 
	
	if( '"' == tokenBeginning ) {
		return [JBJsonStringHandler getInstance];
	}	
	
	if( '0' <= tokenBeginning && tokenBeginning <= '9' ) {
		return [JBJsonNumberHandler getInstance];
	}
	
	if( '[' == tokenBeginning ) {
		return [JBJsonArrayHandler getInstance];
	}
	
	if( '{' == tokenBeginning ) { 
		return [JBJsonObjectHandler getInstance];
	}
	
	if( '+' == tokenBeginning ) {
		return [JBJsonNumberHandler getInstance];
	}
	if( '-' == tokenBeginning ) {
		return [JBJsonNumberHandler getInstance];
	}
	
	
	if( 't' == tokenBeginning || 'T' == tokenBeginning) {
        return [JBJsonBooleanHandler getInstance];
	}
	
	if( 'f' == tokenBeginning || 'F' == tokenBeginning) {
        return [JBJsonBooleanHandler getInstance];
	}
	
	if( 'n' == tokenBeginning || 'N' == tokenBeginning) {
		return [JBJsonNullHandler getInstance];
	}
	
	
	NSString* technicalError = [NSString stringWithFormat:@"bad tokenBeginning; tokenBeginning = %d (%c)", tokenBeginning, tokenBeginning];
	
	BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
	@throw e;
	
}


-(void)writeValue:(id)value writer:(id<JBJsonOutput>)writer {

	BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"unimplemented"];
	@throw e;
	
}

-(id)readValue:(JBJsonInput*)reader { 
	BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"unimplemented"];
	@throw e;
}


#pragma mark instance lifecycle

-(id)init { 
	
	JBJsonHandler* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	return answer;
	
}

-(void)dealloc { 
	
	[JBObjectTracker deallocated:self];
}


@end
