//
//  MyLabel.m
//  RussianToast
//
//  Created by Евгений Иванов on 11.11.12.
//
//

#import "MyLabel.h"

@implementation MyLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {5, 5, 0, 5};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
