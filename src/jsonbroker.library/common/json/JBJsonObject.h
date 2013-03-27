// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBJsonArray.h"


@interface JBJsonObject : NSObject {
	
	NSMutableDictionary* _values;
	//@property (nonatomic, retain) NSMutableDictionary* values;
	//@synthesize values = _values;
	
}


+(JBJsonObject*)buildWithData:(NSData*)data;
+(JBJsonObject*)buildWithString:(NSString*)jsonString;

-(NSEnumerator*)keyEnumerator;
-(NSArray*)allKeys;

-(BOOL)getBoolean:(NSString*)key defaultValue:(bool)defaultValue;
-(BOOL)getBoolean:(NSString*)key;
-(void)setBoolean:(BOOL)value forKey:(NSString*)key;

-(NSInteger)getInteger:(NSString*)key defaultValue:(NSInteger)defaultValue;
-(int)getInt:(NSString*)key;
-(int)getInt:(NSString*)key defaultValue:(int)defaultValue;
-(void)setInt:(int)value forKey:(NSString*)key;
-(void)setInteger:(NSInteger)value forKey:(NSString*)key;

-(JBJsonArray*)getJsonArray:(NSString*)key;
-(JBJsonArray*)getJsonArray:(NSString*)key defaultValue:(JBJsonArray*)defaultValue;


-(JBJsonObject*)getJsonObject:(NSString*)key;
-(JBJsonObject*)getJsonObject:(NSString*)key defaultValue:(JBJsonObject*)defaultValue;

-(long)getLong:(NSString*)key;
-(void)setLong:(long)value forKey:(NSString*)key;

-(long long)getLongLong:(NSString*)key;
-(void)setLongLong:(long long)value forKey:(NSString*)key;

-(id)getObject:(NSString*)key;
-(id)getObject:(NSString*)key defaultValue:(id)defaultValue;



-(void)setObject:(id)object forKey:(NSString*)key;

-(NSString*)getString:(NSString*)key;
-(NSString*)getString:(NSString*)key defaultValue:(NSString*)defaultValue;

-(NSUInteger)getUnsignedInteger:(NSString*)key;
-(void)setUnsignedInteger:(NSUInteger)value forKey:(NSString*)key;

-(void)setUnsignedLongLong:(unsigned long long)value forKey:(NSString*)key;


-(BOOL)hasOwnProperty:(NSString*)key;

-(BOOL)contains:(NSString*)key;


#pragma mark -
#pragma mark Alphabetically sorted


// http://www.ecma-international.org/ecma-262/5.1/#sec-11.4.1
-(void)delete:(NSString*)key;

-(NSString*)toString;


#pragma mark instance lifecycle

-(id)init;
-(id)initWithCapacity:(int)numItems;


@end
