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
#import "JBMemoryModel.h"
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
    JBRelease( reader );
	
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
        JBAutorelease( e );
		@throw e;
		
	}
	
	return answer;
	
}


#pragma mark -
#pragma mark getters


-(BOOL)boolForKey:(NSString*)key {
    
    id blob = [self getBlob:key throwExceptionOnNil:true];
    
    if( ![blob isKindOfClass:[NSNumber class]] ) {
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        JBAutorelease( e );
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
	return [answer boolValue];
}

-(BOOL)boolForKey:(NSString*)key defaultValue:(bool)defaultValue{
    
    id blob = [self getBlob:key throwExceptionOnNil:false];
    
    if( nil == blob ) {
        return defaultValue;
    }
    
    if( ![blob isKindOfClass:[NSNumber class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        JBAutorelease( e );
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
	return [answer boolValue];
}




-(double)doubleForKey:(NSString*)key {

    id blob = [self getBlob:key throwExceptionOnNil:true];
	
	if( ![blob isKindOfClass:[NSNumber class]] ) {
		
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![blob isKindOfClass:[NSNumber class]]; key = '%@'", key];
        JBAutorelease( e );
		@throw e;
	}
	
	NSNumber* number = (NSNumber*)blob;
	return [number doubleValue];

}

-(double)doubleForKey:(NSString*)key defaultValue:(double)defaultValue{
    
    
	id blob = [self getBlob:key throwExceptionOnNil:false];
	
	if( nil == blob ) {
		return defaultValue;
	}
	
	if( ![blob isKindOfClass:[NSNumber class]] ) {
		
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![blob isKindOfClass:[NSNumber class]]; key = '%@'", key];
        JBAutorelease( e );
		@throw e;
	}
	
	NSNumber* number = (NSNumber*)blob;
	return [number doubleValue];
}



-(NSInteger)integerForKey:(NSString*)key {
    
    id blob = [self getBlob:key throwExceptionOnNil:true];
	
	if( ![blob isKindOfClass:[NSNumber class]] ) {
		
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![blob isKindOfClass:[NSNumber class]]; key = '%@'", key];
        JBAutorelease( e );
		@throw e;
	}
	
	NSNumber* number = (NSNumber*)blob;
	return [number integerValue];
}


-(NSInteger)integerForKey:(NSString*)key defaultValue:(NSInteger)defaultValue{

    
	id blob = [self getBlob:key throwExceptionOnNil:false];
	
	if( nil == blob ) {
		return defaultValue;
	}
	
	if( ![blob isKindOfClass:[NSNumber class]] ) { 
		
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![blob isKindOfClass:[NSNumber class]]; key = '%@'", key];
        JBAutorelease( e );
		@throw e;
	}
	
	NSNumber* number = (NSNumber*)blob;
	return [number integerValue];
}

-(int)intForKey:(NSString*)key {

	id blob = [self getBlob:key throwExceptionOnNil:true];
    
    if( ![blob isKindOfClass:[NSNumber class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        JBAutorelease( e );
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
	return [answer intValue];


}


-(int)intForKey:(NSString*)key defaultValue:(int)defaultValue {
    id blob = [self getBlob:key throwExceptionOnNil:false];
	
	if( nil == blob ) {
		return defaultValue;
	}
	
	if( ![blob isKindOfClass:[NSNumber class]] ) {
		
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![blob isKindOfClass:[NSNumber class]]; key = '%@'", key];
        JBAutorelease( e );
		@throw e;
	}
	
	NSNumber* number = (NSNumber*)blob;
	return [number intValue];
}





-(JBJsonArray*)jsonArrayForKey:(NSString*)key {
	
    id blob = [self getBlob:key throwExceptionOnNil:true];

	
	if( ![blob isKindOfClass:[JBJsonArray class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[JSONArray class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];

		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        JBAutorelease( e );
		@throw e;
	}
	
	JBJsonArray* answer = (JBJsonArray*)blob;
	return answer;
	
}


-(JBJsonArray*)jsonArrayForKey:(NSString*)key defaultValue:(JBJsonArray*)defaultValue {

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

-(JBJsonObject*)jsonObjectForKey:(NSString*)key {
    
    id blob = [self getBlob:key throwExceptionOnNil:true];
    
	if( ![blob isKindOfClass:[JBJsonObject class]] ) { 

        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[JSONObject class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];

		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        JBAutorelease( e );
		@throw e;
	}
	
	JBJsonObject* answer = (JBJsonObject*)blob;
	return answer;
    
}

-(JBJsonObject*)jsonObjectForKey:(NSString*)key defaultValue:(JBJsonObject*)defaultValue {
    
    id blob = [self getBlob:key throwExceptionOnNil:false];
    
    if( nil == blob ) {
		return defaultValue;
	}
    
	if( ![blob isKindOfClass:[JBJsonObject class]] ) { 
        
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[JSONObject class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
        
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        JBAutorelease( e );
		@throw e;
	}
	
	JBJsonObject* answer = (JBJsonObject*)blob;
	return answer;
    
}

-(long)longForKey:(NSString*)key {
    
    id blob = [self getBlob:key throwExceptionOnNil:true];
    
    if( ![blob isKindOfClass:[NSNumber class]] ) { 
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        JBAutorelease( e );
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
	return [answer longValue];

}




-(long long)longLongForKey:(NSString*)key {
    
    id blob = [self getBlob:key throwExceptionOnNil:true];
    
    if( ![blob isKindOfClass:[NSNumber class]] ) {
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        JBAutorelease( e );
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
	return [answer longLongValue];
    
}


-(long long)longLongForKey:(NSString*)key defaultValue:(long long)defaultValue {
    
    id blob = [self getBlob:key throwExceptionOnNil:false];
    
    if( nil == blob ) {
		return defaultValue;
	}
    
    if( ![blob isKindOfClass:[NSNumber class]] ) {
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        JBAutorelease( e );
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
	return [answer longLongValue];

}




-(id)objectForKey:(NSString*)key {

    id answer = [self getBlob:key throwExceptionOnNil:true];

	return answer;
	
}

-(id)objectForKey:(NSString*)key defaultValue:(id)defaultValue{
    
    id answer = [self getBlob:key throwExceptionOnNil:false];
    
    if( nil == answer ) { 
        return defaultValue;
    }
    
	return answer;
	
}





-(NSString*)stringForKey:(NSString*)key defaultValue:(NSString*)defaultValue{
	
    id blob = [self getBlob:key throwExceptionOnNil:false];
	
	if( nil == blob ) {
		return defaultValue;
	}
	
	if( ![blob isKindOfClass:[NSString class]] ) { 
		
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"![blob isKindOfClass:[NSString class]]"];
        JBAutorelease( e );
		@throw e;
	}
	
	NSString* answer = (NSString*)blob;
	return answer;
	
	
}


-(NSString*)stringForKey:(NSString*)key {
	
    id blob = [self getBlob:key throwExceptionOnNil:true];

	if( nil == blob ) {
		return nil;
	}

	if( ![blob isKindOfClass:[NSString class]] ) { 
		
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"![blob isKindOfClass:[NSString class]]"];
        JBAutorelease( e );
		@throw e;
	}
	
	NSString* answer = (NSString*)blob;
	return answer;
	
}


-(NSUInteger)unsignedIntegerForKey:(NSString*)key {
    
    id blob = [self getBlob:key throwExceptionOnNil:true];
    
    if( ![blob isKindOfClass:[NSNumber class]] ) {
		
        NSString* technicalError = [NSString stringWithFormat:@"![blob isKindOfClass:[NSNumber class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
		BaseException *e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        JBAutorelease( e );
		@throw e;
	}
	
	NSNumber* answer = (NSNumber*)blob;
	return [answer unsignedIntegerValue];

}





#pragma mark -
#pragma mark setters

-(void)setBool:(BOOL)value forKey:(NSString*)key {
    
    NSNumber* boolean = [NSNumber numberWithBool:value];
	
	[_values setObject:boolean forKey:key];
    
}



-(void)setDoubleForKey:(double)value forKey:(NSString*)key {
    
    NSNumber* number = [NSNumber numberWithDouble:value];
	
	[_values setObject:number forKey:key];
    
}


-(void)setInt:(int)value forKey:(NSString*)key {
	
	NSNumber* number = [NSNumber numberWithInt:value];
	
	[_values setObject:number forKey:key];
}


-(void)setInteger:(NSInteger)value forKey:(NSString*)key {
	
	NSNumber* number = [NSNumber numberWithInteger:value];
	
	[_values setObject:number forKey:key];
}

-(void)setLong:(long)value forKey:(NSString*)key {
    
    
    NSNumber* number = [NSNumber numberWithLong:value];
	
	[_values setObject:number forKey:key];
    
}


-(void)setLongLong:(long long)value forKey:(NSString*)key {
    
    
    NSNumber* number = [NSNumber numberWithLongLong:value];
	
	[_values setObject:number forKey:key];
    
    
    
}


-(void)setObject:(id)object forKey:(NSString*)key {
	
	if( nil == object ) {
		[_values setObject:_NULL_OBJECT forKey:key];
	} else {
		[_values setObject:object forKey:key];
	}
}


-(void)setUnsignedInteger:(NSUInteger)value forKey:(NSString*)key {
	
	NSNumber* number = [NSNumber numberWithUnsignedInteger:value];
	
	[_values setObject:number forKey:key];
}

-(void)setUnsignedLongLong:(unsigned long long)value forKey:(NSString*)key {
    
    NSNumber* number = [NSNumber numberWithUnsignedLongLong:value];
	
	[_values setObject:number forKey:key];
    
}

#pragma mark -


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
    JBRelease( writer );
	
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
    
    JBSuperDealloc();
}


//NSMutableDictionary* _values;
//@property (nonatomic, retain) NSMutableDictionary* values;
@synthesize values = _values;


@end
