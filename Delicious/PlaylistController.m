//
//  PlaylistController.m
//  Delicious
//
//  Created by Vinh Nguyen on 7/9/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import "PlaylistController.h"

static NSString *cellChannelID=@"cellChannelID";

@interface PlaylistController ()

{
    NSString *plID;
    NSString *nextPageToken;
}

@end

@implementation PlaylistController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.playlistTableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:cellChannelID];
    [self initData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.playlistTableView.backgroundColor = [UIColor grayColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black.jpg"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleNetworkStatusNotification" object:nil];

    [self.playlistTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    self.receiverData = [[NSMutableData alloc] initWithCapacity:0];
    self.requestGoogle = [[NSDictionary alloc] init];
    self.reponseData =[[NSMutableArray alloc] init];
    self.results =[[NSMutableDictionary alloc] init];
    self.receiverDatawithURL =[[NSMutableDictionary alloc] init];
    
    //get playlistID from channelID
    self.arrIDVideo = [[NSMutableArray alloc]init];
    self.arrThumbnailVideo = [[NSMutableArray alloc]init];
    self.arrTimeVideo = [[NSMutableArray alloc]init];
    self.arrTitleChannel = [[NSMutableArray alloc]init];
    self.arrTitleVideo = [[NSMutableArray alloc]init];
    
    self.arrVideo = [[NSArray alloc]initWithObjects:self.arrIDVideo,self.arrThumbnailVideo,self.arrTitleVideo,self.arrTimeVideo,self.arrTitleChannel, nil];
}

#pragma Datasource tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.idPlaylist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell *cell= [tableView dequeueReusableCellWithIdentifier:cellChannelID forIndexPath:indexPath];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellChannelID forIndexPath:indexPath];
    }
    cell.channelTitle.text = [NSString stringWithFormat:@"%@",[[self.arrPlaylist objectAtIndex:2] objectAtIndex:indexPath.row]];
    cell.channelID.text = [NSString stringWithFormat:@"%@",[[self.arrPlaylist objectAtIndex:3] objectAtIndex:indexPath.row]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.arrPlaylist objectAtIndex:1] objectAtIndex:indexPath.row]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.channelImage.image = [UIImage imageWithData:imageData];
            
        });
    });

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

#pragma delegate tableview

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.arrIDVideo removeAllObjects];
    [self.arrThumbnailVideo removeAllObjects];
    [self.arrTimeVideo removeAllObjects];
    [self.arrTitleChannel removeAllObjects];
    [self.arrTitleVideo removeAllObjects];
    [self.indicator startAnimating];
    self.playlistTableView.hidden=YES;
    [self getVideoID:[[self.arrPlaylist objectAtIndex:0]objectAtIndex:indexPath.row]];
    
    plID= [[self.arrPlaylist objectAtIndex:0]objectAtIndex:indexPath.row];
    NSLog(@"%@",plID);

 
    //    [self performSegueWithIdentifier:@"segueVideo" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueVideo"]) {
        VideoController *video = [segue destinationViewController];
        video.idPlaylist = plID;
        video.arrIDVideo = self.arrIDVideo;
        video.arrVideo = self.arrVideo;
    }
}

//method get VideoID

