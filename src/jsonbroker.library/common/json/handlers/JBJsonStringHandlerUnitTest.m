// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJsonObject.h"
#import "JBJsonStringHandlerUnitTest.h"

#import "JBLog.h"

@implementation JBJsonStringHandlerUnitTest



-(void)test1 {
    Log_enteredMethod();
}


-(void)testHebrew {

    NSString* input = @"עולמו של יובל המבולבל.mp4";
    
    JBJsonObject* obj = [[JBJsonObject alloc] init];
    [obj setObject:input forKey:@"input"];
    
    
    NSString* objToString = [obj toString];
    Log_debugString(objToString );


    
    STAssertTrue( NSNotFound != [objToString rangeOfString:@"input"].location, @"" );
    STAssertTrue( NSNotFound != [objToString rangeOfString:@"עולמו של יובל המבולבל"].location, @"" );
    
}

@end
