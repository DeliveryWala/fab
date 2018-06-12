//
//  ViewController.h
//  Fab
//
//  Created by Mohammad Arif  on 11/06/18.
//  Copyright © 2018 Fab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSArray *_hotels;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

