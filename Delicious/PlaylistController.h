//
//  PlaylistController.h
//  Delicious
//
//  Created by Vinh Nguyen on 7/9/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "VideoController.h"

@interface PlaylistController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UITableView *playlistTableView;

@property (strong,nonatomic) NSMutableArray *idPlaylist;

@property (strong,nonatomic) NSArray *arrPlaylist;

@property (strong, nonatomic) NSMutableData *receiverData;
@property (strong, nonatomic) NSMutableDictionary *receiverDatawithURL;
@property (strong, nonatomic) NSDictionary *requestGoogle;
@property (strong, nonatomic) NSMutableArray *reponseData;
@property (strong, nonatomic) NSMutableDictionary *results;

@property (strong,nonatomic) NSMutableArray *arrTimeVideo ;
@property (strong,nonatomic) NSMutableArray *arrIDVideo;
@property (strong,nonatomic) NSMutableArray *arrTitleVideo;
@property (strong,nonatomic) NSMutableArray *arrThumbnailVideo;
@property (strong,nonatomic) NSMutableArray *arrTitleChannel;

@property (strong,nonatomic) NSArray *arrVideo;

@end
