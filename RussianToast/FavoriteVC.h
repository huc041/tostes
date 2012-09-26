//
//  FavoriteVC.h
//  RussianToast
//
//  Created by Евгений Иванов on 22.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteVC : UIViewController <UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>

{
    UITableView *table;
    NSFetchedResultsController *fetchFavoriteController;
}


@property (nonatomic,readonly,retain) NSFetchedResultsController *fetchFavoriteController;


@end
