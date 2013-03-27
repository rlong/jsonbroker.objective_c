// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBDataEntity.h"
#import "JBDataHelper.h"
#import "JBInputStreamHelper.h"

@implementation JBDataHelper



+(NSString*)toUtf8String:(NSData*)data { 
    NSString* answer = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [answer autorelease];
    return answer;
}



// DEPRECATED: use [StringHelper toUtf8Data]
+(NSData*)getUtf8Data:(NSString*)input { 
    
	const char* bytes = [input UTF8String];
	
	NSData* answer = [NSData dataWithBytes:bytes length:[input lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    
    return answer;

}

+(NSData*)fromEntity:(id<JBEntity>)entity {
    
    
    if( [entity isKindOfClass:[JBDataEntity class]] ) { 
        
        JBDataEntity* dataEntity = (JBDataEntity*)entity;
        return [dataEntity data];
        
    }
    
    NSUInteger contentLength = (NSUInteger)[entity getContentLength];

    NSMutableData* answer = [[NSMutableData alloc] initWithCapacity:contentLength];
    [answer autorelease];
    
    NSInputStream* entityContent = [entity getContent];

    [JBInputStreamHelper write:contentLength inputStream:entityContent outputData:answer];
    
    return answer;
    
}

@end
