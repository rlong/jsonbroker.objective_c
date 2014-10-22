//
//  JBJsonMlHelper.h
//  jsonbroker
//
//  Created by rlong on 1/04/2014.
//
//

#import <Foundation/Foundation.h>

#import "JBJsonArray.h"

@interface JBJsonMlHelper : NSObject


+(JBJsonArray*)buildWithContentsOfData:(NSData*)data;

+(JBJsonArray*)buildWithContentsOfURL:(NSURL *)url;

+(NSArray*)allChildrenOfParent:(JBJsonArray*)parentElement withName:(NSString*)elementName;

// can return nil
+(NSString*)attributeOfElement:(JBJsonArray*)element withName:(NSString*)attributeName;

// can return nil
+(JBJsonArray*)firstChildOfParent:(JBJsonArray*)parentElement withName:(NSString*)elementName;

// can return nil
+(NSString*)firstTextContentFromElement:(JBJsonArray*)element;

// can return nil
+(NSString*)firstTextContentFromFirstChildOfParent:(JBJsonArray*)parentElement withName:(NSString*)childsName;

@end
