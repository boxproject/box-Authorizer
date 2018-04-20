//
//  BlueToothListViewController.m
//  BoxAuthorizer
//
//  Created by Rony on 2018/1/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "BlueToothListViewController.h"
#import "HLBLEManager.h"
#import "SVProgressHUD.h"
#import "BlueToothListModel.h"
#import "BlueToothListTableViewCell.h"
#import "PrintAlertView.h"
#import "GenerateContractViewController.h"
#import "HLPrinter.h"

static NSString *identifier = @"blueToothList";

@interface BlueToothListViewController ()<UITableViewDataSource,UITableViewDelegate,PrintAlertViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
/**< 蓝牙设备个数 */
@property (strong, nonatomic)NSMutableArray *deviceArray;

@property (nonatomic,strong)PrintAlertView *printAlertView;
/**< 详情数组 */
@property (strong, nonatomic)NSMutableArray *infoss;
/**< 可写入数据的特性 */
@property (strong, nonatomic)CBCharacteristic *chatacter;

@property (assign, nonatomic)NSInteger printAlertIn;

@end

@implementation BlueToothListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[BoxDataManager sharedManager] saveDataWithCoding:@"launchState" codeValue:@"1"];
    self.title = @"蓝牙";
    self.view.backgroundColor = kWhiteColor;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self createBarItem];
    _deviceArray = [[NSMutableArray alloc] init];
    _infoss = [[NSMutableArray alloc] init];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width , self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = kWhiteColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    _tableView.rowHeight = 55.0;
    [_tableView registerClass:[BlueToothListTableViewCell class] forCellReuseIdentifier:identifier];
    
    HLBLEManager *manager = [HLBLEManager sharedInstance];
    __weak HLBLEManager *weakManager = manager;
    manager.stateUpdateBlock = ^(CBCentralManager *central) {
        NSString *info = nil;
        switch (central.state) {
            case CBCentralManagerStatePoweredOn:
                info = @"蓝牙已打开，并且可用";
                [weakManager scanForPeripheralsWithServiceUUIDs:nil options:nil];
                break;
            case CBCentralManagerStatePoweredOff:
                info = @"蓝牙可用，未打开";
                break;
            case CBCentralManagerStateUnsupported:
                info = @"SDK不支持";
                break;
            case CBCentralManagerStateUnauthorized:
                info = @"程序未授权";
                break;
            case CBCentralManagerStateResetting:
                info = @"CBCentralManagerStateResetting";
                break;
            case CBCentralManagerStateUnknown:
                info = @"CBCentralManagerStateUnknown";
                break;
        }
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showInfoWithStatus:info ];
        [SVProgressHUD dismissWithDelay:1.2];
    };
    
    for (NSDictionary *dic in self.deviArray) {
        [self.deviceArray addObject:dic];
    }
    
    manager.discoverPeripheralBlcok = ^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        if (peripheral.name.length <= 0) {
            return ;
        }
        if (self.deviceArray.count == 0) {
            NSDictionary *dict = @{@"peripheral":peripheral, @"RSSI":RSSI};
            [self.deviceArray addObject:dict];
        } else {
            BOOL isExist = NO;
            for (int i = 0; i < self.deviceArray.count; i++) {
                NSDictionary *dict = [self.deviceArray objectAtIndex:i];
                CBPeripheral *per = dict[@"peripheral"];
                if ([per.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
                    isExist = YES;
                    NSDictionary *dict = @{@"peripheral":peripheral, @"RSSI":RSSI};
                    [_deviceArray replaceObjectAtIndex:i withObject:dict];
                }
            }
            if (!isExist) {
                NSDictionary *dict = @{@"peripheral":peripheral, @"RSSI":RSSI};
                [self.deviceArray addObject:dict];
            }
        }
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"upDateDeviceArr" object:self.deviceArray];
        [self.tableView reloadData];
        
    };
}

#pragma mark - createBarItem
- (void)createBarItem{
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backButtonAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
 
}

