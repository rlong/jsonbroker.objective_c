// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBLog.h"
#import "JBDefaultJsonHandler.h"

@implementation JBDefaultJsonHandler


#pragma mark -
#pragma mark <JBJsonDocumentHandler> implementation



#pragma mark -
#pragma mark document

-(void)onObjectDocumentStart {
    
    
    Log_enteredMethod();
    
}

-(void)onObjectDocumentEnd {
    
    Log_enteredMethod();
    
}


-(void)onArrayDocumentStart {
    
    Log_enteredMethod();
    
}

-(void)onArrayDocumentEnd {
    
    Log_enteredMethod();
    
}



#pragma mark -
#pragma mark object

-(void)onArrayStartWithKey:(NSString*)key {
    
    Log_enteredMethod();
    
}

-(void)onArrayEndWithKey:(NSString*)key {
    
    Log_enteredMethod();
    
}


-(void)onBooleanWithKey:(NSString*)key value:(bool)value {
    
    Log_enteredMethod();
    
}

-(void)onNullWithKey:(NSString*)key {
    
    Log_enteredMethod();
    
}

-(void)onNumberWithKey:(NSString*)key value:(NSNumber*)value {
    
    Log_enteredMethod();
    
}


-(void)onObjectStartWithKey:(NSString*)key {
    
    Log_enteredMethod();
    
}

-(void)onObjectEndWithKey:(NSString*)key {
    
    Log_enteredMethod();
    
}


-(void)onStringWithKey:(NSString*)key value:(NSString*)value {
    
    Log_enteredMethod();
    
}


#pragma mark -
#pragma mark array

-(void)onArrayStartWithIndex:(NSUInteger)index {
    
    Log_enteredMethod();
    
}

-(void)onArrayEndWithIndex:(NSUInteger)index {
    
    Log_enteredMethod();
    
}



-(void)onBooleanWithIndex:(NSUInteger)index value:(bool)value {
    
    Log_enteredMethod();
    
}

-(void)onNullWithIndex:(NSUInteger)index {
    
    Log_enteredMethod();
    
}

-(void)onNumberWithIndex:(NSUInteger)index value:(NSNumber*)value {
    
    Log_enteredMethod();
    
}


-(void)onObjectStartWithIndex:(NSUInteger)index {
    
    Log_enteredMethod();
    
}

-(void)onObjectEndWithIndex:(NSUInteger)index {
    
    Log_enteredMethod();
    
}


-(void)onStringWithIndex:(NSUInteger)index value:(NSString*)value {
    
    Log_enteredMethod();
    
}


@end
