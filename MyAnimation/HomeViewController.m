//
//  HomeViewController.m
//  MyAnimation
//
//  Created by tuyunfeng on 15/9/10.
//  Copyright (c) 2015年 tcl. All rights reserved.
//

#import "HomeViewController.h"
#import "BasicAnimationViewController.h"
#import "KeyAnimationViewController.h"
#import "TransitionViewController.h"
#import "Quartz2DViewController.h"
#import "ExternFunction.h"

#import <objc/runtime.h>

#if 1
@interface MyView: NSObject
- (void)setFrame:(CGRect)frame;
@end

@implementation MyView


- (void)setFrame:(CGRect)frame {
    NSLog(@"original set frame");
}


@end

@implementation MyView (MyViewAddtions)

static void mySetFrame(id self, SEL _cmd, CGRect frame);
static void (*setFrameIMP)(id self, SEL _cmd, CGRect frame);

+ (void)load
{
    //    [self swizzle:@selector(setFrame:) with:@selector(my_setFrame:)];
    [self swizzle:@selector(setFrame:) newIMP:(IMP)mySetFrame storeIMP:(IMP *)&setFrameIMP];
}

+ (void)swizzle:(SEL)originalSelector with:(SEL)swizzledSelector
{
    Method original = class_getInstanceMethod(self, originalSelector);
    Method swizzled = class_getInstanceMethod(self, swizzledSelector);
    
    method_exchangeImplementations(original, swizzled);
}

+ (void)swizzle:(SEL)originalSelector newIMP:(IMP)newIMP storeIMP:(IMP *)storeIMP
{
    class_swizzleMethodAndStore(self, originalSelector, newIMP, storeIMP);
}

void mySetFrame(id self, SEL _cmd, CGRect frame)
{
    NSLog(@"my set frame");
    
    setFrameIMP(self, _cmd, frame);
}

BOOL class_swizzleMethodAndStore(Class class, SEL original, IMP replacement, IMP *store)
{
    IMP imp = nil;
    
    Method method = class_getInstanceMethod(class, original);
    
    if (method)
    {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(class, original, replacement, type);
        
        if (!imp)
            imp = method_getImplementation(method);
    }
    
    if (imp && store)
        *store = imp;
    
    return imp != NULL;
}


- (void)my_setFrame:(CGRect)frame {
    // do custom work
    NSLog(@"swizzled setframe");
    
    [self my_setFrame:frame];
}

@end

@interface UITableView (Tracking)

@end

@implementation UITableView (Tracking)

+ (void)load
{
    Class class = [self class];
    
    SEL originalSelector = @selector(setDelegate:);
    SEL swizzledSelector = @selector(cimc_setDelegate:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)cimc_setDelegate:(id<UITableViewDelegate>)delegate
{
    [self cimc_setDelegate:delegate];
    
    Class class = [delegate class];
    
    if (class_addMethod(class, NSSelectorFromString(@"cimc_didSelectRowAtIndexPath"), (IMP)cimc_didSelectRowAtIndexPath, "v@:@@"))
    {
        Method dis_originalMethod = class_getInstanceMethod(class, NSSelectorFromString(@"cimc_didSelectRowAtIndexPath"));
        Method dis_swizzledMethod = class_getInstanceMethod(class, @selector(tableView: didSelectRowAtIndexPath:));
        method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
    }
    
    NSLog(@"exchange success!");
}

void cimc_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, id indexPath)
{
    SEL swizzledSelector = NSSelectorFromString(@"cimc_didSelectRowAtIndexPath");
    [self performSelector:swizzledSelector withObject:tableView withObject:indexPath];
    
    NSLog(@"cimc select indexPath");
}

//-(void)cimc_didSelectRowAtIndexPath:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
//{
//    [self cimc_didSelectRowAtIndexPath:tableView indexPath:indexPath];
//    NSLog(@"cimc select indexPath");
//}

