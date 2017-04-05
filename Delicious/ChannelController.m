//
//  ChannelController.m
//  Delicious
//
//  Created by Vinh Nguyen on 7/9/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import "ChannelController.h"

static NSString *cellChannelID=@"cellChannelID";
@interface ChannelController ()
@end

static NSString *CellID=@"CellID";

@interface ChannelController ()

@property (strong) NSMutableArray *channels;
@end

@implementation ChannelController

bool flag=NO;
bool searchChannel=NO;

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
    // Do any additional setup after loading the view.
    [self initData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkStatusNotification:) name:kReachabilityChangedNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    //    NSLog(@"%ld", self.reachability.currentReachabilityStatus);
    
}

- (void)handleNetworkStatusNotification:(NSNotification *)note {
    Reachability* curReach = [note object];
    NetworkStatus status = curReach.currentReachabilityStatus;
    
    switch (status) {
        case NotReachable:
        {
            NSLog(@"Internet off");
            UIAlertView *alertError =[[UIAlertView alloc]initWithTitle:@"Error!!!" message:@"Internet not reachable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alertError show];
        }
            break;
            
        case ReachableViaWiFi:
        {
            NSLog(@"Internet on");
            UIAlertView *alertWifi =[[UIAlertView alloc]initWithTitle:@"WIFI reachable" message:@"The internet is working via WIFI." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alertWifi show];
        }
            break;
            
        case ReachableViaWWAN:
        {
            NSLog(@"Internet on");
            UIAlertView *alertWwan =[[UIAlertView alloc]initWithTitle:@"WWAN/3G" message:@"The internet is working via WWAN." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alertWwan show];
        }
            break;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.channelTableView.backgroundColor = [UIColor grayColor];
    self.view.backgroundColor = [UIColor   brownColor ];
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Channel"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeChannel" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    self.channels = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.channelTableView reloadData];
    
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
    
    //search channel
    self.arrTitleChannel = [[NSMutableArray alloc]init];
    self.arrThumbnailChannel = [[NSMutableArray alloc]init];
    self.arrTimeChannel = [[NSMutableArray alloc]init];
    self.arrChannelID = [[NSMutableArray alloc]init];
    
    self.arrChannel = [[NSArray alloc]initWithObjects:self.arrChannelID,self.arrThumbnailChannel,self.arrTitleChannel,self.arrTimeChannel, nil];
    
    //get playlistID from channelID
    self.arrTitlePlaylist = [[NSMutableArray alloc]init];
    self.arrThumbnailPlaylist = [[NSMutableArray alloc]init];
    self.arrTimePlaylist = [[NSMutableArray alloc]init];
    self.arrPlaylistID = [[NSMutableArray alloc]init];
    
    self.arrPlaylist=[[NSArray alloc]initWithObjects:self.arrPlaylistID,self.arrThumbnailPlaylist,self.arrTitlePlaylist, self.arrTimePlaylist,nil];
    
}

#pragma Datasource tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.channels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCell *cell= [tableView dequeueReusableCellWithIdentifier:cellChannelID];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:cellChannelID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellChannelID];
    }
    NSManagedObject *channels = [self.channels objectAtIndex:indexPath.row];
    
    cell.channelTitle.text = [NSString stringWithFormat:@"%@",[channels valueForKey:@"titleChannel" ]];
    NSDate *date = [channels  valueForKey:@"timeChannel"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    //
    //    NSLog(@"The Date: %@", dateString);
    
    cell.channelID.text =dateString;
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.channelImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[channels valueForKey:@"thumbnailChannel"]]]];
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[channels valueForKey:@"thumbnailChannel"]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.channelImage.image = [UIImage imageWithData:imageData];
            
        });
    });
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}


