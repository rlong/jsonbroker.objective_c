// Copyright (c) 2014 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBLog.h"
#import "JBJsonBuilder.h"
#import "JBMemoryModel.h"
#import "JBSaxHandler.h"
#import "JBSaxHandlerIntegrationTest.h"


@implementation JBSaxHandlerIntegrationTest



-(NSData*)resolve :(NSString*)xmlFile {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:xmlFile ofType: @"xml"];
    Log_debugString( path );
    
	STAssertTrue( nil != path, @"actual = %x", path );
	
	NSURL* url = [NSURL fileURLWithPath:path];
	NSData* answer = [NSData dataWithContentsOfURL:url];
	return answer;
	
}

-(void)test1 {
    Log_enteredMethod();
}

-(void)testSimple {
    
    NSData* xml = [self resolve:@"JBSaxHandlerIntegrationTest.testSimple"];
	STAssertTrue( nil != xml, @"actual = %p", xml);
    
    
    JBJsonBuilder* jsonBuilder = [[JBJsonBuilder alloc] init];
    JBAutorelease(jsonBuilder);

    JBSaxHandler* handler = [[JBSaxHandler alloc] initWithJsonHandler:jsonBuilder];
    JBAutorelease(handler);
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xml];
    JBAutorelease(parser);

    [parser setDelegate:handler];
    [parser parse];
    
    JBJsonArray* jsonArray = [jsonBuilder arrayDocument];
	STAssertTrue( nil != jsonArray, @"actual = %p", jsonArray);

    Log_debugString( [jsonArray toString] );
    
    NSString* rootElementName = [jsonArray getString:0];
    STAssertTrue( [@"company" isEqualToString:rootElementName],  @"actual = %@", rootElementName );
    
    
}

-(void)testRss {

    
    NSData* xml = [self resolve:@"JBSaxHandlerIntegrationTest.testRss"];
	STAssertTrue( nil != xml, @"actual = %p", xml);
    
    
    JBJsonBuilder* jsonBuilder = [[JBJsonBuilder alloc] init];
    JBAutorelease(jsonBuilder);
    
    JBSaxHandler* handler = [[JBSaxHandler alloc] initWithJsonHandler:jsonBuilder];
    JBAutorelease(handler);
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xml];
    JBAutorelease(parser);
    
    [parser setDelegate:handler];
    [parser parse];
    
    JBJsonArray* jsonArray = [jsonBuilder arrayDocument];
	STAssertTrue( nil != jsonArray, @"actual = %p", jsonArray);

    
    
}


@end
