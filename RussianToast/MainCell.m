//
//  MainCell.m
//  RussianToast
//
//  Created by Евгений Иванов on 10.11.12.
//
//

#import "MainCell.h"

#define HEIGHT_CELL 120

@implementation MainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIView *backView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
        backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellView"]];
        self.backgroundView = backView;
        
        UIImageView*imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(320 - 89 - 20, (HEIGHT_CELL - 79)/2, 89, 79)] autorelease];
        [self.contentView addSubview:imageView];
        self.myImageView = imageView;

    }
    return self;
}

@end
