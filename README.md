# Pixelator

let urImage = // image

let pixelator = Pixelator();
pixelator.set(image: urImage);

let pixelatedImage = pixelator.pixelate(downRate: 8)

// or

let pixelatedImg = urImage.pixelated(downRate: 8)
