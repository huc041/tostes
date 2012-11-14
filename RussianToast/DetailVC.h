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
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface DetailVC : RootVC <UIActionSheetDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

{
    MediaDB *media;    
    UITextView *textView;
    UIView *toolBarView;
    
    float blockTextHeight;
    float fontSize;
    
    SLComposeViewController *mySLComposeViewController;
}

@property (nonatomic,retain)MediaDB *media;

@end
