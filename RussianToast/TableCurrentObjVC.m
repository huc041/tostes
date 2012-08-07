//
//  TableCurrentObjVC.m
//  RussianToast
//
//  Created by Евгений Иванов on 04.08.12.
//
//

#import "TableCurrentObjVC.h"
#import "WebViewVC.h"

@interface TableCurrentObjVC ()

@end

@implementation TableCurrentObjVC

-(void)dealloc
{
    [arrayData release];
    
    [super dealloc];
}
//-------------------------------------------------------------------------------
- (id)initWithStringData:(NSString*)strData
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        NSArray *tempArray = [strData componentsSeparatedByString:@"* * *"];
        arrayData = [[NSArray alloc] initWithArray:tempArray];
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
    NSLog(@"detail objects - %d",[arrayData count]);
    return [arrayData count];
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
    
    cell.textLabel.text = [arrayData objectAtIndex:indexPath.row];
    
	return cell;
}
//-----------------------------------------------------------------------------------
#pragma mark -
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");
    
    WebViewVC *webViewVC = [[[WebViewVC alloc] initWithTextData:[arrayData objectAtIndex:indexPath.row]] autorelease];
    [webViewVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webViewVC animated:YES];
}
//-----------------------------------------------------------------------------------
@end
