// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <Foundation/Foundation.h>

@class JBJsonArray;
@class JBJsonObject;


@interface JBJsonStack : NSObject {
    
    // stack
    NSMutableArray* _stack;
    //@property (nonatomic, retain) NSMutableArray* stack;
    //@synthesize stack = _stack;

    // currentObject
    JBJsonObject* _currentObject;
    //@property (nonatomic, retain) JBJsonObject* currentObject;
    //@synthesize currentObject = _currentObject;
    
    // currentArray
    JBJsonArray* _currentArray;
    //@property (nonatomic, retain) JBJsonArray* currentArray;
    //@synthesize currentArray = _currentArray;


}

-(id)pop;
-(void)pushJsonObject:(JBJsonObject*)top;
-(void)pushJsonArray:(JBJsonArray*)top;


#pragma mark -
#pragma mark fields

// currentObject
//JBJsonObject* _currentObject;
@property (nonatomic, readonly, retain) JBJsonObject* currentObject;
//@synthesize currentObject = _currentObject;

// currentArray
//JBJsonArray* _currentArray;
@property (nonatomic, readonly, retain) JBJsonArray* currentArray;
//@synthesize currentArray = _currentArray;

@end
