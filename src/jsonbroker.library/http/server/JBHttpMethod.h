//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

@interface JBHttpMethod : NSObject {

    // name
    NSString* _name;
    //@property (nonatomic, retain) NSString* name;
    //@synthesize name = _name;

}


+(JBHttpMethod*)GET;
+(JBHttpMethod*)OPTIONS;
+(JBHttpMethod*)POST;


#pragma mark -
#pragma mark fields

// name
//NSString* _name;
@property (nonatomic, readonly) NSString* name;
//@synthesize name = _name;



@end
