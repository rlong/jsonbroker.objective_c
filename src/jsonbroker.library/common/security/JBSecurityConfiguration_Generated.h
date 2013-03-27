//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBJsonObject.h"


@interface JBSecurityConfiguration_Generated : NSObject {
    
    //////////////////////////////////////////////////////
	// localRealm
	NSString* _localRealm;
	//@property (nonatomic, retain) NSString* localRealm;
	//@synthesize localRealm = _localRealm;

}


-(JBJsonObject*)toJsonObject;

#pragma mark -
#pragma mark instance lifecycle

-(id)init;
-(id)initWithJsonObject:(JBJsonObject*)jsonObject;


#pragma mark -
#pragma mark fields

//////////////////////////////////////////////////////
// localRealm
//NSString* _localRealm;
@property (nonatomic, retain) NSString* localRealm;
//@synthesize localRealm = _localRealm;


@end
