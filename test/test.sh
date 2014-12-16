#!/bin/sh
set -e
_TARGET=$1
if [ -z "$_TARGET" ]; then
	_TARGET=osx
fi
case $_TARGET in
	ios)
		haxelib run lime build ios
		;;
	neko)
		haxe "targets/${_TARGET}.hxml"
		neko bin/${_TARGET}/test.n
		;;
	osx)
		haxe "targets/${_TARGET}.hxml"
		bin/${_TARGET}/TestMain
		;;
esac
