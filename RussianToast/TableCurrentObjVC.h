//
//  TableCurrentObjVC.h
//  RussianToast
//
//  Created by Евгений Иванов on 04.08.12.
//
//

#import <UIKit/UIKit.h>

@interface TableCurrentObjVC : UIViewController <UITableViewDataSource,UITableViewDelegate>

{
    NSArray *arrayData;
    UITableView *table;
}

- (id)initWithStringData:(NSString*)strData;

@end
