//
//  MainVC.h
//  ExperimentProject
//
//  Created by Евгений Иванов on 28.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainVC : UIViewController <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
{
    UITableView *table;
    
    NSFetchedResultsController *fetchResultController;
}

@property (nonatomic,readonly,retain)NSFetchedResultsController *fetchResultController;

@end
