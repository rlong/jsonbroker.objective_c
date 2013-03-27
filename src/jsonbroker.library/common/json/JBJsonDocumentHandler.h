// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

@protocol JBJsonDocumentHandler <NSObject>


#pragma mark -
#pragma mark document

-(void)onObjectDocumentStart;
-(void)onObjectDocumentEnd;

-(void)onArrayDocumentStart;
-(void)onArrayDocumentEnd;


#pragma mark -
#pragma mark object

-(void)onArrayStartWithKey:(NSString*)key;
-(void)onArrayEndWithKey:(NSString*)key;

-(void)onBooleanWithKey:(NSString*)key value:(bool)value;
-(void)onNullWithKey:(NSString*)key;
-(void)onNumberWithKey:(NSString*)key value:(NSNumber*)value;

-(void)onObjectStartWithKey:(NSString*)key;
-(void)onObjectEndWithKey:(NSString*)key;

-(void)onStringWithKey:(NSString*)key value:(NSString*)value;

#pragma mark -
#pragma mark array

-(void)onArrayStartWithIndex:(NSUInteger)index;
-(void)onArrayEndWithIndex:(NSUInteger)index;


-(void)onBooleanWithIndex:(NSUInteger)index value:(bool)value;
-(void)onNullWithIndex:(NSUInteger)index;
-(void)onNumberWithIndex:(NSUInteger)index value:(NSNumber*)value;

-(void)onObjectStartWithIndex:(NSUInteger)index;
-(void)onObjectEndWithIndex:(NSUInteger)index;

-(void)onStringWithIndex:(NSUInteger)index value:(NSString*)value;


@end