-(void)getVideoID:(NSString*)PlaylistID{
    
    NSLog(@"Request PlaylistID");
    NSString *requestURL = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=%@&key=AIzaSyAfc0hEne4bOuLRxqCCN1ndaPx6gpMgjD4",PlaylistID];
    
    NSURLRequest *theRequest= [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    //create connection and can use delegate of connection
    NSURLConnection *theConnection = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    if (!theConnection) {
        self.receiverData = nil;
    }
    
    [theConnection start];
    
}

//method get VideoID nextPageToken

-(void)getVideoIDPageToken:(NSString*)PlaylistID pageToken:(NSString*)pageToken{
    NSLog(@"Request nextPageTokenID");
    NSString *requestURL = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=%@&pageToken=%@&key=AIzaSyAfc0hEne4bOuLRxqCCN1ndaPx6gpMgjD4",PlaylistID,pageToken];
    
    NSURLRequest *theRequest= [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    //create connection and can use delegate of connection
    NSURLConnection *theConnection = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    if (!theConnection) {
        self.receiverData = nil;
    }
    
    [theConnection start];
    
}

-(NSDictionary*)parseJSON:(NSData *)data{
    NSError *parseJSONerror=nil;
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseJSONerror];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
   
    NSString *absoluteURL = [connection.currentRequest.URL absoluteString];
    NSLog(@"Request URL");
    if (!self.receiverDatawithURL) {
        self.receiverDatawithURL = [NSMutableDictionary dictionary];
    }
    //create receiveData for this URL
    NSMutableData *receiveData = [NSMutableData data];
    [self.receiverDatawithURL setObject:receiveData forKey:absoluteURL];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"ReceiveData");
    NSString *absoluteURL = [connection.currentRequest.URL absoluteString];
    
    NSMutableData *receiveData = [self.receiverDatawithURL objectForKey:absoluteURL];
    if (receiveData) {
        [receiveData appendData:data];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"finishLoading");
    
    NSString *absoluteURL = [connection.currentRequest.URL absoluteString];
    
    NSMutableData *receiveData = [self.receiverDatawithURL objectForKey:absoluteURL];
    
    self.requestGoogle = [self parseJSON:receiveData];
    
    [self.receiverDatawithURL removeObjectForKey:absoluteURL];
    
    if (![[self.requestGoogle allKeys] containsObject:@"nextPageToken"]&&![[self.requestGoogle allKeys] containsObject:@"prevPageToken"]){
        
        self.reponseData = [self.requestGoogle objectForKey:@"items"];
        
        for(int i =0; i<self.reponseData.count;i++){
            
            NSString *IDVideo =[[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"resourceId"]objectForKey:@"videoId"];
            [self.arrIDVideo addObject:IDVideo];
            
            NSLog(@"Video ID %ld",(long)self.arrIDVideo.count);
            NSLog(@"ID Video %@",IDVideo);
            
            NSString *titleChannel =[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"channelTitle"];
            [self.arrTitleChannel addObject:titleChannel];
            
            NSString *time =[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"publishedAt"];
            [self.arrTimeVideo addObject:time];
            
            if (![[[[self.reponseData objectAtIndex:i]  objectForKey:@"snippet"] allKeys] containsObject:@"thumbnails"])  {
                NSString *thumbnail=  @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRqP2eKXPBcDFlGZ8nQdpeicP2Kl2sMf_AcVS1H4d8SdzkcSHg2g";
                [self.arrThumbnailVideo addObject:thumbnail];

            }
            else {
                NSString *thumbnail= [[[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"thumbnails"]objectForKey:@"default"]objectForKey:@"url"];
                [self.arrThumbnailVideo addObject:thumbnail];
            }
            
            NSString *titleVideo= [[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"title"];
            [self.arrTitleVideo addObject:titleVideo];
            NSLog(@"title Video %@",titleVideo);
        }
        [self.indicator stopAnimating];
        self.playlistTableView.hidden=NO;
        [self performSegueWithIdentifier:@"segueVideo" sender:self];
    }
    else if([[self.requestGoogle allKeys] containsObject:@"nextPageToken"]&&![[self.requestGoogle allKeys] containsObject:@"prevPageToken"]){
        
        self.reponseData = [self.requestGoogle objectForKey:@"items"];
        
        for(int i =0; i<self.reponseData.count;i++){
            
            NSString *IDVideo =[[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"resourceId"]objectForKey:@"videoId"];
            [self.arrIDVideo addObject:IDVideo];
            
            NSLog(@"Video ID %ld",(long)self.arrIDVideo.count);
            NSLog(@"ID Video %@",IDVideo);
            
            NSString *titleChannel =[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"channelTitle"];
            [self.arrTitleChannel addObject:titleChannel];
            
            NSString *time =[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"publishedAt"];
            [self.arrTimeVideo addObject:time];
            
            if (![[[[self.reponseData objectAtIndex:i]  objectForKey:@"snippet"] allKeys] containsObject:@"thumbnails"])  {
                NSString *thumbnail=  @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRqP2eKXPBcDFlGZ8nQdpeicP2Kl2sMf_AcVS1H4d8SdzkcSHg2g";
                [self.arrThumbnailVideo addObject:thumbnail];
                
            }
            else {
                NSString *thumbnail= [[[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"thumbnails"]objectForKey:@"default"]objectForKey:@"url"];
                [self.arrThumbnailVideo addObject:thumbnail];
            }
            
            
            NSString *titleVideo= [[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"title"];
            [self.arrTitleVideo addObject:titleVideo];
            NSLog(@"title Video %@",titleVideo);
        }
        nextPageToken = [self.requestGoogle objectForKey:@"nextPageToken"];
        [self getVideoIDPageToken:plID pageToken:nextPageToken];
        
        
    }
    else if([[self.requestGoogle allKeys] containsObject:@"nextPageToken"]&&[[self.requestGoogle allKeys] containsObject:@"prevPageToken"]){
        
        self.reponseData = [self.requestGoogle objectForKey:@"items"];
        
        for(int i =0; i<self.reponseData.count;i++){
            
            NSString *IDVideo =[[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"resourceId"]objectForKey:@"videoId"];
            [self.arrIDVideo addObject:IDVideo];
            
            NSLog(@"Video ID %ld",(long)self.arrIDVideo.count);
            NSLog(@"ID Video %@",IDVideo);
            
            NSString *titleChannel =[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"channelTitle"];
            [self.arrTitleChannel addObject:titleChannel];
            
            NSString *time =[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"publishedAt"];
            [self.arrTimeVideo addObject:time];
            
            if (![[[[self.reponseData objectAtIndex:i]  objectForKey:@"snippet"] allKeys] containsObject:@"thumbnails"])  {
                NSString *thumbnail=  @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRqP2eKXPBcDFlGZ8nQdpeicP2Kl2sMf_AcVS1H4d8SdzkcSHg2g";
                [self.arrThumbnailVideo addObject:thumbnail];
                
            }
            else {
                NSString *thumbnail= [[[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"thumbnails"]objectForKey:@"default"]objectForKey:@"url"];
                [self.arrThumbnailVideo addObject:thumbnail];
            }
            
            
            NSString *titleVideo= [[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"title"];
            [self.arrTitleVideo addObject:titleVideo];
            NSLog(@"title Video %@",titleVideo);
        }

            nextPageToken = [self.requestGoogle objectForKey:@"nextPageToken"];
            
            [self getVideoIDPageToken:plID pageToken:nextPageToken];
        
        
    }
    else if(![[self.requestGoogle allKeys] containsObject:@"nextPageToken"]&&[[self.requestGoogle allKeys] containsObject:@"prevPageToken"]){
       
        self.reponseData = [self.requestGoogle objectForKey:@"items"];
        
        for(int i =0; i<self.reponseData.count;i++){
            
            NSString *IDVideo =[[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"resourceId"]objectForKey:@"videoId"];
            [self.arrIDVideo addObject:IDVideo];
            
            NSLog(@"Video ID %ld",(long)self.arrIDVideo.count);
            NSLog(@"ID Video %@",IDVideo);
            
            NSString *titleChannel =[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"channelTitle"];
            [self.arrTitleChannel addObject:titleChannel];
            
            NSString *time =[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"publishedAt"];
            [self.arrTimeVideo addObject:time];
            if (![[[[self.reponseData objectAtIndex:i]  objectForKey:@"snippet"] allKeys] containsObject:@"thumbnails"])  {
                NSString *thumbnail=  @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRqP2eKXPBcDFlGZ8nQdpeicP2Kl2sMf_AcVS1H4d8SdzkcSHg2g";
                [self.arrThumbnailVideo addObject:thumbnail];
                
            }
            else {
                NSString *thumbnail= [[[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"thumbnails"]objectForKey:@"default"]objectForKey:@"url"];
                [self.arrThumbnailVideo addObject:thumbnail];
            }
            
            
            NSString *titleVideo= [[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"title"];
            [self.arrTitleVideo addObject:titleVideo];
            NSLog(@"title Video %@",titleVideo);
        }
         [self.indicator stopAnimating];
        self.playlistTableView.hidden=NO;
            [self performSegueWithIdentifier:@"segueVideo" sender:self];
 
    }

}


@end
