// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBJsonDocumentHandler.h"
#import "JBJsonInput.h"

@interface JBJsonReader : NSObject {
    
    bool _continue;

}


-(void)readFromData:(NSData*)data handler:(id<JBJsonDocumentHandler>)handler;
+(void)readFromData:(NSData*)data handler:(id<JBJsonDocumentHandler>)handler;

-(void)stop;

@end
