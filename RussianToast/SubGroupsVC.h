//
//  DetailVC.h
//  RussianToast
//
//  Created by Евгений Иванов on 23.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubGroupsVC : UIViewController <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>

{
    UITableView *table;
    
    NSString *classParentName;
    NSString *idParent;
    BOOL isSubGroup;
    
    NSFetchedResultsController *detailFetchResultController;
}

@property (nonatomic,readonly,retain)NSFetchedResultsController *detailFetchResultController;

- (id)initWithNameParentClass:(NSString*)parentClass WithIDParent:(NSString*)parentID FromSubGroup:(BOOL)isSub;

@end
