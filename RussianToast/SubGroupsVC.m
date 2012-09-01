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
    [classParentName release];
    [idParent release];
    
    [super dealloc];
}
//--------------------------------------------------------------------
- (id)initWithNameParentClass:(NSString*)parentClass WithIDParent:(NSString*)parentID FromSubGroup:(BOOL)isSub
{
    self = [super init];
    if (self) 
    {
        // Custom initialization
        
        classParentName = [[NSString alloc] initWithString:parentClass];
        idParent        = [[NSString alloc] initWithString:parentID];
        isSubGroup = isSub;
    }
    return self;
}
//--------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"Главная";
    
    table = [[UITableView alloc] initWithFrame:self.view.bounds];
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
    Class myClass = (NSClassFromString(classParentName));
    myClass = [self.detailFetchResultController.fetchedObjects objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"id";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!cell)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
    
    if([classParentName isEqualToString:@"GroupDB"])
        cell.textLabel.text = ((GroupDB*)myClass).name;
    else 
        cell.textLabel.text = ((MediaDB*)myClass).fullText;

	return cell;
}
//-----------------------------------------------------------------------------------
#pragma mark -
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DLog(@"");
    
    GroupDB *currentSubGroup = [self.detailFetchResultController.fetchedObjects objectAtIndex:indexPath.row];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"idSubGroup == %@",currentSubGroup.id]];
    
    NSArray *arrayMediaObjectsInSubGroup = [CoreDataManager objects:@"MediaDB" withPredicate:predicate1 inMainContext:YES];
    if([arrayMediaObjectsInSubGroup count] > 0)
    {
        MediaListTableVC *tableVC = [[[MediaListTableVC alloc] initWithMediaArray:arrayMediaObjectsInSubGroup] autorelease];
        [self.navigationController pushViewController:tableVC animated:YES];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:classParentName inManagedObjectContext:CoreDataManager.shared.managedObjectContext];
    [request setEntity:entity];
    [request setFetchLimit:10];
    [request setFetchBatchSize:200];    
    
    NSString *predicate;    
    if([classParentName isEqualToString:@"GroupDB"])
    {
        predicate = [NSString stringWithFormat:@"idParent == %@",idParent];
        [request setSortDescriptors:[NSArray arrayWithObjects:
                                     [[[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO] autorelease],
                                     nil]];
    }
    else if(isSubGroup){
        predicate = [NSString stringWithFormat:@"idSubGroup == %@",idParent];
        [request setSortDescriptors:[NSArray arrayWithObjects:
                                     [[[NSSortDescriptor alloc] initWithKey:@"fullText" ascending:NO] autorelease],
                                     nil]];
    }
    else {
        predicate = [NSString stringWithFormat:@"idGroup == %@",idParent];
        [request setSortDescriptors:[NSArray arrayWithObjects:
                                     [[[NSSortDescriptor alloc] initWithKey:@"fullText" ascending:NO] autorelease],
                                     nil]];
    }
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
