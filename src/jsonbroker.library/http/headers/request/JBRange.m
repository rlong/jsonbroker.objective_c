// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBLog.h"
#import "JBNumericUtilities.h"
#import "JBRange.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBRange () 

-(id)initWithValue:(NSString*)value;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBRange


+(JBRange*)buildFromString:(NSString*)value { 
    
    JBRange* answer = [[JBRange alloc] initWithValue:value];
    
    
    NSRange rangeOfBytes = [value rangeOfString:@"bytes="];
    
    if( 0 != rangeOfBytes.location ) { 
        NSString* technicalError = [NSString stringWithFormat:@"0 != rangeOfBytes.location; value = '%@'", value];
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        @throw e;
        
    }
    
    NSString* range = [value substringFromIndex:rangeOfBytes.length];

    NSRange firstHyphen = [range rangeOfString:@"-"];
    if( NSNotFound == firstHyphen.location ) { 
        NSString* technicalError = [NSString stringWithFormat:@"NSNotFound == firstHyphen.location; value = '%@'", value];
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        @throw e;
    }
    
    NSRange lastHyphen = [range rangeOfString:@"-" options:NSBackwardsSearch];
    
    if( firstHyphen.location != lastHyphen.location ) { 
        NSString* technicalError = [NSString stringWithFormat:@"firstHyphen.location != lastHyphen.location; value = '%@'", value];
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        @throw e;
    }
    
    
    // "bytes=-500"
    if( 0 == firstHyphen.location ) { 
        
        // we record the first byte position as a negative number deliberately ...
        [answer setFirstBytePosition:[JBNumericUtilities parseLongObject:range]];
         
         // leave _lastBytePosition as null;
         return answer;
        
    }
    
    // "bytes=9500-"
    long rangeLength = [range length];
    if( '-' == [range characterAtIndex:(rangeLength-1)] ) { 
        
        // trim off the trailing hyphen ... 
        range = [range substringToIndex:(rangeLength-1)];

        [answer setFirstBytePosition:[JBNumericUtilities parseLongObject:range]];
        
        // leave _lastBytePosition as null;
        return answer;

    }
    
    
    // "bytes=500-999" 
    NSString* startPosition = [range substringToIndex:firstHyphen.location];
    [answer setFirstBytePosition:[JBNumericUtilities parseLongObject:startPosition]];
    
    NSString* endPosition = [range substringFromIndex:firstHyphen.location+1];
    [answer setLastBytePosition:[JBNumericUtilities parseLongObject:endPosition]];
    
    return answer;
                              
    
}



-(NSString*)toContentRange:(unsigned long long)entityContentLength {
    
    // http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.16
    long long firstBytePosition = 0;
    if( nil != _firstBytePosition ) { 
        firstBytePosition = [_firstBytePosition longValue];
        
        // negative firstBytePosition is an offset from the end of the entityContentLength
        if( 0 > firstBytePosition ) {
            firstBytePosition  = entityContentLength + firstBytePosition;
        }
    }
    
    // http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.16
    unsigned long long lastBytePosition = entityContentLength-1;
    if( nil != _lastBytePosition ) {
        lastBytePosition = [_lastBytePosition longValue];
    }
    
    NSString* answer = [NSString stringWithFormat: @"bytes %llu-%llu/%llu", firstBytePosition, lastBytePosition, entityContentLength];
    return answer;
    
}

-(unsigned long long)getSeekPosition:(unsigned long long)entityContentLength { 
    
    long long firstBytePosition = 0;
    if( nil != _firstBytePosition ) {
        firstBytePosition = [_firstBytePosition longValue];
        
        // negative firstBytePosition is an offset from the end of the entityContentLength
        if( 0 > firstBytePosition ) {
            firstBytePosition  = entityContentLength + firstBytePosition;
        }
    }
    
    long long answer = firstBytePosition;
    return answer;
    
}

-(unsigned long long)getContentLength:(unsigned long long)entityContentLength {

    long long firstBytePosition = 0;
    if( nil != _firstBytePosition ) {
        firstBytePosition = [_firstBytePosition longValue];
        
        // negative firstBytePosition is an offset from the end of the entityContentLength
        if( 0 > firstBytePosition ) {
            firstBytePosition  = entityContentLength + firstBytePosition;
        }
    }
    
    unsigned long long lastBytePosition = entityContentLength;
    if( nil != _lastBytePosition ) {
        
        lastBytePosition = [_lastBytePosition longValue];
        
        // vvv http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35.1
        
        // The last-byte-pos value gives the byte-offset of the last byte in the range; 
        // that is, the byte positions specified are inclusive
        
        // ^^^ http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35.1
        
        // so ... 
        lastBytePosition++;
    }
    
    unsigned long long answer = lastBytePosition - firstBytePosition;
    return answer;


}



#pragma mark instance lifecycle

-(id)initWithValue:(NSString*)value { 
    
    
    JBRange* answer = [super init];
    
    answer->_toString = value;
    
    return answer;
    
}

-(void)dealloc {
	
	[self setFirstBytePosition:nil];
    [self setLastBytePosition:nil];
    
    if( nil != _toString ) { 
    }
    _toString = nil;
	
}



#pragma mark fields


////////////////////////////////////////////////////////////////////////////
// http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35
// firstBytePosition
//NSNumber* _firstBytePosition;
//@property (nonatomic, retain) NSNumber* firstBytePosition;
@synthesize firstBytePosition = _firstBytePosition;

////////////////////////////////////////////////////////////////////////////
// http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35
// lastBytePosition
//NSNumber* _lastBytePosition;
//@property (nonatomic, retain) NSNumber* lastBytePosition;
@synthesize lastBytePosition = _lastBytePosition;


// toString
//NSString* _toString;
//@property (nonatomic, readonly) NSString* toString;
@synthesize toString = _toString;


@end
