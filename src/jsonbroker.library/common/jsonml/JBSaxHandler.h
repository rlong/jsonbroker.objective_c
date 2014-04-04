// Copyright (c) 2014 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBJsonDocumentHandler.h"

@interface JBSaxHandler : NSObject <NSXMLParserDelegate> {

    
    
    int _currentIndex;
    
    // elementText
    NSMutableString* _elementText;
    //@property (nonatomic, retain) NSMutableString* elementText;
    //@synthesize elementText = _elementText;

    
    bool _ignoreEmptyStrings;
    
    // indices
    NSMutableArray* _indices;
    //@property (nonatomic, retain) NSMutableArray* indices;
    //@synthesize indices = _indices;

    // jsonHandler
    id<JBJsonDocumentHandler> _jsonHandler;
    //@property (nonatomic, retain) id<JBJsonDocumentHandler> jsonHandler;
    //@synthesize jsonHandler = _jsonHandler;

    bool _trim;
    
    
}



#pragma mark -
#pragma mark instance lifecycle


-(id)initWithJsonHandler:(id<JBJsonDocumentHandler>)jsonHandler;



@end
