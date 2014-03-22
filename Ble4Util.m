//
//  Ble4Util.m
//  Ble4Util
//
//  Created by DBY on 14-3-2.
//  Copyright (c) 2014年 dby. All rights reserved.
//

#import "Ble4Util.h"

/** 数据标识 */
typedef NS_ENUM(NSInteger, BleDataSign)
{
    /** 运动模式标志 */
    BleDataSignF3=0xf3,
    /** 睡眠模式标志 */
    BleDataSignF4=0xf4,
    /** 零点创建时间标志 */
    BleDataSignF5=0xf5,
    /** 开机创建时间标志 */
    BleDataSignF6=0xf6,
};

/** 运动数据读取状态 */
typedef NS_ENUM(NSInteger, BleSportsDataReadState)
{
    /** 初始状态 */
    BleSportsDataReadStateNormal=0,
    /** 读取数据标识 */
    BleSportsDataReadStateSign,
    /** 读取运动模式开始时间 */
    BleSportsDataReadStateSportsTime,
    /** 读取睡眠模式开始时间 */
    BleSportsDataReadStateSleepTime,
    /** 读取运动数据 */
    BleSportsDataReadStateSportsData,
    /** 读取睡眠数据 */
    BleSportsDataReadStateSleepData,
};

@implementation BleSportsData

@synthesize calories=_calories;
@synthesize steps=_steps;
@synthesize meters=_meters;

-(id)initWithCalories:(NSInteger)calories andSteps:(NSInteger)steps andMeters:(NSInteger)meters
{
    self=[super init];
    if(self)
    {
        _calories=calories;
        _steps=steps;
        _meters=meters;
    }
    return self;
}

@end

@implementation BleSportsDataList

@synthesize startTime=_startTime;
@synthesize endTime=_endTime;
@synthesize dataType=_dataType;
@synthesize listData=_listData;

-(id)initWithType:(BleSportsDataType)dataType
{
    self=[super init];
    if(self)
    {
        _dataType=dataType;
        _listData=[[NSMutableArray alloc] init];
    }
    return self;
}

@end

#define kBleServiceUUID @"1880"
#define kBleCharacteristicUUID @"2a80"
#define kBleName @"kuqi"

@interface Ble4Util()<CBCentralManagerDelegate>

@property (nonatomic,assign) id target;
@property (nonatomic,strong) CBCentralManager *scCentralManager;
@property (nonatomic,assign) CBCentralManagerState centralState;
@property (nonatomic,strong) NSMutableArray *arrPeripherals;
@property (nonatomic,strong) NSString *scanUDID;

@end

@implementation Ble4Util

@synthesize delegate=_delegate;
@synthesize loverID=_loverID;

@synthesize target=_target;
@synthesize scCentralManager=_scCentralManager;
@synthesize centralState=_centralState;
@synthesize arrPeripherals=_arrPeripherals;
@synthesize scanUDID=_scanUDID;

+(id)shareBleUtilWithTarget:(id<Ble4UtilDelegate,Ble4PeripheralDelegate>)target
{
    static Ble4Util *ble4Util=nil;
    
    if(!ble4Util)
        ble4Util=[[Ble4Util alloc] initWithTarget:target];
    if(target)
    {
        if(!ble4Util.delegate)
            ble4Util.delegate=target;
        if(!ble4Util.target)
            ble4Util.target=target;
    }
    
    return ble4Util;
}

-(id)initWithTarget:(id<Ble4UtilDelegate,Ble4PeripheralDelegate>)target
{
    self=[super init];
    if(self)
    {
        _target=target;
        _delegate=target;
        _scCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _centralState=_scCentralManager.state;
        _arrPeripherals=[[NSMutableArray alloc] init];
    }
    return self;
}

-(CBCentralManagerState)cbCentralManagerState
{
    return _centralState;
}

