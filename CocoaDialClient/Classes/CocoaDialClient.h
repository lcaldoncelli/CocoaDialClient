//
//  CocoaDialClient
//
//  This class is in the public domain.
//  Originally created by Lucas Caldoncelli Rodrigues on 04/22/2019.
//  Updated and maintained by Lucas Caldoncelli Rodriguesand the Apple development community.
//
//  https://github.com/lcaldoncelli/CocoaDialClient
//

#import "GCDAsyncUdpSocket.h"
#import "CocoaDialServerObject.h"

@class CocoaDialClient;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol CocoaDialClientDelegate <NSObject>
@optional
/**
 * This method is called if dial server list is updated.
 **/
- (void)dialServerListUpdated:(NSArray *)servers;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Inteface
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface CocoaDialClient : NSObject<GCDAsyncUdpSocketDelegate>
- (instancetype)init;
- (instancetype)initWithDelegate:(nullable id <CocoaDialClientDelegate>)aDelegate;
- (BOOL)findServers;

@property (nonatomic,retain) id<CocoaDialClientDelegate> delegate;
@property (nonatomic, retain) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic,retain) NSMutableArray *servers;
@end


