// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBEntity.h"

// __attribute__ ((deprecated)) // use HLDataEntity
@interface JBDataEntity : NSObject<JBEntity> {
    
    // data
	NSData* _data;
	//@property (nonatomic, retain) NSData* data;
	//@synthesize data = _data;
    
    
    // streamContent
    NSInputStream* _streamContent;
    //@property (nonatomic, retain) NSInputStream* streamContent;
    //@synthesize streamContent = _streamContent;


}

#pragma instance setup/teardown

-(id)initWithData:(NSData*)data;

#pragma fields

// data
//NSData* _data;
@property (nonatomic, retain) NSData* data;
//@synthesize data = _data;


@end
