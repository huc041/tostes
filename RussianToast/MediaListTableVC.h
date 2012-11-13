//
//  TableCurrentObjVC.h
//  RussianToast
//
//  Created by Евгений Иванов on 04.08.12.
//
//

#import <UIKit/UIKit.h>
#import "GroupDB.h"

@interface MediaListTableVC : RootVC <UITableViewDataSource,UITableViewDelegate>

{
    NSArray *mediaArray;
    UITableView *table;
}

@property (nonatomic,retain) GroupDB *parentGroup;

- (id)initWithMediaArray:(NSArray*)arrayData;

@end
