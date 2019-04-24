//
//  CocoaDialServerObject.m
//  CocoaAsyncSocket
//
//  Created by Lucas on 23/04/19.
//

#import "CocoaDialServerObject.h"

@implementation CocoaDialServerObject

@synthesize usn;
@synthesize uuid;
@synthesize hostAddress;
@synthesize location;
@synthesize applicationUrl;
@synthesize friendlyName;
@synthesize modelName;

- (id) init {
    self = [super init];
    return self;
}

@end
