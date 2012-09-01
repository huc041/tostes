//
//  SongsListVC.h
//  RussianToast
//
//  Created by Евгений Иванов on 01.09.12.
//
//

#import <UIKit/UIKit.h>

@interface SongsListVC : UIViewController <UITableViewDataSource,UITableViewDelegate>

{
    NSArray *songsListArray;
    NSArray *alphabet;
    NSMutableDictionary *dicSongs;
    
    UITableView *table;
}

@end
