// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <CommonCrypto/CommonDigest.h>

#import "JBErrorCodeUtilities.h"
#import "JBLog.h"

@implementation JBErrorCodeUtilities


+(int)getBaseErrorCode:(NSString*)errorKey {
    
    
    CC_MD5_CTX md5Context;
	
	CC_MD5_Init( &md5Context );
    
    
    const char* data = [errorKey UTF8String];
    unsigned int  dataLen = (unsigned int)strlen( data );
    
	CC_MD5_Update(&md5Context, data, dataLen);
	
	
	UInt8 hash[16];
	memset(hash, 0x0, 16);
	
	CC_MD5_Final( hash, &md5Context);
    
    int answer = 0xFF & hash[0];
    answer <<= 8;
    answer |= 0xFF & hash[1];
    answer <<= 4;
    answer |= (0xF0 & hash[2])>>4;
    answer <<= 8;
    
    Log_debugFormat( @"'%@' -> %x", errorKey, answer );
    
    return answer;
    
    
}

@end
