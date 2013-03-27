//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <CommonCrypto/CommonDigest.h>

#import "JBRandomUtilities.h"
#import "JBSecurityUtilities.h"
#import "JBStringHelper.h"


#import "JBLog.h"


@implementation JBSecurityUtilities


+(NSString*)generateNonce {
	
	// TODO: FDB46896-A292-4F48-811C-88651F37B4F8
	// TODO: come up with a better nonce solution
    
    return [JBRandomUtilities generateUuid];
	
}


+(NSString*)md5HashOfData:(NSData*)input {
	
	CC_MD5_CTX md5Context;
	
	CC_MD5_Init( &md5Context );
	CC_MD5_Update(&md5Context, (void *)[input bytes], (unsigned int)[input length]);
	
	
	UInt8 hashBytes[16];
	memset(hashBytes, 0x0, 16);
	
	CC_MD5_Final( hashBytes, &md5Context);

	NSString* answer = [JBStringHelper toHexString:hashBytes];

	return answer;
	
	
}

+(NSString*)md5HashOfString:(NSString*)input {
	
	int inputLength = (int)[input lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	CC_MD5_CTX md5Context; 
	
	CC_MD5_Init( &md5Context );
	CC_MD5_Update(&md5Context, (void *)[input UTF8String], inputLength);
	
	
	UInt8 hashBytes[16];
	memset(hashBytes, 0x0, 16);
	
	CC_MD5_Final( hashBytes, &md5Context);
	
	NSString* answer = [JBStringHelper toHexString:hashBytes];
	
	return answer;
	
}

+(NSString*)generateNumericUserPassword {
	
	
	CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
	CFUUIDBytes uuidBytes = CFUUIDGetUUIDBytes( uuid );
	
	UInt8 bytes[8];
	bytes[0] = uuidBytes.byte0;
	bytes[1] = uuidBytes.byte1;
	bytes[2] = uuidBytes.byte2;
	bytes[3] = uuidBytes.byte3;
	bytes[4] = uuidBytes.byte4;
	bytes[5] = uuidBytes.byte5;
	bytes[6] = uuidBytes.byte6;
	bytes[7] = uuidBytes.byte7;
	
	CFRelease(uuid);
	
	for( int i = 0; i < 8; i++ ) {
		bytes[i] = bytes[i] % 10;
	}
	
	NSString* answer = [NSString stringWithFormat:@"%d%d%d%d%d%d%d%d", bytes[0], bytes[1], bytes[2], bytes[3],  bytes[4], bytes[5], bytes[6], bytes[7]];
	return answer;
}


@end
