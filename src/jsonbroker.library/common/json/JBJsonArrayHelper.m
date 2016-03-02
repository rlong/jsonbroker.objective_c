// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBJsonBuilder.h"
#import "JBJsonArrayHandler.h"
#import "JBJsonArrayHelper.h"
#import "JBFileUtilities.h"
#import "JBJsonReader.h"
#import "JBJsonStringOutput.h"
#import "JBJsonWalker.h"
#import "JBJsonWriter.h"
#import "JBLog.h"
#import "JBStringHelper.h"


@implementation JBJsonArrayHelper

static JBJsonArrayHandler* _jsonArrayHandler = nil;

+(void)initialize {
	
    _jsonArrayHandler = [JBJsonArrayHandler getInstance];
	
}



// can return nil
+(JBJsonArray*)fromFile:(NSString*)path {
    
    if( ![JBFileUtilities fileExistsAtPath:path] ) {
        return nil;
    }
    
    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    
    if( nil == jsonData ) {
        Log_warnFormat(@"nil == jsonData; path = '%@'", path);
        return nil;
    }
    
    JBJsonBuilder* builder = [[JBJsonBuilder alloc] init];
    
    [JBJsonReader readFromData:jsonData handler:builder];
    
    return [builder arrayDocument];
    
    
}


+(JBJsonArray*)fromString:(NSString*)input {
    
    JBJsonBuilder* builder = [[JBJsonBuilder alloc] init];
    
    @try {
        
        
        NSData* data = [JBStringHelper toUtf8Data:input];
        [JBJsonReader readFromData:data handler:builder];
        
        JBJsonArray* answer = [builder arrayDocument];
        return  answer;
    }
    @finally {
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
    }
    
    return answer;
    
}

+(NSString*)toString:(JBJsonArray*)array {
    
    JBJsonStringOutput* output = [[JBJsonStringOutput alloc] init];
    
    JBJsonWriter* writer = [[JBJsonWriter alloc] initWithOutput:output];
    
    [JBJsonWalker walkJsonArrayDocument:array visitor:writer];
    NSString* answer = [output toString];
    
    return answer;

    
}


+(void)write:(JBJsonArray*)array toFile:(NSString*)path {
    
    NSString* arrayText = [array toString];
    
    NSError* error = nil;

    [arrayText writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if( nil != error ) {
        
        JBBaseException* e = [JBBaseException baseExceptionWithOriginator:self line:__LINE__ callTo:@"[NSString writeToFile:atomically:encoding:error:]" failedWithError:error];
        [e addStringContext:path withName:@"path"];
        @throw e;


    }
    
}


@end
