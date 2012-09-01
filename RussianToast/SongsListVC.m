//
//  SongsListVC.m
//  RussianToast
//
//  Created by Евгений Иванов on 01.09.12.
//
//

#import "SongsListVC.h"
#import "MediaDB.h"
#import "WebViewVC.h"

@interface SongsListVC ()

@end

@implementation SongsListVC

-(void)dealloc
{
    [songsListArray release];
    [alphabet release];
    [dicSongs release];
    
    [super dealloc];
}
//-------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
                
        dicSongs = [NSMutableDictionary new];
        
        alphabet = [[NSArray alloc]initWithObjects:@"А",@"Б",@"В",@"Г",@"Д",@"Е",@"Ж",@"З",@"И",@"К",@"Л",
                    @"М",@"Н",@"О",@"П",@"Р",@"С",@"Т",@"У",@"Ф",@"Х",@"Ц",@"Ч",@"Ш",@"Щ",@"Э",@"Ю",@"Я",nil];
        
        for (int j = 0;j < [alphabet count]; j++) {
            
            NSString *strREx = [NSString stringWithFormat:@"fullText BEGINSWITH[cd] '%@'",[alphabet objectAtIndex:j]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:strREx];
            NSArray *tempArray = [CoreDataManager objects:@"MediaDB" withPredicate:predicate inMainContext:YES];
            if([tempArray count] > 0)
                [dicSongs setObject:tempArray forKey:[alphabet objectAtIndex:j]];
        }
    }
    return self;
}
//--------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
	return [alphabet count];
}
//-----------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}
//-----------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
//    if ([aTableView numberOfRowsInSection:section] == 0)
//        return nil;
    
    return [alphabet objectAtIndex:section];
}
//-----------------------------------------------------------------------------------
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return alphabet;
}
//-----------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [alphabet indexOfObject:title];
}
//-----------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dicSongs objectForKey:[alphabet objectAtIndex:section]] count];
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
    
    NSArray *arraySongsWithCurrentBeginSymbols = [dicSongs objectForKey:[alphabet objectAtIndex:indexPath.section]];
    MediaDB *mediaDB = (MediaDB*)[arraySongsWithCurrentBeginSymbols objectAtIndex:indexPath.row];
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
    
    NSArray *arraySongsWithCurrentBeginSymbols = [dicSongs objectForKey:[alphabet objectAtIndex:indexPath.section]];
    MediaDB *mediaDB = (MediaDB*)[arraySongsWithCurrentBeginSymbols objectAtIndex:indexPath.row];
    if(mediaDB)
    {
        WebViewVC *webViewVC = [[[WebViewVC alloc] initWithTextData:mediaDB.fullText] autorelease];
        [webViewVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:webViewVC animated:YES];
    }
}
//-----------------------------------------------------------------------------------

@end
