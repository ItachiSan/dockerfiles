#!/bin/bash
# Fetching tarballs and verifying them

# Latest official release for i686
i686_date="2017.03.01"
# Calculating correct fetch date for x86_64 tarball
x86_64_date="`date +%Y.%m`.01"
# Base URL for fetching the tarball
base_url="https://archive.archlinux.org/iso"
# Tarball basename
tarball_basename="archlinux-bootstrap"

# Download stuff where this script is
previous_dir=$PWD
work_dir=$(dirname $0)

cd $work_dir
for arch in i686 x86_64
do
	# Set the date to latest available one... and fallback for i686
	date=$x86_64_date; [ "$arch" == "i686" ] && date=$i686_date
	tarball_name="$tarball_basename-$date-$arch.tar.gz"

	echo "Fetching $arch tarball"
	curl -LO "$base_url/$date/$tarball_name"

	echo "Fetching $arch signature"
	curl -LO "$base_url/$date/$tarball_name.sig"

	# Close everything if tarball verification fails
	echo "Verifying the package"
	gpg --verify "$tarball_name.sig" &>/dev/null || exit $?
	rm "$tarball_name.sig" # Now useless

	echo "Recompressing the tarball"
	# Create a temporary working directory
	temp_dir=`mktemp -d`

	echo "Root access is required to preserve files permissions stored inside the tar"

	# Extact properly the files into the working directory
	sudo tar xf "$tarball_name" -C "$temp_dir" \
		--strip-components 1 \
		--same-permissions\
		--same-order \
		--same-owner

	# Recompact all the files
	sudo tar cf "archlinux-$date-$arch.tar" -C "$temp_dir" \
		--same-permissions \
		--same-owner .

	# Last thing as root... Clean up
	sudo rm -rf "$temp_dir"

	echo "Super-compressing with xz"
	rm -f "archlinux-$date-$arch.tar.xz"
	xz -zeT0 "archlinux-$date-$arch.tar"

	rm -rf "$tarball_name" # Now we can delete it

	echo "Repack done for $arch"
done

# Setted by bash
cd $previous_dir
