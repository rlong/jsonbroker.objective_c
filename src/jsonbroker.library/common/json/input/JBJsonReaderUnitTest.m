// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBDefaultJsonHandler.h"
#import "JBJsonBuilder.h"
#import "JBJsonDataInput.h"
#import "JBJsonReader.h"
#import "JBJsonReaderUnitTest.h"
#import "JBLog.h"
#import "JBStringHelper.h"


@implementation JBJsonReaderUnitTest


static JBDefaultJsonHandler* _handler;

+(void)initialize {
    
    _handler = [[JBDefaultJsonHandler alloc] init];
}


-(void)test1 {
    Log_enteredMethod();
}



-(void)testBrokerRequest {
    
    
    NSData* data = [JBStringHelper toUtf8Data:@"[\"request\",{},\"jsonbroker.TestService\",1,0,\"ping\",{},[]]"];
    [JBJsonReader readFromData:data handler:_handler];
    
    
}


-(void)testEmptyObject {
    
    
    NSData* data = [JBStringHelper toUtf8Data:@"{}"];
    [JBJsonReader readFromData:data handler:_handler];
    
    
}

-(void)testEmptyArray {

    NSData* data = [JBStringHelper toUtf8Data:@"[]"];
    [JBJsonReader readFromData:data handler:_handler];


}

-(void)testSimpleObject {
    
    
    NSData* data = [JBStringHelper toUtf8Data:@"{\"nullKey\":null,\"booleanKey\":true,\"integerKey\":314,\"stringKey\":\"value\"}"];
    [JBJsonReader readFromData:data handler:_handler];

}

-(void)testSimpleArray {
    
    NSData* data = [JBStringHelper toUtf8Data:@"[null,true,314,\"value\"]"];
    [JBJsonReader readFromData:data handler:_handler];

}



-(NSData*)readData:(NSString*)resourceName {

    NSString *absoluteFilePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:nil];
    Log_debugString(absoluteFilePath);
    STAssertTrue(nil != absoluteFilePath, @"absoluteFilePath = %p", absoluteFilePath );

    NSData* answer = [NSData dataWithContentsOfFile:absoluteFilePath];
    return answer;
    
}

-(void)testStatusPaused {
    
    NSData* data = [self readData:@"JBJsonReaderUnitTest.testStatusPaused.json"];
    [JBJsonReader readFromData:data handler:_handler];
    
}

-(void)testStatusPlaying {

    NSData* data = [self readData:@"JBJsonReaderUnitTest.testStatusPlaying.json"];
    [JBJsonReader readFromData:data handler:_handler];

}

-(void)testStatusStopped {
    
    NSData* data = [self readData:@"JBJsonReaderUnitTest.testStatusStopped.json"];
    [JBJsonReader readFromData:data handler:_handler];
    
}



@end
