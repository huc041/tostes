//
//  WebViewVC.m
//  RussianToast
//
//  Created by Евгений Иванов on 04.08.12.
//
//

#import "TextViewVC.h"
#import "MediaDB.h"

@interface TextViewVC ()

@end

#define BUTTON_OFFSET_TAG 455

#define SEND_MAIL_BUTTON_INDEX 0
#define SEND_SMS_BUTTON_INDEX  1
#define CANSEL_BUTTON_INDEX 2

static NSString *htmlSTR =  @"<html>"
@"<style type=\"text/css\">"
@"body {"
@"background-color: RGB(245, 245, 243);padding:0;margin:0;"
@"}"
@".block1 {"
@"background-color: RGB(245, 245, 243);padding:0;margin:0;"
@"font-family: Helvetica;"
@"font-size: %fpt;"
@"</style>"
@"<body>"
@"<div class=\"block1\">"
@"%@"
@"</div>"
@"</body></html>";

@implementation TextViewVC

@synthesize media;

//-----------------------------------------------------------------------------------
-(void)dealloc
{    
    [super dealloc];
}
//-----------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
                
        blockTextHeight = 0;
        fontSize = 15.0f;
    }
    return self;
}
//-----------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // кнопка Share
    UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonSystemItemEdit target:self
                                                                    action:@selector(sharePress)] autorelease];
    [rightButton setTintColor:self.navigationController.navigationBar.tintColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    CGRect rectTextView = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49.0f - 46.0f);
    
    textView = [[UITextView alloc] initWithFrame:rectTextView];
    textView.backgroundColor = [UIColor whiteColor];
    textView.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:textView];
    
    toolBarView  = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame), self.view.bounds.size.width, 49.0f)];
    toolBarView.backgroundColor = [UIColor colorWithWhite:0.4f alpha:1.0f];
    [self.view addSubview:toolBarView];
    [toolBarView release];
    
    NSArray *arrayRects = [NSArray arrayWithObjects:NSStringFromCGRect(CGRectMake(CGRectGetMidX(toolBarView.frame) - 2.0f - 30.0f, 9.5, 30, 30)),
                                                    NSStringFromCGRect(CGRectMake(CGRectGetMidX(toolBarView.frame) + 2.0f, 9.5, 30, 30)),
                                                    NSStringFromCGRect(CGRectMake(CGRectGetMaxX(toolBarView.frame) - 25.0f, 14.5, 20, 20)),nil];
    
    NSArray *arrayColors = [NSArray arrayWithObjects:[UIColor brownColor],[UIColor brownColor],[UIColor greenColor], nil];
    for (int j =0; j < 3 ; j++ )
    {
        UIButton *toolBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toolBarButton.tag  = BUTTON_OFFSET_TAG + j;
        toolBarButton.frame = CGRectFromString([arrayRects objectAtIndex:j]);
        toolBarButton.backgroundColor = [arrayColors objectAtIndex:j];
        [toolBarButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
        [toolBarButton setSelected:NO];
        [toolBarView addSubview:toolBarButton];

    }
}
//-----------------------------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *fontNum  = [userDefaults objectForKey:@"fontSize"];
    if(fontNum)
        fontSize = [fontNum floatValue];
    else
        fontSize = 16.0f;
        
    textView.font = [UIFont systemFontOfSize:fontSize];
    textView.text = media.fullText;
    
    // кнопка Избранное
    UIButton *buttonFavorite = (UIButton*)[toolBarView viewWithTag:BUTTON_OFFSET_TAG + 2];
    buttonFavorite.selected = [media.isFavorite boolValue];
    buttonFavorite.backgroundColor = (buttonFavorite.selected) ? [UIColor redColor] : [UIColor greenColor];
}
//-----------------------------------------------------------------------------------
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *fontNum = [NSNumber numberWithFloat:fontSize];
    [userDefaults setObject:fontNum forKey:@"fontSize"];
    [userDefaults synchronize];
}
//-----------------------------------------------------------------------------------
-(void)buttonPress:(UIButton*)button
{
    DLog(@"tag - %d",button.tag);
    if(button.tag == BUTTON_OFFSET_TAG) // decrease font
    {
        if(fontSize > 10)
            fontSize -=5;
        
        textView.font = [UIFont systemFontOfSize:fontSize];
    }
    else if (button.tag == BUTTON_OFFSET_TAG + 1)
    {
        if(fontSize < 35)
            fontSize +=5;
        textView.font = [UIFont systemFontOfSize:fontSize];
    }
    else
    {
        button.selected = !button.selected;
        button.backgroundColor = (button.selected) ? [UIColor redColor] : [UIColor greenColor];
        
        media.isFavorite = [NSNumber numberWithBool:button.selected];
        [CoreDataManager saveMainContext];
    }
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark Share Press
-(void)sharePress
{
    DLog(@"");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Поделиться" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:@"отправить на почту" otherButtonTitles:@"отправить по смс", nil];
    [actionSheet showInView:self.view];
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if(buttonIndex == actionSheet.destructiveButtonIndex)
        [self sendMail];
    else if ( buttonIndex == actionSheet.firstOtherButtonIndex)
        [self sendSMS];
    else
        NSLog(@"CANSEL Press");
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark Send Methods
- (void)sendMail
{
    DLog(@"");
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:@"Прекрасные слова..."];
	
	// Fill out the email body text
	[picker setMessageBody:media.fullText isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
}
//-----------------------------------------------------------------------------------
- (void)sendSMS
{
    DLog(@"");
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (messageClass != nil)
    {
		if ([messageClass canSendText])
			[self displaySMSComposerSheet];
		else
			[self showAlert:@"Устройство не настроено для отправки СМС"];
	}
	else 
        [self showAlert:@"Устройство не настроено для отправки СМС"];
}
//-----------------------------------------------------------------------------------
-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
    // Fill out the email body text
	NSString *smsBody = media.fullText;
    [picker setBody:smsBody];
    
	[self presentModalViewController:picker animated:YES];
	[picker release];
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark Mail Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{	
    NSString *resultMessage = @"";
    switch (result)
	{
		case MFMailComposeResultCancelled:
			resultMessage = @"Отправка отменена";
			break;
		case MFMailComposeResultSaved:
			resultMessage = @"Ваше письмо сохранено";
			break;
		case MFMailComposeResultSent:
			resultMessage = @"Ошибка отправки";
			break;
		case MFMailComposeResultFailed:
			resultMessage = @"Ошибка отправки";
			break;
		default:
			resultMessage = @"Письмо не отправлено";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];    
    [self showAlert:resultMessage];
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark SMS Delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    NSString *resultMessage = @"";
	switch (result)
	{
		case MessageComposeResultCancelled:
			resultMessage = @"Отправка отменена";
			break;
		case MessageComposeResultSent:
			resultMessage = @"Ваше сообщение отправлено";
			break;
		case MessageComposeResultFailed:
			resultMessage = @"Ошибка отправки";
			break;
		default:
			resultMessage = @"Сообщение не отправлено";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
    [self showAlert:resultMessage];
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark ALERT Methods
-(void)showAlert:(NSString*)message
{
    DLog(@"");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Сообщение" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"ОК", nil];
    [alertView show];
    [alertView autorelease];
}
//-----------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"");
}
//-----------------------------------------------------------------------------------
@end
