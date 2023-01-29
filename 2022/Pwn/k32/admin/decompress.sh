#!/bin/sh

mkdir rootfs && cd rootfs
cat ../rootfs.cpio | sudo cpio --extract