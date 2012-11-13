//
//  DetailVC.h
//  RussianToast
//
//  Created by Евгений Иванов on 23.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDB.h"

@interface SubGroupsVC : RootVC <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>

{
//    NSString *idParent;
    
    UITableView *table;
    NSFetchedResultsController *detailFetchResultController;
}

@property (nonatomic,retain)          GroupDB *parentGroup;
@property (nonatomic,readonly,retain) NSFetchedResultsController *detailFetchResultController;

@end
