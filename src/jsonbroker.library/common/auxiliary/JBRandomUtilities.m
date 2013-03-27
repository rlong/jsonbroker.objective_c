// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBRandomUtilities.h"
#import "JBStringHelper.h"

#import "JBLog.h"

@implementation JBRandomUtilities





+(void)initialize {
	
    srand((unsigned int)clock());
	
}


+(void)random:(UInt8*)bytes length:(int)length {
    
    for( int i = 0; i < length; ) { 
        
        long randy = random();
        
        for( int j = 0; j < 4 & i < length; i++, j++ ) {
            bytes[i] = 0xFF & randy;
            randy >>= 8;
        }
    }
    
}


+(NSString*)generateUuid {
	
	
	CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
	CFUUIDBytes uuidBytes = CFUUIDGetUUIDBytes( uuid );
	
	UInt8 rawUuid[16];
	rawUuid[0] = uuidBytes.byte0;
	rawUuid[1] = uuidBytes.byte1;
	rawUuid[2] = uuidBytes.byte2;
	rawUuid[3] = uuidBytes.byte3;
	rawUuid[4] = uuidBytes.byte4;
	rawUuid[5] = uuidBytes.byte5;
	rawUuid[6] = uuidBytes.byte6;
	rawUuid[7] = uuidBytes.byte7;
	rawUuid[8] = uuidBytes.byte8;
	rawUuid[9] = uuidBytes.byte9;
	rawUuid[10] = uuidBytes.byte10;
	rawUuid[11] = uuidBytes.byte11;
	rawUuid[12] = uuidBytes.byte12;
	rawUuid[13] = uuidBytes.byte13;
	rawUuid[14] = uuidBytes.byte14;
	rawUuid[15] = uuidBytes.byte15;
	
	CFRelease(uuid);
    
	return [JBStringHelper toHexString:rawUuid];
	
}


    

@end
