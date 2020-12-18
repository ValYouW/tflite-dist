# How to build
These are notes on how tflite-dist is prepared.

# Android
The build for Android is done using the `build-android.sh` script. It has to run on Linux machine (WSL is OK) that was configured for Tensorflow Android builds.
Can check [this](https://www.thecodingnotebook.com/2019/11/building-tensorflow-lite-for-android-on.html) blog post.

The script will build the C, C++ libraries and the GPU delegate.

This script will also gather all the `include` files for `tflite-dist` (include files are the same for all platforms).

# iOS
Building the C ios framework should be done on a configured mac machine, instructions are per Tensorflow Lite [instructions](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/lite/g3doc/guide/build_ios.md)

Then the build command is:
```
bazel build --config=ios_fat -c opt \
  //tensorflow/lite/ios:TensorFlowLiteC_framework
```

# Windows
Building for windows requires a machine with Python, Numpy and a supported version of Bazel,
the supported version can be found under in the tensorflow repository under `.bazelversion` file.

Then to build the C library, from git bash:
```
cd [tensorflow-root-repo]
git checkot [wanted tag]
python configure.py
./tensorflow/lite/tools/make/download_dependencies.sh
bazel build //tensorflow/lite/c:tensorflowlite_c.dll -c opt
```

One can also build the C++ library, but due to its size it is not included in tflite-dist, the build command is:
```
bazel build //tensorflow/lite:tensorflowlite.dll -c opt
```
