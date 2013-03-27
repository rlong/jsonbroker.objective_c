// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <Foundation/Foundation.h>

#import "JBJsonArray.h"
#import "JBJsonDocumentHandler.h"
#import "JBJsonObject.h"


@interface JBJsonWalker : NSObject {
    
    bool _continue;
    
}

-(void)walkJsonArrayDocument:(JBJsonArray*)jsonArray visitor:(id<JBJsonDocumentHandler>)visitor;
-(void)walkJsonObjectDocument:(JBJsonObject*)jsonObject visitor:(id<JBJsonDocumentHandler>)visitor;

+(void)walkJsonArrayDocument:(JBJsonArray*)jsonArray visitor:(id<JBJsonDocumentHandler>)visitor;
+(void)walkJsonObjectDocument:(JBJsonObject*)jsonObject visitor:(id<JBJsonDocumentHandler>)visitor;


@end
