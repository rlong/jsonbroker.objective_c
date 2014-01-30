// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//




#import "JBJsonObject.h"
#import "JBStringHelper.h"
#import "JBJsonDataInput.h"
#import "JBJsonStringOutput.h"
#import "JBJsonStringHandler.h"
#import "JBJsonStringHandlerUnitTest.h"

#import "JBLog.h"

@implementation JBJsonStringHandlerUnitTest



-(void)test1 {
    Log_enteredMethod();
}




-(NSString*)encodeJsonStringValue:(NSString*)input {
    
    
    
    JBJsonStringOutput* output = [[JBJsonStringOutput alloc] init];
    [output autorelease];
    
    
    JBJsonStringHandler* handler = [JBJsonStringHandler getInstance];
    
    
    [handler writeValue:input writer:output];
    
    return [output toString];
    
}


-(NSString*)decodeJsonStringValue:(NSString*)input {
    
    
    NSData* data = [JBStringHelper toUtf8Data:input];
    
    
    JBJsonDataInput* jsonDataInput = [[JBJsonDataInput alloc] initWithData:data];
    [jsonDataInput autorelease];
    
    NSString* answer = [JBJsonStringHandler readString:jsonDataInput];
    
    return answer;
    
    
}

-(void)testWriteABC {
    
    Log_enteredMethod();
    
    NSString* actual = [self encodeJsonStringValue:@"ABC"];
    
    STAssertTrue( [@"\"ABC\"" isEqualToString:actual], @"actual = '%@'", actual );
    
}

-(void)testReadABC {

    Log_enteredMethod();
    
    NSString* actual = [self decodeJsonStringValue:@"\"ABC\""];
    STAssertTrue( [@"ABC" isEqualToString:actual], @"actual = '%@'", actual );
    
    
}


-(void)testReadWriteSlashes {
    
    Log_enteredMethod();
    
    
    {
        NSString* encodedValue = [self encodeJsonStringValue:@"\\"];
        STAssertTrue( [@"\"\\\\\"" isEqualToString:encodedValue], @"encodedValue = '%@'", encodedValue );
        NSString* decodedValue = [self decodeJsonStringValue:encodedValue];
        STAssertTrue( [@"\\" isEqualToString:decodedValue], @"decodedValue = '%@'", decodedValue );
    }

    
    {
        NSString* encodedValue = [self encodeJsonStringValue:@"/"];
        STAssertTrue( [@"\"\\/\"" isEqualToString:encodedValue], @"encodedValue = '%@'", encodedValue );
        NSString* decodedValue = [self decodeJsonStringValue:encodedValue];
        STAssertTrue( [@"/" isEqualToString:decodedValue], @"decodedValue = '%@'", decodedValue );
    }

    
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
