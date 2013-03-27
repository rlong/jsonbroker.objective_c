// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBBaseException.h"
#import "JBJsonArray.h"
#import "JBJsonObject.h"
#import "JBJsonObjectHandler.h"
#import "JBJsonDataInput.h"
#import "JBJsonStringOutput.h"
#import "JBObjectTracker.h"
#import "JBStringHelper.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBJsonObject () 

//NSMutableDictionary* _values;
@property (nonatomic, retain) NSMutableDictionary* values;
//@synthesize values = _values;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBJsonObject


static NSObject* _NULL_OBJECT = nil;



+(void)initialize {
	
    _NULL_OBJECT = [NSNull null];

}


+(JBJsonObject*)buildWithData:(NSData*)data {
	
	JBJsonObject* answer = nil;
    
	JBJsonDataInput* reader = [[JBJsonDataInput alloc] initWithData:data];
	{
		[reader scanToNextToken];
		
		answer = [[JBJsonObjectHandler getInstance] readJSONObject:reader];
		
		
	}
	[reader release];
	
	return answer;
	
}


+(JBJsonObject*)buildWithString:(NSString*)jsonString {
    
    NSData* data = [JBStringHelper toUtf8Data:jsonString];
    return [self buildWithData:data];
	
}



-(NSEnumerator*)keyEnumerator {
	return [_values keyEnumerator];
}

-(NSArray*)allKeys {
	return [_values allKeys];
}


-(id)getBlob:(NSString*)key throwExceptionOnNil:(bool)throwExceptionOnNil{
    
    
	
	id answer = [_values objectForKey:key];
    
    if( _NULL_OBJECT == answer ) { 
        answer = nil;
    }
	
	if( nil == answer && throwExceptionOnNil ) {
        NSString* technicalError = [NSString stringWithFormat:@"nil == answer; key = '%@'",key];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;
		
	}
	
	return answer;
	
}


