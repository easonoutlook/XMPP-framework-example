//
//  XMPPDataModel.h
//  AskedonTable
//
//  Created by Belov Alexandr on 4/22/13.
//  Copyright (c) 2013 Lenhador. All rights reserved.
//

@protocol ReceiveMessageDelegate <NSObject>
@required
- (void) newMessage : (NSString *) msg;

@end
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "XMPPFramework.h"

@interface XMPPDataModel : NSObject <XMPPRosterDelegate>
{
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic) NSString *fromJid;
@property (nonatomic) id delegate;

- (id) initWithDelegate : (id) delegateObject;
- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;
- (void)sendMsgWithString : (NSString *)messageStr;
- (BOOL)connect;
- (void)disconnect;

@end
