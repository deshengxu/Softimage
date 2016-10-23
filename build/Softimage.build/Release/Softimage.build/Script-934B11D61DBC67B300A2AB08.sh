#!/bin/sh
echo "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
mkdir "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"

export DYLIB=libopencv_core.2.4.13.dylib
export DYL=libopencv_core.2.4.dylib
cp -f "$SRCROOT/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
cp "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"
install_name_tool -change /usr/local/opt/opencv/lib/$DYL @loader_path/../Frameworks/$DYL "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/MacOS/$PRODUCT_NAME"

export DYL_CORE="$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"

export DYLIB=libopencv_imgproc.2.4.13.dylib
export DYL=libopencv_imgproc.2.4.dylib
cp -f "$SRCROOT/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
cp "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"
install_name_tool -change /usr/local/opt/opencv/lib/$DYL @loader_path/../Frameworks/$DYL "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/MacOS/$PRODUCT_NAME"

export DYL_IMGPROC="$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"

export DYLIB=libopencv_highgui.2.4.13.dylib
export DYL=libopencv_highgui.2.4.dylib
cp -f "$SRCROOT/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
cp "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"
install_name_tool -change /usr/local/opt/opencv/lib/$DYL @loader_path/../Frameworks/$DYL "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/MacOS/$PRODUCT_NAME"

export DYL_HIGHGUI="$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"

export FULLLIB=/usr/local/opt/libpng/lib/libpng16.16.dylib
export DYL=libpng16.16.dylib
cp -f "$FULLLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_HIGHGUI"

export FULLLIB=/usr/local/opt/libtiff/lib/libtiff.5.dylib
export DYL=libtiff.5.dylib
cp -f "$FULLLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
chmod +wx "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_HIGHGUI"
export DYL_LIBTIFF="$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"

export FULLLIB=/usr/local/opt/openexr/lib/libIlmImf-2_2.22.dylib
export DYL=libIlmImf-2_2.22.dylib
cp -f "$FULLLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_HIGHGUI"
export DYL_LIBILMIMF="$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"
chmod +wx $DYL_LIBILMIMF

export FULLLIB=/usr/local/opt/ilmbase/lib/libIlmThread-2_2.12.dylib
export DYL=libIlmThread-2_2.12.dylib
cp -f "$FULLLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_HIGHGUI"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_LIBILMIMF"
export DYL_LIBILMTHREAD="$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"
chmod +wx $DYL_LIBILMTHREAD

export FULLLIB=/usr/local/opt/ilmbase/lib/libImath-2_2.12.dylib
export DYL=libImath-2_2.12.dylib
cp -f "$FULLLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
export DYL_LIBIMATH="$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"
chmod +wx $DYL_LIBIMATH
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_HIGHGUI"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_LIBILMIMF"

export DYL=libIexMath-2_2.12.dylib
export FULLLIB=/usr/local/opt/ilmbase/lib/$DYL
cp -f $FULLLIB "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_LIBILMIMF"
export DYL_LIBIEXMATH="$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks/$DYL"
chmod +wx $DYL_LIBIEXMATH

export DYL=libIex-2_2.12.dylib
export FULLLIB=/usr/local/opt/ilmbase/lib/$DYL
cp -f $FULLLIB "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_HIGHGUI"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_LIBILMTHREAD"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_LIBILMIMF"
install_name_tool -change /usr/local/Cellar/ilmbase/2.2.0/lib/libIex-2_2.12.dylib @loader_path/../Frameworks/$DYL "$DYL_LIBIMATH"
install_name_tool -change /usr/local/Cellar/ilmbase/2.2.0/lib/libIex-2_2.12.dylib @loader_path/../Frameworks/$DYL "$DYL_LIBIEXMATH"
install_name_tool -change /usr/local/Cellar/ilmbase/2.2.0/lib/libIex-2_2.12.dylib @loader_path/../Frameworks/$DYL "$DYL_LIBILMTHREAD"

export FULLLIB=/usr/local/opt/jpeg/lib/libjpeg.8.dylib
export DYL=libjpeg.8.dylib
cp -f "$FULLLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_HIGHGUI"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_LIBTIFF"

export DYL=libz.1.dylib
export FULLLIB=/usr/lib/$DYL
cp -f "/usr/lib/$DYL" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_HIGHGUI"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_CORE"


export FULLLIB=/usr/local/opt/ilmbase/lib/libHalf.12.dylib
export DYL=libHalf.12.dylib
cp -f "$FULLLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_HIGHGUI"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_LIBILMIMF"

export FULLLIB=/usr/lib/libobjc.A.dylib
export DYL=libobjc.A.dylib
cp -f "$FULLLIB" "$TARGET_BUILD_DIR/$TARGET_NAME.app/Contents/Frameworks"
install_name_tool -change $FULLLIB @loader_path/../Frameworks/$DYL "$DYL_HIGHGUI"

