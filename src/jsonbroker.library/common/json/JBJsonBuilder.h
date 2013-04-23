// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBJsonDocumentHandler.h"
#import "JBJsonStack.h"

@interface JBJsonBuilder : NSObject <JBJsonDocumentHandler> {
    
    // stack
    JBJsonStack* _stack;
    //@property (nonatomic, retain) JBJsonStack* stack;
    //@synthesize stack = _stack;
    
    
    // objectDocument
    JBJsonObject* _objectDocument;
    //@property (nonatomic, readonly) JBJsonObject* objectDocument;
    //@property (nonatomic, retain, readwrite) JBJsonObject* objectDocument;
    //@synthesize objectDocument = _objectDocument;


    // arrayDocument
    JBJsonArray* _arrayDocument;
    //@property (nonatomic, readonly) JBJsonArray* arrayDocument;
    //@property (nonatomic, retain, readwrite) JBJsonArray* arrayDocument;
    //@synthesize arrayDocument = _arrayDocument;

}


#pragma mark -
#pragma mark fields

// objectDocument
//JBJsonObject* _objectDocument;
@property (nonatomic, readonly) JBJsonObject* objectDocument;
//@property (nonatomic, retain, readwrite) JBJsonObject* objectDocument;
//@synthesize objectDocument = _objectDocument;


// arrayDocument
//JBJsonArray* _arrayDocument;
@property (nonatomic, readonly) JBJsonArray* arrayDocument;
//@property (nonatomic, retain, readwrite) JBJsonArray* arrayDocument;
//@synthesize arrayDocument = _arrayDocument;

@end
