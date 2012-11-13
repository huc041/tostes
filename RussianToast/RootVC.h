//
//  RootVC.h
//  RussianToast
//
//  Created by Евгений Иванов on 13.11.12.
//
//

#import <UIKit/UIKit.h>

@interface RootVC : UIViewController

@property (nonatomic,retain) UIButton *navBarTextButton;
@property (nonatomic,retain) UILabel *textLabel;

-(void)setCustomTitle:(NSString*)title;

@end
