//
//  CDCViewController.m
//  CocoaDialClient
//
//  Created by Lucas Caldoncelli Rodrigues on 04/22/2019.
//  Copyright (c) 2019 Lucas Caldoncelli Rodrigues. All rights reserved.
//

#import "CDCViewController.h"
@interface CDCViewController ()

@end

CocoaDialClient *dialClient;

@implementation CDCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    dialClient = [[CocoaDialClient alloc] initWithDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)send:(id)sender
{
    [dialClient findServersWithTimeout:5000];
}
- (IBAction)launch:(id)sender {
    NSArray *servers = [dialClient getServers];
    if (servers != nil && servers.count > 0) {
        [dialClient launchApplication:@"Netflix" atServer:[servers objectAtIndex:0] withParameters:nil];
    }
}
- (IBAction)getStatus:(id)sender {
    NSArray *servers = [dialClient getServers];
    if (servers != nil && servers.count > 0) {
        [dialClient getApplicationData:@"Netflix" atServer:[servers objectAtIndex:0] completionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable connectionError) {
            NSLog(@"%@", data);
        }];
    }
}

- (void)dialServerListUpdated:(NSArray *)servers
{
    NSLog(@"dialServerListUpdated");
    for (CocoaDialServerObject* result in servers){
        NSLog(@"\nLocation:%@\nHostAddress:%@\nUsn:%@\nUuid:%@\nApplicationUrl:%@\nFriendlyName:%@\nModelName:%@",result.location, result.hostAddress, result.usn, result.uuid, result.applicationUrl, result.friendlyName, result.modelName);
    }
}

@end
