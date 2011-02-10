#!/bin/sh
function failed()
{
    echo "Failed $*: $@" >&2
    exit 1
}

set -ex

export OUTPUT=$WORKSPACE/output
rm -rf $OUTPUT
mkdir -p $OUTPUT
PROFILE_HOME=~/Library/MobileDevice/Provisioning\ Profiles/
KEYCHAIN=~/Library/Keychains/login.keychain

. "$WORKSPACE/autobuild/build.config"

[ -d "$PROFILE_HOME" ] || mkdir -p "$PROFILE_HOME"
security unlock -p `cat ~/.build_password`
agvtool new-version -all $BUILD_NUMBER

for config in $CONFIGURATIONS; do
    provision=$(eval echo \$`echo Provision$config`)
    codesign=$(eval echo \$`echo Codesign$config`)

    cert="$WORKSPACE/autobuild/$provision"
    fileprefix="$JOB_NAME-$BUILD_NUMBER-$config";
    archive="$fileprefix.zip";
    ipaname="$fileprefix.ipa"
    otaname="$fileprefix.plist"

    [ -f "$cert" ] && cp "$cert" "$PROFILE_HOME"
    xcodebuild -activetarget -configuration $config build || failed build;

    if [ "x$config" = "xDistribution" ]; then
        app_path=$(ls -d build/$config-iphoneos/*.app)
        xcrun -sdk iphoneos PackageApplication -v "$app_path" -o "$OUTPUT/$ipaname" --sign "$codesign" --embed "$cert"

	mkdir $OUTPUT/$fileprefix
	cp $WORKSPACE/$OTASmallIcon $OUTPUT/$fileprefix/Icon-57.png
	cp $WORKSPACE/$OTALargeIcon $OUTPUT/$fileprefix/Icon-512.png
        
        info_plist=$(ls *Info.plist | sed -e 's/\.plist//')
        bundle_version=$(defaults read $WORKSPACE/$info_plist CFBundleShortVersionString)
        bundle_id=$(defaults read $WORKSPACE/$info_plist CFBundleIdentifier)

        cat << EOF > $OUTPUT/$otaname
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
   <key>items</key>
   <array>
       <dict>
           <key>assets</key>
           <array>
               <dict>
                   <key>kind</key>
                   <string>software-package</string>
                   <key>url</key>
                   <string>$OTAURL/$ipaname</string>
               </dict>
               <dict>
                   <key>kind</key>
                   <string>display-image</string>
                   <key>needs-shine</key>
                   <true/>
                   <key>url</key>
                   <string>$OTAURL/output/$fileprefix/Icon-57.png</string>
               </dict>
               <dict>
                   <key>kind</key>
                   <string>full-size-image</string>
                   <key>needs-shine</key>
                   <true/>
                   <key>url</key>
                   <string>$OTAURL/output/$fileprefix/Icon-512.png</string>
               </dict>
           </array>
           <key>metadata</key>
           <dict>
               <key>bundle-identifier</key>
               <string>$bundle_id</string>
               <key>bundle-version</key>
               <string>$bundle_version #$BUILD_NUMBER</string>
               <key>kind</key>
               <string>software</string>
               <key>title</key>
               <string>$OTATitle</string>
               <key>subtitle</key>
               <string>$OTASubtitle</string>
           </dict>
       </dict>
   </array>
</dict>
</plist>
EOF
    else
        (
            cd build/$config-iphoneos || failed "no build output";
            zip -r -T -y "$OUTPUT/$archive" *.app $provision || failed zip;
        )
    fi
done