@end
#endif

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *titleArray;
    UITableView *animationTableView;
    BOOL isChanged;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Animation";
    self.view.backgroundColor = [UIColor grayColor];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"换肤" style:UIBarButtonItemStylePlain target:self action:@selector(skinChanged)];
    self.navigationItem.rightBarButtonItem = button;
    
    [self initData];
    [self loadSubview];
    
    [self firstSegment:@"one" :@"two" :@"three"];
    
    NSString *p = (NSString *)[UserDataManager readPassword];
    
    if (p.length)
        [UserDataManager savePassword:@"abc123"];
    
    NSLog(@"password %@", p);
    
    UserDataManager *manager = [[UserDataManager alloc] init];
    manager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)skinChanged
{
    isChanged = !isChanged;
    NSString *skinName = isChanged ? @"Pink" : @"Green";
    setSkin(skinName);
    [animationTableView reloadData];
}

- (void)initData
{
    titleArray = @[@"Basic Animation", @"Keyframe Animation", @"Transition Animation", @"Quartz 2D"];
}

- (void)loadSubview
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    animationTableView = tableView;
}

- (void)firstSegment:(id)firstObj :(id)thirdSegment :(id)thirdObj
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"args[] = {%@, %@, %@}", firstObj, thirdSegment, thirdObj);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleCell = @"simpleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleCell];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = titleArray[indexPath.row];
    
    if (indexPath.row == 0)
        cell.imageView.image = getNamedImage(@"Image", @"icon_msg");
    else
        cell.imageView.image = getImageFromPath(@"Image", @"icon_tel", @"png");
    
//    cell.textLabel.text = @"1234567890";
//    
//    if (indexPath.row == 0)
//        cell.textLabel.font = [UIFont fontWithName:@"Superclarendon-Bold" size:28];
//    if (indexPath.row == 1)
//        cell.textLabel.font = [UIFont fontWithName:@"SavoyeLetPlain-Bold" size:28];
//    if (indexPath.row == 2)
//        cell.textLabel.font = [UIFont fontWithName:@"Menlo-Bold" size:28];
//    if (indexPath.row == 3)
//        cell.textLabel.font = [UIFont fontWithName:@"IowanOldStyle-Bold" size:28];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc;
    
    if (indexPath.row == 0)
        vc = [[BasicAnimationViewController alloc] init];
    else if (indexPath.row == 1)
        vc = [[KeyAnimationViewController alloc] init];
    else if (indexPath.row == 2)
        vc = [[TransitionViewController alloc] init];
    else if (indexPath.row == 3)
        vc = [[Quartz2DViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end

@implementation TEKeyChain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword, (__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock, (__bridge_transfer id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //add new object to search dictionary(Attention: the data format)
    keychainQuery[(__bridge_transfer id)kSecValueData] = [NSKeyedArchiver archivedDataWithRootObject:data];
    //add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //config the search setting
    keychainQuery[(__bridge_transfer id)kSecReturnData] = (id)kCFBooleanTrue;
    keychainQuery[(__bridge_transfer id)kSecMatchLimit] = (__bridge_transfer id)kSecMatchLimitOne;
    
    CFDataRef keyData = NULL;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        }
        @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed %@", service, exception);
        }
        @finally {
            
        }
    }
    
    return ret;
}
@end

@implementation UserDataManager

static const NSString *KEY_KEYCHIAN = @"com.tcl.animation.info";
static const NSString *KEY_PASSWORD = @"com.tcl.user.password";

+ (void)savePassword:(NSString *)password {
    NSMutableDictionary *passwordKVPair = [NSMutableDictionary dictionary];
    passwordKVPair[KEY_PASSWORD] = password;
    [TEKeyChain save:KEY_KEYCHIAN data:passwordKVPair];
}

+ (id)readPassword {
    NSMutableDictionary *passwordKVPair = (NSMutableDictionary *)[TEKeyChain load:KEY_KEYCHIAN];
    return passwordKVPair[KEY_PASSWORD];
}


@end