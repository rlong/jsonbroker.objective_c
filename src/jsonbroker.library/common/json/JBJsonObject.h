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

#pragma mark -
#pragma mark getters


-(BOOL)boolForKey:(NSString*)key;
-(BOOL)boolForKey:(NSString*)key defaultValue:(bool)defaultValue;

-(double)doubleForKey:(NSString*)key;
-(double)doubleForKey:(NSString*)key defaultValue:(double)defaultValue;

-(NSInteger)integerForKey:(NSString*)key;
-(NSInteger)integerForKey:(NSString*)key defaultValue:(NSInteger)defaultValue;

-(int)intForKey:(NSString*)key;
-(int)intForKey:(NSString*)key defaultValue:(int)defaultValue;

-(void)setInt:(int)value forKey:(NSString*)key;

-(JBJsonArray*)jsonArrayForKey:(NSString*)key;
-(JBJsonArray*)jsonArrayForKey:(NSString*)key defaultValue:(JBJsonArray*)defaultValue;

-(JBJsonObject*)jsonObjectForKey:(NSString*)key;
-(JBJsonObject*)jsonObjectForKey:(NSString*)key defaultValue:(JBJsonObject*)defaultValue;

-(long)longForKey:(NSString*)key;

-(long long)longLongForKey:(NSString*)key;
-(long long)longLongForKey:(NSString*)key defaultValue:(long long)defaultValue;

-(id)objectForKey:(NSString*)key;
-(id)objectForKey:(NSString*)key defaultValue:(id)defaultValue;

-(NSString*)stringForKey:(NSString*)key;
-(NSString*)stringForKey:(NSString*)key defaultValue:(NSString*)defaultValue;

-(NSUInteger)unsignedIntegerForKey:(NSString*)key;


#pragma mark -
#pragma mark setters

-(void)setBool:(BOOL)value forKey:(NSString*)key;
-(void)setDoubleForKey:(double)value forKey:(NSString*)key;
-(void)setInteger:(NSInteger)value forKey:(NSString*)key;
-(void)setLong:(long)value forKey:(NSString*)key;
-(void)setLongLong:(long long)value forKey:(NSString*)key;
-(void)setObject:(id)object forKey:(NSString*)key;
-(void)setUnsignedInteger:(NSUInteger)value forKey:(NSString*)key;
-(void)setUnsignedLongLong:(unsigned long long)value forKey:(NSString*)key;

#pragma mark -

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
