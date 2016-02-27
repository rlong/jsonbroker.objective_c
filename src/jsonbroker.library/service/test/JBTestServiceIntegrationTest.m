//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBIntegrationTestUtilities.h"
#import "JBTestService.h"
#import "JBTestServiceIntegrationTest.h"
#import "JBTestProxy.h"

#import "JBLog.h"

@implementation JBTestServiceIntegrationTest



-(void)test1 {
    
    Log_enteredMethod();
}


-(JBTestProxy*)buildProxy {

    JBTestService* testService = [[JBTestService alloc] init];
    [testService autorelease];
    
    id<JBService> service = [[JBIntegrationTestUtilities getInXCTAnce] wrapService:testService];
    
    JBTestProxy* answer = [[JBTestProxy alloc] initWithService:service];
    [answer autorelease];
    
    return answer;

}

-(void)testPing {

    JBTestProxy* proxy = [self buildProxy];
    [proxy ping];
}


-(void)testRaiseError { 
    
    Log_enteredMethod();
    
    JBTestProxy* proxy = [self buildProxy];
    {
        @try {
            [proxy raiseError];
            XCTFail( @"'BaseException' should have been thrown, %d",0);
        }
        @catch (BaseException *exception) {
            NSString* actual = [exception errorDomain];
            XCTAssertTrue( [@"jsonbroker.TestService.RAISE_ERROR" isEqualToString:actual], @"actual = '%@'", actual);
            
        }
    }
    
}


//#define SOAK_TEST
#ifdef SOAK_TEST

-(void)testSoak {
    
    Log_enteredMethod();
    
    TestProxy* proxy = [self buildProxy];

    
    for( int i = 0; i < 1024; i++ )  {
        
        if( 0 == i%10) {
            Log_debugInt( i );
        }
        
        @try {
            [proxy ping];
        }
        @catch (BaseException *exception) {
            Log_warnInt( [exception faultCode] );
        }
    }
}

#endif


@end
