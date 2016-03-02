// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBDelimiterDetector.h"
#import "JBDelimiterFound.h"
#import "JBLog.h"
#import "JBMultiPartReader.h"
#import "JBPartialDelimiterMatched.h"



#import "JBStringHelper.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBMultiPartReader ()


// boundary
//NSString* _boundary;
@property (nonatomic, retain) NSString* boundary;
//@synthesize boundary = _boundary;


// content
//NSInputStream* _content;
@property (nonatomic, retain) NSInputStream* content;
//@synthesize content = _content;



@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


/// <summary>
///
/// as per http://www.w3.org/Protocols/rfc1341/7_2_Multipart.html
/// </summary>
@implementation JBMultiPartReader

#define _BUFFER_SIZE 8 * 1024

const UInt8 _CARRAIGE_RETURN_AND_NEWLINE[2] = {0x0d,0x0a};

+(NSUInteger)BUFFER_SIZE {
    return _BUFFER_SIZE;
}


-(void)fillBuffer {
    
    
    _currentOffset = 0;

    UInt64 amountToRead = _contentRemaining;
    if( amountToRead > _BUFFER_SIZE ) {
        amountToRead = _BUFFER_SIZE;
    }
    

    long bytesRead = [_content read:_buffer maxLength:(NSUInteger)amountToRead];
    if( 0 == bytesRead && 0 != amountToRead) { // `0 == bytesRead` marks the end of the stream
        
        
        @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"0 == bytesRead && 0 != amountToRead; amountToRead = %d; _contentRemaining = %d", amountToRead, _contentRemaining];
        
    }
    if( 0 > bytesRead ) {
        Log_error(@"0 > bytesRead");
        @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ callTo:@"[NSInputStream read:maxLength:]" failedWithError:[_content streamError]];
    }
    
    _contentRemaining -= bytesRead;
    _bufferEnd = bytesRead;
    
}


-(UInt8)readByte {
    if( _currentOffset == _bufferEnd ) {
        [self fillBuffer];
    }
    UInt8 answer = _buffer[_currentOffset];
    _currentOffset++;
    return answer;

}


// external use is for testing only
-(NSString*)readLine:(NSMutableData*)stringBuffer {
    
    
    UInt8 lastChar = 88; // 'X'
    
    
    [stringBuffer setLength:0]; // `clear` the stringBuffer
    
    
    while( true ) {
        
        UInt8 currentChar = [self readByte];
        
        if (0x0d == lastChar) {// '\r'
            
            if (0x0a == currentChar) { // `\n`
                
                return [JBStringHelper getUtf8String:stringBuffer];
                
            } else {
                
                [stringBuffer appendBytes:&lastChar length:1]; // add the previous '\r'
                
            }
            
            
        }
        if (0x0d != currentChar) { // '\r'
            
            [stringBuffer appendBytes:&currentChar length:1]; // add the previous '\r'
            
        }
        
        lastChar = currentChar;
        
    }
    
}


// used for testing only
-(id<JBDelimiterIndicator>)skipToNextDelimiterIndicator {
    
    

    JBDelimiterDetector* detector = [[JBDelimiterDetector alloc] initWithBoundary:_boundary];
    
    if( _currentOffset == _bufferEnd) {
        
        [self fillBuffer];
    }
    
    id<JBDelimiterIndicator> indicator = [detector update:_buffer startingOffset:_currentOffset endingOffset:_bufferEnd];
    
    
    if ( nil == indicator)
    {
        return nil;
    }
    
    if( [indicator isKindOfClass:[JBDelimiterFound class]] ) {
        
        JBDelimiterFound* delimiterFound = (JBDelimiterFound*)indicator;
        _currentOffset = [delimiterFound endOfDelimiter];
    }
    
    return indicator;
    
}




