// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBRange.h"
#import "JBRangeUnitTest.h"

#import "JBLog.h"

@implementation JBRangeUnitTest 


-(void)test1 {
    
    Log_enteredMethod();
    
    
}


// from http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35.1 
-(void)testHyphen500 {
    
    JBRange* range = [JBRange buildFromString:@"bytes=-500"];
    
    XCTAssertEqual( -500, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    XCTAssertNil( [range lastBytePosition], @"actual = %p", [range lastBytePosition]);
    
    XCTAssertTrue( [@"bytes 9500-9999/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    XCTAssertEqual( 9500l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    XCTAssertEqual( 500l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );
    
}


// from http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35.1
-(void)test9500Hyphen {
    
    JBRange* range = [JBRange buildFromString:@"bytes=9500-"];
    
    XCTAssertEqual( 9500, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    XCTAssertNil( [range lastBytePosition], @"actual = %p", [range lastBytePosition]);

    XCTAssertTrue( [@"bytes 9500-9999/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    XCTAssertEqual( 9500l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    XCTAssertEqual( 500l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );

}


// from http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35.1
-(void)test500to999 {

    JBRange* range = [JBRange buildFromString:@"bytes=500-999"];
    
    XCTAssertEqual( 500, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    XCTAssertEqual( 999, [[range lastBytePosition] intValue], @"actual = %d", [[range lastBytePosition] intValue]);

    XCTAssertTrue( [@"bytes 500-999/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    XCTAssertEqual( 500l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    XCTAssertEqual( 500l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );

}

-(void)test0Hyphen499 {
    JBRange* range = [JBRange buildFromString:@"bytes=0-499"];
    
    XCTAssertEqual( 0, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    XCTAssertEqual( 499, [[range lastBytePosition] intValue], @"actual = %d", [[range lastBytePosition] intValue]);

    XCTAssertTrue( [@"bytes 0-499/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    XCTAssertEqual( 0l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    XCTAssertEqual( 500l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );


}

-(void)test0Hyphen {
    JBRange* range = [JBRange buildFromString:@"bytes=0-"];
    
    XCTAssertEqual( 0, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    XCTAssertNil( [range lastBytePosition], @"actual = %p", [range lastBytePosition]);
    
    XCTAssertTrue( [@"bytes 0-9999/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    XCTAssertEqual( 0l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    XCTAssertEqual( 10000l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );

}

-(void)test0Hyphen1 {
    JBRange* range = [JBRange buildFromString:@"bytes=0-1"];
    
    XCTAssertEqual( 0, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    XCTAssertEqual( 1, [[range lastBytePosition] intValue], @"actual = %d", [[range lastBytePosition] intValue]);
    
    XCTAssertTrue( [@"bytes 0-1/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    XCTAssertEqual( 0l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    XCTAssertEqual( 2l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );
    
}


-(void)test0Hyphen0 {
    JBRange* range = [JBRange buildFromString:@"bytes=0-0"];
    
    XCTAssertEqual( 0, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    XCTAssertEqual( 0, [[range lastBytePosition] intValue], @"actual = %d", [[range lastBytePosition] intValue]);
    
    XCTAssertTrue( [@"bytes 0-0/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    XCTAssertEqual( 0l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    XCTAssertEqual( 1l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );
    
}

-(void)test0Hyphen9999 {
    JBRange* range = [JBRange buildFromString:@"bytes=0-9999"];
    
    XCTAssertEqual( 0, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    XCTAssertEqual( 9999, [[range lastBytePosition] intValue], @"actual = %d", [[range lastBytePosition] intValue]);
    
    XCTAssertTrue( [@"bytes 0-9999/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    XCTAssertEqual( 0l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    XCTAssertEqual( 10000l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );
    
}


-(void)testBadRange1 {

    @try {
        [JBRange buildFromString:@"bytes=1-2-3"];
        XCTAssertTrue( false, @"exception expected", 0);
    }
    @catch (BaseException *exception) {
        // good
    }

}

-(void)testUnhandledRange1 {
    @try {
        Log_info( @"valid but unhandled scenario" );
        
        // from http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35.1
        [JBRange buildFromString:@"bytes=0-0,-1"];
        XCTAssertTrue( false, @"exception expected");
        
    }
    @catch (BaseException *exception) {
        // good
    }
}

@end
