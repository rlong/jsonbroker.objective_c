// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBJsonDocumentHandler.h"
#import "JBJsonOutput.h"

@interface JBJsonWriter : NSObject <JBJsonDocumentHandler> {
    
    
    // output
    id<JBJsonOutput> _output;
    //@property (nonatomic, retain) id<JBJsonOutput> output;
    //@synthesize output = _output;

    bool _objectStarted;
    
    
    
}

#pragma mark -
#pragma mark instance lifecycle


-(id)initWithOutput:(id<JBJsonOutput>)output;

@end
