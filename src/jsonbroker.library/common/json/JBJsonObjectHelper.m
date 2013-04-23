// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBJsonBuilder.h"
#import "JBJsonObjectHelper.h"
#import "JBJsonReader.h"
#import "JBStringHelper.h"

@implementation JBJsonObjectHelper




+(JBJsonObject*)buildFromString:(NSString*)jsonString {
    
    
    NSData* jsonData = [JBStringHelper toUtf8Data:jsonString];
    
    JBJsonBuilder* builder = [[JBJsonBuilder alloc] init];
    [builder autorelease];
    
    [JBJsonReader readFromData:jsonData handler:builder];
    
    return [builder objectDocument];

    
}

@end
