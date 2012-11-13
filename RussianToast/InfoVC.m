//
//  InfoVC.m
//  RussianToast
//
//  Created by Евгений Иванов on 04.11.12.
//
//

#import "InfoVC.h"

@interface InfoVC ()
@end

static NSString *textInfo =
@"<html>"
@"<head>"
//@"<link href=\"aboutApp.css\" rel=\"stylesheet\" type=\"text/css\">"
@"</head>"
@"<style>"
@"p {font-size: 11pt;font-family: MyriadPro-Bold;align-left;}"
@"iframe {background: none;}"
@"body {background: none;font-size: 11pt;font-family: MyriadPro-It;align-left;}"
@"</style>"
@"<body>"
@"<p>"
@"iТосты v1.0:"
@"</p>"
@"Это приложение создано специально для тех, кому надоело молчать за праздничным "
@"столом или желать друзьям и знакомым только счастья и здоровья. "
@"<br>"
@"<br>"
@"Давайте мыслить шире!"
@"<br>"
@"<br>"
@"Согласитесь, что девушкам на день рождения гораздо приятнее «получить» богатого "
@"любовника, чем абстрактное счастье."
@"А Вашему начальнику вместо банального "
@"пожелания успехов в работе явно придется по душе Ваше искреннее пожелание "
@"стать хозяином простой маленькой хижины в два этажа с бассейном, джакузи и "
@"личной массажисткой мизинчиков, на берегу Карибского моря."
@"<br>"
@"<br>"
@"В этом приложении собраны более 1000 тостов и поздравлений, благодаря которым "
@"Вы будете в центре внимания на любом празднике."
@"<p>"
@"Как это работает:"
@"</p>"
@"Теперь Вам не нужно ломать голову над очередной поздравительной смской. Мы "
@"придумали все за Вас! Вам осталось только выбрать и отправить."
@"<br>"
@"<br>"
@"Пользуйтесь, друзья!"
@"<br>"
@"<br>"
@"Большого Вам бочонка мёда и морского песка в трусах!"
@"<br>"
@"<p>"
@"Что ожидается:"
@"</p>"
@"- расширение контента и функционала приложения"
@"<p>"
@"Техподдержка:"
@"</p>"
@"В случае возникновения проблем с функционированием приложения или если Вы "
@"нашли ошибку, просьба связаться с нами по e-mail: <a href=\"mailto:ivan.polyntsev@gmail.com\">ivan.polyntsev@gmail.com</a>"
@"<br>"
@"<br>"
@"© 2012. All Rights Reserved"
@"<br>"
@"<br>"
@"Издатель: Ivan Polyntsev (<a href=\"mailto:ivan.polyntsev@gmail.com\">ivan.polyntsev@gmail.com</a>)"
@"<br>"
@"<br>"
@"Разработчик: Evgeny Ivanov(<a href=\"mailto:jovanny041@gmail.com\">jovanny041@gmail.com</a>)"
@"<br>"
@"<br>"
@"Дизайнер: Olga Chuykova (<a href=\"mailto:olgachuykova@gmail.com\">olgachuykova@gmail.com</a>)"
@"</body>"
@"</html>";


@implementation InfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Название
    UIButton *titleBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBarButton setBackgroundColor:[UIColor clearColor]];
    titleBarButton.titleLabel.shadowColor = RGB_Color(190, 157, 96, 1.0f);
    titleBarButton.titleLabel.shadowOffset = CGSizeMake(-0.3f, 0.3f);
    titleBarButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:16];
    [titleBarButton setTitle:@"Инфо" forState:UIControlStateNormal];
    [titleBarButton setTitleColor:RGB_Color(66.0f, 42.0f, 2.0f, 1.0f) forState:UIControlStateNormal];
    [titleBarButton setTitleEdgeInsets:UIEdgeInsetsMake(7.0f, 5.0f, 1.0f, -2.0f)];
    titleBarButton.frame = CGRectMake(0, 0, 150, 27);
    self.navigationItem.titleView= titleBarButton;
    
    // кнопка Назад
    UIButton *toolBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    toolBarButton.frame = CGRectMake(0, 0, 58, 25);
    [toolBarButton addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *leftBarItem = [[[UIBarButtonItem alloc] init] autorelease];
    leftBarItem.customView = toolBarButton;
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 46.0f)] autorelease];
    webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];
    
//    NSURL * _URLForHTMLFile = [[NSBundle mainBundle] URLForResource:@"aboutApp" withExtension:@"html"];
//    
//    [webView loadHTMLString:[NSString stringWithContentsOfURL:_URLForHTMLFile
//                                                          encoding:NSUTF8StringEncoding error:nil]
//                         baseURL:_URLForHTMLFile];
    
    [webView loadHTMLString:textInfo baseURL:nil];
    [self.view addSubview:webView];
}

-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{    
    DLog(@"");
    // Проверяем тип обрабатываемого события
    if (navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeFormSubmitted)
    {
        NSString *requestURLString = request.URL.absoluteString;
        // Проверяем возможные варианты обработки request - Почта, телефон, ссылка
        if ([[requestURLString substringToIndex:7] isEqualToString:@"mailto:"])
        {
            // Почта
            if ([MFMailComposeViewController canSendMail])
            {
                // Если отправка почты возможна, то проверяем на какую почту посылать и выбираем тему письма
                NSString *subject = @"[iTostes] Отзыв о приложении для iPhone";
                
                MFMailComposeViewController *mailVC = [MFMailComposeViewController new];
                [mailVC setSubject:subject];
                [mailVC setMailComposeDelegate:self];
                [mailVC setToRecipients:@[ [requestURLString substringFromIndex:7] ]];
                [self presentModalViewController:mailVC animated:YES];
                [mailVC release];
            }
        }
        return NO;
    }
    return YES;
}

#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    // Если не удалось отправить письмо, то оповещаем об этом пользователя
    if (result == MFMailComposeResultFailed)
        ALERT_VIEW(@"Внимание", @"Ошибка отправки сообщения");
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
