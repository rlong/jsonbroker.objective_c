// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBSecurityUtilities.h"

#import "JBDataEntity.h"
#import "JBInputStreamHelper.h"
#import "JBLog.h"
#import "JBObjectTracker.h"
#import "JBStreamHelper.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBDataEntity ()

// streamContent
//NSInputStream* _streamContent;
@property (nonatomic, retain) NSInputStream* streamContent;
//@synthesize streamContent = _streamContent;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBDataEntity

#pragma <Entity> implementation 

-(NSInputStream*)getContent {
    

    if( nil != _streamContent ) {
        [JBStreamHelper closeStream:_streamContent swallowErrors:false caller:self];
    }
    [self setStreamContent:[NSInputStream inputStreamWithData:_data]];
    
    [_streamContent open];
    return _streamContent;

}
-(unsigned long long)getContentLength {
    
    return [_data length];
    
}
-(NSString*)md5 {
    
    return [JBSecurityUtilities md5HashOfData:_data];
    
}


// can return nil
-(NSString*)mimeType {
    return nil;
}


-(void)teardownForCaller:(id)caller swallowErrors:(BOOL)swallowException {

    if( nil != _streamContent ) {
        [JBStreamHelper closeStream:_streamContent swallowErrors:swallowException caller:caller];
        [self setStreamContent:nil];
    }
    
}

-(void)writeTo:(NSOutputStream*)destination offset:(unsigned long long)offset length:(unsigned long long)length {
    
    NSInputStream* content = [self getContent]; // will open the stream if necessary
    
    [JBInputStreamHelper seek:content to:offset];
    [JBInputStreamHelper writeFrom:content toOutputStream:destination count:length];
}


#pragma instance setup/teardown

-(id)initWithData:(NSData*)data {  
    
    JBDataEntity* answer = [super init];
    
    [JBObjectTracker allocated:answer];
    
    [answer setData:data];
	[self setStreamContent:nil];
    
    return answer;
}

-(void)dealloc{
    
    
    [JBObjectTracker deallocated:self];
	
	[self setData:nil];

    if( nil != _streamContent ) {
        [JBStreamHelper closeStream:_streamContent swallowErrors:false caller:self];
    }
	[self setStreamContent:nil];

	
}


#pragma fields

// data
//NSData* _data;
//@property (nonatomic, retain) NSData* data;
@synthesize data = _data;


// streamContent
//NSInputStream* _streamContent;
//@property (nonatomic, retain) NSInputStream* streamContent;
@synthesize streamContent = _streamContent;


@end
