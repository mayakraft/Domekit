//
//  Script.h
//  Domekit
//
//  Created by Robby on 8/20/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import <Foundation/Foundation.h>

// Define Scenes here
typedef enum : unsigned short {
    MakeFrequency,
    MakeCrop,
    MakeScale,
    Diagram,
    Share
} Scene;

@interface Script : NSObject

@property (nonatomic) Scene scene;

@end
