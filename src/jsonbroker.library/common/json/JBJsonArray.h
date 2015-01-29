// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@class JBJsonObject;

@interface JBJsonArray : NSObject {
	

	NSMutableArray* _values;
	//@property (nonatomic, retain) NSMutableArray* values;
	//@synthesize values = _values;
	

}

+(NSString*)NULL_VALUE_REFERENCED;

-(void)add:(id)object;

-(void)addBoolean:(bool)value;
-(bool)getBoolean:(NSUInteger)index;


-(void)addInt:(int)value;
-(int)getInt:(NSUInteger)index;

-(void)addInteger:(NSInteger)value;
-(void)addUnsignedInteger:(NSUInteger)value;


// deprecated: use integerAtIndex
-(NSInteger)getInteger:(NSUInteger)index;
-(NSUInteger)getUnsignedInteger:(NSUInteger)index;

-(NSInteger)integerAtIndex:(NSUInteger)index;

-(JBJsonArray*)jsonArrayAtIndex:(NSUInteger)index;

-(JBJsonObject*)jsonObjectAtIndex:(NSUInteger)index;

-(NSNumber*)numberAtIndex:(NSUInteger)index;

-(id)objectAtIndex:(NSUInteger)index;
-(id)objectAtIndex:(NSUInteger)index defaultValue:(id)defaultValue;

// deprecated: use stringAtIndex
-(NSString*)getString:(NSUInteger)index;
-(NSString*)getString:(NSUInteger)index defaultValue:(NSString*)defaultValue;


-(int)length;
-(int)count;

-(void)removeAllObjects;
-(void)removeObjectAtIndex:(int)index;

-(NSString*)stringAtIndex:(NSUInteger)index;


-(NSString*)toString;

#pragma mark instance lifecycle

-(id)initWithCapacity:(long)capacity;
	

@end
