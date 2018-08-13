//
//  GprinterLabelPrinterCommand.h
//  GprinterLabelPrinterSDK
//
//  Created by ShaoDan on 2017/7/21.
//  Copyright © 2017年 Gainscha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GprinterLabelPrinterCommand : NSObject
//打印数据(文字图片信息)
@property (nonatomic, strong) NSMutableData *sendData;



typedef enum {
    DENSITY0 = 0,
    DENSITY1 = 1,
    DENSITY2 = 2,
    DENSITY3 = 3,
    DENSITY4 = 4,
    DENSITY5 = 5,
    DENSITY6 = 6,
    DENSITY7 = 7,
    DENSITY8 = 8,
    DENSITY9 = 9,
    DENSITY10 = 10,
    DENSITY11 = 11,
    DENSITY12 = 12,
    DENSITY13 = 13,
    DENSITY14 = 14,
    DENSITY15 = 15,
}DENSITY;

typedef enum {
    DISABLE = 0,
    ENABEL = 1,
}READABLE;

typedef enum {
    ROTATION_0 = 0,
    ROTATION_90 = 90,
    ROTATION_180 =180,
    ROTATION_270 = 270,
}ROTATION;

typedef enum {
    SPEED1 = 1,
    SPEED2 = 2,
    SPEED3 = 3,
    SPEED4 = 4,
    SPEED5 = 5,
    SPEED6 = 6,
}SPEED;


typedef enum {
    FORWARD = 0,
    BACKWARD = 1,
    
}DIRECTION;

typedef enum {
    GAP = 0,
    BLINE = 1,
    
}SENSOR;

typedef enum {
    
    OVERWRITE = 0,
    OR = 1,
    XOR = 2,
    
    
}BITMAPMODE;

typedef enum {
    MUL_1 = 1,
    MUL_2 = 2,
    MUL_3 = 3,
    MUL_4 = 4,
    MUL_5 = 5,
    MUL_6 = 6,
    MUL_7 = 7,
    MUL_8 = 8,
    MUL_9 = 9,
    MUL_10 = 10,
}FONTMAGNIFICATION;

typedef enum {
    //    437: United States
    //    850: Multilingual
    //    852: Slavic
    //    860: Portuguese
    //    863: Canadian/French 865: Nordic
    //    Windows code page 1250: Central Europe 1252: Latin I
    //    1253: Greek
    //    1254: Turkish
    C437 = 437,
    C850 = 850,
    C852 = 852,
    C860 = 860,
    C863 = 863,
    C865 = 865,
    WC1250 = 1250,
    WC1252 = 1252,
    WC1253 = 1253,
    WC1254 = 1254,
    
}CODEPAGE;


typedef NS_ENUM (NSUInteger,FontType){
    FONT_1 = 1,
    FONT_2 = 2,
    FONT_3 = 3,
    FONT_4 = 4,
    FONT_5 = 5,
    FONT_6 = 6,
    FONT_7 = 7,
    FONT_8 = 8,
    //    SIMPLIFIED_CHINESE("TSS24.BF2"),
    //    TRADITIONAL_CHINESE("TST24.BF2"),
    //    KOREAN("K"),
    SIMPLIFIED_CHINESE = 9,
    TRADITIONAL_CHINESE = 10,
    KOREAN = 11,
    
};

