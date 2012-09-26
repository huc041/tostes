//
//  ExPrefixAppDelegate.m
//  RussianToast
//
//  Created by Евгений Иванов on 21.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExPrefixAppDelegate.h"
#import "MainVC.h"
#import "FavoriteVC.h"
#import "GroupDB.h"
#import "MediaDB.h"

@implementation ExPrefixAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)dealloc
{
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSMutableArray *tabsArray = [[NSMutableArray alloc] initWithCapacity:2];
    NSString *classesArray[2] = {@"MainVC",@"FavoriteVC"};
    UITabBarController *tabVC = [[[UITabBarController alloc] init] autorelease];
    for (int j =0; j < 2; j++)
    {
        Class classVC = NSClassFromString(classesArray[j]);
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[[[classVC alloc] init] autorelease]];
        [navVC.navigationBar setBarStyle:UIBarStyleBlackOpaque];
//        navVC.navigationBarHidden = YES;
        [tabsArray addObject:navVC];
        [navVC release];
    }
    tabVC.viewControllers = tabsArray;
    [tabsArray release];
    
    self.window.rootViewController = tabVC;
    
    [self checkNumLoad];
    
    return YES;
}
//------------------------------------------------------------------------------------------------------------
-(void)checkNumLoad
{ 
    DLog(@"");
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *appStart = [userDefault objectForKey:@"appLaunch"];
    if(!appStart)
    {
        appStart = [NSNumber numberWithInt:1];
        [userDefault setObject:appStart forKey:@"appLaunch"];
        [self loadDataIntoBD];
    }
    else 
    {
        int count = [[userDefault objectForKey:@"appLaunch"] intValue];
        count++;
        [userDefault setObject:[NSNumber numberWithInt:count] forKey:@"appLaunch"];
    }
    [userDefault synchronize];
}
//------------------------------------------------------------------------------------------------------------
-(void)loadDataIntoBD
{
    DLog(@"");
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *arrayDataFiles = [mainBundle pathsForResourcesOfType:@".txt" inDirectory:nil];
    for (NSString*filePath in arrayDataFiles)
    {
        NSString *nameFile = [filePath lastPathComponent]; // получаем имя файла + расширение
        NSArray *array = [nameFile componentsSeparatedByString:@"&"];
        NSArray *arrayGroup = [[array objectAtIndex:0] componentsSeparatedByString:@"_"];
        
        GroupDB *groupDB = [CoreDataManager object:@"GroupDB" predicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id == %@ AND idParent == 0",[arrayGroup objectAtIndex:0]]] inMainContext:YES];
        if(!groupDB) // если не было группы - создаем
        {
            groupDB = (GroupDB*)[CoreDataManager newObject:@"GroupDB" inMainContext:YES];
            groupDB.id = [NSNumber numberWithInt:[[arrayGroup objectAtIndex:0]intValue]];
            groupDB.idParent = [NSNumber numberWithInt:0];
            groupDB.name = [arrayGroup objectAtIndex:1];
        }
        
        GroupDB *subGroupDB = nil;
        if([array count]>1) // есть ли подгруппа?
        {
            NSArray *arraySubGroup = [[array objectAtIndex:1] componentsSeparatedByString:@"_"];
            subGroupDB = [CoreDataManager object:@"GroupDB" predicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id == %@ AND idParent == %@",[arraySubGroup objectAtIndex:0],groupDB.id]] inMainContext:YES];
            if(!subGroupDB)
            {
                subGroupDB = (GroupDB*)[CoreDataManager newObject:@"GroupDB" inMainContext:YES];
                subGroupDB.id = [NSNumber numberWithInt:[[arraySubGroup objectAtIndex:0]intValue]];
                subGroupDB.idParent = groupDB.id;
                subGroupDB.name = ((NSString*)[arraySubGroup objectAtIndex:1]).stringByDeletingPathExtension;
            }
        }
        
        NSData *dataFromFile = [NSData dataWithContentsOfFile:filePath];
        NSString *dataString = [[NSString alloc] initWithData:dataFromFile encoding:NSUTF8StringEncoding];
        if(dataString) // разбиваем полный текст на элементы MediaDB
        {
            NSArray *arrayMedia = [dataString componentsSeparatedByString:@"* * *"];
            for (NSString *mediaText in arrayMedia)
            {
//                NSLog(@"subGroupDB.name - %@",subGroupDB.name);

                
                MediaDB *mediaDB = (MediaDB*)[CoreDataManager newObject:@"MediaDB" inMainContext:YES];
                mediaDB.idGroup = groupDB.id;
                mediaDB.nameGroup = groupDB.name;
                mediaDB.isFavorite = [NSNumber numberWithBool:0];
                mediaDB.idSubGroup = subGroupDB.id;
//                mediaDB.nameSubGroup = subGroupDB.name;
                mediaDB.fullText = mediaText;
                
                [groupDB addMediaObject:mediaDB];
            }
        }
        [dataString release];
    }
    
    [CoreDataManager saveMainContext];
    
//    NSArray *arrayMediaFromDB = [CoreDataManager objects:@"MediaDB" withPredicate:nil inMainContext:YES];
//    for (MediaDB*mediaDB in arrayMediaFromDB)
//        NSLog(@"arrayMedia - %@",mediaDB.idSubGroup);
}
//------------------------------------------------------------------------------------------------------------
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
//------------------------------------------------------------------------------------------------------------
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
//------------------------------------------------------------------------------------------------------------
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
//------------------------------------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
//------------------------------------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
//------------------------------------------------------------------------------------------------------------
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}
//------------------------------------------------------------------------------------------------------------
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}
//------------------------------------------------------------------------------------------------------------
// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RussianToast" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}
//------------------------------------------------------------------------------------------------------------
// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RussianToast.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}
//------------------------------------------------------------------------------------------------------------
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
//- (NSURL *)applicationDocumentsDirectory
//{
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//-------------------------------------------------------------------------------------
- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
//------------------------------------------------------------------------------------------------------------
@end
