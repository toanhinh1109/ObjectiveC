//
//  ChannelController.h
//  Delicious
//
//  Created by Vinh Nguyen on 7/9/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "AddChannelController.h"
#import "PlaylistController.h"
#import <CoreData/CoreData.h>
#import "Reachability.h"

@interface ChannelController : UIViewController <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchCooking;
@property (weak, nonatomic) IBOutlet UITableView *channelTableView;

@property (strong, nonatomic) Reachability *reachability;

@property (strong, nonatomic) NSMutableData *receiverData;
@property (strong, nonatomic) NSMutableDictionary *receiverDatawithURL;
@property (strong, nonatomic) NSDictionary *requestGoogle;
@property (strong, nonatomic) NSMutableArray *reponseData;
@property (strong, nonatomic) NSMutableDictionary *results;

@property (strong,nonatomic) NSMutableArray *arrTimeChannel ;
@property (strong,nonatomic) NSMutableArray *arrChannelID;
@property (strong,nonatomic) NSMutableArray *arrTitleChannel;
@property (strong,nonatomic) NSMutableArray *arrThumbnailChannel;

@property (strong,nonatomic) NSArray *arrChannel;

@property (strong,nonatomic) NSMutableArray *arrTimePlaylist ;
@property (strong,nonatomic) NSMutableArray *arrPlaylistID;
@property (strong,nonatomic) NSMutableArray *arrTitlePlaylist;
@property (strong,nonatomic) NSMutableArray *arrThumbnailPlaylist;

@property (strong,nonatomic) NSArray *arrPlaylist;

@end
