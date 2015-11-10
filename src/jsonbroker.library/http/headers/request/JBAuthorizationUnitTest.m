// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBAuthorization.h"
#import "JBAuthorizationUnitTest.h"
#import "JBBaseException.h"

@implementation JBAuthorizationUnitTest


-(void)testBuildFromString {
	
	NSString* input = @"Digest username=\"Mufasa\", realm=\"testrealm@host.com\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", uri=\"/dir/index.html\", qop=auth, nc=00000001, cnonce=\"0a4f113b\", response=\"6629fae49393a05397450978507c4ef1\", opaque=\"5ccc069c403ebaf9f0171e9517f40e41\"";
	JBAuthorization* authorizationRequestHeader = [JBAuthorization buildFromString:input];

	STAssertTrue( [@"Mufasa" isEqualToString:[authorizationRequestHeader username]], @"actual = %@", [authorizationRequestHeader username] ); 
	STAssertTrue( [@"testrealm@host.com" isEqualToString:[authorizationRequestHeader realm]], @"actual = %@", [authorizationRequestHeader realm] ); 
	STAssertTrue( [@"dcd98b7102dd2f0e8b11d0f600bfb0c093" isEqualToString:[authorizationRequestHeader nonce]], @"actual = %@", [authorizationRequestHeader nonce] ); 
	STAssertTrue( [@"/dir/index.html" isEqualToString:[authorizationRequestHeader uri]], @"actual = %@", [authorizationRequestHeader uri] ); 
	STAssertTrue( [@"auth" isEqualToString:[authorizationRequestHeader qop]], @"actual = %@", [authorizationRequestHeader qop] ); 
	STAssertTrue( 1 == [authorizationRequestHeader nc], @"actual = %d", [authorizationRequestHeader nc] ); 	
	STAssertTrue( [@"0a4f113b" isEqualToString:[authorizationRequestHeader cnonce]], @"actual = %@", [authorizationRequestHeader cnonce] ); 
	STAssertTrue( [@"6629fae49393a05397450978507c4ef1" isEqualToString:[authorizationRequestHeader response]], @"actual = %@", [authorizationRequestHeader response] ); 
	STAssertTrue( [@"5ccc069c403ebaf9f0171e9517f40e41" isEqualToString:[authorizationRequestHeader opaque]], @"actual = %@", [authorizationRequestHeader opaque] ); 
}


-(void)testBuildFromStringWithUnkownEntries { 
	
	NSString* input = @"Digest realm=\"testrealm@host.com\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", bad-field=\"bad\", opaque=\"5ccc069c403ebaf9f0171e9517f40e41\"";
	@try {
		[JBAuthorization buildFromString:input];
		// good

	}
	@catch (BaseException * e) {
		STFail( @"'bad-field' should not have caused an exception to be thrown" );
	}
}


@end
