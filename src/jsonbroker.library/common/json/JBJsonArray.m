// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBBaseException.h"
#import "JBJsonArray.h"
#import "JBJsonArrayHandler.h"
#import "JBJsonObject.h"
#import "JBJsonStringOutput.h"
#import "JBObjectTracker.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBJsonArray () 

//NSMutableArray* _values;
@property (nonatomic, retain) NSMutableArray* values;
//@synthesize values = _values;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation JBJsonArray


static NSObject* _NULL_OBJECT = nil;


+(NSString*)NULL_VALUE_REFERENCED {
    return @"jsonbroker.JsonArray.NULL_VALUE_REFERENCED";
}



+(void)initialize {
	
	_NULL_OBJECT = [NSNull null];
    
}



-(id)getBlobAtIndex:(NSUInteger)index throwExceptionOnNil:(bool)throwExceptionOnNil{
    
    
	
	id answer = [_values objectAtIndex:index];
    
    if( _NULL_OBJECT == answer ) {
        answer = nil;
    }
	
	if( nil == answer && throwExceptionOnNil ) {
        NSString* technicalError = [NSString stringWithFormat:@"nil == answer; index = %ld",(unsigned long)index];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        [e setErrorDomain:[JBJsonArray NULL_VALUE_REFERENCED]];
		[e autorelease];
		@throw e;
		
	}
	
	return answer;
	
}



-(void)add:(id)object { 
	
	if( nil == object ) {
		[_values addObject:_NULL_OBJECT];
		return;
	}
	
	[_values addObject:object];
	
}


-(void)addBoolean:(bool)value { 
    
    
    NSNumber* boolean = [NSNumber numberWithBool:value];
    
    [_values addObject:boolean];

    
}

-(bool)getBoolean:(NSUInteger)index {
    
    id blob = [self getBlobAtIndex:index throwExceptionOnNil:true];
    

    if( ![blob isKindOfClass:[NSNumber class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
	return [answer boolValue];
    
    
}


-(void)addInt:(int)value {
    
    [_values addObject:[NSNumber numberWithInt:value]];
    
}

-(void)addUnsignedInteger:(NSUInteger)value {

    [_values addObject:[NSNumber numberWithUnsignedInteger:value]];

}

-(int)getInt:(NSUInteger)index {
	
    id blob = [self getBlobAtIndex:index throwExceptionOnNil:true];
	
	if( ![blob isKindOfClass:[NSNumber class]] ) {

        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;
	}
	
	NSNumber* number = (NSNumber*)blob;
	return [number intValue];
}




-(void)addInteger:(NSInteger)value {
    
    [_values addObject:[NSNumber numberWithInteger:value]];
    
}

// deprecated: use integerAtIndex
-(NSInteger)getInteger:(NSUInteger)index {
	
    id blob = [self getBlobAtIndex:index throwExceptionOnNil:true];
	
	if( ![blob isKindOfClass:[NSNumber class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;
	}
	
	NSNumber* number = (NSNumber*)blob;
	return [number integerValue];
}



-(NSUInteger)getUnsignedInteger:(NSUInteger)index {
	
    id blob = [self getBlobAtIndex:index throwExceptionOnNil:true];
	
	if( ![blob isKindOfClass:[NSNumber class]] ) {
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;
	}
	
	NSNumber* number = (NSNumber*)blob;
	return [number unsignedIntegerValue];
}


-(NSInteger)integerAtIndex:(NSUInteger)index {

    id blob = [self getBlobAtIndex:index throwExceptionOnNil:true];
    
    if( ![blob isKindOfClass:[NSNumber class]] ) {
        
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
        BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        [e autorelease];
        @throw e;
    }
    
    NSNumber* number = (NSNumber*)blob;
    return [number integerValue];

}


-(JBJsonArray*)jsonArrayAtIndex:(NSUInteger)index {
	
	
    id blob = [self getBlobAtIndex:index throwExceptionOnNil:true];
	
	
	if( ![blob isKindOfClass:[JBJsonArray class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[JSONArray class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;

	}
	
	JBJsonArray* answer = (JBJsonArray*)blob;
	return answer;
}

-(JBJsonObject*)jsonObjectAtIndex:(NSUInteger)index {
	
    id blob = [self getBlobAtIndex:index throwExceptionOnNil:true];
	
	if( ![blob isKindOfClass:[JBJsonObject class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[JSONObject class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;

	}
	
	JBJsonObject* answer = (JBJsonObject*)blob;
	return answer;
}

-(NSNumber*)numberAtIndex:(NSUInteger)index {
    
    id blob = [self getBlobAtIndex:index throwExceptionOnNil:true];
    
    if( ![blob isKindOfClass:[NSNumber class]] ) {
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
    return answer;

    
}


-(id)objectAtIndex:(NSUInteger)index {
	
    id blob = [self getBlobAtIndex:index throwExceptionOnNil:true];
	
	return blob;
	
}

-(id)objectAtIndex:(NSUInteger)index defaultValue:(id)defaultValue {

    id blob = [self getBlobAtIndex:index throwExceptionOnNil:false];
    
    if( nil == blob ) {
        return defaultValue;
    }
	
	return blob;

}

-(NSString*)getString:(NSUInteger)index {
	
    id blob = [self getBlobAtIndex:index throwExceptionOnNil:true];
	
	if( ![blob isKindOfClass:[NSString class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSString class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;
	}
	
	NSString* answer = (NSString*)blob;
	return answer;
}


-(NSString*)getString:(NSUInteger)index defaultValue:(NSString*)defaultValue{
	
    id blob = [self getBlobAtIndex:index throwExceptionOnNil:false];
    
    if( nil == blob ) {
        return defaultValue;
    }
	
	if( ![blob isKindOfClass:[NSString class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSString class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;
	}
	
	NSString* answer = (NSString*)blob;
	return answer;
	
	
}



-(int)length {
	return (int)[_values count];
    
}

-(int)count { 
	return (int)[_values count];
}


-(void)removeAllObjects {
    [_values removeAllObjects];
}

-(void)removeObjectAtIndex:(int)index {
    [_values removeObjectAtIndex:index];
}

-(NSString*)stringAtIndex:(NSUInteger)index {
    
    
    id blob = [self getBlobAtIndex:index throwExceptionOnNil:true];
    
    if( ![blob isKindOfClass:[NSString class]] ) {
        
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSString class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
        BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        [e autorelease];
        @throw e;
    }
    
    NSString* answer = (NSString*)blob;
    return answer;

    
}


-(NSString*)toString { 
	
	NSString* answer = nil;
	
	
	JBJsonStringOutput* writer = [[JBJsonStringOutput alloc] init];
	{
		[[JBJsonArrayHandler getInstance] writeValue:self writer:writer];
		
		answer = [writer toString];
		
	}
	[writer release];
	
	return answer;
	
}


#pragma mark instance lifecycle

-(id)init {
	
	JBJsonArray* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	answer->_values = [[NSMutableArray alloc] init];
	
	return answer;
}

-(id)initWithCapacity:(long)capacity { 
	
	JBJsonArray* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	answer->_values = [[NSMutableArray alloc] initWithCapacity:capacity];
	
	return answer;
	
}


-(void)dealloc {
	
	[JBObjectTracker deallocated:self];
	
	[self setValues:nil];
	
	[super dealloc];
}


//NSMutableArray* _values;
//@property (nonatomic, retain) NSMutableArray* values;
@synthesize values = _values;

@end
