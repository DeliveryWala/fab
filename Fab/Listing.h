//
//  Listing.h
//  Fab
//
//  Created by Mohammad Arif  on 11/06/18.
//  Copyright © 2018 Fab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@protocol Listing;
@interface Listing : JSONModel
@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *name;
@property (nonatomic) float price;
@property (nonatomic) int reviewCount;
@end

@interface Hotel : JSONModel
@property (strong, nonatomic) NSMutableArray<Listing, Optional>* listing;
@end
