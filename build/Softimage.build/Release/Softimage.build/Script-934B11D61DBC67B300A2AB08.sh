#!/bin/sh
echo "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
mkdir "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"

export DYLIB=libopencv_core.2.4.13.dylib
export DYL=libopencv_core.2.4.dylib
cp -f "$SRCROOT/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
cp "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"
install_name_tool -change /usr/local/opt/opencv/lib/$DYL @loader_path/../Frameworks/$DYL "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/MacOS/$PRODUCT_NAME"

export DYLIB=libopencv_imgproc.2.4.13.dylib
export DYL=libopencv_imgproc.2.4.dylib
cp -f "$SRCROOT/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
cp "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"
install_name_tool -change /usr/local/opt/opencv/lib/$DYL @loader_path/../Frameworks/$DYL "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/MacOS/$PRODUCT_NAME"

export DYLIB=libopencv_highgui.2.4.13.dylib
export DYL=libopencv_highgui.2.4.dylib
cp -f "$SRCROOT/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
cp "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"
install_name_tool -change /usr/local/opt/opencv/lib/$DYL @loader_path/../Frameworks/$DYL "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/MacOS/$PRODUCT_NAME"
