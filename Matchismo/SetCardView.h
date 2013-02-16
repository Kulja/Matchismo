//
//  SetCardView.h
//  Matchismo
//
//  Created by Marko Kuljanski on 2/13/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;

@property (nonatomic) BOOL faceUp;

@end
