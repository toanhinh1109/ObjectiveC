//
//  FavoriteController.h
//  Delicious
//
//  Created by Vinh Nguyen on 7/16/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CustomCell.h"
#import "DetailFavoriteController.h"

@interface FavoriteController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *favoriteTableView;

@end
