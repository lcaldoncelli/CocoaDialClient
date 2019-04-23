# CocoaDialClient
[![Version](https://img.shields.io/cocoapods/v/CocoaDialClient.svg?style=flat)](https://cocoapods.org/pods/CocoaDialClient)
[![License](https://img.shields.io/cocoapods/l/CocoaDialClient.svg?style=flat)](https://cocoapods.org/pods/CocoaDialClient)
[![Platform](https://img.shields.io/cocoapods/p/CocoaDialClient.svg?style=flat)](https://cocoapods.org/pods/CocoaDialClient)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Basic ViewController usage Example:
```
//  ViewController.m
#import "ViewController.h"

@interface ViewController ()
@end

CocoaDialClient *dialClient;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dialClient = [[CocoaDialClient alloc] initWithDelegate:self];
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
```



```
//  ViewController.h
#import <UIKit/UIKit.h>
#import <CocoaDialClient.h>
@interface ViewController : UIViewController<CocoaDialClientDelegate>
- (void)dialServerListUpdated:(NSArray *)servers;
@end
```
## Requirements

## Installation

CocoaDialClient is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CocoaDialClient'
```

## Author

Lucas Caldoncelli Rodrigues, lcaldoncelli@gmail.com

## License

CocoaDialClient is available under the MIT license. See the LICENSE file for more info.
