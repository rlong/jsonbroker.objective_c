//  Copyright (c) 2014 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBHttpErrorHelper.h"
#import "JBLog.h"
#import "JBMimeTypes.h"
#import "JBRequestHandlerHelper.h"

@implementation JBRequestHandlerHelper


+(void)validateMimeTypeForRequestUri:(NSString*) requestUri {
    
    
    if( nil == [JBMimeTypes getMimeTypeForPath:requestUri] ) {
        
        Log_errorFormat( @"nil == [self getMimeTypeForRequestUri:requestUri]; requestUri = '%@'", requestUri);
        @throw [JBHttpErrorHelper forbidden403FromOriginator:self line:__LINE__];
    }
    
}


+(void)validateRequestUri:(NSString*) requestUri {
    
    
    if( '/' != [requestUri characterAtIndex:0] ) {
        Log_errorFormat( @"'/' != [requestUri characterAtIndex:0]; requestUri = '%@'", requestUri);
        @throw [JBHttpErrorHelper forbidden403FromOriginator:self line:__LINE__];
    }
    
    if( NSNotFound != [requestUri rangeOfString:@"/."].location ) { // UNIX hidden files
        Log_errorFormat( @"NSNotFound != [requestUri rangeOfString:@\"/.\"].location; requestUri = '%@'", requestUri);
        @throw [JBHttpErrorHelper forbidden403FromOriginator:self line:__LINE__];
    }
    if( NSNotFound != [requestUri rangeOfString:@".."].location ) { // parent directory
        Log_errorFormat( @"NSNotFound != [requestUri rangeOfString:@\"..\"].location; requestUri = '%@'", requestUri);
        @throw [JBHttpErrorHelper forbidden403FromOriginator:self line:__LINE__];
    }
}







@end
