#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SoftEtherVPNWrapper : NSObject

/// Connects to a SoftEther VPN server.
/// @param server The VPN server hostname or IP address.
/// @param port The VPN server port (e.g., 443).
/// @param hub The virtual hub name (e.g., "VPN").
/// @param username The VPN username.
/// @param password The VPN password.
/// @return YES if connection was successful, NO otherwise.
+ (BOOL)connectToServer:(NSString *)server
                   port:(NSInteger)port
                   hub:(NSString *)hub
               username:(NSString *)username
               password:(NSString *)password;

/// Disconnects from the SoftEther VPN server.
+ (void)disconnect;

/// Returns YES if the VPN is connected, NO otherwise.
+ (BOOL)isConnected;

@end

NS_ASSUME_NONNULL_END