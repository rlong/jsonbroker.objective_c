// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBFileUtilities.h"
#import "JBJsonBuilder.h"
#import "JBJsonObject.h"
#import "JBJsonObjectHelper.h"
#import "JBJsonReader.h"
#import "JBLog.h"
#import "JBStringHelper.h"

@implementation JBJsonObjectHelper




// can return nil
+(JBJsonObject*)fromFile:(NSString*)path {
    
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
    
    return [builder objectDocument];
    
    
}


+(JBJsonObject*)buildFromData:(NSData*)jsonData {
    

    JBJsonBuilder* builder = [[JBJsonBuilder alloc] init];
    
    [JBJsonReader readFromData:jsonData handler:builder];
    
    return [builder objectDocument];
    
}


+(JBJsonObject*)buildFromString:(NSString*)jsonString {
    
    
    NSData* jsonData = [JBStringHelper toUtf8Data:jsonString];
    return [self buildFromData:jsonData];
    
    
}



+(void)write:(JBJsonObject*)object toFile:(NSString*)path {
    
    NSString* objectText = [object toString];
    
    NSError* error = nil;
    
    [objectText writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if( nil != error ) {
        
        JBBaseException* e = [JBBaseException baseExceptionWithOriginator:self line:__LINE__ callTo:@"[NSString writeToFile:atomically:encoding:error:]" failedWithError:error];
        [e addStringContext:path withName:@"path"];
        @throw e;
        
    }
    
}



@end
