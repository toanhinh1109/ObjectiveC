//
//  VideoController.m
//  Delicious
//
//  Created by Vinh Nguyen on 7/10/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import "VideoController.h"
static NSString *cellChannelID=@"cellChannelID";

@interface VideoController ()
{
    NSString *idVD;
    int index;
    bool watchlatered;
    bool favorited;
}
@property (strong) NSMutableArray *wVideos;
@property (strong) NSMutableArray *fVideos;
@end

@implementation VideoController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateSelected];
    
    [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"disFavorite.png"] forState:UIControlStateSelected];
    
    [self.watchLaterButton setBackgroundImage:[UIImage imageNamed:@"WLater1.png"] forState:UIControlStateNormal];
    [self.watchLaterButton setBackgroundImage:[UIImage imageNamed:@"WLater2.png"] forState:UIControlStateSelected];
    
    [self.videoTableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:cellChannelID];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.playerView.delegate = self;
    NSDictionary *playerVars = @{
                                 @"controls" : @0,
                                 @"playsinline" : @1,
                                 @"autohide" : @1,
                                 @"showinfo" : @0,
                                 @"modestbranding" : @1
                                 };
    [self.playerView loadWithPlaylistId:self.idPlaylist playerVars:playerVars];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.videoTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black.jpg"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black.jpg"]];
    self.slider.value = 0;
    [self.currentTime setText:@"0:00"];
    [self.remainTime setText:@"-0:00"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleNetworkStatusNotification" object:nil];
    
    
    
    [self.videoTableView reloadData];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.playerView pauseVideo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)timeFormat:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    
    int roundedSeconds = (int)lroundf(seconds);
    int roundedMinutes = (int)lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%02d:%02d",
                      roundedMinutes, roundedSeconds];
    return time;
}

-(void)playerView:(YTPlayerView *)playerView didPlayTime:(float)playTime{
    
    float progress = playTime/self.playerView.duration;
    [self.slider setValue:progress];
    
    float remainTime = self.playerView.duration - self.playerView.currentTime ;
    self.currentTime.text = [NSString stringWithFormat:@"%@",[self timeFormat:self.playerView.currentTime]];
    self.remainTime.text = [NSString stringWithFormat:@"-%@",[self timeFormat:remainTime]];
    float timeCount = self.playerView.duration - playTime;
    
    if (index<(self.arrIDVideo.count -1)) {
        
        if (timeCount<1&& timeCount>0) {
            timeCount = 0.0f;
            NSLog(@"%d",index);
            
            [self.playerView loadPlaylistByVideos:self.arrIDVideo index:index startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
            //            [self.playerView playVideo];
            [self.playButton setSelected:NO];
            self.played = YES;
            NSManagedObjectContext *context = [self managedObjectContext];
            
            NSManagedObject *newVideo = [NSEntityDescription insertNewObjectForEntityForName:@"VideoHistory" inManagedObjectContext:context];
            
            [newVideo setValue:[[self.arrVideo objectAtIndex:2] objectAtIndex:index] forKey:@"titleVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:0] objectAtIndex:index] forKey:@"idVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:1] objectAtIndex:index] forKey:@"thumbnailVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:3] objectAtIndex:index] forKey:@"timeVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:4] objectAtIndex:index] forKey:@"channelVideo"];
            [newVideo setValue:[NSDate date] forKey:@"timeStamp"];
            //        NSLog(@"%@",[NSDate date]);
            
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            NSLog(@"Save Video History successful!!!!");
            index ++;
            [self.watchLaterButton setSelected:YES];
            [self.favoriteButton setSelected:YES];
        }
    }
    else if (index==(self.arrIDVideo.count -1)){
        if (timeCount<1&& timeCount>0) {
            timeCount = 0.0f;
            NSLog(@"%d",index);
            
            [self.playerView loadPlaylistByVideos:self.arrIDVideo index:index startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
            //            [self.playerView playVideo];
            [self.playButton setSelected:NO];
            self.played = YES;
            NSManagedObjectContext *context = [self managedObjectContext];
            
            NSManagedObject *newVideo = [NSEntityDescription insertNewObjectForEntityForName:@"VideoHistory" inManagedObjectContext:context];
            
            [newVideo setValue:[[self.arrVideo objectAtIndex:2] objectAtIndex:index] forKey:@"titleVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:0] objectAtIndex:index] forKey:@"idVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:1] objectAtIndex:index] forKey:@"thumbnailVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:3] objectAtIndex:index] forKey:@"timeVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:4] objectAtIndex:index] forKey:@"channelVideo"];
            [newVideo setValue:[NSDate date] forKey:@"timeStamp"];
            //        NSLog(@"%@",[NSDate date]);
            
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            NSLog(@"Save Video History successful!!!!");
            index =0;
            [self.playerView loadPlaylistByVideos:self.arrIDVideo index:index startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
            [self.watchLaterButton setSelected:YES];
            [self.favoriteButton setSelected:YES];
        }
        
    }
    
    NSLog(@"%f",timeCount);
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            [self.playButton setSelected:NO];
            self.played = YES;
            NSLog(@"%f",self.playerView.currentTime );
            NSLog(@"%f",self.playerView.duration);
            break;
        case kYTPlayerStatePaused:
            NSLog(@"Paused playback");
            [self.playButton setSelected:YES];
            self.played = NO;
            //            NSLog(@"%f",self.playerView.currentTime );
            //            NSLog(@"%f",self.playerView.duration);
            break;
        default:
            break;
    }
}

