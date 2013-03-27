// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


@class JBJsonObject;

@interface JBJsonArray : NSObject {
	

	NSMutableArray* _values;
	//@property (nonatomic, retain) NSMutableArray* values;
	//@synthesize values = _values;
	

}

-(void)add:(id)object;

-(void)addBoolean:(bool)value;
-(bool)getBoolean:(NSUInteger)index;


-(void)addInt:(int)value;
-(int)getInt:(NSUInteger)index;

-(void)addInteger:(NSInteger)value;
-(NSInteger)getInteger:(NSUInteger)index;

-(JBJsonArray*)getJsonArray:(NSUInteger)index;

-(JBJsonObject*)jsonObjectAtIndex:(NSUInteger)index;

-(id)objectAtIndex:(NSUInteger)index;
-(id)objectAtIndex:(NSUInteger)index defaultValue:(id)defaultValue;

-(NSString*)getString:(NSUInteger)index;
-(NSString*)getString:(NSUInteger)index defaultValue:(NSString*)defaultValue;

-(void)addUnsignedInteger:(NSUInteger)value;
-(NSUInteger)getUnsignedInteger:(NSUInteger)index;

-(int)length;
-(int)count;

-(void)removeObjectAtIndex:(int)index;

-(NSString*)toString;

#pragma mark instance lifecycle

-(id)initWithCapacity:(long)capacity;
	

@end
