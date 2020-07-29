# tflite-dist
As of today there is no pre-build distribution of TensorFlow Lite C/C++ libraries and headers, this repository is sort of a distribution that can be used in order to use TF lite in C/C++ on mobile.

# Download
You can find the distribution zip under [releases](https://github.com/ValYouW/tflite-dist/releases)

# What's included
The release zip contains a `include` folders with all required headers, and `libs` folder with libraries for Android, iOS and Windows. Not all platform has the same libraries though...

## Android
Has 3 dynamic libs:
1. `libtensorflowlite.so` - C++ library
1. `libtensorflowlite_c.so` - C library
1. `libtensorflowlite_gpu_gl.so` - The C++ GPU delegate library

## iOS
Library is built as a framework for all architectures, contains the framework folder: `TensorFlowLiteC.framework`

## Windows
Has 1 C lib and dll (`tensorflowlite_c.dll.if.lib`, `tensorflowlite_c.dll`)

# Any Example?
I wrote a series of blog posts on [cross-platform object detection using TF lite](https://www.thecodingnotebook.com/2019/11/cross-platform-object-detection-with.html)
