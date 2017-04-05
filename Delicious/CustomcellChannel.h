//
//  CustomcellChannel.h
//  Delicious
//
//  Created by Vinh Nguyen on 8/6/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomcellChannel : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *channelTitle;
@property (weak, nonatomic) IBOutlet UILabel *channelID;
@property (weak, nonatomic) IBOutlet UIImageView *channelImage;


@property (weak, nonatomic) IBOutlet UIButton *btnCheck;

@end
