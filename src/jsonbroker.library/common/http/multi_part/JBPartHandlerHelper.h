// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBContentDisposition.h"
#import "JBMediaType.h"

@interface JBPartHandlerHelper : NSObject


+(JBContentDisposition*)getContentDispositionWithName:(NSString*)name value:(NSString*)value;
+(JBMediaType*)getContentTypeWithName:(NSString*)name value:(NSString*)value;

@end
