//
//  CustomNabBar.m
//  RussianToast
//
//  Created by Евгений Иванов on 10.11.12.
//
//

#import "CustomNabBar.h"

@implementation CustomNabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setTitleTextAttributes:(NSDictionary *)titleTextAttributes
{
    
}

-(void)setTitleLableWithTitle:(NSString *)title
{
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake((320 - 150)/2, 0, 150, 30)] autorelease];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor greenColor];
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:@"Myriad pro" size:16];
    self.topItem.titleView= titleLabel;
}


@end
