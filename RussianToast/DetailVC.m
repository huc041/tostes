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
#define POST_TO_FACEBOOK 45
#define POST_TO_TWITTER 46

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
    
    NSLog(@"middle - %f",CGRectGetMidX(toolBarView.frame));
    
    NSArray *arrayRects = @[NSStringFromCGRect(CGRectMake(CGRectGetMidX(toolBarView.frame) - 2*46.0f - 38.0f, 10.0, 27, 27)),
                            NSStringFromCGRect(CGRectMake(CGRectGetMidX(toolBarView.frame) - 41.0f - 28.0f, 10.0, 27, 27)),
                            NSStringFromCGRect(CGRectMake(CGRectGetMidX(toolBarView.frame) - 14.0f, 10.0, 28, 28)),
                            NSStringFromCGRect(CGRectMake(CGRectGetMidX(toolBarView.frame) + 41.0f, 10.0, 27, 27)),
                            NSStringFromCGRect(CGRectMake(CGRectGetMidX(toolBarView.frame) + 2*46.0f + 10.0f, 10.0, 27, 27))];
    
    NSArray *arrayImages = @[@"previosBtn.png",@"plus.png",@"favorite.png",@"minus.png",@"nextBtn.png"];
    for (int j =0; j < [arrayRects count] ; j++ )
    {
        UIButton *toolBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toolBarButton.tag  = BUTTON_OFFSET_TAG + j;
        toolBarButton.frame = CGRectFromString([arrayRects objectAtIndex:j]);
        [toolBarButton setImage:[UIImage imageNamed:[arrayImages objectAtIndex:j]] forState:UIControlStateNormal];
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
    
    [self setFavotiteButtonStatus];
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
            
            [self setFavotiteButtonStatus];
        }
    }
    else if (button.tag == BUTTON_OFFSET_TAG + 1)         // increase font
    {
        if(fontSize < 35)
            fontSize +=5;
        textView.font = [UIFont fontWithName:@"MyriadPro-It" size:fontSize];
    }
    else if (button.tag == BUTTON_OFFSET_TAG + 2)
    {
        button.selected = !button.selected;
        
        NSString *imageButtonStr = (button.selected) ? @"favorite_sel.png" : @"favorite.png";
        [button setImage:[UIImage imageNamed:imageButtonStr] forState:UIControlStateNormal];
        
        media.isFavorite = [NSNumber numberWithBool:button.selected];
        [CoreDataManager saveMainContext];
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
            
            [self setFavotiteButtonStatus];
        }
    }
    else
        NSLog(@"Aa press");
}
//-----------------------------------------------------------------------------------
-(void)setFavotiteButtonStatus
{
    // кнопка Избранное
    UIButton *buttonFavorite = (UIButton*)[toolBarView viewWithTag:BUTTON_OFFSET_TAG + 2];
    buttonFavorite.selected = [media.isFavorite boolValue];
    
    NSString *imageButtonStr = (buttonFavorite.selected) ? @"favorite_sel.png" : @"favorite.png";
    [buttonFavorite setImage:[UIImage imageNamed:imageButtonStr] forState:UIControlStateNormal];
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark Share Press
-(void)sharePress
{
    DLog(@"");
    UIActionSheet *actionSheet = nil;
    if(isGreatThanIOS5)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Поделиться :" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:@"отправить на почту" otherButtonTitles:@"отправить по смс",@"Facebook",@"Twitter", nil];
    }
    else
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Поделиться" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:@"отправить на почту" otherButtonTitles:@"отправить по смс", nil];
    
    actionSheet.destructiveButtonIndex = -1;
    [actionSheet showInView:self.view];
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if(buttonIndex == 0)
        [self sendMail];
    else if ( buttonIndex == actionSheet.firstOtherButtonIndex)
        [self sendSMS];
    else if (isGreatThanIOS5 && buttonIndex == actionSheet.firstOtherButtonIndex + 1)
        [self sendToSocialNetworkWithIndex:POST_TO_FACEBOOK];
    else if (isGreatThanIOS5 && buttonIndex == actionSheet.firstOtherButtonIndex + 2)
        [self sendToSocialNetworkWithIndex:POST_TO_TWITTER];
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
-(void)sendToSocialNetworkWithIndex:(int)indexSN
{
    DLog(@"");
    
    NSString *titleAlert = (indexSN == POST_TO_FACEBOOK) ? @"Facebook" : @"Twitter";
    NSString *typeSocialNetwork = (indexSN == POST_TO_FACEBOOK) ? SLServiceTypeFacebook : SLServiceTypeTwitter;
    
    if([SLComposeViewController isAvailableForServiceType:typeSocialNetwork])
    {
        mySLComposeViewController = [SLComposeViewController composeViewControllerForServiceType:typeSocialNetwork];
        [mySLComposeViewController setInitialText:[NSString stringWithFormat:@"%@",media.fullText]];
        [self presentViewController:mySLComposeViewController animated:YES completion:nil];
    }
    
    [mySLComposeViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSLog(@"facebook posting result");
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Операция отменена";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Успешная отправка";
                break;
            default:
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",titleAlert] message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert autorelease];
    }];
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
