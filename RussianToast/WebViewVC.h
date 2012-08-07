//
//  WebViewVC.h
//  RussianToast
//
//  Created by Евгений Иванов on 04.08.12.
//
//

#import <UIKit/UIKit.h>

@interface WebViewVC : UIViewController <UIWebViewDelegate>

{
    NSString *dataText;
    UIWebView *webView;
    
    float blockTextHeight;
    float fontSize;
}

- (id)initWithTextData:(NSString*)textData;

@end
