//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


@class JBHttpRequest;
@class JBHttpResponse;

#import "JBRequestHandler.h"


@interface JBFileRequestHandler : NSObject <JBRequestHandler> {
    
	// rootFolder
	NSString* _rootFolder;
	//@property (nonatomic, retain) NSString* rootFolder;
	//@synthesize rootFolder = _rootFolder;


}



-(JBHttpResponse*)processRequest:(JBHttpRequest*)request;


#pragma mark instance lifecycle


-(id)initWithRootFolder:(NSString*)rootFolder; 

@end
