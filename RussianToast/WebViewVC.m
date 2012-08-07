//
//  WebViewVC.m
//  RussianToast
//
//  Created by Евгений Иванов on 04.08.12.
//
//

#import "WebViewVC.h"
#import "MediaDB.h"

@interface WebViewVC ()

@end

#define BUTTON_OFFSET_TAG 455

static NSString *htmlSTR =  @"<html>"
@"<style type=\"text/css\">"
@"body {"
@"background-color: RGB(245, 245, 243);padding:0;margin:0;"
@"}"
@".block1 {"
@"background-color: RGB(245, 245, 243);padding:0;margin:0;"
@"font-family: Helvetica;"
@"font-size: %fpt;"
@"</style>"
@"<body>"
@"<div class=\"block1\">"
@"%@"
@"</div>"
@"</body></html>";

@implementation WebViewVC

//-----------------------------------------------------------------------------------
-(void)dealloc
{
    [dataText release];
    
    [super dealloc];
}
//-----------------------------------------------------------------------------------
- (id)initWithTextData:(NSString*)textData
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        dataText = [[NSString alloc] initWithString:textData];
        blockTextHeight = 0;
        fontSize = 15.0f;
    }
    return self;
}
//-----------------------------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *fontNum  = [userDefaults objectForKey:@"fontSize"];
    if(fontNum)
    {
        fontSize = [fontNum floatValue];
        DLog(@"fontSize - %f",fontSize);

        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByClassName('block1')[0].style.fontSize = '%fpt';", fontSize]];
    }
    
    NSString *innerHtml=[NSString stringWithFormat:(NSString*)htmlSTR,fontSize,dataText];
    [webView loadHTMLString:innerHtml baseURL:nil];
}
//-----------------------------------------------------------------------------------
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *fontNum = [NSNumber numberWithFloat:fontSize];
    [userDefaults setObject:fontNum forKey:@"fontSize"];
    [userDefaults synchronize];
}
//-----------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49.0f - 46.0f)];
    webView.backgroundColor = [UIColor greenColor];
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView release];
    
    UIView *toolBarView  = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(webView.frame), self.view.bounds.size.width, 49.0f)];
    toolBarView.backgroundColor = [UIColor colorWithWhite:0.4f alpha:1.0f];
    [self.view addSubview:toolBarView];
    [toolBarView release];
    
    NSArray *arrayRects = [NSArray arrayWithObjects:NSStringFromCGRect(CGRectMake(CGRectGetMidX(toolBarView.frame) - 2.0f - 30.0f, 9.5, 30, 30)),
                                                    NSStringFromCGRect(CGRectMake(CGRectGetMidX(toolBarView.frame) + 2.0f, 9.5, 30, 30)),
                                                    NSStringFromCGRect(CGRectMake(CGRectGetMaxX(toolBarView.frame) - 25.0f, 14.5, 20, 20)),nil];
    
    NSArray *arrayColors = [NSArray arrayWithObjects:[UIColor brownColor],[UIColor brownColor],[UIColor greenColor], nil];
    for (int j =0; j < 3 ; j++ )
    {
        UIButton *toolBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toolBarButton.tag  = BUTTON_OFFSET_TAG + j;
        toolBarButton.frame = CGRectFromString([arrayRects objectAtIndex:j]);
        toolBarButton.backgroundColor = [arrayColors objectAtIndex:j];
        [toolBarButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
        [toolBarButton setSelected:NO];
        [toolBarView addSubview:toolBarButton];
    }
}
//-----------------------------------------------------------------------------------
-(void)buttonPress:(UIButton*)button
{
    DLog(@"tag - %d",button.tag);
    if(button.tag == BUTTON_OFFSET_TAG) // decrease font
    {
        if(fontSize > 10)
        {
            fontSize -=5;
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByClassName('block1')[0].style.fontSize = '%fpt';", fontSize]];
        }
    }
    else if (button.tag == BUTTON_OFFSET_TAG + 1)
    {
        if(fontSize < 35)
        {
            fontSize +=5;
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByClassName('block1')[0].style.fontSize = '%fpt';", fontSize]];
        }
    }
    else
    {
        button.selected = !button.selected;
        button.backgroundColor = (button.selected) ? [UIColor redColor] : [UIColor greenColor];
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"fullText ==[c] %@",dataText]];
//        MediaDB *currentMedia = [CoreDataManager object:@"" predicate:predicate inMainContext:YES];
//        if(currentMedia)
//            currentMedia.isFavorite = [NSNumber numberWithBool:button.selected];
//        NSLog(@"favorite - %@",currentMedia.isFavorite);
//        [CoreDataManager saveMainContext];
    }
}
//-----------------------------------------------------------------------------------
#pragma mark
#pragma mark UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)web
{
    blockTextHeight = [[web stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('block1')[0].offsetHeight;"] floatValue];
    DLog(@"blockTextHeight - %f",blockTextHeight);
}
//-----------------------------------------------------------------------------------
- (void)webView:(UIWebView *)_webView didFailLoadWithError:(NSError *)error
{
    DLog(@"");
}
//-----------------------------------------------------------------------------------
@end
