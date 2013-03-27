//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBHttpRequest.h"
#import "JBHttpResponse.h"

#import "JBRequestHandler.h"


@interface JBFileProcessor : NSObject <JBRequestHandler> {
    
	// rootFolder
	NSString* _rootFolder;
	//@property (nonatomic, retain) NSString* rootFolder;
	//@synthesize rootFolder = _rootFolder;


}



-(JBHttpResponse*)processRequest:(JBHttpRequest*)request;


#pragma mark instance lifecycle


-(id)initWithRootFolder:(NSString*)rootFolder; 

@end
