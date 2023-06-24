export rootfs=/var/tmp/rootfs
sudo debootstrap --arch=i386 etch $rootfs http://archive.debian.org/debian/

rm -rf $rootfs/{dev,proc}
mkdir -p $rootfs{dev,proc}

mkdir -p $rootfs/etc
cp /etc/resolv.conf $rootfs/etc/

tar --numeric-owner -caf $rootfs/rootfs.tar.xz -C $rootfs --transform='s,^./,,' .
