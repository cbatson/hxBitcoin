#!/bin/sh
set -e
_THIS="$( cd "$( dirname "$0" )" && pwd )"
cd "${_THIS}"
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
	linux | osx)
		haxe "targets/${_TARGET}.hxml"
		bin/${_TARGET}/TestMain
		;;
	*)
		echo "error: unknown target: ${_TARGET}" >&2
		exit 1
		;;
esac
