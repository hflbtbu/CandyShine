//
//  Ble4Util.h
//  Ble4Util
//
//  Created by DBY on 14-3-2.
//  Copyright (c) 2014年 dby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

/** 蓝牙外设类型 */
typedef NS_ENUM(NSInteger,BleDeviceType)
{
    /** 心率带 */
    BleDeviceTypeHeart=1,
    /** 头带 */
    BleDeviceTypeHead=2,
};

/** 设备异常 */
typedef NS_ENUM(NSInteger, BlePeripheralError)
{
    /** 读取服务异常 */
    BlePeripheralErrorDiscoverService,
    /** 读取特征异常 */
    BlePeripheralErrorDiscoverCharacteristic,
    /** 读取特征值异常 */
    BlePeripheralErrorReadCharacteristicValue,
};

/** 数据类型 */
typedef NS_ENUM(NSInteger, BleSportsDataType)
{
    /** 运动数据 */
    BleSportsDataTypeSports,
    /** 睡眠数据 */
    BleSportsDataTypeSleep,
};

/** 运动计划类型 */
typedef NS_ENUM(NSInteger, BleSportsPlanType)
{
    /** 时间 */
    BleSportsPlanTypeTime=1,
    /** 圈数 */
    BleSportsPlanTypeCircles=2,
    /** 步数 */
    BleSportsPlanTypeSteps=3,
};

/** 数据回调标记 */
typedef NS_ENUM(NSInteger, Ble4CallBackMark)
{
    /** 握手 */
    Ble4CallBackMarkShakeHands = 0x81,
    /** 设备信息 */
    Ble4CallBackMarkDeviceInfo = 0x82,
    /** 更新设备时间 */
    Ble4CallBackMarkUpdateTime = 0x83,
    /** 获取设备时间 */
    Ble4CallBackMarkDeviceTime = 0x84,
    /** 读取数据的次数 */
    Ble4CallBackMarkReadDataTimes = 0x85,
    /** 读取数据 */
    Ble4CallBackMarkReadData = 0x86,
    /** 清除数据 */
    Ble4CallBackMarkClearData = 0x87,
    /** 设置运动计划 */
    Ble4CallBackMarkSetSportsPlan = 0x88,
    /** 获取运动计划 */
    Ble4CallBackMarkGetSportsPlan = 0x89,
    /** 情侣配对提示 */
    Ble4CallBackMarkPairLovers = 0x8a,
    /** 喝水提示 */
    Ble4CallBackMarkDrinkWater = 0x8b,
    /** 设置睡眠模式时间 */
    Ble4CallBackMarkSetSleepTime = 0x8c,
    /** 设置喝水提示间隔时间 */
    Ble4CallBackMarkSetDrinkWaterInterval = 0x8d,
    /** 读取电量 */
    Ble4CallBackMarkBattery = 0x8e,
};

/** 数据写入异常 */
typedef NS_ENUM(NSInteger, BleWriteValueError)
{
    /** 默认异常 */
    BleWriteValueErrorDefault,
    /** 握手异常 */
    BleWriteValueErrorShakeHands,
    /** 读取设备信息异常 */
    BleWriteValueErrorDeviceInfo,
    /** 更新设备时间异常 */
    BleWriteValueErrorUpdateTime,
    /** 获取设备时间异常 */
    BleWriteValueErrorDeviceTime,
    /** 读取运动数据异常 */
    BleWriteValueErrorSportsData,
    /** 设置运动计划异常 */
    BleWriteValueErrorSetSportsPlan,
    /** 读取运动计划异常 */
    BleWriteValueErrorGetSportsPlan,
    /** 情侣配对提示异常 */
    BleWriteValueErrorPairLovers,
    /** 喝水提示异常 */
    BleWriteValueErrorDrinkWater,
    /** 设置睡眠模式时间异常 */
    BleWriteValueErrorSetSleepTime,
    /** 设置喝水提示间隔时间异常 */
    BleWriteValueErrorSetDrinkWaterInterval,
    /** 读取电量异常 */
    BleWriteValueErrorBattery,
};


/** 运动数据 */
@interface BleSportsData : NSObject

