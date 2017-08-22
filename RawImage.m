//
//  RawImage.m
//  TTMPixelator
//
//  Created by Thwin Htoo Aung on 8/22/17.
//  Copyright © 2017 Thwin Htoo Aung. All rights reserved.
//

#import "RawImage.h"

@implementation RawImage

//- (instancetype)init {
//    self = [super init];
//    
//    return nil;
//}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    
    if (self) {
        
        width = 0;
        height = 0;
        bytesPerPixel = 0;
        bytesPerRow = 0;
        
        
        if (image != nil) {
            
            // get the reference to CGImageRef
            CGImageRef temp_cgImageRef = [image CGImage];
            
            // if the UIImage instance is backed by CIImage
            if (!temp_cgImageRef) {
                
                // get CGImageRef from CIImage instance
                temp_cgImageRef = [[image CIImage] CGImage];
            }
            
            
            // if the CGImageRef exists
            if (temp_cgImageRef) {
                
                printf("It\'s running \n");
                // set width of the image
                width = CGImageGetWidth(temp_cgImageRef);
                
                // set height of the image
                height = CGImageGetHeight(temp_cgImageRef);
                
//                printf("width: %d, height: %d \n", width, height);
                
                // total bits used to represent a channel
                bitsPerComponent = 8;
                
                // total bytes used to represent a pixel
                bytesPerPixel = 4;
                
                // bytes per row
                bytesPerRow = width * bytesPerPixel;
                
                // total bytes required to allocate
//                const NSInteger totalBytes = bytesPerRow * height;
                
                
                // allocate required memory
                raw = malloc(bytesPerPixel * width * height * sizeof(unsigned char));
                
                
                // get device's color space
                CGColorSpaceRef hostColorspcae = CGColorSpaceCreateDeviceRGB();
                
                
                // get a CGContextRef to draw image into buffer
                CGContextRef cgContext = CGBitmapContextCreate(raw, width, height, bitsPerComponent, bytesPerRow, hostColorspcae, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
                
                
                // draw image datas into the buffer
                CGContextDrawImage(cgContext, (CGRect){0, 0, width, height}, temp_cgImageRef);
                
                
                // release colorspace ref
                CGColorSpaceRelease(hostColorspcae);
                hostColorspcae = NULL;
                
                CGContextRelease(cgContext);
                cgContext = NULL;
            }
            
        }
    }
    
    return self;
}






- (void)dealloc {
    
    // deallocate raw memory block if allocated
    if (raw) {
        free(raw);
    }
}






#pragma mark Private Methods

- (BOOL) isX:(NSInteger)x andYInBound:(NSInteger)y {
    BOOL result = NO;
    
    if ( (x > -1 && x < width) && (y > -1 && y < height) ) {
        result = YES;
    }
    
    if ([self isEmptyImage]) {
        result = NO;
    }
    
    return result;
}

/// returns actual pointer jump point according to given x and y
- (NSInteger) getActualPointerIndexUsingX:(NSInteger)x andY:(NSInteger)y {
    const NSInteger actualPixelY = y * bytesPerRow;
    const NSInteger actualPixelX = x * bytesPerPixel;
    const NSInteger actualIndex = actualPixelX + actualPixelY;
    
    return actualIndex;
}






#pragma mark Exposed Methods

- (UInt32)getRedValueOfPixelAtX:(NSInteger)x andY:(NSInteger)y {
    if ([self isX:x andYInBound:y]) {
        UInt32 value = 0;
        
        const NSInteger actualIndex = [self getActualPointerIndexUsingX:x andY:y];

        // red value
        value = *(raw + actualIndex + 0);
        
        return value;
    } else {
        NSAssert(NO, @"Pixel Index Out of Bound");
    }
    return 0;
}






- (UInt32)getGreenValueOfPixelAtX:(NSInteger)x andY:(NSInteger)y {
    if ([self isX:x andYInBound:y]) {
        UInt32 value = 0;
        
        const NSInteger actualIndex = [self getActualPointerIndexUsingX:x andY:y];
        
        // green value
        value = *(raw + actualIndex + 1);
        
        return value;
    } else {
        NSAssert(NO, @"Pixel Index Out of Bound.");
    }
    return 0;
}






- (UInt32)getBlueValueOfPixelAtX:(NSInteger)x andY:(NSInteger)y {
    if ([self isX:x andYInBound:y]) {
        UInt32 value = 0;
        
        const NSInteger actualIndex = [self getActualPointerIndexUsingX:x andY:y];
        
        // blue value
        value = *(raw + actualIndex + 2);
        
        return value;
    } else {
        NSAssert(NO, @"Pixel Index Out of Bound.");
    }
    return 0;
}






- (UInt32)getAlphaValueOfPixelAtX:(NSInteger)x andY:(NSInteger)y {
    if ([self isX:x andYInBound:y]) {
        UInt32 value = 0;
        
        const NSInteger actualIndex = [self getActualPointerIndexUsingX:x andY:y];
        
        // alpha value
        value = *(raw + actualIndex + 3);
        
        return value;
    } else {
        NSAssert(NO, @"Pixel Index Out of Bound.");
    }
    return 0;
}






