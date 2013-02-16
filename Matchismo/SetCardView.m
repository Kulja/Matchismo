//
//  SetCardView.m
//  Matchismo
//
//  Created by Marko Kuljanski on 2/13/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12.0];
    [roundedRect addClip]; //prevents filling corners, i.e. sharp corners not included in roundedRect
    
    if (self.faceUp) {
        [[UIColor lightGrayColor] setFill];
        UIRectFill(self.bounds);
    } else {
        [[UIColor whiteColor] setFill];
        UIRectFill(self.bounds);
    }
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawCards];
}

#define SIZE_OF_OVAL_CURVE 10
#define Y_OFFSET_FOR_NUMBER_2 2.7
#define Y_OFFSET_FOR_NUMBER_3 1.7

- (void)drawCards
{
    if ([self.symbol isEqualToString:@"diamond"]) {
        [self drawDiamond];
    } else if ([self.symbol isEqualToString:@"squiggle"]) {
        [self drawSquiggle];
    } else if ([self.symbol isEqualToString:@"oval"]) {
        [self drawOval];
    }
}

- (void)drawSquiggle
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint start = CGPointMake(middle.x + (middle.x / 2), middle.y - (middle.y / 4.5));
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:start];
    [path addQuadCurveToPoint:CGPointMake(start.x, middle.y + (middle.y / 4.5)) controlPoint:CGPointMake(start.x + SIZE_OF_OVAL_CURVE, middle.y)];
    [path addCurveToPoint:CGPointMake(middle.x - (middle.x / 2), middle.y + (middle.y / 4.5)) controlPoint1:CGPointMake(middle.x + (middle.x / 10), middle.y + (middle.y / 2.5)) controlPoint2:CGPointMake(middle.x - (middle.x / 10), middle.y + (middle.y / 30))];
    [path addQuadCurveToPoint:CGPointMake(middle.x - (middle.x / 2), start.y) controlPoint:CGPointMake(middle.x - (middle.x / 2) - SIZE_OF_OVAL_CURVE, middle.y)];
    [path addCurveToPoint:CGPointMake(start.x, start.y) controlPoint1:CGPointMake(middle.x - (middle.x / 10), middle.y - (middle.y / 2.5)) controlPoint2:CGPointMake(middle.x + (middle.x / 10), middle.y - (middle.y / 30))];
    
    [self drawAttributesFor:path];
}

- (void)drawOval
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint start = CGPointMake(middle.x + (middle.x / 2), middle.y - (middle.y / 4.5));
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:start];
    [path addQuadCurveToPoint:CGPointMake(start.x, middle.y + (middle.y / 4.5)) controlPoint:CGPointMake(start.x + SIZE_OF_OVAL_CURVE, middle.y)];
    [path addLineToPoint:CGPointMake(middle.x - (middle.x / 2), middle.y + (middle.y / 4.5))];
    [path addQuadCurveToPoint:CGPointMake(middle.x - (middle.x / 2), start.y) controlPoint:CGPointMake(middle.x - (middle.x / 2) - SIZE_OF_OVAL_CURVE, middle.y)];
    [path closePath];
    
    [self drawAttributesFor:path];
}

- (void)drawDiamond
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint start = CGPointMake(middle.x, middle.y - (middle.y / 4.5));
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:start];
    [path addLineToPoint:CGPointMake(middle.x + (middle.x / 1.5), middle.y)];
    [path addLineToPoint:CGPointMake(middle.x, middle.y + (middle.y / 4.5))];
    [path addLineToPoint:CGPointMake(middle.x - (middle.x / 1.5), middle.y)];
    [path closePath];
    
    [self drawAttributesFor:path];
}

- (void)drawAttributesFor:(UIBezierPath *)path
{
    [[UIColor valueForKey:self.color] setStroke];
    
    if ([self.shading isEqualToString:@"striped"]) {
        [[[UIColor valueForKey:self.color] colorWithAlphaComponent:0.3] setFill];
    } else if ([self.shading isEqualToString:@"solid"]) {
        [[UIColor valueForKey:self.color] setFill];
    } else {
        
    }
    
    if (self.number == 2) {
        CGFloat yOffset = self.bounds.size.height/2/Y_OFFSET_FOR_NUMBER_2;
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
        
        transform = CGAffineTransformMakeTranslation(0, yOffset * 2);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
    } else if (self.number == 3) {
        CGFloat yOffset = self.bounds.size.height/2/Y_OFFSET_FOR_NUMBER_3;
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
        
        transform = CGAffineTransformMakeTranslation(0, yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
        
        transform = CGAffineTransformMakeTranslation(0, yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
    } else {
        [path stroke];
        [path fill];
    }
}

@end
