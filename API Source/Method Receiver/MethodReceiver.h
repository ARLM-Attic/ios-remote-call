//
//  MethodReceiver.h
//  TestThread
//
//  Created by Chris Burns on 10-07-08.
//  Copyright 2010 University of Calgary. All rights reserved.
//	
//	MethodReciever is the class that handles all incoming messages on the socket connected to the 
//	server. MethodCall's are recieved as plain XML (POX) and are parsed to get access to the method
//	name the messageID number and the parameters. Once this data is collected a selector that matches
//	the called method is located and it, along with the parameters, are bundled together to form a 
//	NSOperationInvocation which is then run concurrently by adding it to an NSOperationQueue. 
//
//
//	Some modifications to the dependent classes have been made.. (TODO) list them.

#import <Foundation/Foundation.h>

#import "AsyncSocket.h"
#import "TouchXML.h"
#import "MethodCollection.h"
#import "Connection.h"

@interface MethodReceiver : NSObject {
	
	
	AsyncSocket *socket;
	NSTimer *timer;
	NSOperationQueue *operationQueue;
	id methods;
	
	
	
	NSString *hostAddress; 
	NSUInteger hostPort; 
	
	BOOL isConnectedToHost; 
	
	
	
	
}

@property (nonatomic, retain) id methods; 



- (id) initWithAddress: (NSString *) ipAddress andPort: (NSUInteger) port;
- (void) startReceiving; 


- (void) parseMethodCallAndSchedule:(NSString *) methodCall; 
- (NSInvocationOperation*) createInvocationForMethod:(NSString *) methodName andParameters: (NSMutableArray *) params withTarget: (id) target;



@end
