# [hxBitcoin - the Bitcoin, cryptocurrency and cryptography library for Haxe](http://hxbitcoin.com)

	
## Features

### Bitcoin
 * BIP0038 (encrypted private keys)
 * WIF
 * Convert private keys to public keys & addresses
 * Base58

### Crypto
 * scrypt
 * AES
 * SHA-1, SHA-256, RIPEMD160
 * Elliptic curve arithmetic
 * secp256k1 & NIST curves

### Other
 * Modular arithmetic (Fp)
 * Arbitrary-size (big) integer
 * Unicode 7.0
 * Extensive test suite of **over 22,000** individual tests and vectors
 * Pure Haxe implementation
 * No additional/external dependencies


## Supported Platforms & Targets

 * iOS (C++)
 * Windows (C++)
 * Mac OSX (C++)
 * Linux (C++)
 * AS3/Flash
 * Neko
 * [Request more...](mailto:fundoware+hxbitcoin@gmail.com)


## Installation

    haxelib install hxBitcoin

To use in your Haxe project, build with this:

    haxe -lib hxBitcoin ...

To use in your lime/NME project, at this to your project's
`application.xml` file:
	
    <haxelib name="hxBitcoin"/>


## Examples

### Convert private key to address

``` haxe
import com.fundoware.engine.bitcoin.FunBitcoinContext;
import com.fundoware.engine.bitcoin.FunBitcoinPrivateKey;

var context = new FunBitcoinContext();
var privKey = FunBitcoinPrivateKey.fromString(context, "5KN7MzqK5wt2TP1fQCYyHBtDrXdJuXbUzm4A9rKAteGu3Qi5CVR");
trace("private key = " + privKey.toBytes().toHex());
var address = privKey.toAddress();
privKey.clear();
trace("address = " + address);
```

```
haxe -lib hxBitcoin -main Example.hx -neko example.n && neko example.n
Example.hx:10: private key (hex) = cbf4b9f70470856bb4f40f80b87edb90865997ffee6df315ab166d713af433a5
Example.hx:13: address = 1Jq6MksXQVWzrznvZzxkV6oY57oWXD9TXB
```

### Decrypt BIP0038 private key

``` haxe
import com.fundoware.engine.bitcoin.FunBitcoinContext;
import com.fundoware.engine.bitcoin.FunBitcoinEncryptedPrivateKey;
import com.fundoware.engine.bitcoin.FunBitcoinPrivateKey;

var context = new FunBitcoinContext();
var encryptedKey = FunBitcoinEncryptedPrivateKey.fromString(context, "6PRVWUbkzzsbcVac2qwfssoUJAN1Xhrg6bNk8J7Nzm5H7kxEbn2Nh2ZoGg");
var decryptedKey = encryptedKey.decryptString("TestingOneTwoThree");
encryptedKey.clear();
trace("private key (WIF) = " + decryptedKey.toWIF());
var address = decryptedKey.toAddress();
decryptedKey.clear();
trace("address = " + address);
```

```
haxe -lib hxBitcoin -main Example.hx -neko example.n && neko example.n
Example.hx:23: private key (WIF) = 5KN7MzqK5wt2TP1fQCYyHBtDrXdJuXbUzm4A9rKAteGu3Qi5CVR
Example.hx:26: address = 1Jq6MksXQVWzrznvZzxkV6oY57oWXD9TXB
```


## License

hxBitcoin is offered under the MIT license. See
[LICENSE.txt](LICENSE.txt).


## Change Log

See [CHANGES.md](CHANGES.md).


## Security Notes

Thoughtful care is needed when dealing with any security-sensitive
application.

Some non-exhaustive consideration has been given to security
concerns when authoring this library.

In particular, no special effort has been made (yet) to deal with
[side channel attacks](http://en.wikipedia.org/wiki/Side_channel_attack)
such as [timing attacks](http://en.wikipedia.org/wiki/Timing_attack).

This software is only as secure as the machine, system, and process
running it. If another process (privileged or otherwise) gains
access to the software's memory, sensitive data such as private keys
can be discovered.

This particular vector can be mitigated somewhat by consistent use
of the `clear()` method found on classes that implement the
`FunIClearable` interface to wipe sensitive data from objects as
early as possible. However even by applying this strategy it cannot
be guaranteed that all sensitive data will be cleared in all cases.
Due to the behavior or semantics of the underlying language,
framework, and/or runtime environment it is possible that copies of
sensitive data can be created outside the control of this software.

Should you find any specific security issues, kindly report the
issue to the contact below.


## To Do

 * Run test suite from Travis CI on Github
 * Documentation
 * HD wallets / BIP0032 & BIP0044
 * ECDSA
 * RFC 6979
 * Confirmation codes for BIP0038
 * Decompression of public keys
 * Blockchain data structures
 * QR code generation
 * Harden against timing attacks
 * More targets
 * Performance optimization


## Why Haxe?

 * Target C++, Java, JS, PHP, AS3 and more—with a single code base
 * Extends reach to desktop, mobile, web, and server platforms
 * Performant
 * Vibrant and passionate community


## Contact

Questions, issues, feature, priority, and additional target requests
welcome!

Chuck Batson  
fundoware+hxbitcoin@gmail.com  
http://github.com/cbatson
