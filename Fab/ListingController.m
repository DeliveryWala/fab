//
//  ListingController.m
//  Fab
//
//  Created by Mohammad Arif  on 11/06/18.
//  Copyright © 2018 Fab. All rights reserved.
//

#import "ListingController.h"
#import "AFNetworking.h"
#import "Listing.h"
#import "ListingCell.h"

@interface ListingController ()
@property (strong, nonatomic) NSMutableArray* listing;
@end

@implementation ListingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchListing];
    
    
}


- (void)fetchListing {
    NSString *URL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ENDPOINT"];
    NSLog(@"%@",URL);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        for(NSDictionary *result in responseObject){
//
//            NSLog(@"%@",[responseObject objectForKey:result]);
//

       //     SLog(@"%@",[dict objectForKey:key]);
            if ([responseObject isKindOfClass:[NSArray class]]) {
//                NSArray *responseArray = [responseObject objectForKey:result];
//                /* do something with responseArray */
//                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseArray];
//
//                self.listing = [Listing arrayOfModelsFromData:data error:nil];
               // NSLog(@"%@",self.listing);
               
            }else if ([responseObject  isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                NSLog(@"%@",responseDict);
                self.listing = [responseDict objectForKey:@"propertyListing"];
                NSLog(@"%@",self.listing);
                
                 NSLog(@"%@",URL);
                /* do something with responseDict */
     //       }
            
            
        }
       
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        
        //self.listing = [Listing arrayOfModelsFromData:responseObject error:nil];
       // self.hotel = self.listing[arc4random() % self.listing.count];
        //NSLog(@"JSON: %@", self.listing);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