/** 卡路里 */
@property (nonatomic,readonly) NSInteger calories;
/** 步数 */
@property (nonatomic,readonly) NSInteger steps;
/** 米数 */
@property (nonatomic,readonly) NSInteger meters;

-(id)initWithCalories:(NSInteger)calories andSteps:(NSInteger)steps andMeters:(NSInteger)meters;

@end

/** 运动数据集合 */
@interface BleSportsDataList : NSObject

/** 开始时间 */
@property (nonatomic,strong) NSDate *startTime;
/** 结束时间 */
@property (nonatomic,strong) NSDate *endTime;
/** 数据类型(运动数据|睡眠数据) */
@property (nonatomic,readonly) BleSportsDataType dataType;
/** 数据集合(BleSportsData|NSNumber) */
@property (nonatomic,readonly) NSMutableArray *listData;

-(id)initWithType:(BleSportsDataType)dataType;

@end

@protocol Ble4PeripheralDelegate <NSObject>

@optional
/** 读到特征 */
- (void)ble4PeripheralDidDiscoverCharacteristics:(id)ble4Peripheral;
/** 错误信息 */
- (void)ble4Peripheral:(id)ble4Peripheral didBlePeripheralWithError:(BlePeripheralError)error;

/** 写入错误回调 */
- (void)ble4Peripheral:(id)ble4Peripheral didWriteValueForCharacteristicWithError:(BleWriteValueError)error;
/**
 指令执行成功回调
 @param mark 数据回调标记(更新设备时间|设置运动计划|情侣配对提示|喝水提示|设置睡眠模式时间|设置喝水提示间隔时间)
 */
- (void)ble4Peripheral:(id)ble4Peripheral callBackWithMark:(Ble4CallBackMark)mark;
/** 获取设备信息回调 */
- (void)ble4Peripheral:(id)ble4Peripheral callBackWithDeviceType:(BleDeviceType)deviceType andVersion:(NSString *)version;
/** 获取设备时间回调 */
- (void)ble4Peripheral:(id)ble4Peripheral callBackWithDeviceTime:(NSDate *)date andWeek:(NSInteger)week;
/** 读取数据回调 */
- (void)ble4Peripheral:(id)ble4Peripheral callBackWithSportsData:(NSArray *)data;
/** 读取运动计划回调 */
- (void)ble4Peripheral:(id)ble4Peripheral callBackWithPlanType:(BleSportsPlanType)planType andTarget:(NSInteger)target;
/** 读取电量回调 */
- (void)ble4Peripheral:(id)ble4Peripheral callBackWithBattery:(NSInteger)battery;

@end

@interface Ble4Peripheral : NSObject

@property (nonatomic,assign) id<Ble4PeripheralDelegate> delegate;

@property (nonatomic,readonly) CBPeripheral *scCBPeripheral;

/** udid */
@property (nonatomic,readonly) NSString *udid;
/** 设备类型 */
@property (nonatomic,readonly) BleDeviceType deviceType;
/** 是否正在连接 */
@property (atomic,assign) BOOL isConnecting;
/** 是否正在读取数据 */
@property (nonatomic,readonly) BOOL isReading;

- (id)initWithPeripheral:(CBPeripheral *)peripheral andUDID:(NSString *)udid;
-(void)invalidateTimer;

/** 握手 */
-(void)cmdShakeHands;
/** 设备信息 */
-(void)cmdDeviceInfo;
/** 更新设备时间 */
-(void)cmdUpdateTime;
/** 获取设备时间 */
-(void)cmdDeviceTime;
/** 读取数据 */
-(void)cmdReadData;
/**
 设置运动计划
 @param type 类型(1:时间;2:圈数;3:步数[目前设备只支持步数])
 @param target 目标(若类型为时间,则目标单位为分钟)
 */
-(void)cmdSetSportsPlanWithType:(BleSportsPlanType)type andTarget:(NSInteger)target;
/** 获取运动计划 */
-(void)cmdGetSportsPlan;
/** 情侣配对提示 */
-(void)cmdPairLovers;
/** 喝水提示 */
-(void)cmdDrinkWater;
/**
 设置睡眠模式时间
 @param startHour 开始时间(小时)
 @param startMin  开始时间(分钟)
 */