// can return null if not indicator was found (partial or complete)
-(JBDelimiterFound*)findFirstDelimiterIndicator:(JBDelimiterDetector*)detector {
    
    if (_currentOffset == _bufferEnd) {
        [self fillBuffer];
    }
    
    id<JBDelimiterIndicator> indicator = [detector update:_buffer startingOffset:_currentOffset endingOffset:_bufferEnd];
    
    if (nil == indicator)
    {
        @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"null == indicator, could not find first delimiter; _boundary = '%@'", _boundary];
        
    }
    
    if( ![indicator isKindOfClass:[JBDelimiterFound class]] ) {
        Log_error(@"unimplemented: support for `JBDelimiterIndicator` types that are not `JBDelimiterFound`" );
        @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"![indicator isKindOfClass:[JBDelimiterFound class]]; NSStringFromClass([indicator class]) = '%@'", NSStringFromClass([indicator class])];
    }
    
    return (JBDelimiterFound*)indicator;

}


// will accept `null` values
-(void)writePartialDelimiter:(JBPartialDelimiterMatched*)partialDelimiterMatched partHandler:(id<JBPartHandler>)partHandler {
    
    
    if (nil == partialDelimiterMatched)
    {
        return;
    }
    
    NSData* matchingData = [partialDelimiterMatched matchingData];
    
    [partHandler handleBytes:[matchingData bytes] offset:0 length:[matchingData length]];
    
    
}


-(JBDelimiterFound*)tryProcessPart:(id<JBPartHandler>)partHandler detector:(JBDelimiterDetector*)detector {
    
    NSMutableData* stringBuffer = [[NSMutableData alloc] init];
    
    NSString* line = [self readLine:stringBuffer];
    while( 0 != [line length] ) {
        
        
        NSRange firstColon = [line rangeOfString:@":"];
        
        if( NSNotFound == firstColon.location ) {
            @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"NSNotFound == firstColon.location; line = '%@'", line];
        }
        
        NSString* name = [line substringToIndex:firstColon.location];
        name = [name lowercaseString]; // headers are case insensitive
        
        NSString* value = [line substringFromIndex:firstColon.location+1];
        value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [partHandler handleHeaderWithName:name value:value];
        

        line = [self readLine:stringBuffer];
        
        
    }
    
    JBPartialDelimiterMatched* partialDelimiterMatched = nil;
    
    bool partCompleted = false;
    
    while (!partCompleted) {
        
        id<JBDelimiterIndicator> delimiterIndicator = [detector update:_buffer startingOffset:_currentOffset endingOffset:_bufferEnd];
        
        // nothing detected ?
        if (nil == delimiterIndicator) {
            
            // write existing partial match (if it exists)
            {
                [self writePartialDelimiter:partialDelimiterMatched partHandler:partHandler];
                partialDelimiterMatched = nil;
            }
            
            NSUInteger length = _bufferEnd - _currentOffset;
            [partHandler handleBytes:_buffer offset:_currentOffset length:length];
            [self fillBuffer];
            continue;
        }
        
        if( [delimiterIndicator isKindOfClass:[JBDelimiterFound class]] ) {
            
            JBDelimiterFound* delimiterFound = (JBDelimiterFound*)delimiterIndicator;
            // more content to add ?
            if( ![delimiterFound completesPartialMatch] ) {
                
                // write existing partial match (if it exists)
                {
                    [self writePartialDelimiter:partialDelimiterMatched partHandler:partHandler];
                    partialDelimiterMatched = nil;
                }
                
                NSUInteger length = [delimiterFound startOfDelimiter] - _currentOffset;
                [partHandler handleBytes:_buffer offset:_currentOffset length:length];
                

            } else { // delimiterFound completesPartialMatch
                
                partialDelimiterMatched = nil;
                
            }
            
            _currentOffset = [delimiterFound endOfDelimiter];
            [partHandler partCompleted];
            partCompleted = true; // not required, but signalling intent
            return delimiterFound;
        }
        
        if( [delimiterIndicator isKindOfClass:[JBPartialDelimiterMatched class]] ){
            
            // write existing partial match (if it exists)
            {
                [self writePartialDelimiter:partialDelimiterMatched partHandler:partHandler];
            }
            
            partialDelimiterMatched = (JBPartialDelimiterMatched*)delimiterIndicator;
            NSData* matchingData = [partialDelimiterMatched matchingData];
            NSUInteger startOfMatch = _bufferEnd - [matchingData length];
            if (startOfMatch < _currentOffset) {
                // can happen when the delimiter straddles 2 distinct buffer reads of size `BUFFER_SIZE`
                startOfMatch = _currentOffset;
                
            } else {
                NSUInteger length = startOfMatch - _currentOffset;
                [partHandler handleBytes:_buffer offset:_currentOffset length:length];
            }
            [self fillBuffer];

        }

    }
    
    // will never happen ... we hope
    @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultString:@"unexpected code path followed"];

}


