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
    archive="$OUTPUT/$JOB_NAME-$BUILD_NUMBER-$config.zip";
    ipaname="$OUTPUT/$JOB_NAME-$BUILD_NUMBER-$config.ipa"
    provname="$OUTPUT/$JOB_NAME-$BUILD_NUMBER-$config.mobileprovision"

    [ -f "$cert" ] && cp "$cert" "$PROFILE_HOME"
    xcodebuild -activetarget -configuration $config build || failed build;

    if [ "x$config" = "xDistribution" ]; then
        app_path=$(ls -d build/$config-iphoneos/*.app)
        xcrun -sdk iphoneos PackageApplication -v "$app_path" -o "$ipaname" --sign "$codesign" --embed "$cert"
    else
        (
            cd build/$config-iphoneos || failed "no build output";
            zip -r -T -y "$archive" *.app $provision || failed zip;
        )
    fi
done
