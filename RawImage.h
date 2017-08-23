//
//  RawImage.h
//  TTMPixelator
//
//  Created by Thwin Htoo Aung on 8/22/17.
//  Copyright © 2017 Thwin Htoo Aung. All rights reserved.
//

@import Foundation;

#if TARGET_OS_IPHONE
@import UIKit;
#elif TARGET_OS_MAC
@import AppKit;
#endif

@import CoreGraphics;


#if TARGET_OS_IPHONE
#define CrossImage UIImage
#elif TARGET_OS_MAC
#define CrossImage NSImage
#endif


/*!
 A representation of Core Graphics Bitmap Image as Objective-C pointer.
 Simplify Raw Image handling (hopefully).
 */
@interface RawImage : NSObject {
    
    NSInteger bytesPerPixel;
    NSInteger bytesPerRow;
    NSInteger bitsPerComponent;
    NSInteger width;
    NSInteger height;
    
    unsigned char * raw;
    
    
}


NS_ASSUME_NONNULL_BEGIN
@property(nonatomic, getter=getImage) CrossImage * image;
@property(nonatomic, getter=getWidth) NSInteger width;
@property(nonatomic, getter=getHeight) NSInteger height;
NS_ASSUME_NONNULL_END



//- (nullable instancetype)init;


NS_ASSUME_NONNULL_BEGIN
- (instancetype) initWithImage: (nullable CrossImage *) image;
NS_ASSUME_NONNULL_END

- (void)dealloc;



/// get the red value of pixel at given coordinate.
- (UInt32)getRedValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y;
/// get the green value of pixel at given coordinate.
- (UInt32)getGreenValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y;
/// get the blue value of pixel at given coordinate.
- (UInt32)getBlueValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y;
/// get the alpha value of pixel at given coordinate.
- (UInt32)getAlphaValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y;
/// get the color value of pixel at given coordinate.
- (UInt32)getColorValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y;


/// set the red value of pixel at given coordinate.
- (void)setRedValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y withValue:(unsigned char)value;

/// set the green value of pixel at given coordinate.
- (void)setGreenValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y withValue:(unsigned char)value;

/// set the blue value of pixel at given coordinate.
- (void)setBlueValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y withValue:(unsigned char)value;

/// set the alpha value of pixel at given coordinate.
- (void)setAlphaValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y withValue:(unsigned char)value;

/// set the value of pixel at given coordinate.
- (void)setColorValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y withValue:(unsigned int)value;

/// Check if the raw image is empty
- (BOOL) isEmptyImage;



NS_ASSUME_NONNULL_BEGIN
- (nonnull CrossImage * ) getImage;

/// Width of the raw image.
/// @return Width of underlying Core Graphics image in Integer format
- (NSInteger) getWidth;

/// Height of the raw image.
/// @return Height of underlying Core Graphics image in Integer format
- (NSInteger) getHeight;

/// Creates a copy of self.
/// @warning This method creates a new image without caching. Creating too much instance may result in memory warning.
- (RawImage *) copy;
NS_ASSUME_NONNULL_END

@end