- (UInt32)getColorValueOfPixelAtX:(NSInteger)x andY:(NSInteger)y {
    if ([self isX:x andYInBound:y]) {
        UInt32 value = 0;
        
        const NSInteger actualIndex = [self getActualPointerIndexUsingX:x andY:y];
        
        // color value descriptor
        unsigned int * _32bits_ptr = (unsigned int *) (raw + actualIndex);
        
        // get 32 bit color value
        value = *_32bits_ptr;
        
        return value;
    } else {
        NSAssert(NO, @"Pixel Index Out of Bound.");
    }
    return 0;
}






// setters

- (void)setRedValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y withValue:(unsigned char)value {
    // check array bound
    if ([self isX:x andYInBound:y]) {
        
        unsigned char channelValue = (value);
        
        const NSInteger actualIndex = [self getActualPointerIndexUsingX:x andY:y];
        // assign to red index
        *(raw + actualIndex) = channelValue;
    } else {
        NSAssert(NO, @"Pixel Index Out of Bound.");
    }
}





- (void)setGreenValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y withValue:(unsigned char)value {
    // check array bound
    if ([self isX:x andYInBound:y]) {
        
        unsigned char channelValue = (value);
        
        const NSInteger actualIndex = [self getActualPointerIndexUsingX:x andY:y];
        // assign to green index
        *(raw + actualIndex + 1) = channelValue;
    } else {
        NSAssert(NO, @"Pixel Index Out of Bound.");
    }
}





- (void)setBlueValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y withValue:(unsigned char)value {
    // check array bound
    if ([self isX:x andYInBound:y]) {
        
        unsigned char channelValue = (value);
        
        const NSInteger actualIndex = [self getActualPointerIndexUsingX:x andY:y];
        // assign to blue index
        *(raw + actualIndex + 2) = channelValue;
    } else {
        NSAssert(NO, @"Pixel Index Out of Bound.");
    }
}





- (void)setAlphaValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y withValue:(unsigned char)value {
    // check array bound
    if ([self isX:x andYInBound:y]) {
        
        unsigned char channelValue = (value);
        
        const NSInteger actualIndex = [self getActualPointerIndexUsingX:x andY:y];
        // assign to alpha index
        *(raw + actualIndex + 3) = channelValue;
    } else {
        NSAssert(NO, @"Pixel Index Out of Bound.");
    }
}






- (void)setColorValueOfPixelAtX:(NSInteger) x andY: (NSInteger)y withValue:(unsigned int)value {
    // check array bound
    if ([self isX:x andYInBound:y]) {
        
        unsigned int channelValue = (value);
        
        const NSInteger actualIndex = [self getActualPointerIndexUsingX:x andY:y];
        
        *(unsigned int *)(raw + actualIndex) = channelValue;
    } else {
        NSAssert(NO, @"Pixel Index Out of Bound.");
    }
}



- (BOOL)isEmptyImage {
    return (width == 0 || height == 0);
}





#pragma mark setters and getters
- (UIImage *) getImage {
    
    UIImage * img;
    
    if ([self isEmptyImage]) {
        img = [[UIImage alloc] init];
    } else {
        
        CFDataRef cfdata = CFDataCreate(NULL, self->raw, width * height * bytesPerPixel);
        
        CGDataProviderRef provider = CGDataProviderCreateWithCFData(cfdata);
        
        CGColorSpaceRef hostColorspace = CGColorSpaceCreateDeviceRGB();
        
        CGImageRef cgimage = CGImageCreate(width,
                                           height,
                                           bitsPerComponent,
                                           bytesPerPixel * bitsPerComponent,
                                           bytesPerRow,
                                           hostColorspace,
                                           kCGBitmapByteOrderDefault,
                                           provider,
                                           NULL,
                                           NO,
                                           kCGRenderingIntentDefault);
        
        
        printf("width: %zu, height: %zu \n", CGImageGetWidth(cgimage), CGImageGetHeight(cgimage));
        
        img = [[UIImage alloc] initWithCGImage: cgimage];
        
        
        CFRelease(cfdata);
        cfdata = NULL;
        CGDataProviderRelease(provider);
        provider = NULL;
        CGColorSpaceRelease(hostColorspace);
        hostColorspace = NULL;
        CGImageRelease(cgimage);
        cgimage = NULL;
    }
    
    if (img == nil) {
        printf("Image is nil \n");
    } else {
        printf("Image is not nil");
        
    }
    
    return img;
}


@synthesize width = _width;
- (NSInteger)getWidth {
    return self->width;
}

@synthesize height = _height;
- (NSInteger)getHeight {
    return self->height;
}


- (RawImage *)copy {
    return [[RawImage alloc] initWithImage:self.image];
}

@end
