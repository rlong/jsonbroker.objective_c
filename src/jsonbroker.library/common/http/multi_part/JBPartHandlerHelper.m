// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBPartHandlerHelper.h"


@implementation JBPartHandlerHelper

+(JBContentDisposition*)getContentDispositionWithName:(NSString*)name value:(NSString*)value {
    
    
    if( [@"content-disposition" isEqualToString:name] ) {
        
        
        return [JBContentDisposition buildFromString:value];
        
        
    }
    
    return nil;
    
    
}


+(JBMediaType*)getContentTypeWithName:(NSString*)name value:(NSString*)value {

    if( [@"content-type" isEqualToString:name] ) {
        
        
        return [JBMediaType buildFromString:value];
        
        
    }

    return nil;

}



@end
