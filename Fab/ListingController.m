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
@property (strong, nonatomic) NSMutableArray* listing;
@end

@implementation ListingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if([self connected]){
        [self fetchListing];
    }else{
        
    }
   
    
    
}

- (void)fetchListing {
    NSString *URL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ENDPOINT"];
    NSLog(@"%@",URL);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {

            if ([responseObject isKindOfClass:[NSArray class]]) {

               
            }else if ([responseObject  isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                NSLog(@"%@",responseDict);
                self.listing = [responseDict objectForKey:@"propertyListing"];
                NSLog(@"%@",self.listing);
                
                NSLog(@"%@",URL);
    
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void) fetchFromCore{
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Hotels"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
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
