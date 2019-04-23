//
//  CDCViewController.h
//  CocoaDialClient
//
//  Created by Lucas Caldoncelli Rodrigues on 04/22/2019.
//  Copyright (c) 2019 Lucas Caldoncelli Rodrigues. All rights reserved.
//

@import UIKit;
#import "CocoaDialClient.h"

@interface CDCViewController : UIViewController <CocoaDialClientDelegate> {
    
}

- (IBAction)send:(id)sender;

@end
