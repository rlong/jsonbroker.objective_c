// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBAuthenticationInfo.h"
#import "JBAuthenticationInfoUnitTest.h"
#import "JBBaseException.h"

#import "JBLog.h"

@implementation JBAuthenticationInfoUnitTest



-(void)testBuildFromString {
	
	NSString* input = @"cnonce=\"0a4f113b\", nc=000000FF, nextnonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", qop=auth-int, rspauth=\"6629fae49393a05397450978507c4ef1\"";
	
	JBAuthenticationInfo* authenticationInfoHeader = [JBAuthenticationInfo buildFromString:input];
	
	STAssertTrue( [@"0a4f113b" isEqualToString:[authenticationInfoHeader cnonce]], @"actual = %@", [authenticationInfoHeader cnonce] ); 
	STAssertTrue( 255 == [authenticationInfoHeader nc], @"actual = %d", [authenticationInfoHeader nc] ); 
	STAssertTrue( [@"dcd98b7102dd2f0e8b11d0f600bfb0c093" isEqualToString:[authenticationInfoHeader nextnonce]], @"actual = %@", [authenticationInfoHeader nextnonce] ); 
	STAssertTrue( [@"auth-int" isEqualToString:[authenticationInfoHeader qop]], @"actual = %@", [authenticationInfoHeader qop] ); 
	STAssertTrue( [@"6629fae49393a05397450978507c4ef1" isEqualToString:[authenticationInfoHeader rspauth]], @"actual = %@", [authenticationInfoHeader rspauth] ); 
    
    
    Log_debugString([authenticationInfoHeader toString] );
	
	
}

-(void)testBuildFromStringWithUnkownEntries { 

	NSString* input = @"nextnonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", bad-field=\"bad\"";

	@try {
		[JBAuthenticationInfo buildFromString:input];
		// good
	}
	@catch (BaseException * e) {
		STFail( @"'bad-field' should not have caused an exception to be thrown" );
	}
}

@end
