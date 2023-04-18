# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/bananadroid/android_manifest.git -b 13 -g default,-mips,-darwin,-notdefault --git-lfs
git clone https://github.com/aepranata/local_manifests.git --depth 1 -b banana/13 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch banana_rosy-userdebug
export KBUILD_BUILD_USER=aepranata
export KBUILD_BUILD_HOST=a3machine
export BUILD_USERNAME=aepranata
export BUILD_HOSTNAME=a3machine
export SELINUX_IGNORE_NEVERALLOWS=true
export WITH_GAPPS=true
export BUILD_CORE_GAPPS=true
export BUILD_CORE_GAPPS_EXTRA=true
export WITH_FM_RADIO=true
export TZ=Asia/Jakarta #put before last build command
m banana

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
