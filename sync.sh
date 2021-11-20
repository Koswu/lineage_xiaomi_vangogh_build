#!/bin/bash

mkdir -p /tmp/rom # Where to sync source
cd /tmp/rom

# Repo init command, that -device,-mips,-darwin,-notdefault part will save you more time and storage to sync, add more according to your rom and choice. Optimization is welcomed! Let's make it quit, and with depth=1 so that no unnecessary things.
repo init --depth=1 -u git://github.com/LineageOS/android.git -b lineage-18.1 # -g default,-device,-mips,-darwin,-notdefault

ls -al
#rm -rf .repo/local_manifests

# Sync source with -q, no need unnecessary messages, you can remove -q if want! try with -j30 first, if fails, it will try again with -j8
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j10