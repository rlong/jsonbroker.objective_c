// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBContentDisposition.h"
#import "JBContentDispositionUnitTest.h"
#import "JBLog.h"

@implementation JBContentDispositionUnitTest

-(void)test1 {
    Log_enteredMethod();
}

-(void)testMultiPartFormData {
    
    
    JBContentDisposition* contentDisposition = [JBContentDisposition buildFromString:@"form-data; name=\"datafile\"; filename=\"test.txt\""];
    STAssertTrue( [@"form-data" isEqualToString:[contentDisposition dispExtensionToken]], @"actual = '%@'", [contentDisposition dispExtensionToken]);
    
    NSString* actual = [contentDisposition getDispositionParameter:@"name" defaultValue:nil];
    STAssertTrue( [@"datafile" isEqualToString:actual], @"actual = '%@'", actual );
    
    actual = [contentDisposition getDispositionParameter:@"filename" defaultValue:nil];
    STAssertTrue( [@"test.txt" isEqualToString:actual], @"actual = '%@'", actual );
    
}


@end





