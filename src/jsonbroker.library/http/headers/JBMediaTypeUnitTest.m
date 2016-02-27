// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBLog.h"
#import "JBMediaType.h"
#import "JBMediaTypeUnitTest.h"


@implementation JBMediaTypeUnitTest


-(void)test1 {
    Log_enteredMethod();
}

-(void)testMultiPartFormData {
    
    
    JBMediaType* mediaType = [JBMediaType buildFromString:@"multipart/form-data; boundary=---------------------------114782935826962"];
    XCTAssertTrue( [@"multipart" isEqualToString:[mediaType type]], @"actual = '%@'", [mediaType type]);
    XCTAssertTrue( [@"form-data" isEqualToString:[mediaType subtype]], @"actual = '%@'", [mediaType subtype]);

    NSString* actualBoundary = [mediaType getParameterValue:@"boundary" defaultValue:nil];
    XCTAssertTrue( [@"---------------------------114782935826962" isEqualToString:actualBoundary], @"actual = '%@'", actualBoundary );
    
    
    
    
}


-(void)testTextPlain  {

    JBMediaType* mediaType = [JBMediaType buildFromString:@"text/plain"];
    XCTAssertTrue( [@"text" isEqualToString:[mediaType type]], @"actual = '%@'", [mediaType type]);
    XCTAssertTrue( [@"plain" isEqualToString:[mediaType subtype]], @"actual = '%@'", [mediaType subtype]);

    
}


-(void)testApplicationXZipCompresssed {
    

    JBMediaType* mediaType = [JBMediaType buildFromString:@"application/x-zip-compressed"];
    XCTAssertTrue( [@"application" isEqualToString:[mediaType type]], @"actual = '%@'", [mediaType type]);
    XCTAssertTrue( [@"x-zip-compressed" isEqualToString:[mediaType subtype]], @"actual = '%@'", [mediaType subtype]);

    
}
@end
