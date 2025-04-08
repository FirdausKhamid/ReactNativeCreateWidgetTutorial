//
//  RNSharedWidget.m
//  ReactNativeCreateWidgetTutorial
//
//  Created by Mohamad Firdaus K Hamid on 08/04/2025.
//

#import <Foundation/Foundation.h>
#import "RNSharedWidget.h"

@implementation RNSharedWidget

NSUserDefaults *sharedDefaults;
NSString *appGroup = @"group.tuto";

-(dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE(RNSharedWidget)

RCT_EXPORT_METHOD(setData: (NSString *)key: (NSString *)data:
                  (RCTResponseSenderBlock)callback){
  sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName:appGroup];
  if (sharedDefaults == nil){
  callback(@[@0]);
    return;
  }
  
  [sharedDefaults setValue:data forKey: key];
  callback(@[[NSNull null]]);
}

@end
