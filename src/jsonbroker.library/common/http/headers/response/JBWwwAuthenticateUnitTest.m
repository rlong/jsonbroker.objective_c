// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBWwwAuthenticate.h"
#import "JBWwwAuthenticateUnitTest.h"
#import "JBBaseException.h"


@implementation JBWwwAuthenticateUnitTest


-(void)testBuildFromString {
	
	NSString* input = @"Digest realm=\"testrealm@host.com\", qop=\"auth,auth-int\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", opaque=\"5ccc069c403ebaf9f0171e9517f40e41\"";
	
	JBWwwAuthenticate* authenticateResponseHeader = [JBWwwAuthenticate buildFromString:input];
	STAssertTrue( [@"dcd98b7102dd2f0e8b11d0f600bfb0c093" isEqualToString:[authenticateResponseHeader nonce]], @"actual = %@", [authenticateResponseHeader nonce] ); 
	STAssertTrue( [@"5ccc069c403ebaf9f0171e9517f40e41" isEqualToString:[authenticateResponseHeader opaque]], @"actual = %@", [authenticateResponseHeader opaque] ); 
	STAssertTrue( [@"auth,auth-int" isEqualToString:[authenticateResponseHeader qop]], @"actual = %@", [authenticateResponseHeader qop] ); 
	STAssertTrue( [@"testrealm@host.com" isEqualToString:[authenticateResponseHeader realm]], @"actual = %@", [authenticateResponseHeader realm] ); 
}

-(void)testBuildFromStringWithUnkownEntries { 
	
	NSString* input = @"Digest realm=\"testrealm@host.com\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", bad-field=\"bad\", opaque=\"5ccc069c403ebaf9f0171e9517f40e41\"";
	@try {
		[JBWwwAuthenticate buildFromString:input];
		// good
	}
	@catch (BaseException * e) {
        
		STFail( @"'bad-field' should not have caused an exception to be thrown", 0);
	}
}
@end
