//
//  ListingController.m
//  Fab
//
//  Created by Mohammad Arif  on 11/06/18.
//  Copyright © 2018 Fab. All rights reserved.
//

#import "ListingController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "Listing.h"
#import "ListingCell.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>


@interface ListingController ()

@end

@implementation ListingController


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if([self connected]){
        [self fetchListing];
    }else{
        [self fetchFromDb];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    _delegate = [[UIApplication sharedApplication] delegate];
    if ([_delegate performSelector:@selector(persistentContainer)]) {
        context = _delegate.persistentContainer.viewContext;
    }
    return context;
}

- (void) fetchFromDb{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Hotels"];
    self.listing = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    [self.tableView reloadData];
}

- (void)deleteAllEntities:(NSString *)nameEntity
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [managedObjectContext deleteObject:object];
    }
    
    error = nil;
    [managedObjectContext save:&error];
}


- (void)fetchListing {
    NSString *URL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ENDPOINT"];
    NSLog(@"%@",URL);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if ([responseObject  isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                NSLog(@"%@",responseDict);
            
                [self deleteAllEntities:@"Hotels"];
            
                self.listing = [responseDict objectForKey:@"propertyListing"];
                int i;
                for(i=0; i<[self.listing count]; i++){
                    Listing* model = self.listing[i];
                    
                  
                    NSManagedObjectContext *context = [self managedObjectContext];
                    
                    NSManagedObject *hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotels" inManagedObjectContext:context];
                    [hotel setValue:[model valueForKeyPath:@"name"] forKey:@"name"];
                    [hotel setValue:[model valueForKeyPath:@"city"] forKey:@"city"];
                    [hotel setValue:[model valueForKeyPath:@"landmark"] forKey:@"landmark"];
                    [hotel setValue:[model valueForKeyPath:@"price"] forKey:@"price"];
                    [hotel setValue:[model valueForKeyPath:@"reviewCount"] forKey:@"reviewCount"];
                    NSError *error = nil;
                    // Save the object to persistent store
                    if (![context save:&error]) {
                        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.listing.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"listingCell";
    ListingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Listing* model = self.listing[indexPath.row];
    
    cell.name.text = [model valueForKeyPath:@"name"];
    cell.city.text = [model valueForKeyPath:@"city"];
    cell.landmark.text = [model valueForKeyPath:@"landmark"];
    cell.price.text = [NSString stringWithFormat:@"Rs.%@", [model valueForKeyPath:@"price"]];
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}
//
//
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
