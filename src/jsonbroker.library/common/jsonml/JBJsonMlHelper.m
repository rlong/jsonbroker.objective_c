//
//  JBJsonMlHelper.m
//  jsonbroker
//
//  Created by rlong on 1/04/2014.
//
//


#import "JBJsonBuilder.h"
#import "JBJsonMlHelper.h"
#import "JBMemoryModel.h"
#import "JBSaxHandler.h"

@implementation JBJsonMlHelper



+(JBJsonArray*)buildWithParser:(NSXMLParser*)parser {

    JBJsonBuilder* jsonBuilder = [[JBJsonBuilder alloc] init];
    JBAutorelease(jsonBuilder);

    JBSaxHandler* handler = [[JBSaxHandler alloc] initWithJsonHandler:jsonBuilder];
    JBAutorelease(handler);

    [parser setDelegate:handler];
    [parser parse];
    
    JBJsonArray* answer = [jsonBuilder arrayDocument];
    return answer;

}

+(JBJsonArray*)buildWithContentsOfURL:(NSURL *)url {
    
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    JBAutorelease(parser);
    
    return [self buildWithParser:parser];

}


+(NSArray*)allChildrenOfParent:(JBJsonArray*)parentElement withName:(NSString*)elementName {
    
    NSMutableArray* answer = [[NSMutableArray alloc] init];
    JBAutorelease(answer);

    // no attributes or children ?
    if( 1 == [parentElement count] ) {
        return answer;
    }
    
    int startingIndex = 1;
    
    id objectAtIndex1 = [parentElement objectAtIndex:1];
    
    // skip past the attributes if they exit
    if( [objectAtIndex1 isKindOfClass:[JBJsonObject class]] ) {
        startingIndex = 2;
    }
    
    for( int i = startingIndex, count = [parentElement count]; i < count; i++ ) {

        id candidate = [parentElement objectAtIndex:i];
        if( [candidate isKindOfClass:[JBJsonArray class]] ) {
            JBJsonArray* candidateElement = (JBJsonArray*)candidate;
            NSString* candidateElementName = [candidateElement getString:0];
            if( [elementName isEqualToString:candidateElementName] ) {
                [answer addObject:candidateElement];
            }
        }
    }
    
    return answer;
    
}

// can return nil
+(NSString*)attributeOfElement:(JBJsonArray*)element withName:(NSString*)attributeName {
    
    
    // no attributes ?
    if( 2 > [element count] ) {
        return nil;
    }
    
    id objectAtIndex1 = [element objectAtIndex:1];
    
    // second element is attributes ?
    if( ![objectAtIndex1 isKindOfClass:[JBJsonObject class]] ) {
        return nil;
    }
    
    JBJsonObject* attributes = (JBJsonObject*)objectAtIndex1;
    NSString* answer = [attributes stringForKey:attributeName defaultValue:nil];
    return answer;

    
}

// can return nil
+(JBJsonArray*)firstChildOfParent:(JBJsonArray*)parentElement withName:(NSString*)childsName {
    
    // no attributes or children ?
    if( 1 == [parentElement count] ) {
        return nil;
    }
    
    int startingIndex = 1;
    
    id objectAtIndex1 = [parentElement objectAtIndex:1];
    
    // skip past the attributes if they exit
    if( [objectAtIndex1 isKindOfClass:[JBJsonObject class]] ) {
        startingIndex = 2;
    }
    
    for( int i = startingIndex, count = [parentElement count]; i < count; i++ ) {
        
        id candidate = [parentElement objectAtIndex:i];
        if( [candidate isKindOfClass:[JBJsonArray class]] ) {
            JBJsonArray* candidateElement = (JBJsonArray*)candidate;
            NSString* candidateElementName = [candidateElement getString:0];
            if( [childsName isEqualToString:candidateElementName] ) {
                return candidateElement;
            }
        }
    }
    
    return nil;
    
}

// can return nil
+(NSString*)firstTextContentFromElement:(JBJsonArray*)element {
    
    // no attributes or children ?
    if( 1 == [element count] ) {
        return nil;
    }
    
    int startingIndex = 1;
    
    id objectAtIndex1 = [element objectAtIndex:1];
    
    // skip past the attributes if they exit
    if( [objectAtIndex1 isKindOfClass:[JBJsonObject class]] ) {
        startingIndex = 2;
    }

    for( int i = startingIndex, count = [element count]; i < count; i++ ) {
        
        id candidate = [element objectAtIndex:i];
        if( [candidate isKindOfClass:[NSString class]] ) {
            return (NSString*)candidate;
        }
    }
    
    return nil;
}

// can return nil
+(NSString*)firstTextContentFromFirstChildOfParent:(JBJsonArray*)parentElement withName:(NSString*)childsName {
    
    
    JBJsonArray* firstChild = [self firstChildOfParent:parentElement withName:childsName];
    
    if( nil == firstChild ) {
        return nil;
    }
    
    return [self firstTextContentFromElement:firstChild];
    
    
}

@end
