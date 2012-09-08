//
//  WebViewVC.h
//  RussianToast
//
//  Created by Евгений Иванов on 04.08.12.
//
//

#import <UIKit/UIKit.h>
#import "MediaDB.h"

@interface WebViewVC : UIViewController <UIWebViewDelegate>

{
    MediaDB *media;    
    UIWebView *webView;
    UIView *toolBarView;
    
    float blockTextHeight;
    float fontSize;
}

@property (nonatomic,retain)MediaDB *media;

@end