typedef NS_ENUM (NSUInteger,BarColorType) {
    CODE128=1,
    
    CODE128M=2,
    
    EAN128=3,
    
    ITF25=4,
    
    ITF25C=5,
    
    CODE39=6,
    
    CODE39C=7,
    
    
    CODE93 = 9,
    
    EAN13 = 10,
    
    EAN13_2 = 11,
    
    EAN13_5 = 12,
    
    EAN8 = 13,
    
    EAN8_2 = 14,
    
    EAN8_5 = 15,
    
    CODABAR = 16,
    
    POSt = 17,
    
    UPCA = 18,
    
    UPCA_2 = 19,
    
    UPCA_5 = 20,
    
    UPCE = 21,
    
    UPCE_2 = 22,
    
    UPCE_5 = 23,
    
    
    MSI = 25,
    
    MSIC = 26,
    
    PLESSEY = 27,
    
    ITF14 = 28,
    
    EAN14 = 29,
    
    //   CODE128 = "128",
    //    CODE128M("128M"),
    //    EAN128("EAN128"),
    //    ITF25("25"),
    //    ITF25C("25C"),
    //    CODE39("39"),
    //    CODE39C("39C"),
    //    CODE39S("39S"),
    //    CODE93("93"),
    //    EAN13("EAN13"),
    //    EAN13_2("EAN13+2"),
    //    EAN13_5("EAN13+5"),
    //    EAN8("EAN8"),
    //    EAN8_2("EAN8+2"),
    //    EAN8_5("EAN8+5"),
    //    CODABAR("CODA"),
    //    POST("POST"),
    //    UPCA("UPCA"),
    //    UPCA_2("UPCA+2"),
    //    UPCA_5("UPCA+5"),
    //    UPCE("UPCE13"),
    //    UPCE_2("UPCE13+2"),
    //    UPCE_5("UPCE13+5"),
    //    CPOST("CPOST"),
    //    MSI("MSI"),
    //    MSIC("MSIC"),
    //    PLESSEY("PLESSEY"),
    //    ITF14("ITF14"),
    //    EAN14("EAN14");
};



typedef NS_ENUM (NSUInteger,QRcodeLevel){
    //    LEVEL_L("L"),
    //    LEVEL_M("M"),
    //    LEVEL_Q("Q"),
    //    LEVEL_H("H");
    LEVEL_L  = 1,
    LEVEL_M  = 2,
    LEVEL_Q  = 3,
    LEVEL_H  = 4,
};



//连接
-(instancetype)openport:(NSString*)host port:(UInt16)port timeout:(NSTimeInterval)timeout;
//断开
- (void)closeport;
//发送给打印机
-(void)sendToPrinter;
//初始化UI
-(void)setupForWidth:(NSString*)w heigth:(NSString*)h speed:(SPEED)sp density:(DENSITY)den sensor:(SENSOR)string vertical:(NSString*)ver offset:(NSString*)off;
//打印文字
-(void)printerfontFormX:(NSString*)x Y:(NSString*)y fontName:(FontType)fonttype rotation:(ROTATION)rotation magnificationRateX:(FONTMAGNIFICATION)mx magnificationRateY:(FONTMAGNIFICATION)my content:(NSString*)text;
//条形码
-(void)barcodeFromX:(NSString*)x Y:(NSString*)y barcodeType:(BarColorType)barcodetype height:(NSString*)h readable:(READABLE)readable rotation:(ROTATION)ro narrow:(NSString*)narrow wide:(NSString*)wide code:(NSString*)codetext;
//二维码
-(void)QRCodeWithX:(NSString*)x Y:(NSString*)y ECClevel:(QRcodeLevel)qrlevel cellwidth:(NSString*)cw Mode:(NSString*)m rotation:(ROTATION)rotation model:(NSString*)model mask:(NSString*)mask code:(NSString*)codetext;
//矩形
-(void)Box:(NSString*)x y:(NSString*)y xend:(NSString*)w yend:(NSString*)h thickness:(NSString*)line;
//划线
-(void)Bar:(NSString*)x y:(NSString*)y width:(NSString*)w height:(NSString*)h;
//打印图片
-(void)PrintPictureWithX:(NSString*)x Y:(NSString*)y mode:(BITMAPMODE)m Image:(UIImage*)img;
//打印份数
-(void)printLabelWithNumberOfSets:(NSString*)m copies:(NSString*)n
;
//发送指令
-(void)sendcommand:(NSString*)commandText;
//十六进制
-(void)sendcommandData:(NSData*)commandtextData;
//CLS
-(void)clearBuffer;
//formfeed
-(void)FormFeed;
//打印方向
-(void)Direction:(NSString*)d;

@end
