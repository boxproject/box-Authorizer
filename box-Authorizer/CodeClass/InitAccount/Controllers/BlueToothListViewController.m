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
#import "GprinterLabelPrinterBluetooth.h"
#import "GprinterLabelPrinterCommand.h"
#import <UIKit/UIKit.h>

static NSString *identifier = @"blueToothList";
#define SubCount  115

@interface BlueToothListViewController ()<UITableViewDataSource,UITableViewDelegate,PrintAlertViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (strong, nonatomic)NSArray  *deviceArray;  /**< 蓝牙设备个数 */

@property (nonatomic,strong)PrintAlertView *printAlertView;
/**< 详情数组 */
@property (strong, nonatomic)NSMutableArray *infoss;
/**< 可写入数据的特性 */
@property (strong, nonatomic)CBCharacteristic *chatacter;

@property (assign, nonatomic)NSInteger printAlertIn;

@property (strong, nonatomic)CBPeripheral *pperipheral;

@property(nonatomic,strong)GprinterLabelPrinterCommand *c;

@end

@implementation BlueToothListViewController

- (GprinterLabelPrinterCommand *)c{
    if (!_c) {
        _c = [[GprinterLabelPrinterCommand alloc] init];
    }
    return _c;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[BoxDataManager sharedManager] saveDataWithCoding:@"launchState" codeValue:@"1"];
    self.title = BlueToothListVCTitle;
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
    GprinterLabelPrinterBluetooth *t = [GprinterLabelPrinterBluetooth sharedInstance];
    [t startScanPerpheralTimeout:10 Success:^(NSArray<CBPeripheral *> *perpherals, BOOL isTimeout) {
        NSLog(@"perpherals:%@",perpherals);
        _deviceArray = perpherals;
        [_tableView reloadData];
        for (id s in self.deviceArray) {
            NSLog(@"::%@",s);
        }
    } failure:^(ScanError error) {
        NSLog(@"error:%ld",(long)error);
    }];
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
    if (_deviceArray.count > 0) {
        CBPeripheral *peripherral =[self.deviceArray objectAtIndex:indexPath.row];
        [cell setDataWithModel:peripherral.name];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *peripheral = [self.deviceArray objectAtIndex:indexPath.row];
    self.pperipheral = peripheral;
    [self connectBlueTooth:peripheral];
}