-(BOOL)getBoolean:(NSString*)key defaultValue:(bool)defaultValue{
    
    id blob = [self getBlob:key throwExceptionOnNil:false];
    
    if( nil == blob ) {
        return defaultValue;
    }
    
    if( ![blob isKindOfClass:[NSNumber class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
	return [answer boolValue];
}

-(BOOL)getBoolean:(NSString*)key {
    
    id blob = [self getBlob:key throwExceptionOnNil:true];
    
    if( ![blob isKindOfClass:[NSNumber class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
	return [answer boolValue];
}

-(void)setBoolean:(BOOL)value forKey:(NSString*)key {
    
    NSNumber* boolean = [NSNumber numberWithBool:value];
	
	[_values setObject:boolean forKey:key];

}



-(NSInteger)getInteger:(NSString*)key defaultValue:(NSInteger)defaultValue{

    
	id blob = [self getBlob:key throwExceptionOnNil:false];
	
	if( nil == blob ) {
		return defaultValue;
	}
	
	if( ![blob isKindOfClass:[NSNumber class]] ) { 
		
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![blob isKindOfClass:[NSNumber class]]; key = '%@'", key];
		[e autorelease];
		@throw e;
	}
	
	NSNumber* number = (NSNumber*)blob;
	return [number integerValue];
}

-(int)getInt:(NSString*)key {

	id blob = [self getBlob:key throwExceptionOnNil:true];
    
    if( ![blob isKindOfClass:[NSNumber class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
	return [answer intValue];


}


-(int)getInt:(NSString*)key defaultValue:(int)defaultValue {
    id blob = [self getBlob:key throwExceptionOnNil:false];
	
	if( nil == blob ) {
		return defaultValue;
	}
	
	if( ![blob isKindOfClass:[NSNumber class]] ) {
		
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![blob isKindOfClass:[NSNumber class]]; key = '%@'", key];
		[e autorelease];
		@throw e;
	}
	
	NSNumber* number = (NSNumber*)blob;
	return [number intValue];
}



-(void)setInt:(int)value forKey:(NSString*)key {
	
	NSNumber* number = [NSNumber numberWithInt:value];
	
	[_values setObject:number forKey:key];
}


-(void)setInteger:(NSInteger)value forKey:(NSString*)key {
	
	NSNumber* number = [NSNumber numberWithInteger:value];
	
	[_values setObject:number forKey:key];
}


-(JBJsonArray*)getJsonArray:(NSString*)key {
	
    id blob = [self getBlob:key throwExceptionOnNil:true];

	
	if( ![blob isKindOfClass:[JBJsonArray class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[JSONArray class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];

		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        [e autorelease];
		@throw e;
	}
	
	JBJsonArray* answer = (JBJsonArray*)blob;
	return answer;
	
}


-(JBJsonArray*)getJsonArray:(NSString*)key defaultValue:(JBJsonArray*)defaultValue {

    id blob = [self getBlob:key throwExceptionOnNil:false];
    
    if( nil == blob ) { 
        return defaultValue;
    }
    
	if( ![blob isKindOfClass:[JBJsonArray class]] ) { 
    
        return defaultValue;
    }
    
	JBJsonArray* answer = (JBJsonArray*)blob;
	return answer;
    

}

-(JBJsonObject*)getJsonObject:(NSString*)key {
    
    id blob = [self getBlob:key throwExceptionOnNil:true];
    
	if( ![blob isKindOfClass:[JBJsonObject class]] ) { 

        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[JSONObject class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];

		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        [e autorelease];
		@throw e;
	}
	
	JBJsonObject* answer = (JBJsonObject*)blob;
	return answer;
    
}

-(JBJsonObject*)getJsonObject:(NSString*)key defaultValue:(JBJsonObject*)defaultValue {
    
    id blob = [self getBlob:key throwExceptionOnNil:false];
    
    if( nil == blob ) {
		return defaultValue;
	}
    
	if( ![blob isKindOfClass:[JBJsonObject class]] ) { 
        
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[JSONObject class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
        
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        [e autorelease];
		@throw e;
	}
	
	JBJsonObject* answer = (JBJsonObject*)blob;
	return answer;
    
}

-(long)getLong:(NSString*)key {
    
    id blob = [self getBlob:key throwExceptionOnNil:true];
    
    if( ![blob isKindOfClass:[NSNumber class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
	return [answer longValue];

}


-(void)setLong:(long)value forKey:(NSString*)key {
    
    
    NSNumber* number = [NSNumber numberWithLong:value];
	
	[_values setObject:number forKey:key];

    
    
}


-(long long)getLongLong:(NSString*)key {
    
    id blob = [self getBlob:key throwExceptionOnNil:true];
    
    if( ![blob isKindOfClass:[NSNumber class]] ) {
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
	return [answer longLongValue];
    
}


-(void)setLongLong:(long long)value forKey:(NSString*)key {
    
    
    NSNumber* number = [NSNumber numberWithLongLong:value];
	
	[_values setObject:number forKey:key];
    
    
    
}


-(id)getObject:(NSString*)key {

    id answer = [self getBlob:key throwExceptionOnNil:true];

	return answer;
	
}

-(id)getObject:(NSString*)key defaultValue:(id)defaultValue{
    
    id answer = [self getBlob:key throwExceptionOnNil:false];
    
    if( nil == answer ) { 
        return defaultValue;
    }
    
	return answer;
	
}


-(void)setObject:(id)object forKey:(NSString*)key {
	
	if( nil == object ) {
		[_values setObject:_NULL_OBJECT forKey:key];
	} else {
		[_values setObject:object forKey:key];
	}
}


-(NSString*)getString:(NSString*)key defaultValue:(NSString*)defaultValue{
	
    id blob = [self getBlob:key throwExceptionOnNil:false];
	
	if( nil == blob ) {
		return defaultValue;
	}
	
	if( ![blob isKindOfClass:[NSString class]] ) { 
		
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"![blob isKindOfClass:[NSString class]]"];
		[e autorelease];
		@throw e;
	}
	
	NSString* answer = (NSString*)blob;
	return answer;
	
	
}


-(NSString*)getString:(NSString*)key {
	
    id blob = [self getBlob:key throwExceptionOnNil:true];

	if( nil == blob ) {
		return nil;
	}

	if( ![blob isKindOfClass:[NSString class]] ) { 
		
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"![blob isKindOfClass:[NSString class]]"];
		[e autorelease];
		@throw e;
	}
	
	NSString* answer = (NSString*)blob;
	return answer;
	
}


-(NSUInteger)getUnsignedInteger:(NSString*)key {
    
    id blob = [self getBlob:key throwExceptionOnNil:true];
    
    if( ![blob isKindOfClass:[NSNumber class]] ) {
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
	return [answer unsignedIntegerValue];

}



-(void)setUnsignedInteger:(NSUInteger)value forKey:(NSString*)key {
	
	NSNumber* number = [NSNumber numberWithUnsignedInteger:value];
	
	[_values setObject:number forKey:key];
}

-(void)setUnsignedLongLong:(unsigned long long)value forKey:(NSString*)key {

    NSNumber* number = [NSNumber numberWithUnsignedLongLong:value];
	
	[_values setObject:number forKey:key];

}





-(BOOL)hasOwnProperty:(NSString*)key { 
    
	id blob = [_values objectForKey:key];
	if( nil == blob ) { 
		return FALSE;
	}
	return TRUE;    
}

-(BOOL)contains:(NSString*)key {
	
	id blob = [_values objectForKey:key];
	if( nil == blob ) { 
		return FALSE;
	}
	return TRUE;
	
}


#pragma mark -
#pragma mark Alphabetically sorted


// http://www.ecma-international.org/ecma-262/5.1/#sec-11.4.1
-(void)delete:(NSString*)key {
    
    [_values removeObjectForKey:key];
    
}

-(NSString*)toString {
	
	NSString* answer = nil;
	
	
	//JSONWriter writer = new JSONWriter();
	JBJsonStringOutput* writer = [[JBJsonStringOutput alloc] init];
	{
		//_jsonObjectHandler.writeValue( this, jsonWriter);
		[[JBJsonObjectHandler getInstance] writeValue:self writer:writer];
		
		//return jsonWriter.toString();
		answer = [writer toString];
        
        
	}
	[writer release];
	
	return answer;
	
}


#pragma mark instance lifecycle



-(id)init {
	
	JBJsonObject* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	answer->_values = [[NSMutableDictionary alloc] init];
	
	return answer;
}

-(id)initWithCapacity:(int)numItems {
	
	JBJsonObject* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	answer->_values = [[NSMutableDictionary alloc] initWithCapacity:numItems];
	
	return answer;
	
}

-(void)dealloc {
	
	[JBObjectTracker deallocated:self];
	
	[self setValues:nil];
	
	[super dealloc];
}


//NSMutableDictionary* _values;
//@property (nonatomic, retain) NSMutableDictionary* values;
@synthesize values = _values;


@end
