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
#import "WebViewVC.h"

@interface FavoriteVC ()

@end

@implementation FavoriteVC

//-----------------------------------------------------------------------------------
-(void)dealloc
{
    [dic release];
    [super dealloc];
}
//-----------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
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
    
    dic = [NSMutableDictionary new];
    
    isReady = NO;
}
//-----------------------------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated
{
    isReady = YES;
    [table reloadData];
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!isReady)
        return 0;
    else
    {
        [self saveDataToDictionary];
        return [[dic allKeys] count];
    }
}
//-----------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleSection = @"";
    
    GroupDB *group = [self getGroupWithIndexSetion:section];
    if(group) titleSection = group.name;
    return titleSection;
}
//-----------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}
//-----------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GroupDB *group = [self getGroupWithIndexSetion:section];
    return [[[dic objectForKey:group.name] allObjects] count];
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
    
    GroupDB *group = [self getGroupWithIndexSetion:indexPath.section];
    MediaDB *media = [[[dic objectForKey:group.name] allObjects] objectAtIndex:indexPath.row];
    if(media)
        cell.textLabel.text = media.fullText;
    
	return cell;
}
//-----------------------------------------------------------------------------------
#pragma mark -
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");
    GroupDB *group = [self getGroupWithIndexSetion:indexPath.section];
    MediaDB *mediaDB = [[[dic objectForKey:group.name] allObjects] objectAtIndex:indexPath.row];
    if(mediaDB)
    {
        WebViewVC *webViewVC = [[WebViewVC alloc] init];
        webViewVC.media = mediaDB;
        [webViewVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:webViewVC animated:YES];
        [webViewVC release];
    }
}
//-----------------------------------------------------------------------------------
-(GroupDB*)getGroupWithIndexSetion:(int)section
{    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"ANY media.isFavorite == 1"]];
    NSArray *arrayobjects = [CoreDataManager objects:@"GroupDB" withPredicate:predicate WithSortArray:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES]autorelease]] WithAscending:YES inMainContext:YES];
    GroupDB *curGroup = [arrayobjects objectAtIndex:section];
    
    return curGroup;
}
//-----------------------------------------------------------------------------------
-(void)saveDataToDictionary
{
    NSString *predicateString = [NSString stringWithFormat:@"ANY media.isFavorite == 1"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    NSArray *arrayGroups = [CoreDataManager objects:@"GroupDB" withPredicate:predicate inMainContext:YES];
    
    if(!dic) dic = [NSMutableDictionary new];
    [dic removeAllObjects];
    for (GroupDB *group in arrayGroups) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"idGroup == %@ AND isFavorite == 1",group.id]];
        NSArray *arrayMediaObjects = [CoreDataManager objects:@"MediaDB" withPredicate:predicate inMainContext:YES];
        [dic setObject:arrayMediaObjects forKey:group.name];
    }
}
//-----------------------------------------------------------------------------------
@end
