// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBAuthenticationHeaderScannerUnitTest.h"
#import "JBAuthenticationInfoUnitTest.h"
#import "JBAuthorizationUnitTest.h"
#import "JBBaseExceptionUnitTest.h"
#import "JBContentDispositionUnitTest.h"
#import "JBDateTimeUtilitiesUnitTest.h"
#import "JBFaultSerializerUnitTest.h"
#import "JBJsonReaderUnitTest.h"
#import "JBJsonStringHandlerUnitTest.h"
#import "JBJsonWriterUnitTest.h"
#import "JBLog.h"
#import "JBMediaTypeUnitTest.h"
#import "JBMetaProxyIntegrationTest.h"
#import "JBMultiPartReaderUnitTest.h"
#import "JBNumericUtilitiesUnitTest.h"
#import "JBRangeUnitTest.h"
#import "JBSecurityUtilitiesUnitTest.h"
#import "JBStringHelperUnitTest.h"
#import "JBUnitTestRunner.h"
#import "JBWwwAuthenticateUnitTest.h"




#import "JBKeychainUtilitiesIntegrationTest.h"
#import "JBTestServiceIntegrationTest.h"

@implementation JBUnitTestRunner




+(void)run { 
    
    Log_enteredMethod();
    
    [SenTestObserver class];
    
    
    SenTestSuite *suite = [SenTestSuite testSuiteForTestCaseClass:[JBUnitTestRunner class]];
    
    if( NO ) {
        
 
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBAuthenticationHeaderScannerUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBAuthenticationInfoUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBAuthorizationUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBBaseExceptionUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBContentDispositionUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBDateTimeUtilitiesUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBFaultSerializerUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBJsonReaderUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBJsonStringHandlerUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBJsonWriterUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBMediaTypeUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBMultiPartReaderUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBNumericUtilitiesUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBRangeUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBSecurityUtilitiesUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBStringHelperUnitTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBWwwAuthenticateUnitTest class]]];

        
    }
    
    if( NO ) {
        
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBJsonWriterUnitTest class]]];
        
    }
    
    if( YES ) {
        
        suite= [SenTestSuite testSuiteWithName:@"JBUnitTestRunner"];
        
        id test;
        {
            // 
            test = [JBJsonWriterUnitTest testCaseWithSelector:@selector(testBrokerMessage)];
        }
        
        
        [suite addTest:test];
        
    }
    
    [suite run];
}


@end
