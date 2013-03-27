// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBLog.h"
#import "JBJsonObject.h"
#import "JBJsonStringOutput.h"
#import "JBJsonWalker.h"
#import "JBJsonWriter.h"
#import "JBJsonWriterUnitTest.h"



@implementation JBJsonWriterUnitTest


-(void)test1 {
    Log_enteredMethod();
}

-(void)testEmptyObject {
    
    JBJsonStringOutput* output = [[JBJsonStringOutput alloc] init];
    [output autorelease];
    {
        
        JBJsonWriter* writer = [[JBJsonWriter alloc] initWithOutput:output];
        [writer autorelease];
        
        
        JBJsonObject* target = [[JBJsonObject alloc] init];
        [target autorelease];
        
        
        [JBJsonWalker walkJsonObjectDocument:target visitor:writer];
    }
    NSString* actual = [output toString];
    Log_debugString( actual );
    STAssertTrue([@"{}" isEqualToString:actual], @"actual = '%@'", actual);
    
}


-(void)testEmptyArray {
    
    JBJsonStringOutput* output = [[JBJsonStringOutput alloc] init];
    [output autorelease];
    {
        
        JBJsonWriter* writer = [[JBJsonWriter alloc] initWithOutput:output];
        [writer autorelease];
        
        
        JBJsonArray* target = [[JBJsonArray alloc] init];
        [target autorelease];
        
        
        [JBJsonWalker walkJsonArrayDocument:target visitor:writer];
    }
    NSString* actual = [output toString];
    Log_debugString( actual );
    STAssertTrue([@"[]" isEqualToString:actual], @"actual = '%@'", actual);
    
}

-(void)testSimpleObject {
    
    
    JBJsonStringOutput* output = [[JBJsonStringOutput alloc] init];
    [output autorelease];
    {
        
        JBJsonWriter* writer = [[JBJsonWriter alloc] initWithOutput:output];
        [writer autorelease];
        
        
        JBJsonObject* target = [[JBJsonObject alloc] init];
        [target autorelease];
        [target setObject:nil forKey:@"nullKey"];
        [target setBoolean:true forKey:@"booleanKey"];
        [target setInt:314 forKey:@"integerKey"];
        [target setObject:@"value" forKey:@"stringKey"];
        
        
        [JBJsonWalker walkJsonObjectDocument:target visitor:writer];
    }
    NSString* actual = [output toString];
    Log_debugString( actual );
    STAssertTrue([@"{\"stringKey\":\"value\",\"booleanKey\":true,\"integerKey\":314,\"nullKey\":null}" isEqualToString:actual], @"actual = '%@'", actual);

}

-(void)testSimpleArray {
    
    
    JBJsonStringOutput* output = [[JBJsonStringOutput alloc] init];
    [output autorelease];
    {
        
        JBJsonWriter* writer = [[JBJsonWriter alloc] initWithOutput:output];
        [writer autorelease];
        
        
        JBJsonArray* target = [[JBJsonArray alloc] init];
        [target autorelease];
        [target add:nil];
        [target addBoolean:true];
        [target addInt:314];
        [target add:@"value"];
        
        
        
        [JBJsonWalker walkJsonArrayDocument:target visitor:writer];
    }
    NSString* actual = [output toString];
    Log_debugString( actual );
    STAssertTrue([@"[null,true,314,\"value\"]" isEqualToString:actual], @"actual = '%@'", actual);

    
    
    
}


@end
