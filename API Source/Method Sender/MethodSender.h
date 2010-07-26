//
//  API.h
//  
//
//  Created by Chris Burns on 10-06-07.
//  Copyright 2010 University of Calgary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"


@interface MethodSender : NSObject{
	
	NSString *deviceID;
	NSString *baseAddress;
	NSMutableSet *connections;
	NSInteger *bytesPerRequest;

}

@property (nonatomic, retain) NSString *deviceID;
@property (nonatomic, retain) NSString *baseAddress;
@property (nonatomic, retain) NSMutableSet *connections;



- (void) onMethodCallReturn: (id) returnValues;
- (void) onMethodCallException: (id) exceptionValues;




- (void) registerDevice: (id) target andSelector: (SEL) selector;
- (void) deregisterDevice;
- (void) testString;
- (void) onTestStringReturn: (NSData *) data; 

- (void) sendJPEG: (UIImage *)image withName:(NSString *) name;
//-(void) sendXML: (?) xml; 




@end
