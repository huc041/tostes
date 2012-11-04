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

static NSString *textInfo = @"Это приложение создано специально для тех, кому надоело молчать за праздничным"
@"столом или желать друзьям и знакомым только счастья и здоровья."
@"Давайте мыслить шире!"

@"Ведь девушкам на день рождения гораздо приятнее «получить» богатого"
@"любовника, чем абстрактное счастье. А Вашему начальнику вместо банального"
@"пожелания успехов в работе явно придется по душе Ваше искреннее пожелание"
@"стать хозяином простой маленькой хижины в два этажа с бассейном, джакузи и"
@"личной массажисткой мизинчиков, на берегу Карибского моря."

@"В этом приложении собраны более 1000 тостов и поздравлений, благодаря которым"
@"Вы будете в центре внимания на любом празднике."

@"Теперь Вам не нужно ломать голову над очередной поздравительной смской. Мы"
@"придумали все за Вас! Вам осталось только выбрать и отправить."

@"Пользуйтесь, друзья!"

@"Большого Вам бочонка мёда и морского песка в трусах!";

@implementation InfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    textView = [[[UITextView alloc] initWithFrame:self.view.bounds] autorelease];
    textView.backgroundColor = [UIColor whiteColor];
    textView.textAlignment = UITextAlignmentCenter;
    textView.text = textInfo;
    [self.view addSubview:textView];
}

//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:YES];
//    self.tabBarController.tabBar.hidden = NO;
//}

@end
