//
//  RootVC.m
//  RussianToast
//
//  Created by Евгений Иванов on 13.11.12.
//
//

#import "RootVC.h"

@interface RootVC ()

@end

@implementation RootVC

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        // кнопка Назад
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0, 0, 58, 25);
        [backButton addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchDown];
        
        UIBarButtonItem *leftBarItem = [[[UIBarButtonItem alloc] init] autorelease];
        leftBarItem.customView = backButton;
        self.navigationItem.leftBarButtonItem = leftBarItem;
        
        // Главная
        UIButton *titleBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleBarButton setBackgroundColor:[UIColor clearColor]];
        titleBarButton.titleLabel.shadowColor = RGB_Color(190, 157, 96, 1.0f);
        titleBarButton.titleLabel.shadowOffset = CGSizeMake(-0.3f, 0.3f);
        titleBarButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:16];
        [titleBarButton setTitleColor:RGB_Color(66.0f, 42.0f, 2.0f, 1.0f) forState:UIControlStateNormal];
        [titleBarButton setTitleEdgeInsets:UIEdgeInsetsMake(7.0f, 5.0f, 1.0f, -2.0f)];
        titleBarButton.frame = CGRectMake(0, 0, 150, 27);
        self.navigationItem.titleView = titleBarButton;
    }
    return self;
}
//-------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
//-------------------------------------------------------------------------------
-(void)setCustomTitle:(NSString*)title
{
    UIButton *customButton = (UIButton*)self.navigationItem.titleView;
    [customButton setTitle:title forState:UIControlStateNormal];
}
//-------------------------------------------------------------------------------
-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-------------------------------------------------------------------------------
@end
