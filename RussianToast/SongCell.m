//
//  SongCell.m
//  RussianToast
//
//  Created by Евгений Иванов on 11.11.12.
//
//

#import "SongCell.h"

@implementation SongCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIView *backView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
        backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"smallCellView.png"]];
        self.backgroundView = backView;
    }
    return self;
}

@end
