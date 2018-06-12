//
//  ListingCell.m
//  Fab
//
//  Created by Mohammad Arif  on 11/06/18.
//  Copyright © 2018 Fab. All rights reserved.
//

#import "ListingCell.h"

@implementation ListingCell

@synthesize name = _name;
@synthesize city = _city;
@synthesize price = _price;
@synthesize landmark = _landmark;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
