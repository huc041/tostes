//
//  TableCurrentObjVC.h
//  RussianToast
//
//  Created by Евгений Иванов on 04.08.12.
//
//

#import <UIKit/UIKit.h>

@interface MediaListTableVC : RootVC <UITableViewDataSource,UITableViewDelegate>

{
    NSArray *mediaArray;
    UITableView *table;
}

- (id)initWithMediaArray:(NSArray*)arrayData;

@end
