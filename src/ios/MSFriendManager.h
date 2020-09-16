#import <Meridian/Meridian.h>

@protocol MSFriendManagerObserver;

@interface MSFriendManager : NSObject
+ (instancetype)manager1;
+ (instancetype)manager2;
+ (instancetype)manager3;
+ (void)setActiveManager:(MSFriendManager *)manager;
@property (nonatomic, strong) MRSharingSession *session;
@property (nonatomic, strong) MRFriend *profile;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *invites;
- (void)addObserver:(id<MSFriendManagerObserver>)observer;
- (void)removeObserver:(id<MSFriendManagerObserver>)observer;
- (void)newAccountWithPassword:(NSString *)password name:(NSString *)name;
- (void)deleteAccount;
- (void)acceptInviteURL:(NSURL *)url;
- (void)reloadData;
@end

@protocol MSFriendManagerObserver <NSObject>
@optional
- (void)friendManagerDidUpdate:(MSFriendManager *)manager;
- (void)friendManagerDidFailWithError:(NSError *)error;
@end

@interface UIViewController (MSFriendManager)
- (void)handleFriendError:(NSError *)error;
@end
