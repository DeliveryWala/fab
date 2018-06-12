//
//  ListingCell.h
//  Fab
//
//  Created by Mohammad Arif  on 11/06/18.
//  Copyright © 2018 Fab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *city;
@property (nonatomic, weak) IBOutlet UILabel *price;
@property (nonatomic, weak) IBOutlet UILabel *landmark;
@end
