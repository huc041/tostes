//
//  DetailVC.m
//  RussianToast
//
//  Created by Евгений Иванов on 23.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubGroupsVC.h"
#import "GroupDB.h"
#import "MediaDB.h"
#import "MediaListTableVC.h"

@interface SubGroupsVC ()

@end

@implementation SubGroupsVC

@synthesize detailFetchResultController;

//--------------------------------------------------------------------
-(void)dealloc
{
    [idParent release];    
    [super dealloc];
}
//--------------------------------------------------------------------
- (id)initWithWithIDParent:(NSString*)parentID
{
    self = [super init];
    if (self) 
    {
        idParent = [[NSString alloc] initWithString:parentID];
    }
    return self;
}
//--------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"Главная";
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49.0f - 46.0f)];
    table.backgroundColor = [UIColor darkGrayColor];
    table.delegate = self;
    table.dataSource = self;
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
	return 60;
}
//-----------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"detail objects - %d",[self.detailFetchResultController.fetchedObjects count]);
    return [self.detailFetchResultController.fetchedObjects count];
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
    
    GroupDB *subGroup = [self.detailFetchResultController.fetchedObjects objectAtIndex:indexPath.row];
    if(subGroup)
        cell.textLabel.text = subGroup.name;

	return cell;
}
//-----------------------------------------------------------------------------------
#pragma mark -
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DLog(@"");
    GroupDB *currentSubGroup = [self.detailFetchResultController.fetchedObjects objectAtIndex:indexPath.row];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"idGroup == %@",currentSubGroup.id]];
    NSArray *arraySubGroups = [CoreDataManager objects:@"GroupDB" withPredicate:predicate inMainContext:YES];
    // проверяем,есть ли подгруппы,если есть - переходим на аналогичный экран,если нет - на экран Media
    if([arraySubGroups count] > 0)
    {
        SubGroupsVC *detailVC = [[SubGroupsVC alloc] initWithWithIDParent:[NSString stringWithFormat:@"%@",currentSubGroup.id]];
        [self.navigationController pushViewController:detailVC animated:YES];
        [detailVC release];
    }
    else
    {
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"idGroup == %@",currentSubGroup.id]];
        NSArray *arrayMediaObjectsInSubGroup = [CoreDataManager objects:@"MediaDB" withPredicate:predicate1 WithSortArray:
                                                [NSArray arrayWithObjects:[[[NSSortDescriptor alloc] initWithKey:@"fullText" ascending:YES] autorelease],nil]
                                                          WithAscending:YES inMainContext:YES];
        if([arrayMediaObjectsInSubGroup count] > 0)
        {
            MediaListTableVC *tableVC = [[[MediaListTableVC alloc] initWithMediaArray:arrayMediaObjectsInSubGroup] autorelease];
            [self.navigationController pushViewController:tableVC animated:YES];
        }
    }
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark NSFetchedResultsController Delegate
- (NSFetchedResultsController*) detailFetchResultController
{
    if (detailFetchResultController != nil)
    {
        detailFetchResultController.delegate = (id <NSFetchedResultsControllerDelegate>) self;
        return detailFetchResultController;     
    }
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GroupDB" inManagedObjectContext:CoreDataManager.shared.managedObjectContext];
    [request setEntity:entity];
    [request setFetchLimit:100];
    [request setFetchBatchSize:200];    
    
    NSString *predicate = [NSString stringWithFormat:@"idParent == %@",idParent];
    [request setSortDescriptors:[NSArray arrayWithObjects:
                                     [[[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO] autorelease],
                                     nil]];
    [request setPredicate:[NSPredicate predicateWithFormat:predicate]];

    detailFetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:CoreDataManager.shared.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    detailFetchResultController.delegate = (id <NSFetchedResultsControllerDelegate>) self;
    
    NSError *error = nil;
    @try {
        
        if (![detailFetchResultController performFetch:&error])
        {
            //abort();
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"NewRead:::Context: %@", CoreDataManager.shared.managedObjectContext);
    }
    
    return detailFetchResultController;
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
@end
