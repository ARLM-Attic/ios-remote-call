//
//  API.m
//  iPhoneWrapperTest
//
//  Created by Chris Burns on 10-06-07.
//  Copyright 2010 University of Calgary. All rights reserved.
//

#import "MethodSender.h"


@implementation MethodSender


@synthesize deviceID; 
@synthesize connections;
@synthesize baseAddress; 



#pragma mark -
#pragma mark Constructor & Class Methods

- (id) init 
{
	
	if (self = [super init]) 
	{
		connections = [[NSMutableSet alloc] init];
		

	}
	
	
	return self;
	
	
}

- (void ) dealloc 
{
	
	[connections release];
	[super dealloc];
	
}

/* Testing Methods Only */

- (void) testString {
	
	NSLog(@"Test String activated"); 
	Connection *connect = [[Connection alloc] init];
	connect.onRetrieveDataAction = NSSelectorFromString(@"onTestStringReturn:");
	connect.onRetrieveDataTarget = self;
	connect.asynchronous = YES;
	
	[connect sendWithMethod:@"iphonetest" usingVerb:@"GET" andParameters:nil];
	
}




- (void) onTestStringReturn:(NSData *)data {
	
	
	
	NSLog(@" %@ ", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] deserializeString]);
	
	
}

- (void) onRegisterDeviceReturn: (NSData *) data {
	
	
	
	NSLog(@" %@ ", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	
	
	
	
}






/* registerDevice will send out a request to register the device. Since the only information
 required (the UUID) is already included we do not need any parameters
 */
- (void) registerDevice: (id) target andSelector: (SEL) selector
{


	/*Since we do not need a return no onDataRetrieved targets or actions are needed*/
	Connection *con = [[Connection alloc]	initWithRetrieveTarget:target 
											andRetrieveAction:selector];
	
	
		
	[con sendWithMethod:@"register" usingVerb:@"POST" andParameters:nil];
	
	
	[connections addObject:con];
	
	
	
}

/* deregisterDevice will send out a request to deregister the device. Since the only information
 required (the UUID) is already included we do not need any parameters
 */
- (void) deregisterDevice 
{
	/*Since we do not need a return no onDataRetrieved targets or actions are needed*/
	Connection *con = [[Connection alloc] initWithRetrieveTarget:nil andRetrieveAction:nil];
	
	
	[con sendWithMethod:@"register" usingVerb:@"POST" andParameters:nil];
	
	
	[connections addObject:con];
	

}

- (void) sendJPEG:(UIImage *)image withName:(NSString *) name {
	

	
	SEL onJPEGRetrieved = NSSelectorFromString(@"onJPEGRetrieved:");
	Connection *con = [[Connection alloc] initWithRetrieveTarget:self andRetrieveAction:onJPEGRetrieved];
	con.asynchronous = NO;
	
	NSData *data = UIImageJPEGRepresentation(image, 1.0);
	
	NSString *lengthOfData = [NSString stringWithFormat:@"%d", [data length]];
	//NSLog(@"Length of Data %@", lengthOfData); 
	
	//Intialize the transfer witha  call to "uploadstart"
	[con	sendWithMethod:@"uploadstart" usingVerb:@"POST" 
			andParameters:[[NSArray alloc] initWithObjects:name,@"jpg",lengthOfData, nil]];
	 
	
	 
	//Iterate Through The Data Transfering Each In Order
	
	NSUInteger transferredBytes = 0;
	NSUInteger transfer = 5000;
	NSString *lengthOfTransfer  = nil;
	
	
	while (transferredBytes < [data length]) {
		
		if (transfer > [data length] - transferredBytes) { transfer = [data length] - transferredBytes;}
		
		NSRange range = NSMakeRange(transferredBytes, transfer);
		NSData *chunk = [data subdataWithRange:range];
		
		transferredBytes += transfer;
		lengthOfTransfer = [NSString stringWithFormat:@"%d", transfer];
		
		
		NSLog(@"Transfer Message %d of %d with  %d sent", transferredBytes,[data length], transfer);
		[con	uploadData:chunk withMethod:@"upload" 
				andParameters:[[NSArray alloc] initWithObjects:name,@"jpg",lengthOfTransfer, nil]];
		
		
		
	}
	 
	[con	sendWithMethod:@"uploadfinish" usingVerb:@"POST" 
		  andParameters:[[NSArray alloc] initWithObjects:name,@"jpg",nil]];
	
}

- (void) onJPEGRetrieved: (NSData *) data {
	
	
	
	
	
	
}


/* onMethodCallReturn - This is called at the completion of the NSInvocationOperation to return values to calling server. The results
 * of the method are returns as an NSArray and all that are paired with it are sent to the server via a REST call through the connection*/
- (void) onMethodCallReturn:(id)returnValue {
	
	
	NSArray *params = (NSArray *) returnValue; 
	
		
	
	
	//We create a Connection object to call the return method on the server. The target/action is left as nil since there will be no return.
	Connection *outgoing = [[Connection alloc] init]; 
	
	
	
	[outgoing sendWithMethod:@"return" usingVerb:@"POST" andParameters:params]; 
	
	
	
	
	
}

/* onMethodCallException: - This method is called whenever there is an exception thrown while the NSInvocationOperation
 * is running. The value of the exception is assumed to be an NSString */
- (void) onMethodCallException:(id)exceptionValue {
	
	
	NSString *exception = (NSString *) exceptionValue; 
	NSArray *exceptionReturn = [NSArray arrayWithObject:exception];
	
	Connection *outgoing = [[Connection alloc] init]; 
	
	
	[outgoing sendWithMethod:@"exception" usingVerb:@"POST" andParameters:exceptionReturn];
	
	
	
}


@end
