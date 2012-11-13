//
//  WebViewVC.m
//  RussianToast
//
//  Created by Евгений Иванов on 04.08.12.
//
//

#import "DetailVC.h"
#import "MediaDB.h"
#import "InfoVC.h"

@interface DetailVC ()

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

@implementation DetailVC

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
    UIButton *toolBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolBarButton setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    toolBarButton.frame = CGRectMake(0, 0, 33, 25);
    [toolBarButton addTarget:self action:@selector(sharePress) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *rightBarItem = [[[UIBarButtonItem alloc] init] autorelease];
    rightBarItem.customView = toolBarButton;
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    CGRect rectTextView = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49.0f - 46.0f);
    
    textView = [[UITextView alloc] initWithFrame:rectTextView];
    textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgrnd.png"]];
    textView.textAlignment = UITextAlignmentCenter;
    textView.font = [UIFont fontWithName:@"MyriadPro-It" size:16];
    textView.editable = NO;
    [self.view addSubview:textView];
    
    toolBarView  = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame) + 1, self.view.bounds.size.width, 49.0f)];
    toolBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar.png"]];
    [self.view addSubview:toolBarView];
    [toolBarView release];
    
    NSArray *arrayRects = @[NSStringFromCGRect(CGRectMake(CGRectGetMidX(toolBarView.frame) - 2*46.0f - 28.0f, 9.5, 28, 28)),
                            NSStringFromCGRect(CGRectMake(CGRectGetMidX(toolBarView.frame) - 46.0f - 28.0f, 9.5, 28, 28)),
                            NSStringFromCGRect(CGRectMake(CGRectGetMidX(toolBarView.frame) - 20.0f, 12.0, 39, 23)),
                            NSStringFromCGRect(CGRectMake(CGRectGetMidX(toolBarView.frame) + 46.0f, 9.5, 28, 28)),
                            NSStringFromCGRect(CGRectMake(CGRectGetMidX(toolBarView.frame) + 2*46.0f, 9.5, 28, 28)),
                            NSStringFromCGRect(CGRectMake(320.0f - 10.0f - 23.0f, 9.5, 28, 28))];
    
    NSArray *arrayImages = @[@"pusto 1",@"plus.png",@"Aa.png",@"minus.png",@"pusto 2",@"favorite.png"];
    for (int j =0; j < [arrayRects count] ; j++ )
    {
        UIButton *toolBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if(j == 0)
            toolBarButton.backgroundColor = [UIColor redColor];
        else if(j == 4)
            toolBarButton.backgroundColor = [UIColor greenColor];
        else 
            toolBarButton.backgroundColor = [UIColor clearColor];
        
        toolBarButton.tag  = BUTTON_OFFSET_TAG + j;
        toolBarButton.frame = CGRectFromString([arrayRects objectAtIndex:j]);
        [toolBarButton setBackgroundImage:[UIImage imageNamed:[arrayImages objectAtIndex:j]] forState:UIControlStateNormal];
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
        
    textView.font = [UIFont fontWithName:@"MyriadPro-It" size:fontSize];
    textView.text = media.fullText;
    
    // кнопка Избранное
    UIButton *buttonFavorite = (UIButton*)[toolBarView viewWithTag:BUTTON_OFFSET_TAG + 5];
    buttonFavorite.selected = [media.isFavorite boolValue];
    
    NSString *imageButtonStr = (buttonFavorite.selected) ? @"favorite_sel.png" : @"favorite.png";
    [buttonFavorite setBackgroundImage:[UIImage imageNamed:imageButtonStr] forState:UIControlStateNormal];
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
    if(button.tag == BUTTON_OFFSET_TAG) // previos
    {
        NSPredicate *predic = [NSPredicate predicateWithFormat:@"idGroup == %d AND identifier == %d",[media.idGroup integerValue],[media.identifier integerValue] - 1];
        MediaDB *previosObject = [CoreDataManager object:@"MediaDB" predicate:predic inMainContext:YES];
        
        UIButton *nextButton = (UIButton*)[toolBarView viewWithTag:BUTTON_OFFSET_TAG + 4];
        nextButton.alpha = 1.0f;
        
        button.alpha = (previosObject == nil)? 0 : 1;
        if(previosObject)
        {
            self.media = previosObject;
            textView.text = media.fullText;
        }
    }
    else if (button.tag == BUTTON_OFFSET_TAG + 1)         // increase font
    {
        if(fontSize < 35)
            fontSize +=5;
        textView.font = [UIFont fontWithName:@"MyriadPro-It" size:fontSize];
    }
    else if(button.tag == BUTTON_OFFSET_TAG + 3) // decrease font
    {
        if(fontSize > 10)
            fontSize -=5;
        
        textView.font = [UIFont fontWithName:@"MyriadPro-It" size:fontSize];
    }
    else if(button.tag == BUTTON_OFFSET_TAG + 4) // next
    {
        NSPredicate *predicNext = [NSPredicate predicateWithFormat:@"idGroup == %d AND identifier == %d",[media.idGroup integerValue],[media.identifier integerValue] + 1];;
        MediaDB *nextObject = [CoreDataManager object:@"MediaDB" predicate:predicNext inMainContext:YES];
        
        UIButton *previosButton = (UIButton*)[toolBarView viewWithTag:BUTTON_OFFSET_TAG];
        previosButton.alpha = 1.0f;
        
        button.alpha = (nextObject == nil)? 0 : 1;
        if(nextObject)
        {
            self.media = nextObject;
            textView.text = media.fullText;
        }
    }
    else if (button.tag == BUTTON_OFFSET_TAG + 5)
    {
        button.selected = !button.selected;
        
        NSString *imageButtonStr = (button.selected) ? @"favorite_sel.png" : @"favorite.png";        
        [button setBackgroundImage:[UIImage imageNamed:imageButtonStr] forState:UIControlStateNormal];
        
        media.isFavorite = [NSNumber numberWithBool:button.selected];
        [CoreDataManager saveMainContext];
    }
    else
        NSLog(@"Aa press");
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark Share Press
-(void)sharePress
{
    DLog(@"");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Поделиться" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:@"отправить на почту" otherButtonTitles:@"отправить по смс", nil];
    
//    - (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated NS_AVAILABLE_IOS(3_2);

    
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
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:@"Прекрасные слова..."];
        // Fill out the email body text
        [picker setMessageBody:media.fullText isHTML:NO];
        [self presentViewController:picker animated:YES completion:^{}];
        [picker release];
    }
    else
        [self showAlert:@"Возможно у Вас не настроен почтовый клиент"];
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
    DLog(@"error text - %@",error.userInfo);
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
			resultMessage = @"Ваше письмо успешно отправлено";
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
-(void)infoPress
{
    InfoVC *infoVC = [[[InfoVC alloc] init] autorelease];
    [infoVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:infoVC animated:YES];
}
//--------------------------------------------------------------------
@end
