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
    [dialClient findServers];
}

- (void)dialServerListUpdated:(NSArray *)servers
{
    NSLog(@"dialServerListUpdated");
    for (CocoaDialServerObject* result in servers){
        NSLog(@"%@ %@ %@ %@",result.location, result.hostAddress, result.usn, result.uuid);
    }
}



@end