/** 获取设备唯一标识 */
-(NSString *)udidWithManufacturerData:(NSData *)data
{
    NSMutableString *udid=nil;
    
    if(data && data.length>0)
    {
        udid=[NSMutableString stringWithString:@""];
        Byte *bts=(Byte *)[data bytes];
        for(int i=0;i<data.length;i++)
        {
            [udid appendFormat:@"%02x",bts[i]];
        }
    }
    
    return udid;
}
/** 扫描设备 */
-(void)startScanBle
{
    [self stopScanBle];
    self.scanUDID=nil;
    if ([self.scCentralManager respondsToSelector:@selector(scanForPeripheralsWithServices:options:)])
    {
        [self stopConnection];
        
        NSMutableArray *services=[[NSMutableArray alloc] initWithObjects:[CBUUID UUIDWithString:kBleServiceUUID], nil];
        [self.scCentralManager scanForPeripheralsWithServices:services options:nil];
    }
}
/** 扫描设备 */
-(void)startScanBleWithUDID:(NSString *)udid
{
    [self stopScanBle];
    if ([self.scCentralManager respondsToSelector:@selector(scanForPeripheralsWithServices:options:)])
    {
        self.scanUDID=udid;
        
        NSMutableArray *services=[[NSMutableArray alloc] initWithObjects:[CBUUID UUIDWithString:kBleServiceUUID], nil];
        [self.scCentralManager scanForPeripheralsWithServices:services options:nil];
    }
}
/** 停止扫描设备 */
-(void)stopScanBle
{
    if (_scCentralManager.state == CBCentralManagerStatePoweredOn) [self.scCentralManager stopScan];
}
/** 连接指定设备 */
-(void)connectPeripheralWithUDID:(NSString *)udid
{
    CBPeripheral *peripheral=nil;
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithUDID:udid];
    if(blePeripheral)
        peripheral=blePeripheral.scCBPeripheral;
    if(peripheral && !peripheral.isConnected && !blePeripheral.isConnecting)
    {
        blePeripheral.isConnecting=YES;
        [self.scCentralManager connectPeripheral:peripheral options:nil];
    }
}
/** 取消所有连接 */
-(void)stopConnection
{
    if(_arrPeripherals.count>0 && [self.scCentralManager respondsToSelector:@selector(scanForPeripheralsWithServices:options:)])
    {
        for(Ble4Peripheral *blePeripheral in _arrPeripherals)
        {
            if(blePeripheral.scCBPeripheral.isConnected)
            {
                [self.scCentralManager cancelPeripheralConnection:blePeripheral.scCBPeripheral];
            }
        }
    }
}
/** 取消指定设备连接 */
-(void)stopConnectionWithUDID:(NSString *)udid
{
    if (_arrPeripherals.count>0 && [self.scCentralManager respondsToSelector:@selector(scanForPeripheralsWithServices:options:)])
    {
        for(Ble4Peripheral *blePeripheral in _arrPeripherals)
        {
            if([blePeripheral.udid isEqualToString:udid])
            {
                if(blePeripheral.scCBPeripheral.isConnected)
                    [self.scCentralManager cancelPeripheralConnection:blePeripheral.scCBPeripheral];
                break;
            }
        }
    }
}
/** 判断指定设备是否处于连接状态 */
-(BOOL)isConnectedWithUDID:(NSString *)udid
{
    BOOL isConnected=NO;
    
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithUDID:udid];
    if(blePeripheral)
        isConnected=blePeripheral.scCBPeripheral.isConnected;
    
    return isConnected;
}
/** 判断指定设备集合是否处于连接状态 */
-(BOOL)isConnectedWithUDIDs:(NSArray *)arrUDIDs
{
    BOOL isConnected=YES;
    
    if(arrUDIDs && arrUDIDs.count>0)
    {
        for(int i=0;i<arrUDIDs.count;i++)
        {
            isConnected=[self isConnectedWithUDID:[arrUDIDs objectAtIndex:i]];
            if(!isConnected)break;
        }
    }
    else
    {
        isConnected=NO;
    }
    
    return isConnected;
}
-(Ble4Peripheral *)ble4PeripheralWithPeripheral:(CBPeripheral *)peripheral
{
    Ble4Peripheral *blePeripheral=nil;
    for(blePeripheral in _arrPeripherals)
    {
        if([blePeripheral.scCBPeripheral isEqual:peripheral])
            break;
        else
            blePeripheral=nil;
    }
    return blePeripheral;
}
-(Ble4Peripheral *)ble4PeripheralWithUDID:(NSString *)udid
{
    Ble4Peripheral *blePeripheral=nil;
    for(blePeripheral in _arrPeripherals)
    {
        if([blePeripheral.udid isEqualToString:udid])
            break;
        else
            blePeripheral=nil;
    }
    return blePeripheral;
}

/** 握手 */
-(void)cmdShakeHandsWithUDID:(NSString *)udid
{
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithUDID:udid];
    if(blePeripheral)
    {
        [blePeripheral cmdShakeHands];
    }
}
/** 设备信息 */
-(void)cmdDeviceInfoWithUDID:(NSString *)udid
{
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithUDID:udid];
    if(blePeripheral)
    {
        [blePeripheral cmdDeviceInfo];
    }
}
/** 更新设备时间 */
-(void)cmdUpdateTimeWithUDID:(NSString *)udid
{
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithUDID:udid];
    if(blePeripheral)
    {
        [blePeripheral cmdUpdateTime];
    }
}
/** 获取设备时间 */
-(void)cmdDeviceTimeWithUDID:(NSString *)udid
{
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithUDID:udid];
    if(blePeripheral)
    {
        [blePeripheral cmdDeviceTime];
    }
}
/** 读取数据 */
-(void)cmdReadDataWithUDID:(NSString *)udid
{
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithUDID:udid];
    if(blePeripheral)
    {
        [blePeripheral cmdReadData];
    }
}
/** 设置运动计划 */
-(void)cmdSetSportsPlanWithType:(BleSportsPlanType)type andTarget:(NSInteger)target andUDID:(NSString *)udid
{
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithUDID:udid];
    if(blePeripheral)
    {
        [blePeripheral cmdSetSportsPlanWithType:type andTarget:target];
    }
}
/** 获取运动计划 */
-(void)cmdGetSportsPlanWithUDID:(NSString *)udid
{
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithUDID:udid];
    if(blePeripheral)
    {
        [blePeripheral cmdGetSportsPlan];
    }
}
/** 情侣配对提示 */
-(void)cmdPairLoversWithUDID:(NSString *)udid
{
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithUDID:udid];
    if(blePeripheral)
    {
        [blePeripheral cmdPairLovers];
    }
}
/** 喝水提示 */
-(void)cmdDrinkWaterWithUDID:(NSString *)udid
{
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithUDID:udid];
    if(blePeripheral)
    {
        [blePeripheral cmdDrinkWater];
    }
}
/**
 设置睡眠模式时间
 @param startHour 开始时间(小时)
 @param startMin  开始时间(分钟)
 */