-(void)cmdSetSleepTimeWithHour:(NSInteger)hour andMin:(NSInteger)min;
/**
 设置喝水提示间隔时间
 @param interval 间隔时间(秒)
 */
-(void)cmdSetDrinkWaterInterval:(NSInteger)interval;
/** 读取电量 */
-(void)cmdBattery;

@end


@protocol Ble4UtilDelegate <NSObject>
@optional

/** 发现设备 */
-(void)ble4Util:(id)ble4Util didDiscoverPeripheralWithName:(NSString *)name andUDID:(NSString *)udid;
/** 连接设备成功 */
-(void)ble4UtilDidConnect:(id)ble4Util withUDID:(NSString *)udid;
/** 失去连接 */
-(void)ble4UtilDidDisconnect:(id)ble4Util withUDID:(NSString *)udid;

@end

@interface Ble4Util : NSObject

@property (nonatomic,assign) id<Ble4UtilDelegate> delegate;
/** 情侣设备ID */
@property (nonatomic,strong) NSString *loverID;

+(id)shareBleUtilWithTarget:(id<Ble4UtilDelegate,Ble4PeripheralDelegate>)target;
-(Ble4Peripheral *)ble4PeripheralWithUDID:(NSString *)udid;

/** 
 0:未发现蓝牙4.0设备;
 1:请重设蓝牙设备;
 2:硬件不支持蓝牙4.0;
 3:app未被授权使用BLE4.0;
 4:请在设置中开启蓝牙功能;
 */
-(CBCentralManagerState)cbCentralManagerState;
/** 开始扫描周边设备 */
-(void)startScanBle;
-(void)startScanBleWithUDID:(NSString *)udid;
/** 停止扫描 */
-(void)stopScanBle;
/** 连接设备 */
-(void)connectPeripheralWithUDID:(NSString *)udid;
/** 取消连接 */
-(void)stopConnectionWithUDID:(NSString *)udid;
/** 取消所有连接 */
-(void)stopConnection;
/** 判断指定设备是否处于连接状态 */
-(BOOL)isConnectedWithUDID:(NSString *)udid;
/** 判断指定设备集合是否处于连接状态 */
-(BOOL)isConnectedWithUDIDs:(NSArray *)arrUDIDs;

/** 握手 */
-(void)cmdShakeHandsWithUDID:(NSString *)udid;
/** 设备信息 */
-(void)cmdDeviceInfoWithUDID:(NSString *)udid;
/** 更新设备时间 */
-(void)cmdUpdateTimeWithUDID:(NSString *)udid;
/** 获取设备时间 */
-(void)cmdDeviceTimeWithUDID:(NSString *)udid;
/** 读取数据 */
-(void)cmdReadDataWithUDID:(NSString *)udid;
/**
 设置运动计划
 @param type 类型(1:时间;2:圈数;3:步数[目前设备只支持步数])
 @param target 目标(若类型为时间,则目标单位为分钟)
 */
-(void)cmdSetSportsPlanWithType:(BleSportsPlanType)type andTarget:(NSInteger)target andUDID:(NSString *)udid;
/** 获取运动计划 */
-(void)cmdGetSportsPlanWithUDID:(NSString *)udid;
/** 情侣配对提示 */
-(void)cmdPairLoversWithUDID:(NSString *)udid;
/** 喝水提示 */
-(void)cmdDrinkWaterWithUDID:(NSString *)udid;
/**
 设置睡眠模式时间
 @param startHour 开始时间(小时)
 @param startMin  开始时间(分钟)
 */
-(void)cmdSetSleepTimeWithHour:(NSInteger)hour andMin:(NSInteger)min andUDID:(NSString *)udid;
/**
 设置喝水提示间隔时间
 @param interval 间隔时间(秒)
 */
-(void)cmdSetDrinkWaterInterval:(NSInteger)interval withUDID:(NSString *)udid;
/** 读取电量 */
-(void)cmdBatteryWithUDID:(NSString *)udid;

@end

