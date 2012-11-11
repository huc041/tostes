//
//  MainVC.m
//  ExperimentProject
//
//  Created by Евгений Иванов on 28.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainVC.h"
#import "GroupDB.h"
#import "SubGroupsVC.h"
#import "SongsListVC.h"
#import "MediaDB.h"
#import "InfoVC.h"
#import "CustomNabBar.h"
#import "MainCell.h"


static NSArray *arrayImages = nil;

@interface MainVC ()
@end

@implementation MainVC

@synthesize fetchResultController;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        arrayImages = [[NSArray alloc] initWithObjects:@"songs.png",@"celebraties.png",@"toats.png", nil];
    }
    return self;
}
//--------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // навбар
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    // Главная
    UIButton *titleBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBarButton setBackgroundColor:[UIColor clearColor]];
    titleBarButton.titleLabel.shadowColor = RGB_Color(190, 157, 96, 1.0f);
    titleBarButton.titleLabel.shadowOffset = CGSizeMake(-0.3f, 0.3f);
    titleBarButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:16];
    [titleBarButton setTitle:@"Главная" forState:UIControlStateNormal];
    [titleBarButton setTitleColor:RGB_Color(66.0f, 42.0f, 2.0f, 1.0f) forState:UIControlStateNormal];
    [titleBarButton setTitleEdgeInsets:UIEdgeInsetsMake(7.0f, 5.0f, 1.0f, -2.0f)];
    titleBarButton.frame = CGRectMake(0, 0, 150, 27);
    self.navigationItem.titleView= titleBarButton;
    
    // кнопка Инфо
    UIButton *toolBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolBarButton setBackgroundImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    toolBarButton.frame = CGRectMake(0, 0, 27, 27);
    [toolBarButton addTarget:self action:@selector(infoPress) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *rightBarItem = [[[UIBarButtonItem alloc] init] autorelease];
    rightBarItem.customView = toolBarButton;
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    table = [[UITableView alloc] initWithFrame:self.view.bounds];
    table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgrnd.png"]];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:table];
    [table release];
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
//-----------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 120;
}
//-----------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchResultController.fetchedObjects count];
}
//-----------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupDB *groupDB = [self.fetchResultController.fetchedObjects objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"id";
    MainCell *cell = (MainCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!cell)
	{
		cell = [[[MainCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithRed:66.0f/255.0f green:42.0f/255.0f blue:2.0f/255.0f alpha:1.0f];
        cell.textLabel.textColor = RGB_Color(66.0f, 42.0f, 2.0f, 2.0f);
	}
    
    if(groupDB)
        cell.textLabel.text = groupDB.name;
    
    cell.myImageView.image = [UIImage imageNamed:[arrayImages objectAtIndex:indexPath.row]];
    
	return cell;
}
//-----------------------------------------------------------------------------------
#pragma mark -
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DLog(@"");
    
    GroupDB *groupDB = [self.fetchResultController.fetchedObjects objectAtIndex:indexPath.row];
    NSString *predicateSTR = [NSString stringWithFormat:@"idParent == %@",groupDB.id];
    NSArray *arraySubGroups = [CoreDataManager objects:@"GroupDB" withPredicate:[NSPredicate predicateWithFormat:predicateSTR] inMainContext:YES];
    if([arraySubGroups count] == 1) // это песня
    {
        NSPredicate *predicateSongs = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"idGroup == %@",groupDB.id]];
        NSArray *arraySongs = [CoreDataManager objects:@"MediaDB" withPredicate:predicateSongs inMainContext:YES];
        if([arraySongs count] > 0)
        {
            SongsListVC *songsListVC = [[SongsListVC alloc] init];
            [self.navigationController pushViewController:songsListVC animated:YES];
            [songsListVC release];
        }
    }
    else if([arraySubGroups count] > 0)
    {
        SubGroupsVC *detailVC = [[SubGroupsVC alloc] initWithWithIDParent:[NSString stringWithFormat:@"%@",groupDB.id]];
        [self.navigationController pushViewController:detailVC animated:YES];
        [detailVC release];
    }
}
//-----------------------------------------------------------------------------------//-------------------------------------------------------------------------------
#pragma mark
#pragma mark NSFetchedResultsController Delegate
- (NSFetchedResultsController*) fetchResultController
{
    if (fetchResultController != nil)
    {
        fetchResultController.delegate = (id <NSFetchedResultsControllerDelegate>) self;
        return fetchResultController;     
    }
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GroupDB" inManagedObjectContext:CoreDataManager.shared.managedObjectContext];
    [request setEntity:entity];
    [request setFetchLimit:100];
    [request setFetchBatchSize:200];    
    
    [request setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"idParent == 0"]]];
    [request setSortDescriptors:[NSArray arrayWithObjects:
                                 [[[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO] autorelease],
                                 nil]];
    
    fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:CoreDataManager.shared.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    fetchResultController.delegate = (id <NSFetchedResultsControllerDelegate>) self;
    
    NSError *error = nil;
    @try {
        
        if (![fetchResultController performFetch:&error])
        {
            //abort();
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"NewRead:::Context: %@", CoreDataManager.shared.managedObjectContext);
    }
    
    return fetchResultController;
}
//--------------------------------------------------------------------
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    DLog(@"");
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
    DLog(@"");
    [table reloadData];
}
//--------------------------------------------------------------------
-(void)infoPress
{
    InfoVC *infoVC = [[[InfoVC alloc] init] autorelease];    
    [infoVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:infoVC animated:YES];
}
@end
