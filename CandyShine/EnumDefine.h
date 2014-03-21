//
//  EnumDefine.h
//  CandyShine
//
//  Created by huangfulei on 14-1-22.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#ifndef CandyShine_EnumDefine_h
#define CandyShine_EnumDefine_h

typedef NS_ENUM(NSInteger, DataPattern) {
    DataPatternDay,
    DataPatternWeek,
};


typedef NS_ENUM(NSInteger, CellPosition) {
    CellPositionTop,
    CellPositionMiddle,
    CellPositionBottom,
};


typedef NS_ENUM(NSInteger, EditType) {
    EditTypeModify,
    EditTypeAdd,
};


typedef NS_ENUM(NSInteger, PageMoveType) {
    PageMoveDown,
    PageMoveUp,
};

typedef NS_ENUM(NSInteger, PickerViewType) {
    PickerViewTime,
    PickerViewHeight,
    PickerViewBirthday,
    PickerViewWeight,
};

typedef NS_ENUM(NSInteger, WaterWarmState) {
    WaterWarmStateOff,
    WaterWarmStateBefore,
    WaterWarmStateDrink,
    WaterWarmStateAfter,
};

typedef NS_ENUM(NSInteger, CSLoginType) {
    CSLoginDefault = 0,
    CSLoginQQ = 1,
    CSLoginWeibo = 2,
};

typedef NS_ENUM(NSInteger, CSResponceCode) {
    CSResponceCodeFail = 0,
    CSResponceCodeSuccess = 1,
};

typedef NS_ENUM(NSInteger, CSConnectState) {
    CSConnectUnfound = 0,
    CSConnectfound = 1,
};

#endif