-(void)cmdSetSleepTimeWithHour:(NSInteger)hour andMin:(NSInteger)min andUDID:(NSString *)udid
{
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithUDID:udid];
    if(blePeripheral)
    {
        [blePeripheral cmdSetSleepTimeWithHour:hour andMin:min];
    }
}
/**
 设置喝水提示间隔时间
 @param interval 间隔时间(秒)
 */
-(void)cmdSetDrinkWaterInterval:(NSInteger)interval withUDID:(NSString *)udid
{
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithUDID:udid];
    if(blePeripheral)
    {
        [blePeripheral cmdSetDrinkWaterInterval:interval];
    }
}
/** 读取电量 */
-(void)cmdBatteryWithUDID:(NSString *)udid
{
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithUDID:udid];
    if(blePeripheral)
    {
        [blePeripheral cmdBattery];
    }
}


#pragma mark - CBCentralManager delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    _centralState=central.state;
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if(peripheral && peripheral.name && [[peripheral.name lowercaseString] rangeOfString:kBleName].location!=NSNotFound)
    {
        NSData *manufacturerData=[advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
        NSString *udid=[self udidWithManufacturerData:manufacturerData];
        if(udid)
        {
            if(!_scanUDID || [_scanUDID isEqualToString:udid] || [udid isEqualToString:_loverID])
            {
                if(_scanUDID)
                    [self.scCentralManager stopScan];
                
                BOOL isContains=NO;
                for(Ble4Peripheral *blePeripheral in _arrPeripherals)
                {
                    if([udid isEqualToString:blePeripheral.udid])
                    {
                        isContains=YES;
                        break;
                    }
                }
                if(!isContains)
                {
                    Ble4Peripheral *blePeripheral=[[Ble4Peripheral alloc] initWithPeripheral:peripheral andUDID:udid];
                    blePeripheral.delegate=_target;
                    [_arrPeripherals addObject:blePeripheral];
                }
                if (_delegate && [_delegate respondsToSelector:@selector(ble4Util:didDiscoverPeripheralWithName:andUDID:)])
                {
                    [_delegate ble4Util:self didDiscoverPeripheralWithName:peripheral.name andUDID:udid];
                }
            }
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    Ble4Peripheral *blePeripheral=[self ble4PeripheralWithPeripheral:peripheral];
    if (blePeripheral && _delegate && [_delegate respondsToSelector:@selector(ble4UtilDidConnect:withUDID:)])
    {
        blePeripheral.isConnecting=NO;
        
        [_delegate ble4UtilDidConnect:self withUDID:blePeripheral.udid];
        
        [peripheral discoverServices:nil];
    }
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    Ble4Peripheral *blePeripheral=nil;
    for(blePeripheral in _arrPeripherals)
    {
        if([blePeripheral.scCBPeripheral isEqual:peripheral])
            break;
        else
            blePeripheral=nil;
    }
    if(blePeripheral)
    {
        blePeripheral.isConnecting=NO;
        [blePeripheral invalidateTimer];
        if (_delegate && [_delegate respondsToSelector:@selector(ble4UtilDidDisconnect:withUDID:)])
        {
            [_delegate ble4UtilDidDisconnect:self withUDID:blePeripheral.udid];
        }
        peripheral.delegate=nil;
        
        [self.arrPeripherals removeObject:blePeripheral];
    }
    
    NSLog(@"didFailToConnectPeripheral!!!");
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    Ble4Peripheral *blePeripheral=nil;
    for(blePeripheral in _arrPeripherals)
    {
        if([blePeripheral.scCBPeripheral isEqual:peripheral])
            break;
        else
            blePeripheral=nil;
    }
    if(blePeripheral)
    {
        blePeripheral.isConnecting=NO;
        [blePeripheral invalidateTimer];
        if (_delegate && [_delegate respondsToSelector:@selector(ble4UtilDidDisconnect:withUDID:)])
        {
            [_delegate ble4UtilDidDisconnect:self withUDID:blePeripheral.udid];
        }
        peripheral.delegate=nil;
        
        [_arrPeripherals removeObject:blePeripheral];
    }
    
    NSLog(@"didDisconnectPeripheral!!!");
}

@end


@interface Ble4Peripheral()<CBPeripheralDelegate>

@property (nonatomic,strong) CBService *scService;
@property (atomic,assign) BOOL canSendData;

@property (atomic,assign) BleSportsDataReadState readState;
@property (nonatomic,assign) BOOL isReadLast;

@property (nonatomic,strong) BleSportsDataList *dataList;
@property (nonatomic,strong) NSMutableArray *arrData;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation Ble4Peripheral

@synthesize delegate=_delegate;
@synthesize udid=_udid;
@synthesize deviceType=_deviceType;
@synthesize isConnecting=_isConnecting;
@synthesize isReading=_isReading;

@synthesize scCBPeripheral=_scCBPeripheral;

@synthesize scService=_scService;
@synthesize canSendData=_canSendData;

@synthesize readState=_readState;
@synthesize isReadLast=_isReadLast;

@synthesize dataList=_dataList;
@synthesize arrData=_arrData;

@synthesize timer=_timer;

/** ##### 发送指令 ##### */
/** 起始符 */
#define kCMD_FH 0x68
/** 握手 */
#define kCMD_ShakeHands 0x01
/** 获取设备信息 */
#define kCMD_DeviceInfo 0x02
/** 更新设备时间 */
#define kCMD_UpdateTime 0x03
/** 获取设备时间 */
#define kCMD_DeviceTime 0x04
/** 读取数据次数 */
#define kCMD_ReadDataTimes 0x05
/** 读取数据 */
#define kCMD_ReadData 0x06
/** 擦除数据 */
#define kCMD_ClearData 0x07
/** 设置运动计划 */
#define kCMD_SetSportsPlan 0x08
/** 读取运动计划 */
#define kCMD_GetSportsPlan 0x09
/** 情侣配对提示 */
#define kCMD_PairLovers 0x0a
/** 喝水提示 */
#define kCMD_DrinkWater 0x0b
/** 设置睡眠模式时间 */
#define kCMD_SetSleepTime 0x0c
/** 设置喝水提示间隔时间 */
#define kCMD_SetDrinkWaterInterval 0x0d
/** 读取电量 */
#define kCMD_Battery 0x0e
/** ##### 发送指令end ##### */

-(unsigned char)byteToBCD:(unsigned char)dec
{
    return (((dec / 10) << 4) | (dec % 10));
}
-(unsigned char)bcdToByte:(unsigned char)bcd
{
    return (((bcd & 0xf0)>>4)*10 + (bcd & 0x0f));
}

/** 校验码 */
-(long)verifyCode:(Byte *)bts andLength:(int)len
{
    long verify=0x00;
    
    if(bts)
    {
        for(int i=0;i<len;i++)
        {
            verify+=bts[i];
        }
        verify=verify&0xff;
        verify=~verify;
    }
    
    return verify;
}

/** 星期转换 */
-(NSInteger) convertIntWeekDay:(NSInteger)week
{
    NSInteger value_week=0;
    
    switch (week) {
        case 1:
            value_week=6;
            break;
        case 2:
            value_week=0;
            break;
        case 3:
            value_week=1;
            break;
        case 4:
            value_week=2;
            break;
        case 5:
            value_week=3;
            break;
        case 6:
            value_week=4;
            break;
        case 7:
            value_week=5;
            break;
        default:
            break;
    }
    
    return value_week;
}

/** 握手 */
-(void)cmdShakeHands
{
    NSMutableData *data=nil;
    
    Byte bts[3]={kCMD_FH,kCMD_ShakeHands,0x00};
    data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
    Byte verify[1]={[self verifyCode:bts andLength:3]};
    [data appendBytes:verify length:sizeof(verify)];
    
    [self sendData:data];
}
/** 设备信息 */
-(void)cmdDeviceInfo
{
    NSMutableData *data=nil;
    
    Byte bts[3]={kCMD_FH,kCMD_DeviceInfo,0x00};
    data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
    Byte verify[1]={[self verifyCode:bts andLength:3]};
    [data appendBytes:verify length:sizeof(verify)];
    
    [self sendData:data];
}
/** 更新设备时间 */
-(void)cmdUpdateTime
{
    NSMutableData *data=nil;
    
    Byte bts[10];
    bts[0]=kCMD_FH;
    bts[1]=kCMD_UpdateTime;
    bts[2]=0x07;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now=[NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    NSInteger second = [comps second];
    NSInteger week = [comps weekday];
    
    bts[3]=[self byteToBCD:year%100];
    bts[4]=[self byteToBCD:month];
    bts[5]=[self byteToBCD:day];
    bts[6]=[self byteToBCD:hour];
    bts[7]=[self byteToBCD:minute];
    bts[8]=[self byteToBCD:second];
    bts[9]=[self byteToBCD:[self convertIntWeekDay:week]];
    
    data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
    Byte verify[1]={[self verifyCode:bts andLength:10]};
    [data appendBytes:verify length:sizeof(verify)];
    
    [self sendDataWithoutCondition:data];
}
/** 获取设备时间 */
-(void)cmdDeviceTime
{
    NSMutableData *data=nil;
    
    Byte bts[3]={kCMD_FH,kCMD_DeviceTime,0x00};
    data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
    Byte verify[1]={[self verifyCode:bts andLength:3]};
    [data appendBytes:verify length:sizeof(verify)];
    
    [self sendDataWithoutCondition:data];
}
/** 读取数据 */
-(void)cmdReadData
{
    NSMutableData *data=nil;
    
    Byte bts[3]={kCMD_FH,kCMD_ReadDataTimes,0x00};
    data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
    Byte verify[1]={[self verifyCode:bts andLength:3]};
    [data appendBytes:verify length:sizeof(verify)];
    
    [self sendData:data];
}
/** 读取数据 */
-(void)cmdReadDataWithTimes:(NSInteger)times
{
    if(_readState!=BleSportsDataReadStateNormal)return;
    
    _readState=BleSportsDataReadStateSign;
    _isReading=YES;
    _isReadLast=NO;
    [_arrData removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                   {
                       for(int i=0;i<times;i++)
                       {
                           while (!self.canSendData) {
                               [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                           }
                           
                           if(i==times-1)
                               _isReadLast=YES;
                           dispatch_sync(dispatch_get_main_queue(), ^
                                         {
                                             NSInteger high=i/256;
                                             NSInteger low=i%256;
                                             Byte bts[5]={kCMD_FH,kCMD_ReadData,0x02,high,low};
                                             NSMutableData *data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
                                             Byte verify[1]={[self verifyCode:bts andLength:5]};
                                             [data appendBytes:verify length:sizeof(verify)];
                                             
                                             [self sendData:data];
                                         });
                       }
                   });
}
/** 擦除数据 */
-(void)cmdClearData
{
    NSMutableData *data=nil;
    
    Byte bts[3]={kCMD_FH,kCMD_ClearData,0x00};
    data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
    Byte verify[1]={[self verifyCode:bts andLength:3]};
    [data appendBytes:verify length:sizeof(verify)];
    
    [self sendDataWithoutCondition:data];
}
/** 设置运动计划 */
-(void)cmdSetSportsPlanWithType:(BleSportsPlanType)type andTarget:(NSInteger)target
{
    NSMutableData *data=nil;
    
    NSInteger target1=target/256;
    NSInteger target2=target%256;
    Byte bts[6]={kCMD_FH,kCMD_SetSportsPlan,0x03,type,target1,target2};
    data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
    Byte verify[1]={[self verifyCode:bts andLength:6]};
    [data appendBytes:verify length:sizeof(verify)];
    
    [self sendData:data];
}
/** 获取运动计划 */
-(void)cmdGetSportsPlan
{
    NSMutableData *data=nil;
    
    Byte bts[3]={kCMD_FH,kCMD_GetSportsPlan,0x00};
    data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
    Byte verify[1]={[self verifyCode:bts andLength:3]};
    [data appendBytes:verify length:sizeof(verify)];
    
    [self sendData:data];
}
/** 情侣配对提示 */
-(void)cmdPairLovers
{
    NSMutableData *data=nil;
    
    Byte bts[3]={kCMD_FH,kCMD_PairLovers,0x00};
    data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
    Byte verify[1]={[self verifyCode:bts andLength:3]};
    [data appendBytes:verify length:sizeof(verify)];
    
    [self sendDataWithoutCondition:data];
}
/** 喝水提示 */
-(void)cmdDrinkWater
{
    NSMutableData *data=nil;
    
    Byte bts[3]={kCMD_FH,kCMD_DrinkWater,0x00};
    data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
    Byte verify[1]={[self verifyCode:bts andLength:3]};
    [data appendBytes:verify length:sizeof(verify)];
    
    [self sendDataWithoutCondition:data];
}
/**
 设置睡眠模式时间
 @param startHour 开始时间(时)
 @param startMin  开始时间(分)
 @param endHour   结束时间(时)
 @param endMin    结束时间(分)
 */
-(void)cmdSetSleepTimeWithStartHour:(NSInteger)startHour andStartMin:(NSInteger)startMin andEndHour:(NSInteger)endHour andEndMin:(NSInteger)endMin
{
    NSMutableData *data=nil;
    
    Byte bts[7]={kCMD_FH,kCMD_SetSleepTime,0x04,startHour,startMin,endHour,endMin};
    data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
    Byte verify[1]={[self verifyCode:bts andLength:7]};
    [data appendBytes:verify length:sizeof(verify)];
    
    [self sendData:data];
}
/**
 设置睡眠模式时间
 @param hour 开始时间(小时)
 @param min  开始时间(分钟)
 */
-(void)cmdSetSleepTimeWithHour:(NSInteger)hour andMin:(NSInteger)min
{
    NSMutableData *data=nil;
    
    Byte bts[5]={kCMD_FH,kCMD_SetSleepTime,0x02,hour,min};
    data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
    Byte verify[1]={[self verifyCode:bts andLength:5]};
    [data appendBytes:verify length:sizeof(verify)];
    
    [self sendData:data];
}
/**
 设置喝水提示间隔时间
 @param interval 间隔时间(秒)
 */
-(void)cmdSetDrinkWaterInterval:(NSInteger)interval
{
    NSMutableData *data=nil;
    
    if(interval>0xffff)interval=0xffff;
    NSInteger interval1=interval/256;
    NSInteger interval2=interval%256;
    Byte bts[5]={kCMD_FH,kCMD_SetDrinkWaterInterval,0x02,interval1,interval2};
    data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
    Byte verify[1]={[self verifyCode:bts andLength:5]};
    [data appendBytes:verify length:sizeof(verify)];
    
    [self sendData:data];
}
/** 读取电量 */
-(void)cmdBattery
{
    NSMutableData *data=nil;
    
    Byte bts[3]={kCMD_FH,kCMD_Battery,0x00};
    data=[[NSMutableData alloc] initWithBytes:bts length:sizeof(bts)];
    Byte verify[1]={[self verifyCode:bts andLength:3]};
    [data appendBytes:verify length:sizeof(verify)];
    
    [self sendDataWithoutCondition:data];
}

/** 发送指令 */
-(void)sendData:(NSData *)data
{
    if(!self.canSendData)return;
    if(self.scCBPeripheral && self.scCBPeripheral.isConnected)
    {
        for (CBCharacteristic *aChar in self.scService.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:kBleCharacteristicUUID]])
            {
                self.canSendData=NO;
                [self.scCBPeripheral writeValue:data forCharacteristic:aChar type:CBCharacteristicWriteWithResponse];
                break;
            }
        }
    }
}
/** 发送指令 */
-(void)sendDataWithoutCondition:(NSData *)data
{
    if(self.scCBPeripheral && self.scCBPeripheral.isConnected)
    {
        for (CBCharacteristic *aChar in self.scService.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:kBleCharacteristicUUID]])
            {
                [self.scCBPeripheral writeValue:data forCharacteristic:aChar type:CBCharacteristicWriteWithResponse];
                break;
            }
        }
    }
}

