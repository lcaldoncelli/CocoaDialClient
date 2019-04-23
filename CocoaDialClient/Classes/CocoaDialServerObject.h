//
//  CocoaDialServerObject.h
//  CocoaAsyncSocket
//
//  Created by Lucas on 23/04/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CocoaDialServerObject : NSObject


@property (nonatomic, retain) NSString *usn;
@property (nonatomic, retain) NSString *uuid;

@property (nonatomic, retain) NSString *hostAddress;
@property (nonatomic, retain) NSString *location;

@end

NS_ASSUME_NONNULL_END
