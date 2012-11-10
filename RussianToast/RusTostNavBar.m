//
//  RusTostNavBar.m
//  RussianToast
//
//  Created by Евгений Иванов on 10.11.12.
//
//

#import "RusTostNavBar.h"

@implementation RusTostNavBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    }
    return self;
}

@end