//返回按钮
- (void)backButtonAction:(UIBarButtonItem *)buttonItem{

    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    self.arrayListBlock(self.deviceArray);
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlueToothListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSDictionary *dict = [self.deviceArray objectAtIndex:indexPath.row];
    CBPeripheral *peripherral = dict[@"peripheral"];
    BlueToothListModel *model = [[BlueToothListModel alloc] initWithDict:dict];
    [cell setDataWithModel:model];
    if (peripherral.state == CBPeripheralStateConnected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [self.deviceArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = dict[@"peripheral"];
    [self connectBlueTooth:peripheral];
}

#pragma mark ----- 查找蓝牙服务 -----
-(void)connectBlueTooth:(CBPeripheral *)peripherall
{
    HLBLEManager *manager = [HLBLEManager sharedInstance];
    [manager connectPeripheral:peripherall
                connectOptions:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@(YES)}
        stopScanAfterConnected:YES
               servicesOptions:nil
        characteristicsOptions:nil
                 completeBlock:^(HLOptionStage stage, CBPeripheral *peripheral, CBService *service, CBCharacteristic *character, NSError *error) {
                     switch (stage) {
                         case HLOptionStageConnection:
                         {
                             if (error) {
                                 //[SVProgressHUD showErrorWithStatus:@"连接失败"];
                                 
                             } else {
                                 //[SVProgressHUD showSuccessWithStatus:@"连接成功"];
                                //正在连接打印机
                                [self showAlertView];
                             }
                             break;
                         }
                         case HLOptionStageSeekServices:
                         {
                             if (error) {
                                 //[SVProgressHUD showSuccessWithStatus:@"查找服务失败"];
                             } else {
                                 //[SVProgressHUD showSuccessWithStatus:@"查找服务成功"];
                                 [_infoss addObjectsFromArray:peripheral.services];
                                 [self createChatacter];
                                 [_printAlertView changePrintState:BTConnectSuccess];
                             }
                             break;
                         }
                         case HLOptionStageSeekCharacteristics:
                         {
                             // 该block会返回多次，每一个服务返回一次
                             if (error) {
                                 NSLog(@"查找特性失败");
                             } else {
                                 NSLog(@"查找特性成功");
                                 [self createChatacter];
                             }
                             break;
                         }
                         case HLOptionStageSeekdescriptors:
                         {
                             // 该block会返回多次，每一个特性返回一次
                             if (error) {
                                 NSLog(@"查找特性的描述失败");
                             } else {
                                 // NSLog(@"查找特性的描述成功");
                             }
                             break;
                         }
                         default:
                             break;
                     }
                     
                 }];
}

#pragma mark ----- 生成可写入的特性 -----
-(void)createChatacter
{
    for (int i = 0; i < _infoss.count; i ++) {
        CBService *serviceCB = _infoss[i];
        for (int j = 0; j < serviceCB.characteristics.count; j ++) {
            CBCharacteristic *character = [serviceCB.characteristics objectAtIndex: j];
            CBCharacteristicProperties properties = character.properties;
            if (properties & CBCharacteristicPropertyWrite) {
                self.chatacter = character;
            }
        }
    }
}

#pragma mark ----- show PrintAlertView -----
-(void)showAlertView
{
    if (_printAlertIn == 1) {
        return;
    }
    _printAlertIn = 1;
    _printAlertView = [[PrintAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _printAlertView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_printAlertView];
    
}

#pragma mark ----- PrintAlertViewDelegate 立即打印 -----
- (void)printRightNow
{
    [_printAlertView changePrintState:BTPrinting];
    [self goToPrinting];
}

#pragma mark ----- PrintAlertViewDelegate 重新打印 -----
- (void)printNew
{
    [_printAlertView changePrintState:BTPrinting];
    [self goToPrinting];
}

-(void)goToPrinting
{
    HLPrinter *printer = [[HLPrinter alloc] init];
    UIImage *image = [CIQRCodeManager createImageWithString:[BoxDataManager sharedManager].codePassWord];
    [printer appendImage:image alignment:HLTextAlignmentCenter maxWidth:300];
    NSInteger timestampIn = [[NSDate date]timeIntervalSince1970] * 1000;
    NSString *printTime = [self getElapseTimeToString:timestampIn];
    [printer appendFooter:printTime];
    [printer appendFooter:nil];
    NSData *mainData = [printer getFinalData];
    HLBLEManager *bleManager = [HLBLEManager sharedInstance];
    if (_infoss.count & CBCharacteristicPropertyWrite) {
        [bleManager writeValue:mainData forCharacteristic:self.chatacter type:CBCharacteristicWriteWithResponse completionBlock:^(CBCharacteristic *characteristic, NSError *error) {
            if (!error) {
                NSLog(@"写入成功");
                [_printAlertView changePrintState:BTPrintSuccess];
 
            }
        }];
    } else if (_infoss.count & CBCharacteristicPropertyWriteWithoutResponse) {
        [bleManager writeValue:mainData forCharacteristic:self.chatacter type:CBCharacteristicWriteWithoutResponse];
        [_printAlertView changePrintState:BTPrintSuccess];
    }
}

- (NSString *)getElapseTimeToString:(NSInteger)second{
    NSDateFormatter  *dateformatter1 = [[NSDateFormatter alloc] init];
    [dateformatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval timeInterval1 = second/1000;
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeInterval1];
    NSString *dateStr1=[dateformatter1 stringFromDate:date1];
    return dateStr1;
}

#pragma mark ----- PrintAlertViewDelegate 生成合约 -----
- (void)generateContract
{
    [_printAlertView removeFromSuperview];
    GenerateContractViewController *generateContractVC = [[GenerateContractViewController alloc] init];
    UINavigationController *generateContractNV = [[UINavigationController alloc] initWithRootViewController:generateContractVC];
    [self presentViewController:generateContractNV animated:YES completion:nil];
    [[BoxDataManager sharedManager] removeDataWithCoding:@"codePassWord"];
    [[BoxDataManager sharedManager] saveDataWithCoding:@"launchState" codeValue:@"2"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
