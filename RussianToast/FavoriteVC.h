//
//  FavoriteVC.h
//  RussianToast
//
//  Created by Евгений Иванов on 22.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteVC : UIViewController <UITableViewDelegate,UITableViewDataSource>

{
    
    BOOL isReady;
    UITableView *table;
    
    NSMutableDictionary *dic;
}

@end