- (IBAction)shareFB:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController *controller =
        [SLComposeViewController
         composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:@"Các món ăn ngon đây"];
        [controller addURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@&index=%d&list=%@",idVD,index,self.idPlaylist]]];
        controller.completionHandler = ^(SLComposeViewControllerResult result){
            NSLog(@"Completed");
        };
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        NSLog(@"The FB service is not available");
        SLComposeViewController *controller =
        [SLComposeViewController
         composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:@"Các món ăn ngon đây"];
        [controller addURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@&index=%d&list=%@",idVD,index,self.idPlaylist]]];
        controller.completionHandler = ^(SLComposeViewControllerResult result){
            NSLog(@"Completed");
        };
        [self presentViewController:controller animated:YES completion:nil];    }
}

- (IBAction)favoriteVideo:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Video"];
    self.fVideos = (NSMutableArray*)[context executeFetchRequest:fetchRequest error:nil];
    if (!favorited) {
        [self.favoriteButton setSelected:NO];
        NSLog(@"FAVORITE");
        if (![[self.fVideos valueForKey:@"idVideo"] containsObject:[[self.arrVideo objectAtIndex:0] objectAtIndex:index]]) {
                    NSManagedObjectContext *context = [self managedObjectContext];
            
            NSManagedObject *newVideo = [NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:context];
            
            [newVideo setValue:[[self.arrVideo objectAtIndex:2] objectAtIndex:index] forKey:@"titleVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:0] objectAtIndex:index] forKey:@"idVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:1] objectAtIndex:index] forKey:@"thumbnailVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:3] objectAtIndex:index] forKey:@"timeVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:4] objectAtIndex:index] forKey:@"channelVideo"];
            
            NSLog(@"%d",index);
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            favorited=YES;
        }
        
        if ([[self.fVideos valueForKey:@"idVideo"] containsObject:[[self.arrVideo objectAtIndex:0] objectAtIndex:index]]) {
            favorited=YES;
            return;
        }
        NSLog(@"Save Video Favorite successful");
    }
    else {
        
        [self.favoriteButton setSelected:YES];
        fetchRequest.predicate =[NSPredicate predicateWithFormat:@"idVideo LIKE[c] %@", [[self.arrVideo objectAtIndex:0] objectAtIndex:index]];
        
        NSLog(@"idvideo %@",[[self.arrVideo objectAtIndex:0] objectAtIndex:index]);
        NSLog(@"Object delete Favorite: %@",[[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0]);
        
        [context deleteObject:[[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0]];

        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        favorited=NO;
        NSLog(@"UnFavorite");
        
    }
    
}

- (IBAction)watchLaterVideo:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"VideoWatchLater"];
    self.wVideos = (NSMutableArray*)[context executeFetchRequest:fetchRequest error:nil];
    if (!watchlatered) {
        [self.watchLaterButton setSelected:NO];
        NSLog(@"WATCHLATER");
        if (![[self.wVideos valueForKey:@"idVideo"] containsObject:[[self.arrVideo objectAtIndex:0] objectAtIndex:index]]) {
                        NSManagedObjectContext *context = [self managedObjectContext];
            
            NSManagedObject *newVideo = [NSEntityDescription insertNewObjectForEntityForName:@"VideoWatchLater" inManagedObjectContext:context];
            
            [newVideo setValue:[[self.arrVideo objectAtIndex:2] objectAtIndex:index] forKey:@"titleVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:0] objectAtIndex:index] forKey:@"idVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:1] objectAtIndex:index] forKey:@"thumbnailVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:3] objectAtIndex:index] forKey:@"timeVideo"];
            [newVideo setValue:[[self.arrVideo objectAtIndex:4] objectAtIndex:index] forKey:@"channelVideo"];
            
            NSLog(@"%d",index);
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                
            }
            watchlatered=YES;
        }
        
        if ([[self.wVideos valueForKey:@"idVideo"] containsObject:[[self.arrVideo objectAtIndex:0] objectAtIndex:index]]) {
            watchlatered=YES;
            return;
        }
        NSLog(@"Save video Watch later successful");
        
    }
    else {
        
        [self.watchLaterButton setSelected:YES];

//        [context deleteObject:[self.wVideos lastObject]];
        
        fetchRequest.predicate =[NSPredicate predicateWithFormat:@"idVideo LIKE[c] %@", [[self.arrVideo objectAtIndex:0] objectAtIndex:index]];
        
        NSLog(@"idvideo %@",[[self.arrVideo objectAtIndex:0] objectAtIndex:index]);
        NSLog(@"Object delete watchlater: %@",[[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0]);
        
        [context deleteObject:[[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0]];
        
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        watchlatered=NO;
        NSLog(@"DisWatchlater");
        
    }
    
}

- (IBAction)playVideo:(id)sender {
    if(!self.played){
        [self.playButton setSelected:NO];
        [self.playerView playVideo];
        self.played = YES;
        //       index=self.playerView.playlistIndex;
        NSLog(@"%d",index);
    }
    else
    {
        [self.playButton setSelected:YES];
        [self.playerView pauseVideo];
        self.played = NO;
        NSLog(@"%d",index);
        //        index=self.playerView.playlistIndex;
    }
}

- (IBAction)nextVideo:(id)sender {
    self.slider.value = 0;
    [self.watchLaterButton setSelected:YES];
    [self.favoriteButton setSelected:YES];
    if (self.arrIDVideo.count<200) {
        if (index<(self.arrIDVideo.count-1)) {
            index ++;
            [self.playButton setSelected:NO];
            [self.playerView nextVideo];
            self.played = YES;
        }
        else if(index==(int)(self.arrIDVideo.count-1)){
            
            index=0;
            
            [self.playerView loadPlaylistByVideos:self.arrIDVideo index:index startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
        }
        
        NSLog(@"%d",index);
        
    }
    
    if (self.arrIDVideo.count>=200) {
        if (index<self.arrIDVideo.count-1) {
            index ++;
        }
        else{
            index=0;
            [self.playerView loadPlaylistByVideos:self.arrIDVideo index:index startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
        }
        [self.playerView loadPlaylistByVideos:self.arrIDVideo index:index startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
        [self.playButton setSelected:NO];
        self.played = YES;
        NSLog(@"%d",index);
    }
}

- (IBAction)previousVideo:(id)sender {
    self.slider.value = 0;
    [self.watchLaterButton setSelected:YES];
    [self.favoriteButton setSelected:YES];
    if (self.arrIDVideo.count<200) {
        if (index>=1) {
            index --;
            [self.playButton setSelected:NO];
            [self.playerView previousVideo];
            self.played = YES;
        }
        else if(index==0){
            index=(int)(self.arrIDVideo.count-1);
            
            [self.playerView loadPlaylistByVideos:self.arrIDVideo index:index startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
        }
        
        NSLog(@"%d",index);
        
    }
    if (self.arrIDVideo.count>=200) {
        if (index>=1) {
            index --;
        }
        else{
            index=(int)(self.arrIDVideo.count-1);
            [self.playerView loadPlaylistByVideos:self.arrIDVideo index:index startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
        }
        [self.playerView loadPlaylistByVideos:self.arrIDVideo index:index startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
        [self.playButton setSelected:NO];
        self.played = YES;
        NSLog(@"%d",index);
    }
    
}

- (IBAction)onSliderChange:(id)sender {
    NSLog(@"%d",index);
    float seekToTime = self.playerView.duration * self.slider.value;
    [self.playerView seekToSeconds:seekToTime allowSeekAhead:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrIDVideo.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellChannelID];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellChannelID];
    }
    cell.channelTitle.text = [NSString stringWithFormat:@"%@",[[self.arrVideo objectAtIndex:2] objectAtIndex:indexPath.row]];
    cell.channelID.text = [NSString stringWithFormat:@"%@",[[self.arrVideo objectAtIndex:4] objectAtIndex:indexPath.row]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.arrVideo objectAtIndex:1] objectAtIndex:indexPath.row]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.channelImage.image = [UIImage imageWithData:imageData];
            
        });
    });
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.playerView loadPlaylistByVideos:self.arrIDVideo index:(int)indexPath.row startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
    
    index = (int)indexPath.row;
    idVD = [self.arrIDVideo objectAtIndex:indexPath.row];
    [self.watchLaterButton setSelected:YES];
    watchlatered=NO;
    [self.favoriteButton setSelected:YES];
    favorited=NO;
    [self.playButton setSelected:NO];
    self.slider.value = 0;
    NSLog(@"%ld",(long)indexPath.row);
}


@end
