//
//  NavControllerAppDelegate.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "NavControllerAppDelegate.h"
#import "CompanyVC.h"

@interface NavControllerAppDelegate ()

// CREATED MANAGED OBJECT MODEL, MANAGED OBJECT CONTEXT, PERSISTENT STORE COORDINATOR OBJECTS IN THE APP DELEGATE
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation NavControllerAppDelegate

// LINE IS HERE SO THAT THEY CAN BE REFERENCED WITHOUT UNDERSCORE
@synthesize managedObjectModel = _managedObjectModel, managedObjectContext = _managedObjectContext, persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CompanyVC *rootController = [[CompanyVC alloc] init];
  
    self.navigationController = [[UINavigationController alloc]
                            initWithRootViewController:rootController];
    
    // ADDED A MANAGED OBJECT CONTEXT TO THE COMPANY VC CONTROLLER
    rootController.managedObjectContext = self.managedObjectContext;
    
    self.window = [[UIWindow alloc]
                   initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.navigationController];
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
    
    
    /*
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
     */
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // SAVE CORE DATA WHEN APPLICATION WILL RESIGN
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // SAVE CORE DATA WHEN APPLICATION ENTERS BACKGROUND
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // SAVE CORE DATA WHEN APPLICATION IS ABOUT TO TERMINATE.
    [self saveContext];
}

- (void)saveContext {
    
    // SAVES CORE DATA USING SAVE COMMAND.
    // FIRST CHECKS IF THERE IS A MANAGED OBJECT CONTEXT (SCRATCH PAD)
    // IF THERE ARE CHANGES AND THEY DIDN'T SAVE, THROW THE ERROR
    NSError *error;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack
/* THIS CORE DATA STACK IMPLEMENTATION IS FROM OLDER IOS 10 APPLICATIONS
 NEW IMPLEMENTATIONS ARE EASIER - SEE NEW APPLE DOCUMENTATION
 TRY TO IMPLEMENT IT LATER */

/* RETURNS THE MANAGED OBJECT CONTEXT FOR THE APPLICATION
 IF THE CONTEXT DOESN'T ALREADY EXIST, IT IS CREATED AND BOUND TO THE PERSISTENT STORE COORDINATOR FOR THE APPLICATION */
- (NSManagedObjectContext*)managedObjectContext {
    // IF MANAGED OBJECT CONTEXT ALREADY EXISTS, RETURN IT
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    // MANAGED OBJECT IS TIED TO A PERSISTENT STORE COORDINATOR
    // FIRST HAVE TO GET THE COORDINATOR FROM SELF.
    // WILL CALL SELF PERSISTENT STORE COORDINATOR
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/* RETURNS THE MANAGED OBJECT MODEL FOR THE APPLICAITON. IF THE MODEL DOESN'T ALREADY EXIST, IT IS CREATED FROM THE APPLICATION'S MODEL */

- (NSManagedObjectModel*)managedObjectModel {
    // IF MANAGED OBJECT MODEL ALREADY EXISTS, RETURN IT
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NavController" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator*)persistentStoreCoordinator {
    // IF PERSISTENT STORE COORDINATOR ALREADY EXISTS, RETURN IT
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // CREATES THE FILE LOCATION FOR STORAGE BY ADDING FILENAME TO THE
    // DOCUMENTS DIRECTOR
    // NOTE, THIS IS JUST THE LOCATION AND NOT THE FILE
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NavController.CDBStore"];
    
    // CALLS THE INSTANCE OF THE SHARED FILE MANAGER
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // WILL CHECK TO SEE IF THERE IS A FILE ALREADY EXISTING AT THE PATH ABOVE
    // IF THE FILE EXISTS, THEN YOU DON'T NEED TO DO ANYTHING.
    // IF THE FILE DOESNT EXIST, WE NEED TO CREATE IT.
    // MAIN BUNDLE ACCESSES FILES IN THE CURRENT APP DIRECTORY
    // IT LOOKS FOR THE NAVCONTROLLER.CDBSTORE FILE AND STORES THAT FILEPATH
    // IN A URL. IF IT FINDS IT, THEN THE FILE MANAGER COPIES THE FILE AT THE
    // EXISTING PATH AND COPIES IT TO THE PATH IN DOCUMENTS YOU WANT IT ON.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle]
                                  URLForResource:@"NavController" withExtension:@"CDBStore"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
    // ALLOCATES A PERSISTENT STORE COORDINATOR WITH THE MANAGED OBJECT MODEL IN SELF
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unersolved error %@, %@",error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's documents directory

- (NSURL *)applicationDocumentsDirectory {
    // CREATES A SHARED INSTANCE OF FILE MANAGER, AND THEN SEARCHES FOR THE
    // USERS DOCUMENTS DIRECTORY IN THEIR USER DOMAINS. LAST OBJECT SINCE THE
    // METHOD RETURNS AN ARRAY OF URLS DEPENDING ON THE DOMAIN MASK.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
