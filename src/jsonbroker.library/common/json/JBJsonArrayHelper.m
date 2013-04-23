// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJsonBuilder.h"
#import "JBJsonArrayHandler.h"
#import "JBJsonArrayHelper.h"
#import "JBJsonReader.h"
#import "JBJsonStringOutput.h"
#import "JBJsonWalker.h"
#import "JBJsonWriter.h"
#import "JBStringHelper.h"


@implementation JBJsonArrayHelper

static JBJsonArrayHandler* _jsonArrayHandler = nil;

+(void)initialize {
	
    _jsonArrayHandler = [JBJsonArrayHandler getInstance];
	
}


+(JBJsonArray*)fromString:(NSString*)input {
    
    JBJsonBuilder* builder = [[JBJsonBuilder alloc] init];
    
    @try {
        
        
        NSData* data = [JBStringHelper toUtf8Data:input];
        [JBJsonReader readFromData:data handler:builder];
        
        JBJsonArray* answer = [builder arrayDocument];
        [answer retain];
        [answer autorelease];
        return  answer;
    }
    @finally {
        [builder release];
    }
}



+(NSData*)toData:(JBJsonArray*)array {
    
    NSData* answer;
    
    JBJsonStringOutput* writer = [[JBJsonStringOutput alloc] init];
    
    @try {
        [_jsonArrayHandler writeValue:array writer:writer];
        
        NSString* json = [writer toString];
        
        answer = [JBStringHelper toUtf8Data:json];
        
    }
    @finally {
        [writer release];
    }
    
    return answer;
    
}

+(NSString*)toString:(JBJsonArray*)array {
    
    JBJsonStringOutput* output = [[JBJsonStringOutput alloc] init];
    [output autorelease];
    
    JBJsonWriter* writer = [[JBJsonWriter alloc] initWithOutput:output];
    [writer autorelease];
    
    [JBJsonWalker walkJsonArrayDocument:array visitor:writer];
    NSString* answer = [output toString];
    
    return answer;

    
}



@end
