//
//  HistoryController.h
//  Delicious
//
//  Created by Vinh Nguyen on 7/16/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CustomCell.h"
#import "DetailHistoryController.h"

@interface HistoryController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@end
