// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBMultiPartHandler.h"

@interface JBTestMultiPartHandler : NSObject <JBMultiPartHandler> {
    
    
    
    // partHandlers
    NSMutableArray* _partHandlers;
    //@property (nonatomic, retain) NSMutableArray* partHandlers;
    //@synthesize partHandlers = _partHandlers;

    
    bool _foundCloseDelimiter;
    
}


-(bool)haveFoundCloseDelimiter;


#pragma mark -
#pragma mark fields

// partHandlers
//NSMutableArray* _partHandlers;
@property (nonatomic, retain) NSMutableArray* partHandlers;
//@synthesize partHandlers = _partHandlers;


@end