-(void)invalidateTimer
{
    if(_timer)
    {
        if(_timer.isValid)
            [_timer invalidate];
        self.timer=nil;
    }
}

- (id)initWithPeripheral:(CBPeripheral *)peripheral andUDID:(NSString *)udid
{
    self = [super init];
    if (self)
    {
        _udid=[[NSString alloc] initWithString:udid];
        _scCBPeripheral=peripheral;
        self.scCBPeripheral.delegate=self;
        _arrData=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)readBatteryEvent:(NSTimer *)timer
{
    if(timer.isValid)
    {
        if(!_isReading)
            [self cmdBattery];
    }
}

#pragma mark CBPeripheralDelegate
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {
    
    
}

- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error {
    
    if (!error)
    {
        for (CBService *aService in aPeripheral.services)
        {
            if ([aService.UUID isEqual:[CBUUID UUIDWithString:kBleServiceUUID]])
            {
                [aPeripheral discoverCharacteristics:nil forService:aService];
                break;
            }
        }
    }
    else
    {
        NSLog(@"didDiscoverServices error");
        if (_delegate && [_delegate respondsToSelector:@selector(ble4Peripheral:didBlePeripheralWithError:)])
        {
            [_delegate ble4Peripheral:self didBlePeripheralWithError:BlePeripheralErrorDiscoverService];
        }
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    if (!error)
    {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kBleServiceUUID]])
        {
            self.scService = service;
            for(CBCharacteristic *aChar in service.characteristics)
            {
                if([aChar.UUID isEqual:[CBUUID UUIDWithString:kBleCharacteristicUUID]])
                {
                    [peripheral setNotifyValue:YES forCharacteristic:aChar];
                    
                    _canSendData=YES;
                    
                    if(_timer)
                    {
                        if(_timer.isValid)
                            [_timer invalidate];
                        self.timer=nil;
                    }
                    _timer=[NSTimer scheduledTimerWithTimeInterval:180.0 target:self selector:@selector(readBatteryEvent:) userInfo:nil repeats:YES];
                    [self readBatteryEvent:_timer];
                    
                    if([_delegate respondsToSelector:@selector(ble4PeripheralDidDiscoverCharacteristics:)])
                        [_delegate ble4PeripheralDidDiscoverCharacteristics:self];
                    break;
                }
            }
        }
        
    }
    else
    {
        NSLog(@"didDiscoverCharacteristicsForService error");
        if (_delegate && [_delegate respondsToSelector:@selector(ble4Peripheral:didBlePeripheralWithError:)])
        {
            [_delegate ble4Peripheral:self didBlePeripheralWithError:BlePeripheralErrorDiscoverCharacteristic];
        }
    }
}

