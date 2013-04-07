// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBKeychainUtilitiesIntegrationTest.h"

#import "JBGethostbyaddrRequestIntegrationTest.h"
#import "JBIntegrationTestRunner.h"
#import "JBMetaProxyIntegrationTest.h"
#import "JBNetworkUtilitiesIntegrationTest.h"
#import "JBTestServiceIntegrationTest.h"


#import "JBLog.h"

@implementation JBIntegrationTestRunner


+(void)run {
    
    Log_enteredMethod();
    
    [SenTestObserver class];
    
    SenTestSuite *suite = [SenTestSuite testSuiteForTestCaseClass:[JBIntegrationTestRunner class]];
    
    if( NO ) {
        

        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBGethostbyaddrRequestIntegrationTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBMetaProxyIntegrationTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBNetworkUtilitiesIntegrationTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBKeychainUtilitiesIntegrationTest class]]];
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBTestServiceIntegrationTest class]]];
        
        
    }
    
    if( NO ) {
        
        [suite addTest: [SenTestSuite testSuiteForTestCaseClass:[JBTestServiceIntegrationTest class]]];
        
    }
    
    if( YES ) {
        
        suite= [SenTestSuite testSuiteWithName:@"JBIntegrationTestRunner"];
        
        id test;
        {
            test = [JBNetworkUtilitiesIntegrationTest testCaseWithSelector:@selector(testGetWifiNetworkName)];
        }
        
        
        [suite addTest:test];
        
    }
    
    [suite run];
}


@end