#pragma Delegate tableView

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[self.channels objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [self.channels removeObjectAtIndex:indexPath.row];
        [self.channelTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //     CustomCell *cell= (CustomCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    NSManagedObject *channels = [self.channels objectAtIndex:indexPath.row];
    
    [self getPlaylistID:[channels valueForKey:@"idChannel"]];
    
    NSLog(@"%@",[channels valueForKey:@"idChannel"]);
    searchChannel = YES;
    [self performSegueWithIdentifier:@"seguePlaylist" sender:self];
}

#pragma search and connection

-(NSString*)requestURL: (NSString*)keySearch {
    return [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q=%@+huongdan+nauan&type=channel&key=AIzaSyAfc0hEne4bOuLRxqCCN1ndaPx6gpMgjD4",keySearch] ;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Search Mon an");
    if (flag==NO) {
        
        NSString *request = [self.searchCooking.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *theRequest= [NSURLRequest requestWithURL:[NSURL URLWithString:[self requestURL:request]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        
        //create connection and can use delegate of connection
        NSURLConnection *theConnection = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
        
        if (!theConnection) {
            self.receiverData = nil;
        }
        [theConnection start];
        flag=YES;
    }
    
    else return;
    searchChannel = NO;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchCooking.text = @"";
    //hide keyboard
    [self.searchCooking resignFirstResponder];
}


#pragma mark NSURLConnection Delegate Methods

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
    
    
    
    //gan array items
    self.reponseData = [self.requestGoogle objectForKey:@"items"];
    
    if (searchChannel== NO) {
        
        //get title, channelID, time, thmbnail when search channel
        [self.arrChannelID removeAllObjects];
        [self.arrThumbnailChannel removeAllObjects];
        [self.arrTimeChannel removeAllObjects];
        [self.arrTitleChannel removeAllObjects];
        if(!(self.reponseData.count==0)){
            for(int i =0; i<self.reponseData.count;i++){
                
                NSString *titleChannel =[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"title"];
                [self.arrTitleChannel addObject:titleChannel];
                NSLog(@"Channel %ld",(long)self.arrTitleChannel.count);
                
                NSString *channelId =[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"channelId"];
                [self.arrChannelID addObject:channelId];
                
                NSString *time =[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"publishedAt"];
                [self.arrTimeChannel addObject:time];
                
                NSString *thumbnail= [[[[[self.reponseData objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"thumbnails"]objectForKey:@"default"]objectForKey:@"url"];
                [self.arrThumbnailChannel addObject:thumbnail];
                
            }
        }
        else if(self.reponseData.count==0)
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"No Channel COOKING."
                                      message:@"Please search other channels!!!!"
                                      delegate:self
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        [self.channelTableView reloadData];
        [self performSegueWithIdentifier:@"segueAdd" sender:nil];
        
        flag= NO;
        
    }
    else
    {
        [self.arrTitlePlaylist removeAllObjects];
        [self.arrTimePlaylist removeAllObjects];
        [self.arrThumbnailPlaylist removeAllObjects];
        [self.arrPlaylistID removeAllObjects];
        if (!(self.reponseData.count==0)) {
            for(int i =0; i<self.reponseData.count;i++)
            {
                NSString *playlistID = [[self.reponseData objectAtIndex:i] objectForKey:@"id"];
                [self.arrPlaylistID addObject:playlistID];
                NSLog(@"playlist %ld",(long)self.arrPlaylistID.count);
                
                NSString *titlePlaylist = [[[self.reponseData objectAtIndex:i]objectForKey:@"snippet"]objectForKey:@"title"];
                
                [self.arrTitlePlaylist addObject:titlePlaylist];
                
                NSString *thumbnailPlaylist = [[[[[self.reponseData objectAtIndex:i]objectForKey:@"snippet"]objectForKey:@"thumbnails"]objectForKey:@"default"]objectForKey:@"url"];
                [self.arrThumbnailPlaylist addObject:thumbnailPlaylist];
                
                NSString *timePlaylist = [[[self.reponseData objectAtIndex:i]objectForKey:@"snippet"]objectForKey:@"publishedAt"];
                [self.arrTimePlaylist addObject:timePlaylist];
            }
            
        }
        else if(self.reponseData.count==0)
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"This channel has no playlists."
                                      message:@"You look for other channels!!!!"
                                      delegate:self
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"Ok"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}

//method get playlistID

-(void)getPlaylistID:(NSString*)channelID{
    
    NSLog(@"Request ChannelID");
    NSString *requestURL = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlists?part=snippet&maxResults=50&channelId=%@&key=AIzaSyAfc0hEne4bOuLRxqCCN1ndaPx6gpMgjD4",channelID];
    
    NSURLRequest *theRequest= [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    //create connection and can use delegate of connection
    NSURLConnection *theConnection = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    if (!theConnection) {
        self.receiverData = nil;
    }
    
    [theConnection start];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"segueAdd"]) {
        AddChannelController *addChannel = [segue destinationViewController];
        addChannel.idChannel = self.arrChannelID;
        addChannel.arrAddChannel = self.arrChannel;
    }
    
    if ([segue.identifier isEqualToString:@"seguePlaylist"]) {
        
        PlaylistController *playlist = [segue destinationViewController];
        playlist.idPlaylist = self.arrPlaylistID;
        playlist.arrPlaylist = self.arrPlaylist ;
    }
}

@end

