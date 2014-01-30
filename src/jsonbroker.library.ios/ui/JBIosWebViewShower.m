//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBIosWebViewShower.h"
#import "JBLog.h"
#import "JBMemoryModel.h"



@implementation JBIosWebViewShower



+(JBIosWebViewShower*)setup:(UIWebView *)webView {
    
    [webView setHidden:true];
    
    JBIosWebViewShower* answer = [[JBIosWebViewShower alloc] init];
    JBAutorelease(answer);
    
    return answer;
    
}

#pragma mark -
#pragma mark <UIWebViewDelegate> implementation

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    Log_enteredMethod();
    [webView setHidden:false];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    Log_enteredMethod();
    return true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    Log_enteredMethod();
    [webView setHidden:false];
    
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    Log_enteredMethod();
}

@end
