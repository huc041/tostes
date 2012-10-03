//
//  WebViewVC.h
//  RussianToast
//
//  Created by Евгений Иванов on 04.08.12.
//
//

#import <UIKit/UIKit.h>
#import "MediaDB.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface TextViewVC : UIViewController <UIActionSheetDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

{
    MediaDB *media;    
    UITextView *textView;
    UIView *toolBarView;
    
    float blockTextHeight;
    float fontSize;
}

@property (nonatomic,retain)MediaDB *media;

@end
