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

#define HEIGHT_MAIN_CELL 120.0f

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
        arrayImages = [[NSArray alloc] initWithObjects:@"songs.png",@"toats.png",@"celebraties.png", nil];
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
        
    self.navigationItem.leftBarButtonItem = nil;
    [self setCustomTitle:@"Главная"];
   
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
	return HEIGHT_MAIN_CELL;
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
        cell.textLabel.textColor = RGB_Color(66.0f, 42.0f, 2.0f, 2.0f);
        cell.textLabel.font = [UIFont fontWithName:@"Lobster" size:20.0f];
	}
    
    if(groupDB)
        cell.textLabel.text = groupDB.name;
    
    UIImage *image = [UIImage imageNamed:[arrayImages objectAtIndex:indexPath.row]];
    CGSize sizeImage = image.size;
    
    cell.myImageView.frame = CGRectMake(tableView.frame.size.width - sizeImage.width - 20.0f, (HEIGHT_MAIN_CELL - sizeImage.height)/2, sizeImage.width, sizeImage.height);
    cell.myImageView.image = image;
    
	return cell;
}
//-----------------------------------------------------------------------------------
#pragma mark -
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    GroupDB *groupDB = [self.fetchResultController.fetchedObjects objectAtIndex:indexPath.row];
    NSString *predicateSTR = [NSString stringWithFormat:@"idParent == %@",groupDB.id];
    NSArray *arraySubGroups = [CoreDataManager objects:@"GroupDB" withPredicate:[NSPredicate predicateWithFormat:predicateSTR] inMainContext:YES];
    if(!arraySubGroups) // это песня
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
        SubGroupsVC *detailVC = [[SubGroupsVC alloc] init];
        detailVC.parentGroup = groupDB;
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
//--------------------------------------------------------------------
@end
