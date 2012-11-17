//
//  FavoriteVC.m
//  RussianToast
//
//  Created by Евгений Иванов on 22.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoriteVC.h"
#import "MediaDB.h"
#import "GroupDB.h"
#import "DetailVC.h"
#import "MyLabel.h"
#import "InfoVC.h"
#import "SongCell.h"

@interface FavoriteVC ()

@end

@implementation FavoriteVC

//@synthesize fetchFavoriteController;

//-----------------------------------------------------------------------------------
-(void)dealloc
{
    [super dealloc];
}
//-----------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        DLog(@"");
    }
    return self;
}
//-----------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgrnd.png"]];

    // навбар
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = nil;
    [self setCustomTitle:@"Избранное"];
    
    // кнопка Инфо
    UIButton *toolBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolBarButton setBackgroundImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    toolBarButton.frame = CGRectMake(0, 0, 27, 27);
    [toolBarButton addTarget:self action:@selector(infoPress) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *rightBarItem = [[[UIBarButtonItem alloc] init] autorelease];
    rightBarItem.customView = toolBarButton;
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    emptyMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMidX(self.view.frame) - 50.0f, self.view.frame.size.width, 100)];
    emptyMessageLabel.backgroundColor = [UIColor clearColor];
    emptyMessageLabel.font = [UIFont fontWithName:@"Lobster" size:20.0f];
    emptyMessageLabel.textAlignment = UITextAlignmentCenter;
    emptyMessageLabel.textColor = RGB_Color(66.0f, 42.0f, 2.0f, 2.0f);
    emptyMessageLabel.text = @"Список избранного пуст";
    [self.view addSubview:emptyMessageLabel];
    [emptyMessageLabel release];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49.0f - 46.0f)];
    table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgrnd.png"]];
    table.delegate = self;
    table.dataSource = self;
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:table];
    [table release];
}
//-----------------------------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated
{
    if(self.fetchFavoriteController.sections.count == 0)
    {
        table.alpha = 0.0f;
        emptyMessageLabel.alpha = 1.0f;
    }
    else
    {
        table.alpha = 1.0f;
        emptyMessageLabel.alpha = 0.0f;
        [table reloadData];
    }
}
//-----------------------------------------------------------------------------------
-(void)viewDidDisappear:(BOOL)animated
{
    [fetchFavoriteController release], fetchFavoriteController = nil;
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchFavoriteController.sections.count;
}
//-----------------------------------------------------------------------------------
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchFavoriteController sections] objectAtIndex:section];

    MyLabel *sectionLabel = [[[MyLabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30.0f)] autorelease];
    sectionLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sectionView.png"]];
    sectionLabel.textAlignment = UITextAlignmentLeft;
    sectionLabel.textColor = RGB_Color(66.0f, 42.0f, 2.0f, 1.0f);
    sectionLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:16];
    sectionLabel.text = [sectionInfo name];
    return sectionLabel;
}
//-----------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}
//-----------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchFavoriteController sections] objectAtIndex:section];
    return [[sectionInfo objects] count];
}
//-----------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"id";
    SongCell *cell = (SongCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!cell)
	{
		cell = [[[SongCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = RGB_Color(66.0f, 42.0f, 2.0f, 2.0f);
        cell.textLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:16];
	}
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchFavoriteController sections] objectAtIndex:indexPath.section];
    MediaDB *mediaDB = [[sectionInfo objects] objectAtIndex:indexPath.row];
    if(mediaDB)
        cell.textLabel.text = mediaDB.fullText;
    
	return cell;
}
//-----------------------------------------------------------------------------------
#pragma mark -
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");
    
    NSMutableArray *arrayList = [NSMutableArray array];
    for (int section = 0; section < self.fetchFavoriteController.sections.count; section++)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchFavoriteController sections] objectAtIndex:section];
        NSArray *objects = [sectionInfo objects];
        int j = [objects count]-1;
        while (j >= 0) {
            MediaDB *mediaDB = [objects objectAtIndex:j];
            [arrayList addObject:mediaDB];
            j--;
        }
    }
    
    // нужно определить индекс объекта в новом массиве
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchFavoriteController sections] objectAtIndex:indexPath.section];
    MediaDB *mediaDB = [[sectionInfo objects] objectAtIndex:indexPath.row];

    int index = [arrayList indexOfObject:mediaDB];

    DetailVC *detailVC = [[DetailVC alloc] init];
    detailVC.arrayMedia = arrayList;
    detailVC.indexCurrentMedia = index;
    
    [detailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark NSFetchedResultsController Delegate
- (NSFetchedResultsController*) fetchFavoriteController
{
    if (fetchFavoriteController != nil)
    {
        fetchFavoriteController.delegate = (id <NSFetchedResultsControllerDelegate>) self;
        return fetchFavoriteController;
    }
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MediaDB" inManagedObjectContext:CoreDataManager.shared.managedObjectContext];
    [request setEntity:entity];
    [request setFetchLimit:100];
    [request setFetchBatchSize:200];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite == 1"];
    [request setPredicate:predicate];
    [request setSortDescriptors:[NSArray arrayWithObjects:
                                 [[[NSSortDescriptor alloc] initWithKey:@"idGroup" ascending:NO] autorelease],
                                 [[[NSSortDescriptor alloc] initWithKey:@"fullText" ascending:NO] autorelease],
                                 nil]];
    
    fetchFavoriteController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:CoreDataManager.shared.managedObjectContext sectionNameKeyPath:@"nameGroup" cacheName:nil];
    fetchFavoriteController.delegate = (id <NSFetchedResultsControllerDelegate>) self;
    
    NSError *error = nil;
    @try {
        
        if (![fetchFavoriteController performFetch:&error])
        {
            //abort();
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"NewRead:::Context: %@", CoreDataManager.shared.managedObjectContext);
    }
    
    return fetchFavoriteController;
}
//--------------------------------------------------------------------
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    //DLog(@"");
}
//--------------------------------------------------------------------
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
}
//--------------------------------------------------------------------
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //DLog(@"");
//    [table reloadData];
}
//--------------------------------------------------------------------
-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}
//--------------------------------------------------------------------
-(void)infoPress
{
    InfoVC *infoVC = [[[InfoVC alloc] init] autorelease];
    [infoVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:infoVC animated:YES];
}
//--------------------------------------------------------------------
@end
