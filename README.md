Scripts to copy lib:
echo "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
mkdir "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"

export DYLIB=libopencv_core.2.4.13.dylib
cp -f "$SRCROOT/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
install_name_tool -change @executable_path/$DYLIB @loader_path/../Frameworks/$DYLIB "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/MacOS/$PRODUCT_NAME"

export DYLIB=libopencv_imgproc.2.4.13.dylib
cp -f "$SRCROOT/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
install_name_tool -change @executable_path/$DYLIB @loader_path/../Frameworks/$DYLIB "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/MacOS/$PRODUCT_NAME"

export DYLIB=libopencv_highgui.2.4.13.dylib
cp -f "$SRCROOT/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
install_name_tool -change @executable_path/$DYLIB @loader_path/../Frameworks/$DYLIB "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/MacOS/$PRODUCT_NAME"

"--deep" flag should be added to signing in order to support signing on opencv lib.
