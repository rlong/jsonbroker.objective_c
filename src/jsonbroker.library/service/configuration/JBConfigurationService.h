//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBDescribedService.h"

@interface JBConfigurationService : NSObject <JBDescribedService> {
	
	NSMutableDictionary* _bundles;
	//@property (nonatomic, retain) NSMutableDictionary* bundles;
	//@synthesize bundles = _bundles;

	NSString* _root;
	//@property (nonatomic, retain) NSString* root;
	//@synthesize root = _root;
	
	NSFileManager* _fileManager;
	//@property (nonatomic, retain) NSFileManager* fileManager;
	//@synthesize fileManager = _fileManager;
	
	
}


+(NSString*)SERVICE_NAME;



// can return 'nil' if the bundle is not on disk, or there is a problem reading it
-(JBJsonObject*)getBundle:(NSString*)bundleName;

-(void)saveBundle:(JBJsonObject*)bundle withName:(NSString*)bundleName;

-(void)set_bundle:(NSString*)bundleName bundle:(JBJsonObject*)bundle;
-(void)saveAllBundles;


#pragma instance lifecycle

-(id)initWithRootFolder:(NSString*)rootFolder;
	
@end
