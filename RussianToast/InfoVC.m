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

static NSString *textInfo = @"Это приложение создано специально для тех, кому надоело молчать за праздничным "
@"столом или желать друзьям и знакомым только счастья и здоровья. "
@"Давайте мыслить шире!"

@"Ведь девушкам на день рождения гораздо приятнее «получить» богатого "
@"любовника, чем абстрактное счастье. А Вашему начальнику вместо банального "
@"пожелания успехов в работе явно придется по душе Ваше искреннее пожелание "
@"стать хозяином простой маленькой хижины в два этажа с бассейном, джакузи и "
@"личной массажисткой мизинчиков, на берегу Карибского моря. "

@"В этом приложении собраны более 1000 тостов и поздравлений, благодаря которым "
@"Вы будете в центре внимания на любом празднике."

@"Теперь Вам не нужно ломать голову над очередной поздравительной смской. Мы "
@"придумали все за Вас! Вам осталось только выбрать и отправить. "

@"Пользуйтесь, друзья!"

@"Большого Вам бочонка мёда и морского песка в трусах!";

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
    
    textView = [[[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 46.0f)] autorelease];
    textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgrnd.png"]];
    textView.textAlignment = UITextAlignmentCenter;
    textView.font = [UIFont fontWithName:@"MyriadPro-It" size:18.0f];
    textView.text = textInfo;
    [self.view addSubview:textView];
}

-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
