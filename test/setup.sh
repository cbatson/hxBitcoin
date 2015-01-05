#!/bin/sh
set -e
_THIS="$( cd "$( dirname "$0" )" && pwd )"
set -x

HOST=$1
TARGET=$2
DEVHAXE=$3
RETRY=$4

case $HOST in
	linux)
		if $DEVHAXE; then
			$RETRY sudo apt-get install ocaml zlib1g-dev libgc-dev gcc-multilib g++-multilib -y
			$RETRY git clone https://github.com/HaxeFoundation/neko.git ~/neko
			( cd ~/neko && make os=$HOST && sudo make install )
		else
			$RETRY sudo add-apt-repository ppa:eyecreate/haxe -y
			$RETRY sudo apt-get update
			$RETRY sudo apt-get install haxe -y --force-yes
			$RETRY sudo apt-get install gcc-multilib g++-multilib -y
		fi
		;;
	osx)
		$RETRY brew update
		if $DEVHAXE; then
			$RETRY brew install ocaml camlp4
			$RETRY brew install neko --HEAD
		fi
		;;
	*)
		echo "error: unknown host: ${HOST}" >&2
		exit 1
		;;
esac

# Prep haxe
if $DEVHAXE; then
	git clone --recursive https://github.com/HaxeFoundation/haxe.git ~/haxe
	( cd ~/haxe && make && make tools && sudo make install )
fi
mkdir ~/haxelib
haxelib setup ~/haxelib

# Prep hxcpp
if $DEVHAXE; then
	git clone --recursive https://github.com/HaxeFoundation/hxcpp.git ~/hxcpp
	( cd ~/hxcpp/tools/run && haxe compile.hxml )
	( cd ~/hxcpp/tools/hxcpp && haxe compile.hxml )
	( cd ~/hxcpp/project && neko build.n )
else
	$RETRY haxelib install hxcpp
fi
