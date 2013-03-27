// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


#import "JBDelimiterIndicator.h"
#import "JBEntity.h"
#import "JBMultiPartHandler.h"


/// <summary>
///
/// as per http://www.w3.org/Protocols/rfc1341/7_2_Multipart.html
/// </summary>
@interface JBMultiPartReader : NSObject {
    
    
    // boundary
    NSString* _boundary;
    //@property (nonatomic, retain) NSString* boundary;
    //@synthesize boundary = _boundary;
    
    
    // content
    NSInputStream* _content;
    //@property (nonatomic, retain) NSInputStream* content;
    //@synthesize content = _content;
    
    UInt64 _contentRemaining;
    
    UInt8* _buffer;
    
    NSUInteger _currentOffset;
    NSUInteger _bufferEnd;


    
}


// used for testing only
+(NSUInteger)BUFFER_SIZE;


// external use is for testing only
-(NSString*)readLine:(NSMutableData*)stringBuffer;

// used for testing only
-(id<JBDelimiterIndicator>)skipToNextDelimiterIndicator;


-(void)process:(id<JBMultiPartHandler>)multiPartHandler skipFirstCrNl:(bool)skipFirstCrNl;
-(void)process:(id<JBMultiPartHandler>)multiPartHandler;

#pragma mark -
#pragma mark instance lifecycle


-(id)initWithBoundary:(NSString*)boundary entity:(id<JBEntity>)entity;



@end