#pragma mark ----- 查找蓝牙服务 -----
-(void)connectBlueTooth:(CBPeripheral *)peripherall
{
    [[GprinterLabelPrinterBluetooth sharedInstance]connectPeripheral:peripherall completion:^(CBPeripheral *perpheral, NSError *error) {
        if (error) {
        } else {
            [self showAlertView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_printAlertView changePrintState:BTConnectSuccess];
            });
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

-(void)cancelPrintView
{
    [_printAlertView removeFromSuperview];
    _printAlertIn = 0;
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

-(NSArray *)createQRCode
{
    NSArray *codeArray = [NSArray arrayWithObjects:[BoxDataManager sharedManager].stringD, [BoxDataManager sharedManager].passWord, nil];
    NSString *codeSting = [JsonObject dictionaryToarrJson:codeArray];
    NSString *aesStr = [FSAES128 AES128EncryptStrig:codeSting keyStr:[BoxDataManager sharedManager].codePassWord];
    if (aesStr.length >= SubCount) {
        NSString *str1 = [aesStr substringToIndex:SubCount];
        NSString *str2 = [aesStr substringFromIndex:SubCount];
        NSString *str3 = [str2 substringToIndex:SubCount];
        NSString *str4 = [str2 substringFromIndex:SubCount];
        NSArray *subArray = [NSArray arrayWithObjects:str1, str3, str4, nil];
        return subArray;
    }else{
        NSArray *subArray = [NSArray arrayWithObjects:aesStr, nil];
        return subArray;
    }
}

-(void)goToPrinting
{
    NSArray *codeArray = [NSArray arrayWithObjects:[BoxDataManager sharedManager].stringD, [BoxDataManager sharedManager].passWord, nil];
    NSString *codeSting = [JsonObject dictionaryToarrJson:codeArray];
    NSString *aesStr = [FSAES128 AES128EncryptStrig:codeSting keyStr:[BoxDataManager sharedManager].codePassWord];
    //如果你需要连接，立刻去打印
    [[GprinterLabelPrinterBluetooth sharedInstance] fullOptionPeripheral:self.pperipheral completion:^(OptionStage stage, CBPeripheral *perpheral, NSError *error) {
        if (stage == OptionStageSeekCharacteristics) {
            self.c = [[GprinterLabelPrinterCommand alloc]init];
            [self.c clearBuffer];
            NSInteger timestampIn = [[NSDate date]timeIntervalSince1970] * 1000;
            NSString *printTime = [self getElapseTimeToString:timestampIn];
            printTime = [NSString stringWithFormat:@"%@ (%@)",printTime, [BoxDataManager sharedManager].applyer_account];
            /* 指令打印
            */
            /*
            NSString *str1 = @"SPEED 3\r\nDENSITY 2\r\nSET COUNTER @1 1\r\nDIRECTION 1\r\nSIZE 100 mm,100 mm\r\nCLS\r\nGAP 2 mm,0 mm\r\nTEXT 140,100,\"TSS24.BF2\",0,1,1,\"";
            NSString *str4 = @"\"\r\n";
            NSString *str5 = @"QRCODE 140,200,H,4,A,0,\"";
            NSString *str2 = @"\"\r\nREFERENCE 40,40\r\nPRINT 1,1\r\n";
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@", str1,printTime,str4,str5,aesStr, str2];
            [self.c sendcommand:str];
            */
            
            
            /*
             SDK打印
             */
            NSString *printStr = aesStr;
            //SIZE：定义标签纸的宽度及高度 这里为100 mm, 100 mm；
            //SPEED：设定打印机的打印速度 SPEED1～SPEED6
            //DENSITY：设定打印机的打印浓度 0~15 0 表示最淡的浓度，15 表示最深的浓度
            //GAP：定义两张标签之间的间隙距离， GAP m mm, n mm：定义标签间隙高度 (英寸或厘米)，定义标签间隙高度的补偿值 (英寸或厘米)
            [self.c setupForWidth:@"100 mm" heigth:@"100 mm" speed:SPEED3 density:DENSITY7 sensor:GAP vertical:@"2" offset:@"0"];
            //设定打印方向：0 、1
            [self.c Direction:@"1"];
            //打印二维码各参数：X：QRCODE 条码左上角 X 座标；Y：QRCODE 条码左上角 Y 座标；ECC level：错误纠正能力等级； cell width：1~10；mode：自动生成编码/手动生成编码；rotation：顺时针旋转角度；model：条码生成样式：1:(预设), 原始版本、2:扩大版本;mask:范围:0~8，预设 7; Data string:码资料内容
            [self.c QRCodeWithX:@"205" Y:@"230" ECClevel:LEVEL_H cellwidth:@"4" Mode:@"M" rotation:ROTATION_0 model:@"1" mask:@"2" code:printStr];
            //打印文字 语法:TEXT X, Y, ”font”, rotation, x-multiplication, y-multiplication, “content” :font:字型名称 Rotation:顺时针旋转角度 X-multiplication:水平放大值，最大可放大至 10 倍 有效系数:1~10 Y-multiplication:垂直放大值，最大可放大至 10 倍 有效系数:1~10
            [self.c printerfontFormX:@"205" Y:@"150" fontName:SIMPLIFIED_CHINESE rotation:ROTATION_0 magnificationRateX:MUL_1 magnificationRateY:MUL_1 content:printTime];
            //PRINT:将存于数据缓存的标签打印 语法:PRINT m [,n] m:打印张数,N:每张标签需重复打印的张数 1 ≤ m ≤ 999999999 1 ≤ n ≤ 999999999
            [self.c printLabelWithNumberOfSets:@"1" copies:@"1"];
            //发送指令
            [self.c sendToPrinter];
            [[GprinterLabelPrinterBluetooth sharedInstance] sendPrintData:[self.c sendData] completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
                NSLog(@"写入结：%d---错误:%@",completion,error);
                [_printAlertView changePrintState:BTPrintSuccess];
            }];
        }
    }];
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
    [self handleDataCode];
}

-(void)handleDataCode
{
    [[BoxDataManager sharedManager] removeDataWithCoding:@"codePassWord"];
    [[BoxDataManager sharedManager] removeDataWithCoding:@"stringD"];
    [[BoxDataManager sharedManager] removeDataWithCoding:@"passWord"];
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