- (void) peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(!_delegate)
    {
        self.canSendData=YES;
        return;
    }
    if (!error)
    {
        if([characteristic.UUID isEqual:[CBUUID UUIDWithString:kBleCharacteristicUUID]])
        {
            Byte *receiveData = (Byte *)[characteristic.value bytes];
            if(receiveData)
            {
                NSString *tmpstr=nil;
                uint8_t flag=receiveData[1];
                switch (flag) {
                    case Ble4CallBackMarkDeviceInfo:
                    {
                        if([_delegate respondsToSelector:@selector(ble4Peripheral:callBackWithDeviceType:andVersion:)])
                        {
                            tmpstr=[[NSString alloc] initWithFormat:@"%d.%d",receiveData[4],receiveData[5]];
                            [_delegate ble4Peripheral:self callBackWithDeviceType:receiveData[3] andVersion:tmpstr];
                        }
                    }
                        break;
                    case Ble4CallBackMarkShakeHands:
                    case Ble4CallBackMarkUpdateTime:
                    case Ble4CallBackMarkSetSportsPlan:
                    case Ble4CallBackMarkPairLovers:
                    case Ble4CallBackMarkDrinkWater:
                    case Ble4CallBackMarkSetSleepTime:
                    case Ble4CallBackMarkSetDrinkWaterInterval:
                    {
                        if([_delegate respondsToSelector:@selector(ble4Peripheral:callBackWithMark:)])
                            [_delegate ble4Peripheral:self callBackWithMark:flag];
                    }
                        break;
                    case Ble4CallBackMarkDeviceTime:
                    {
                        if([_delegate respondsToSelector:@selector(ble4Peripheral:callBackWithDeviceTime:andWeek:)])
                        {
                            NSString *year=[[NSString alloc] initWithFormat:@"20%02d",[self bcdToByte:receiveData[3]]];
                            NSString *month=[[NSString alloc] initWithFormat:@"%02d",[self bcdToByte:receiveData[4]]];
                            NSString *day=[[NSString alloc] initWithFormat:@"%02d",[self bcdToByte:receiveData[5]]];
                            NSString *hour=[[NSString alloc] initWithFormat:@"%02d",[self bcdToByte:receiveData[6]]];
                            NSString *minute=[[NSString alloc] initWithFormat:@"%02d",[self bcdToByte:receiveData[7]]];
                            NSString *second=[[NSString alloc] initWithFormat:@"%02d",[self bcdToByte:receiveData[8]]];
                            
                            tmpstr=[[NSString alloc] initWithFormat:@"%@%@%@%@%@%@",year,month,day,hour,minute,second];
                            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
                            NSDate *date=[dateFormatter dateFromString:tmpstr];
                            
                            [_delegate ble4Peripheral:self callBackWithDeviceTime:date andWeek:receiveData[9]];
                        }
                    }
                        break;
                    case Ble4CallBackMarkReadDataTimes:
                    {
                        [self cmdReadDataWithTimes:256*receiveData[3]+receiveData[4]];
                    }
                        break;
                    case Ble4CallBackMarkReadData:
                    {
                        if(receiveData[3]==BleDataSignF3
                           && receiveData[4]==BleDataSignF3
                           && receiveData[5]==BleDataSignF3
                           && receiveData[6]==BleDataSignF3)
                        {
                            //运动模式标志,下一条读取开始时间
                            _readState=BleSportsDataReadStateSportsTime;
                        }
                        else if(receiveData[3]==BleDataSignF4
                                && receiveData[4]==BleDataSignF4
                                && receiveData[5]==BleDataSignF4
                                && receiveData[6]==BleDataSignF4)
                        {
                            //睡眠模式标志,下一条读取开始时间
                            _readState=BleSportsDataReadStateSleepTime;
                        }
                        else if(receiveData[3]==BleDataSignF5
                                && receiveData[4]==BleDataSignF5
                                && receiveData[5]==BleDataSignF5
                                && receiveData[6]==BleDataSignF5)
                        {
                            //零点时间标志,下一条读取开始时间
                            //确保数据与零点之前的数据类型一致
                            if(_readState==BleSportsDataReadStateSportsData)
                                _readState=BleSportsDataReadStateSportsTime;
                            else if(_readState==BleSportsDataReadStateSleepData)
                                _readState=BleSportsDataReadStateSleepTime;
                        }
                        else
                        {
                            if(_readState==BleSportsDataReadStateSportsTime
                               || _readState==BleSportsDataReadStateSleepTime)
                            {
                                //读取时间
                                int partYear=[self bcdToByte:receiveData[3]];
                                NSString *year=[[NSString alloc] initWithFormat:@"%02d%02d",partYear,[self bcdToByte:receiveData[4]]];
                                NSString *month=[[NSString alloc] initWithFormat:@"%02d",[self bcdToByte:receiveData[5]]];
                                NSString *day=[[NSString alloc] initWithFormat:@"%02d",[self bcdToByte:receiveData[6]]];
                                NSString *hour=[[NSString alloc] initWithFormat:@"%02d",[self bcdToByte:receiveData[7]]];
                                NSString *minute=[[NSString alloc] initWithFormat:@"%02d",[self bcdToByte:receiveData[8]]];
                                NSString *second=[[NSString alloc] initWithFormat:@"%02d",[self bcdToByte:receiveData[9]]];
                                
                                tmpstr=[[NSString alloc] initWithFormat:@"%@%@%@%@%@%@",year,month,day,hour,minute,second];
                                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                                [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
                                NSDate *date=[dateFormatter dateFromString:tmpstr];
                                
                                if(_dataList)
                                {
                                    if(_dataList.listData.count>0)
                                    {
                                        _dataList.endTime=date;
                                        [_arrData addObject:_dataList];
                                    }
                                    self.dataList=nil;
                                }
                                
                                if(_isReadLast)
                                {
                                    //如果是最后一条数据
                                    [self cmdClearData];
                                    if([_delegate respondsToSelector:@selector(ble4Peripheral:callBackWithSportsData:)])
                                    {
                                        [_delegate ble4Peripheral:self callBackWithSportsData:_arrData];
                                        [_arrData removeAllObjects];
                                    }
                                }
                                else
                                {
                                    if(_readState==BleSportsDataReadStateSportsTime)
                                    {
                                        _dataList=[[BleSportsDataList alloc] initWithType:BleSportsDataTypeSports];
                                        _readState=BleSportsDataReadStateSportsData;
                                    }
                                    else if(_readState==BleSportsDataReadStateSleepTime)
                                    {
                                        _dataList=[[BleSportsDataList alloc] initWithType:BleSportsDataTypeSleep];
                                        _readState=BleSportsDataReadStateSleepData;
                                    }
                                }
                                
                                if(_dataList)
                                {
                                    _dataList.startTime=date;
                                }
                            }
                            else if(_readState==BleSportsDataReadStateSportsData)
                            {
                                //读取运动数据
                                if(_dataList && _dataList.dataType==BleSportsDataTypeSports)
                                {
                                    NSInteger calories=256*receiveData[3]+receiveData[4];
                                    NSInteger steps=256*receiveData[5]+receiveData[6];
                                    NSInteger meters=256*receiveData[7]+receiveData[8];
                                    BleSportsData *sportsData=[[BleSportsData alloc] initWithCalories:calories andSteps:steps andMeters:meters];
                                    [_dataList.listData addObject:sportsData];
                                }
                            }
                            else if(_readState==BleSportsDataReadStateSleepData)
                            {
                                //读取睡眠数据
                                if(_dataList && _dataList.dataType==BleSportsDataTypeSleep)
                                {
                                    NSNumber *rate=[[NSNumber alloc] initWithInteger:256*receiveData[3]+receiveData[4]];
                                    [_dataList.listData addObject:rate];
                                }
                            }
                        }
                        
                        if(_isReadLast)
                        {
                            _readState=BleSportsDataReadStateNormal;
                            _isReading=NO;
                        }
                    }
                        break;
                    case Ble4CallBackMarkClearData:
                        return;
                        break;
                    case Ble4CallBackMarkGetSportsPlan:
                    {
                        if([_delegate respondsToSelector:@selector(ble4Peripheral:callBackWithPlanType:andTarget:)])
                        {
                            [_delegate ble4Peripheral:self callBackWithPlanType:receiveData[3] andTarget:256*receiveData[4]+receiveData[5]];
                        }
                    }
                        break;
                    case Ble4CallBackMarkBattery:
                        NSLog(@"电量:%d%%",receiveData[3]);
                        if([_delegate respondsToSelector:@selector(ble4Peripheral:callBackWithBattery:)])
                            [_delegate ble4Peripheral:self callBackWithBattery:receiveData[3]];
                        break;
                    default:
                        NSLog(@"default:%d",flag);
                        break;
                }
            }
        }
    }
    else
    {
        NSLog(@"didUpdateValueForCharacteristic error");
        if (_delegate && [_delegate respondsToSelector:@selector(ble4Peripheral:didBlePeripheralWithError:)])
        {
            [_delegate ble4Peripheral:self didBlePeripheralWithError:BlePeripheralErrorReadCharacteristicValue];
        }
    }
    self.canSendData=YES;
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error)
    {
        self.canSendData=YES;
        if (_delegate && [_delegate respondsToSelector:@selector(ble4Peripheral:didWriteValueForCharacteristicWithError:)])
        {
            Byte *receiveData = (Byte *)[characteristic.value bytes];
            if(receiveData && receiveData[0]==kCMD_FH)
            {
                BleWriteValueError error_=BleWriteValueErrorDefault;
                uint8_t flag=receiveData[1];
                switch (flag) {
                    case kCMD_ShakeHands:
                        error_=BleWriteValueErrorShakeHands;
                        break;
                    case kCMD_DeviceInfo:
                        error_=BleWriteValueErrorDeviceInfo;
                        break;
                    case kCMD_UpdateTime:
                        error_=BleWriteValueErrorUpdateTime;
                        break;
                    case kCMD_DeviceTime:
                        error_=BleWriteValueErrorDeviceTime;
                        break;
                    case kCMD_ReadDataTimes:
                    case kCMD_ReadData:
                        error_=BleWriteValueErrorSportsData;
                        break;
                    case kCMD_SetSportsPlan:
                        error_=BleWriteValueErrorSetSportsPlan;
                        break;
                    case kCMD_GetSportsPlan:
                        error_=BleWriteValueErrorGetSportsPlan;
                        break;
                    case kCMD_PairLovers:
                        error_=BleWriteValueErrorPairLovers;
                        break;
                    case kCMD_DrinkWater:
                        error_=BleWriteValueErrorDrinkWater;
                        break;
                    case kCMD_SetSleepTime:
                        error_=BleWriteValueErrorSetSleepTime;
                        break;
                    case kCMD_SetDrinkWaterInterval:
                        error_=BleWriteValueErrorSetDrinkWaterInterval;
                        break;
                    case kCMD_Battery:
                        error_=BleWriteValueErrorBattery;
                        break;
                    default:
                        break;
                }
                [_delegate ble4Peripheral:self didWriteValueForCharacteristicWithError:error_];
            }
        }
    }
}

@end
