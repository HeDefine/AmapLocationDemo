//
//  ViewController.m
//  AmapLocationDemo
//
//  Created by cybl on 2022/1/5.
//

#import "ViewController.h"
#import <AMapLocationKit/AmapLocationKit.h>

@interface ViewController ()<AMapLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;

@property (nonatomic, strong) AMapLocationManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"===== %@", self.manager);
}

- (IBAction)btnClick:(id)sender {
    [self.manager startUpdatingLocation];
}

- (AMapLocationManager *)manager {
    if (_manager == nil) {
        _manager = [[AMapLocationManager alloc] init];
        if (_manager == nil) {
            [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
            [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
            _manager = [[AMapLocationManager alloc] init];
        }
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        _manager.distanceFilter = 0.1;
        _manager.locationTimeout = 5;
        _manager.locatingWithReGeocode = YES; //返回地理信息
        _manager.reGeocodeTimeout = 5;
        _manager.allowsBackgroundLocationUpdates = YES; //允许后台定位,如果要开启，必须得设置Background Mode
    }
    return _manager;

}

#pragma mark - 高德回调
/// 申请定位权限
/// FIXME: 这个方法有问题，不再调用了
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager {
    [locationManager requestAlwaysAuthorization];
}

/// 定位错误
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败, 继续定位");
}

/// 连续定位回调
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    NSLog(@"定位成功：%@, %@", reGeocode.description, location.description);
    [self.manager stopUpdatingLocation];
}

/// 定位权限状态改变时回调函数。注意：iOS13及之前版本回调
/// @param manager AMapLocationManager 类。
/// @param status 定位权限状态。
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"状态更改时，重新定位");
}

/// 定位权限状态改变时回调函数。注意：iOS14及之后版本回调
/// @param manager AMapLocationManager 类。
/// @param locationManager CLLocationManager类 locationManager.authorizationStatus获取定位权限，locationManager.accuracyAuthorization获取定位精度权限
- (void)amapLocationManager:(AMapLocationManager *)manager locationManagerDidChangeAuthorization:(CLLocationManager*)locationManager {
    NSLog(@"状态更改时，重新定位");
}


@end
