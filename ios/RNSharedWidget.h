//
//  RNSharedWidget.h
//  ReactNativeCreateWidgetTutorial
//
//  Created by Mohamad Firdaus K Hamid on 08/04/2025.
//

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

@interface RNSharedWidget : NSObject<RCTBridgeModule>

@end
