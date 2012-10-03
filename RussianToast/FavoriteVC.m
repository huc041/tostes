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
#import "TextViewVC.h"

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
    
    self.view.backgroundColor = [UIColor brownColor];
    self.navigationController.navigationBar.topItem.title = @"Избранное";
        
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49.0f - 46.0f)];
    table.backgroundColor = [UIColor darkGrayColor];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [table release];
}
//-----------------------------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated
{
    [table reloadData];
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
//    DLog(@"section count - %d",self.fetchFavoriteController.sections.count);
//    for (MediaDB*media in self.fetchFavoriteController.fetchedObjects) {
//        NSLog(@"name section - %@",media.nameGroup);
//    }
    
    return self.fetchFavoriteController.sections.count;
}
////-----------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchFavoriteController sections] objectAtIndex:section];
    return [sectionInfo name];
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
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!cell)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchFavoriteController sections] objectAtIndex:indexPath.section];
    MediaDB *mediaDB = [[sectionInfo objects] objectAtIndex:indexPath.row];
    
    TextViewVC *textViewVC = [[TextViewVC alloc] init];
    textViewVC.media = mediaDB;
    
    [textViewVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:textViewVC animated:YES];
    [textViewVC release];
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark NSFetchedResultsController Delegate
- (NSFetchedResultsController*) fetchFavoriteController
{
    DLog(@"");
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
@end
