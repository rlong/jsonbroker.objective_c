//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <CommonCrypto/CommonDigest.h>

#import "JBLog.h"
#import "JBSecurityUtilities.h"
#import "JBSecurityUtilitiesUnitTest.h"


@implementation JBSecurityUtilitiesUnitTest

-(void)testMd5HashOfData {
	
	NSString* stringInput = @"Mufasa:testrealm@host.com:Circle Of Life";
	NSData* input = [stringInput dataUsingEncoding:NSUTF8StringEncoding];
	NSString* response = [JBSecurityUtilities md5HashOfData:input];
	STAssertTrue( [@"939e7578ed9e3c518a452acee763bce9" isEqualToString:response], @"actual = %@", response );

	stringInput = @"GET:/dir/index.html";
	input = [stringInput dataUsingEncoding:NSUTF8StringEncoding];
	response = [JBSecurityUtilities md5HashOfData:input];
	STAssertTrue( [@"39aff3a2bab6126f332b942af96d3366" isEqualToString:response], @"actual = %@", response );

	stringInput = @"939e7578ed9e3c518a452acee763bce9:dcd98b7102dd2f0e8b11d0f600bfb0c093:00000001:0a4f113b:auth:39aff3a2bab6126f332b942af96d3366";
	input = [stringInput dataUsingEncoding:NSUTF8StringEncoding];
	response = [JBSecurityUtilities md5HashOfData:input];
	STAssertTrue( [@"6629fae49393a05397450978507c4ef1" isEqualToString:response], @"actual = %@", response );
	
}

-(void)testMd5HashOfString {
	
	NSString* input = @"Mufasa:testrealm@host.com:Circle Of Life";
	NSString* response = [JBSecurityUtilities md5HashOfString:input];
	STAssertTrue( [@"939e7578ed9e3c518a452acee763bce9" isEqualToString:response], @"actual = %@", response );
	

	input = @"GET:/dir/index.html";
	response = [JBSecurityUtilities md5HashOfString:input];
	STAssertTrue( [@"39aff3a2bab6126f332b942af96d3366" isEqualToString:response], @"actual = %@", response );
	

	input = @"939e7578ed9e3c518a452acee763bce9:dcd98b7102dd2f0e8b11d0f600bfb0c093:00000001:0a4f113b:auth:39aff3a2bab6126f332b942af96d3366";
	response = [JBSecurityUtilities md5HashOfString:input];
	STAssertTrue( [@"6629fae49393a05397450978507c4ef1" isEqualToString:response], @"actual = %@", response );
}

-(void)testGenerateNonce {
	// not a real test ... just exercising the functionality
	
	NSString* nonce = [JBSecurityUtilities generateNonce];
    Log_debugString(nonce);
}

@end
