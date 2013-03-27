// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


#import "JBEntity.h"


@interface JBStreamEntity : NSObject<JBEntity> {

    

	// content
	NSInputStream* _content;
	//@property (nonatomic, retain) NSInputStream* content;
	//@synthesize content = _content;
    
    // contentSource
    NSURL* _contentSource;
    //@property (nonatomic, retain) NSURL* contentSource;
    //@synthesize contentSource = _contentSource;

    // contentLength
	unsigned long long _contentLength;
	//@property (nonatomic) unsigned long long contentLength;
	//@synthesize contentLength = _contentLength;

    // mimeType
    NSString* _mimeType;
    //@property (nonatomic, retain) NSString* mimeType;
    //@synthesize mimeType = _mimeType;

    
    bool _didOpen;
    
}


#pragma mark instance lifecycle

-(id)initWithContentLength:(unsigned long long)contentLength content:(NSInputStream*)content;
-(id)initWithContentSource:(NSURL*)contentSource contentLength:(unsigned long long)contentLength mimeType:(NSString*)mimeType;


@end
