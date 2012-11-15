//
//  SongsListVC.m
//  RussianToast
//
//  Created by Евгений Иванов on 01.09.12.
//
//

#import "SongsListVC.h"
#import "MediaDB.h"
#import "DetailVC.h"
#import "SongCell.h"
#import "MyLabel.h"

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
            
            NSString *strREx = [NSString stringWithFormat:@"idGroup == 3 AND fullText BEGINSWITH[cd] '%@'",[alphabet objectAtIndex:j]];
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
    
    // Название
    UIButton *titleBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBarButton setBackgroundColor:[UIColor clearColor]];
    titleBarButton.titleLabel.shadowColor = RGB_Color(190, 157, 96, 1.0f);
    titleBarButton.titleLabel.shadowOffset = CGSizeMake(-0.3f, 0.3f);
    titleBarButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:16];
    [titleBarButton setTitle:@"Застольные песни" forState:UIControlStateNormal];
    [titleBarButton setTitleColor:RGB_Color(66.0f, 42.0f, 2.0f, 1.0f) forState:UIControlStateNormal];
    [titleBarButton setTitleEdgeInsets:UIEdgeInsetsMake(7.0f, 5.0f, 1.0f, -2.0f)];
    titleBarButton.frame = CGRectMake(0, 0, 150, 27);
    self.navigationItem.titleView= titleBarButton;
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49.0f - 46.0f)];
    table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgrnd.png"]];
    table.delegate = self;
    table.dataSource = self;
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([[dicSongs objectForKey:[alphabet objectAtIndex:section]] count] == 0)
        return 0.0f;
    else
        return 30.0f;
}
//-----------------------------------------------------------------------------------
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([[dicSongs objectForKey:[alphabet objectAtIndex:section]] count] == 0)
        return nil;
    
    MyLabel *sectionLabel = [[[MyLabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30.0f)] autorelease];
    sectionLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sectionView.png"]];
    sectionLabel.textAlignment = UITextAlignmentLeft;
    sectionLabel.textColor = RGB_Color(66.0f, 42.0f, 2.0f, 1.0f);
    sectionLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:16];
    sectionLabel.text = [alphabet objectAtIndex:section];
    return sectionLabel;
}
//-----------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
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
    SongCell *cell = (SongCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!cell)
	{
		cell = [[[SongCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = RGB_Color(66.0f, 42.0f, 2.0f, 2.0f);
        cell.textLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:16];
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
        DetailVC *webViewVC = [[DetailVC alloc] init];
        webViewVC.media = mediaDB;
        [webViewVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:webViewVC animated:YES];
        [webViewVC release];
    }
}
//-----------------------------------------------------------------------------------
-(void)backPress
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-----------------------------------------------------------------------------------
@end
