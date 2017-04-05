//
//  CustomCell.h
//  Delicious
//
//  Created by Vinh Nguyen on 7/9/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *channelImage;
@property (weak, nonatomic) IBOutlet UILabel *channelTitle;
@property (weak, nonatomic) IBOutlet UILabel *channelID;

@end
