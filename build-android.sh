set -e

function log() {
	echo "-------------"
	echo "----->>> $1"
	echo "-------------"
}

function rmdir() {
	if [ -d $1 ]; then
		log "Removing folder $1"
		rm -rf $1
	fi
}

function collectHeaders() {
	log "Collecting headers..."
	cd $TF_DIR/tensorflow
	rm -f headers.tar
	find ./lite -name "*.h" | tar -cf headers.tar -T -
	if [ ! -f headers.tar ]; then
		log "headers.tar not created not error given"
		exit 1
	fi

	mv headers.tar $DIST_DIR
	cd $DIST_DIR
	mkdir -p include/tensorflow
	tar xvf headers.tar -C include/tensorflow
	rm headers.tar
}

function buildArch() {
	log "Building for $1 --> $2"
	cd $TF_DIR

	bazel build //tensorflow/lite/c:libtensorflowlite_c.so --config=$1 -c opt
	bazel build //tensorflow/lite/delegates/gpu:libtensorflowlite_gpu_delegate.so -c opt --config $1 --copt -Os --copt -DTFLITE_GPU_BINARY_RELEASE --copt -s --strip always

	mkdir -p $DIST_DIR/libs/android/$2

	cp bazel-bin/tensorflow/lite/c/libtensorflowlite_c.so $DIST_DIR/libs/android/$2/
	cp bazel-bin/tensorflow/lite/delegates/gpu/libtensorflowlite_gpu_delegate.so $DIST_DIR/libs/android/$2/
}

# The order of these two should match
ARCHS=("android_arm64" "android_arm" "android_x86_64" "android_x86")
ABIS=("arm64-v8a" "armeabi-v7a" "x86_64" "x86")

DIST_DIR=`dirname ${BASH_SOURCE[0]}`
DIST_DIR=`realpath $DIST_DIR`
TF_DIR=`realpath $1`
BRANCH=$2

if [ ! -d $TF_DIR ]; then
	log "First param must be tensorflow repo path"
	exit 1
fi

if [ -e $BRANCH ]; then
	log "Second param must be a branch/tag"
	exit 1
fi

cd $DIST_DIR
log "clean local dist"
rmdir include
rmdir libs/android
mkdir -p libs/android

cd $TF_DIR
log "Update repo"
git checkout master
git pull
log "Switching to $BRANCH"
git checkout $BRANCH

log "bazel clean"
bazel clean

for i in ${!ARCHS[@]}; do
	buildArch ${ARCHS[$i]} ${ABIS[$i]}
done

collectHeaders