-(JBDelimiterFound*)processPart:(id<JBMultiPartHandler>)multiPartHandler detector:(JBDelimiterDetector*)detector {
    
    
    id<JBPartHandler> partHandler = [multiPartHandler foundPartDelimiter];
    
    @try {
        return [self tryProcessPart:partHandler detector:detector];
    }
    @catch (BaseException *exception) {
        [partHandler handleFailure:exception];
        @throw exception;
    }
    

    
}

-(void)tryProcess:(id<JBMultiPartHandler>)multiPartHandler skipFirstCrNl:(bool)skipFirstCrNl {
    
    
    JBDelimiterDetector* detector = [[JBDelimiterDetector alloc] initWithBoundary:_boundary];
    {
        if( skipFirstCrNl ) {
            [detector update:_CARRAIGE_RETURN_AND_NEWLINE startingOffset:0 endingOffset:2];
        }
        
        id<JBDelimiterIndicator> indicator = [self findFirstDelimiterIndicator:detector];
        
        if( nil == indicator ) {
            
            @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultString:@"nil == indicator; expected delimiter at start of stream"];
            
        }
        
        if( ![indicator isKindOfClass:[JBDelimiterFound class]] ) {
            
            Log_error(@"unimplemented: support for `JBDelimiterIndicator` types that are not `JBDelimiterFound`");
            @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"![indicator isKindOfClass:[JBDelimiterFound class]]; NSStringFromClass([indicator class]) = '%@'", NSStringFromClass([indicator class])];
            
        }
        
        
        JBDelimiterFound* delimiterFound = (JBDelimiterFound*)indicator;
        
        _currentOffset = [delimiterFound endOfDelimiter];
        
        while( ![delimiterFound isCloseDelimiter] ) {
            
            delimiterFound =  [self processPart:multiPartHandler detector:detector];
            
            
        }
        
    }
    
    
    [multiPartHandler foundCloseDelimiter];
    
    // consume (and discard) any trailing data
    while( 0 != _contentRemaining  ) {
        [self fillBuffer];
    }
    
    
}

-(void)process:(id<JBMultiPartHandler>)multiPartHandler skipFirstCrNl:(bool)skipFirstCrNl {
    
    @try {
        [self tryProcess:multiPartHandler skipFirstCrNl:skipFirstCrNl];
    }
    @catch (BaseException *exception) {
        
        [multiPartHandler handleExceptionZZZ:exception];
    }
}


-(void)process:(id<JBMultiPartHandler>)multiPartHandler {
    [self process:multiPartHandler skipFirstCrNl:false];
}


#pragma mark -
#pragma mark instance lifecycle


-(id)initWithBoundary:(NSString*)boundary entity:(id<JBEntity>)entity {
    
    JBMultiPartReader* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setBoundary:boundary];
        [answer setContent:[entity getContent]];
        answer->_contentRemaining = [entity getContentLength];
        answer->_buffer = malloc( sizeof(UInt8) * _BUFFER_SIZE  );
        answer->_currentOffset = 0;
        answer->_bufferEnd = 0;
    }
    
    return answer;
}

-(void)dealloc {
	
	[self setBoundary:nil];
	[self setContent:nil];
    
    free( _buffer );

	

}


#pragma mark -
#pragma mark fields

// boundary
//NSString* _boundary;
//@property (nonatomic, retain) NSString* boundary;
@synthesize boundary = _boundary;


// content
//NSInputStream* _content;
//@property (nonatomic, retain) NSInputStream* content;
@synthesize content = _content;


@end
