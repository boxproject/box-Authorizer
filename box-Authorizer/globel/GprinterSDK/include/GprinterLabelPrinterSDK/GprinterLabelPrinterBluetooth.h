//
//  GprinterLabelPrinterBluetooth.h
//  GprinterLabelPrinterSDK
//
//  Created by ShaoDan on 2017/7/21.
//  Copyright © 2017年 Gainscha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>



// 发送数据时，需要分段的长度,可修改
#define Length   90

@class GprinterLabelPrinterBluetooth;

typedef NS_ENUM(NSInteger, ScanError) {
    ScanErrorUnknown = 0,
    ScanErrorResetting,
    ScanErrorUnsupported,         //设备不支持
    ScanErrorUnauthorized,        //未授权
    ScanErrorPoweredOff,          //蓝牙可用，但是未打开
    ScanErrorTimeout,             //搜索超时
};

typedef NS_ENUM(NSInteger, OptionStage) {
    OptionStageConnection,            //蓝牙连接阶段
    OptionStageSeekServices,          //搜索服务阶段
    OptionStageSeekCharacteristics,   //搜索特性阶段
    OptionStageSeekdescriptors,       //搜索描述信息阶段
};
/**
 *  扫描成功的block
 *
 *  @param perpherals 蓝牙外设列表
 */
typedef void(^ScanPerpheralSuccess)(NSArray<CBPeripheral *> *perpherals, BOOL isTimeout);

/**
 *  扫描失败的block
 *
 *  @param error 失败的字典
 */
typedef void(^ScanPerpheralFailure)(ScanError error);

/**
 *  连接完成的block
 *
 *  @param perpheral 要连接的蓝牙外设
 */
typedef void(^ConnectCompletion)(CBPeripheral *perpheral, NSError *error);

/**
 *  连接、扫描服务、扫描特性、扫描描述全套流程
 *
 *  @param stage     枚举  所处阶段
 *  @param perpheral 蓝牙外设
 *  @param error     错误信息
 */
typedef void(^FullOptionCompletion)(OptionStage stage, CBPeripheral *perpheral, NSError *error);

/**
 *  断开蓝牙连接
 *
 *  @param perpheral 蓝牙外设
 *  @param error        错误
 */
typedef void(^Disconnect)(CBPeripheral *perpheral, NSError *error);

/**
 *  打印回调
 *
 *  @param completion 是否完成
 *  @param error      错误信息
 */
typedef void(^PrintResult)(CBPeripheral *connectPerpheral, BOOL completion, NSString *error);


@protocol GprinterLabelPrinterBlueToothDeledage <NSObject>

/** 返回扫描到的蓝牙 设备列表
 *  因为蓝牙模块一次返回一个设备，所以该方法会调用多次
 */
- (void)printerManager:(GprinterLabelPrinterBluetooth *)manager perpherals:(NSArray<CBPeripheral *> *)perpherals isTimeout:(BOOL)isTimeout;

/** 扫描蓝牙设备失败
 *
 */
- (void)printerManager:(GprinterLabelPrinterBluetooth *)manager scanError:(ScanError)error;

/**
 *  连接蓝牙外设完成
 *
 *  @param manager   管理中心
 *  @param perpheral 蓝牙外设
 *  @param error     错误
 */
- (void)printerManager:(GprinterLabelPrinterBluetooth *)manager completeConnectPerpheral:(CBPeripheral *)perpheral error:(NSError *)error;

/**
 *  断开连接
 *
 *  @param manager    管理中心
 *  @param peripheral 设备
 *  @param error      错误信息
 */
- (void)printerManager:(GprinterLabelPrinterBluetooth *)manager disConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

@end



@interface GprinterLabelPrinterBluetooth : NSObject
/*蓝牙操作代理 */
@property (assign, nonatomic)   id<GprinterLabelPrinterBlueToothDeledage>             delegate;

/*当前连接的外设 */
@property (strong, nonatomic, readonly) CBPeripheral *connectedPerpheral;


#pragma mark - bluetooth method

+ (instancetype)sharedInstance;

/**
 *  上次连接的蓝牙外设的UUIDString
 *
 *  @return UUIDString,没有时返回nil
 */
+ (NSString *)UUIDStringForLastPeripheral;

/**
 *  蓝牙外设是否已连接
 *
 *  @return YES/NO
 */
- (BOOL)isConnected;

/**
 *  开始扫描蓝牙外设
 *  @param timeout 扫描超时时间,设置为0时表示一直扫描
 */
- (void)startScanPerpheralTimeout:(NSTimeInterval)timeout;

/**
 *  开始扫描蓝牙外设，block方式返回结果
 *  @param timeout 扫描超时时间，设置为0时表示一直扫描
 *  @param success 扫描成功的回调
 *  @param failure 扫描失败的回调
 */
- (void)startScanPerpheralTimeout:(NSTimeInterval)timeout Success:(ScanPerpheralSuccess)success failure:(ScanPerpheralFailure)failure;

/**
 *  停止扫描蓝牙外设
 */
- (void)stopScan;

/**
 *  连接蓝牙外设,连接成功后会停止扫描蓝牙外设
 *
 *  @param peripheral 蓝牙外设
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral;

/**
 *  连接蓝牙外设，连接成功后会停止扫描蓝牙外设，block方式返回结果
 *
 *  @param peripheral 要连接的蓝牙外设
 *  @param completion 完成后的回调
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral completion:(ConnectCompletion)completion;

/**
 *  完整操作，包括连接、扫描服务、扫描特性、扫描描述
 *
 *  @param peripheral 要连接的蓝牙外设
 *  @param completion 完成后的回调
 */
- (void)fullOptionPeripheral:(CBPeripheral *)peripheral completion:(FullOptionCompletion)completion;

/**
 *  取消某个蓝牙外设的连接
 *
 *  @param peripheral 蓝牙外设
 */
- (void)cancelPeripheral:(CBPeripheral *)peripheral;

/**
 *  自动连接上次的蓝牙外设
 *
 *  @param timeout    超时
 *  @param completion 完成
 */
- (void)autoConnectLastPeripheralTimeout:(NSTimeInterval)timeout completion:(ConnectCompletion)completion;

/**
 *  设置断开连接的block
 *
 *  @param disconnectBlock 断开
 */
- (void)isDisconnect:(Disconnect)disconnectBlock;

/**
 *  打印自己组装的数据
 *
 *  @param data   数据
 *  @param result 结果
 */
- (void)sendPrintData:(NSData *)data completion:(PrintResult)result;



@end
