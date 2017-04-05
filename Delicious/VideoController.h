//
//  VideoController.h
//  Delicious
//
//  Created by Vinh Nguyen on 7/10/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "CustomCell.h"
#import <Social/Social.h>
#import <CoreData/CoreData.h>

@interface VideoController : UIViewController <UITableViewDataSource,UITableViewDelegate,YTPlayerViewDelegate>

@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;

@property (weak, nonatomic) IBOutlet UITableView *videoTableView;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *preButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *remainTime;

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *watchLaterButton;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property BOOL played;

- (IBAction)shareFB:(id)sender;

- (IBAction)favoriteVideo:(id)sender;

- (IBAction)watchLaterVideo:(id)sender;

- (IBAction)playVideo:(id)sender;

- (IBAction)nextVideo:(id)sender;

- (IBAction)previousVideo:(id)sender;
- (IBAction)onSliderChange:(id)sender;

@property (strong,nonatomic) NSString *idPlaylist;
@property (strong,nonatomic) NSMutableArray *arrIDVideo;
@property (strong,nonatomic) NSArray *arrVideo;


@end
