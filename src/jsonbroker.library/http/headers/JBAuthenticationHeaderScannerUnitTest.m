// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBLog.h"
#import "JBAuthenticationHeaderScanner.h"
#import "JBAuthenticationHeaderScannerUnitTest.h"


@implementation JBAuthenticationHeaderScannerUnitTest

-(void)test1 {
    Log_enteredMethod();
}


-(void)testAuthenticateHeader {
	
	NSString* headerValue = @"Digest realm=\"testrealm@host.com\", qop=\"auth,auth-int\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", opaque=\"5ccc069c403ebaf9f0171e9517f40e41\"";

	JBAuthenticationHeaderScanner* scanner = [[JBAuthenticationHeaderScanner alloc] initWithHeaderValue:headerValue];

	////////////////////////////////////////////////////////////////////////////
	
	[scanner scanPastDigestString];
	
	////////////////////////////////////////////////////////////////////////////
	
	NSString* name = [scanner scanName];
	STAssertTrue( [@"realm" isEqualToString:name], @"actual = %@", name );

	NSString* value = [scanner scanQuotedValue];
	STAssertTrue( [@"testrealm@host.com" isEqualToString:value], @"actual = %@", value );

	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( [@"qop" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	STAssertTrue( [@"auth,auth-int" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( [@"nonce" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	STAssertTrue( [@"dcd98b7102dd2f0e8b11d0f600bfb0c093" isEqualToString:value], @"actual = %@", value );

	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( [@"opaque" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	STAssertTrue( [@"5ccc069c403ebaf9f0171e9517f40e41" isEqualToString:value], @"actual = %@", value );

	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( nil == name, @"actual = %p", name );
	
}

-(void)testAuthorizationHeader {
	
	NSString* headerValue = @"Digest username=\"Mufasa\", realm=\"testrealm@host.com\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", uri=\"/dir/index.html\", qop=auth, nc=00000001, cnonce=\"0a4f113b\", response=\"6629fae49393a05397450978507c4ef1\", opaque=\"5ccc069c403ebaf9f0171e9517f40e41\"";

	JBAuthenticationHeaderScanner* scanner = [[JBAuthenticationHeaderScanner alloc] initWithHeaderValue:headerValue];

	
	////////////////////////////////////////////////////////////////////////////
	
	[scanner scanPastDigestString];
	
	////////////////////////////////////////////////////////////////////////////
	
	NSString* name = [scanner scanName];
	STAssertTrue( [@"username" isEqualToString:name], @"actual = %@", name );
	
	NSString* value = [scanner scanQuotedValue];
	STAssertTrue( [@"Mufasa" isEqualToString:value], @"actual = %@", value );
	
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( [@"realm" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	STAssertTrue( [@"testrealm@host.com" isEqualToString:value], @"actual = %@", value );
	
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( [@"nonce" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	STAssertTrue( [@"dcd98b7102dd2f0e8b11d0f600bfb0c093" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( [@"uri" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	STAssertTrue( [@"/dir/index.html" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( [@"qop" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanValue];
	STAssertTrue( [@"auth" isEqualToString:value], @"actual = %@", value );
	
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( [@"nc" isEqualToString:name], @"actual = %@", name );
	
	UInt32 nc = [scanner scanHexUInt32];
	STAssertTrue( 1 == nc, @"actual = %d", nc );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( [@"cnonce" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	STAssertTrue( [@"0a4f113b" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( [@"response" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	STAssertTrue( [@"6629fae49393a05397450978507c4ef1" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( [@"opaque" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	STAssertTrue( [@"5ccc069c403ebaf9f0171e9517f40e41" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( nil == name, @"actual = %p", name );
	
	
}


-(void)testHexIntegers {
	
	NSString* headerValue = @"value00000000=00000000, value0000000a=0000000a, valueFFFFFFFF=FFFFFFFF, valueFFFFFFFFFFFF=FFFFFFFFFFFF";
	
	JBAuthenticationHeaderScanner* scanner = [[JBAuthenticationHeaderScanner alloc] initWithHeaderValue:headerValue];
	
	
	////////////////////////////////////////////////////////////////////////////
	
	NSString* name = [scanner scanName];
	STAssertTrue( [@"value00000000" isEqualToString:name], @"actual = %@", name );
	
	UInt32 value = [scanner scanHexUInt32];
	STAssertTrue( 0 == value, @"actual = %u", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	
	name = [scanner scanName];
	STAssertTrue( [@"value0000000a" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanHexUInt32];
	STAssertTrue( 10 == value, @"actual = %u", value );
	
	////////////////////////////////////////////////////////////////////////////

	name = [scanner scanName];
	STAssertTrue( [@"valueFFFFFFFF" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanHexUInt32];
	STAssertTrue( 0xFFFFFFFF == value, @"actual = %u", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( [@"valueFFFFFFFFFFFF" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanHexUInt32];
	STAssertTrue( 0 == value, @"actual = %u", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	
}

-(void)testHeaderWithNonQuotedValueAtEnd {
	NSString* headerValue = @"Digest realm=\"testrealm@host.com\", qop=auth-int"; // not a valid RFC-2617, but thats not relevant here
	
	JBAuthenticationHeaderScanner* scanner = [[JBAuthenticationHeaderScanner alloc] initWithHeaderValue:headerValue];

	////////////////////////////////////////////////////////////////////////////
	
	[scanner scanPastDigestString];
	
	////////////////////////////////////////////////////////////////////////////
	
	NSString* name = [scanner scanName];
	STAssertTrue( [@"realm" isEqualToString:name], @"actual = %@", name );
	
	NSString* value = [scanner scanQuotedValue];
	STAssertTrue( [@"testrealm@host.com" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////

	
	name = [scanner scanName];
	STAssertTrue( [@"qop" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	STAssertTrue( [@"auth-int" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	
	
	
}


-(void)testHeaderWithHexIntegerAtEnd {
	NSString* headerValue = @"Digest realm=\"testrealm@host.com\", nc=0000000a"; // not a valid RFC-2617, but thats not relevant here
	
	JBAuthenticationHeaderScanner* scanner = [[JBAuthenticationHeaderScanner alloc] initWithHeaderValue:headerValue];
	
	////////////////////////////////////////////////////////////////////////////
	
	[scanner scanPastDigestString];
	
	////////////////////////////////////////////////////////////////////////////
	
	NSString* name = [scanner scanName];
	STAssertTrue( [@"realm" isEqualToString:name], @"actual = %@", name );
	
	NSString* value = [scanner scanQuotedValue];
	STAssertTrue( [@"testrealm@host.com" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	
	name = [scanner scanName];
	STAssertTrue( [@"nc" isEqualToString:name], @"actual = %@", name );
	
	UInt32 nc = [scanner scanHexUInt32];
	STAssertTrue( 10 == nc, @"actual = %u", nc );

	////////////////////////////////////////////////////////////////////////////
	
}


-(void)testRealm1 {
	
	NSString* headerValue = @"Digest realm=\"users@al's computer\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\"";
	
	JBAuthenticationHeaderScanner* scanner = [[JBAuthenticationHeaderScanner alloc] initWithHeaderValue:headerValue];
	
	
	////////////////////////////////////////////////////////////////////////////
	
	[scanner scanPastDigestString];
	
	////////////////////////////////////////////////////////////////////////////
	
	NSString* name = [scanner scanName];
	STAssertTrue( [@"realm" isEqualToString:name], @"actual = %@", name );
	
	NSString* value = [scanner scanQuotedValue];
	STAssertTrue( [@"users@al's computer" isEqualToString:value], @"actual = %@", value );
	
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	STAssertTrue( [@"nonce" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	STAssertTrue( [@"dcd98b7102dd2f0e8b11d0f600bfb0c093" isEqualToString:value], @"actual = %@", value );
	
}

@end
