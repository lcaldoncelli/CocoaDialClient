//
//  CocoaDialClient
//
//  This class is in the public domain.
//  Originally created by Lucas Caldoncelli Rodrigues on 04/22/2019.
//  Updated and maintained by Lucas Caldoncelli Rodriguesand the Apple development community.
//
//  https://github.com/lcaldoncelli/CocoaDialClient
//

#import "CocoaDialClient.h"
#import <XMLDictionary/XMLDictionary.h>

@interface CocoaDialClient ()
@end

@implementation CocoaDialClient

@synthesize udpSocket;
@synthesize delegate;
@synthesize servers;

- (id)init
{
    self.servers = [[NSMutableArray alloc] init];
    [self setupSocket];
    return self;
}

- (id)initWithDelegate:(nullable id <CocoaDialClientDelegate>)aDelegate
{
    self->delegate = aDelegate;
    return [self init];
}

- (BOOL)findServers {
    return [self findServersWithTimeout:3000];
}

- (NSArray *) getServers {
    return self.servers;
}

- (BOOL)findServersWithTimeout:(int)timeoutMs {
    [self.servers removeAllObjects];
    NSString *host = @"239.255.255.250";
    int port = 1900;
    NSString *msg = @"M-SEARCH * HTTP/1.1\r\n HOST:239.255.255.250:1900\r\nST:urn:dial-multiscreen-org:service:dial:1\r\nMX:2\r\nMAN:\"ssdp:discover\"\r\n\r\n";
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:0];
    
    [NSTimer scheduledTimerWithTimeInterval:(timeoutMs/1000)
                                     target:self
                                   selector:@selector(findServersTimeout)
                                   userInfo:nil
                                    repeats:NO];
    return YES;
}
- (void)setupSocket
{
    // Setup our socket.
    // The socket will invoke our delegate methods using the usual delegate paradigm.
    // However, it will invoke the delegate methods on a specified GCD delegate dispatch queue.
    //
    // Now we can configure the delegate dispatch queues however we want.
    // We could simply use the main dispatc queue, so the delegate methods are invoked on the main thread.
    // Or we could use a dedicated dispatch queue, which could be helpful if we were doing a lot of processing.
    //
    // The best approach for your application will depend upon convenience, requirements and performance.
    //
    // For this simple example, we're just going to use the main thread.
    
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    
    if (![udpSocket bindToPort:65507 error:&error]) {
        NSLog(@"Error binding: %@", error);
        return;
    }
    
    if (![udpSocket beginReceiving:&error]) {
        NSLog(@"Error receiving: %@", error);
        return;
    }
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    // You could add checks here
//    NSLog(@"didSendDataWithTag: %ld", tag);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    // You could add checks here
//    NSLog(@"didNotSendDataWithTag: %ld", tag);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg) {
//        NSLog(@"RECV: %@", msg);
        [servers addObject:[self parseServer:msg]];
    } else {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        
//        NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
    }
}

- (CocoaDialServerObject*) parseServer:(NSString*)msg
{
    CocoaDialServerObject* result = [[CocoaDialServerObject alloc] init];
    NSArray *array = [msg componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    bool found = NO;
    for (NSString* line in array) {
        //NSLog(@">>>%@",line);
        if ([line hasPrefix:@"LOCATION: "]) {
            //LOCATION: http://192.168.15.7:56790/dd.xml
            NSString *location = [line stringByReplacingOccurrencesOfString:@"LOCATION: " withString:@""];
            location = [location stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            result.location = location;
            
            NSURL* url = [NSURL URLWithString:location];
            result.hostAddress = [url host];
        } else if ([line hasPrefix:@"ST: urn:dial-multiscreen-org:service:dial:1"]) {
            found = YES;
        } else if ([line hasPrefix:@"USN: "]) {
            //USN: uuid:4fe3c6c4-6613-11e9-a85f-8c10d4d95e46::urn:dial-multiscreen-org:service:dial:1
            NSString *usn = [line stringByReplacingOccurrencesOfString:@"USN: " withString:@""];
            usn = [usn stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            result.usn = usn;
            
            NSString *uuid = [usn stringByReplacingOccurrencesOfString:@"uuid:" withString:@""];
            uuid = [uuid stringByReplacingOccurrencesOfString:@"::urn:dial-multiscreen-org:service:dial:1" withString:@""];
            result.uuid = uuid;
        }
    }
    
//    NSLog(@"%@ %@ %@ %@",result.location, result.hostAddress, result.usn, result.uuid);
    
    if (found) {
        NSURL *url = [NSURL URLWithString:result.location];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                NSLog(@"Error,%@", [error localizedDescription]);
            } else {
                [self parseAndUpdateServerInfo:data response:response forServer:result];
            }
        }];
        return result;
    }
    
    return nil;
}

- (BOOL)parseAndUpdateServerInfo:(NSData *)data response:(NSURLResponse*)response forServer:(CocoaDialServerObject*) server
{
    XMLDictionaryParser * parser = [[XMLDictionaryParser alloc] init];
    NSDictionary *dict = [parser dictionaryWithData:data];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *headers = [httpResponse allHeaderFields];
    server.applicationUrl = [headers valueForKey:@"Application-URL"];
    
    NSDictionary *device = [dict valueForKey:@"device"];
    if (device != nil) {
        server.friendlyName = [device valueForKey:@"friendlyName"];
        server.modelName = [device valueForKey:@"modelName"];
        return YES;
    }
    return NO;
}

-(void) findServersTimeout {
    if (self.delegate != nil
        && [self.delegate conformsToProtocol:@protocol(CocoaDialClientDelegate)]
           && [self.delegate respondsToSelector:@selector(dialServerListUpdated:)]) {
            [self.delegate dialServerListUpdated:servers];
    }
}

- (BOOL)getApplicationData:(NSString*)applicationName atServer:(CocoaDialServerObject*)server completionHandler:(void (^)(NSDictionary* _Nullable data, NSError* _Nullable connectionError)) handler
{
    if (server != nil && server.applicationUrl != nil && server.applicationUrl.length > 0 ) {
        NSURL *url = [NSURL URLWithString:[server.applicationUrl stringByAppendingString:applicationName]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSDictionary *result = nil;
            if (!error) {
                XMLDictionaryParser * parser = [[XMLDictionaryParser alloc] init];
                result = [parser dictionaryWithData:data];
            }
            
            if (handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(result, error);
                });
            }
        }];
    }
    return NO;
}

- (BOOL)launchApplication:(NSString*)applicationName atServer:(CocoaDialServerObject*)server withParameters:(NSString*)parameters
{
    if (server != nil && server.applicationUrl != nil && server.applicationUrl.length > 0 ) {
        NSURL *url = [NSURL URLWithString:[server.applicationUrl stringByAppendingString:applicationName]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod:@"POST"];
        
        if (parameters != nil && parameters.length > 0) {
            [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                NSLog(@"Error Launching Application %@", [error localizedDescription]);
            }
        }];
        return YES;
    }
    return NO;
}

@end
