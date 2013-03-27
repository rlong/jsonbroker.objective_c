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
    
    STAssertEquals( -500, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    STAssertNil( [range lastBytePosition], @"actual = %p", [range lastBytePosition]);
    
    STAssertTrue( [@"bytes 9500-9999/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    STAssertEquals( 9500l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    STAssertEquals( 500l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );
    
}


// from http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35.1
-(void)test9500Hyphen {
    
    JBRange* range = [JBRange buildFromString:@"bytes=9500-"];
    
    STAssertEquals( 9500, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    STAssertNil( [range lastBytePosition], @"actual = %p", [range lastBytePosition]);

    STAssertTrue( [@"bytes 9500-9999/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    STAssertEquals( 9500l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    STAssertEquals( 500l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );

}


// from http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35.1
-(void)test500to999 {

    JBRange* range = [JBRange buildFromString:@"bytes=500-999"];
    
    STAssertEquals( 500, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    STAssertEquals( 999, [[range lastBytePosition] intValue], @"actual = %d", [[range lastBytePosition] intValue]);

    STAssertTrue( [@"bytes 500-999/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    STAssertEquals( 500l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    STAssertEquals( 500l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );

}

-(void)test0Hyphen499 {
    JBRange* range = [JBRange buildFromString:@"bytes=0-499"];
    
    STAssertEquals( 0, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    STAssertEquals( 499, [[range lastBytePosition] intValue], @"actual = %d", [[range lastBytePosition] intValue]);

    STAssertTrue( [@"bytes 0-499/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    STAssertEquals( 0l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    STAssertEquals( 500l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );


}

-(void)test0Hyphen {
    JBRange* range = [JBRange buildFromString:@"bytes=0-"];
    
    STAssertEquals( 0, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    STAssertNil( [range lastBytePosition], @"actual = %p", [range lastBytePosition]);
    
    STAssertTrue( [@"bytes 0-9999/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    STAssertEquals( 0l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    STAssertEquals( 10000l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );

}

-(void)test0Hyphen1 {
    JBRange* range = [JBRange buildFromString:@"bytes=0-1"];
    
    STAssertEquals( 0, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    STAssertEquals( 1, [[range lastBytePosition] intValue], @"actual = %d", [[range lastBytePosition] intValue]);
    
    STAssertTrue( [@"bytes 0-1/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    STAssertEquals( 0l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    STAssertEquals( 2l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );
    
}


-(void)test0Hyphen0 {
    JBRange* range = [JBRange buildFromString:@"bytes=0-0"];
    
    STAssertEquals( 0, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    STAssertEquals( 0, [[range lastBytePosition] intValue], @"actual = %d", [[range lastBytePosition] intValue]);
    
    STAssertTrue( [@"bytes 0-0/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    STAssertEquals( 0l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    STAssertEquals( 1l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );
    
}

-(void)test0Hyphen9999 {
    JBRange* range = [JBRange buildFromString:@"bytes=0-9999"];
    
    STAssertEquals( 0, [[range firstBytePosition] intValue], @"actual = %d", [[range firstBytePosition] intValue]);
    STAssertEquals( 9999, [[range lastBytePosition] intValue], @"actual = %d", [[range lastBytePosition] intValue]);
    
    STAssertTrue( [@"bytes 0-9999/10000" isEqualToString:[range toContentRange:10000]], @"actual = '%@'", [range toContentRange:10000] );
    STAssertEquals( 0l, [range getSeekPosition:10000], @"actual = %ld", [range getSeekPosition:10000] );
    STAssertEquals( 10000l, [range getContentLength:10000], @"actual = %ld", [range getContentLength:10000] );
    
}


-(void)testBadRange1 {

    @try {
        [JBRange buildFromString:@"bytes=1-2-3"];
        STAssertTrue( false, @"exception expected", 0);
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
        STAssertTrue( false, @"exception expected");
        
    }
    @catch (BaseException *exception) {
        // good
    }
}

@end
