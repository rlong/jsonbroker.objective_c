// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBStringHelper.h"
#import "JBStringHelperUnitTest.h"

#import "JBLog.h"

@implementation JBStringHelperUnitTest

-(void)test1 {
    Log_enteredMethod();
}




-(void)testUnescapeHtmlCodes {

    NSString* expected = @"A & B";
    NSString* actual = [JBStringHelper unescapeHtmlCodes:@"A &#38; B"];
    XCTAssertTrue( [expected isEqualToString:actual], @"actual = %@", actual );

    expected = @"& B";
    actual = [JBStringHelper unescapeHtmlCodes:@"&#38; B"];    
    XCTAssertTrue( [expected isEqualToString:actual], @"actual = %@", actual );

    expected = @"A &";
    actual = [JBStringHelper unescapeHtmlCodes:@"A &#38;"];
    XCTAssertTrue( [expected isEqualToString:actual], @"actual = %@", actual );

    expected = @"A & B &";
    actual = [JBStringHelper unescapeHtmlCodes:@"A &#38; B &#38;"];
    XCTAssertTrue( [expected isEqualToString:actual], @"actual = %@", actual );

}
@end
