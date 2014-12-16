import com.fundoware.engine.bitcoin.FunBitcoinContext;
import com.fundoware.engine.bitcoin.FunBitcoinEncryptedPrivateKey;
import com.fundoware.engine.bitcoin.FunBitcoinPrivateKey;

class Example
{
	public static function privateKeyToAddress() : Void
	{
		var context = new FunBitcoinContext();
		var privKey = FunBitcoinPrivateKey.fromString(context, "5KN7MzqK5wt2TP1fQCYyHBtDrXdJuXbUzm4A9rKAteGu3Qi5CVR");
		trace("private key (hex) = " + privKey.toBytes().toHex());
		var address = privKey.toAddress();
		privKey.clear();
		trace("address = " + address);
	}
	
	public static function decryptBIP0038() : Void
	{
		var context = new FunBitcoinContext();
		var encryptedKey = FunBitcoinEncryptedPrivateKey.fromString(context, "6PRVWUbkzzsbcVac2qwfssoUJAN1Xhrg6bNk8J7Nzm5H7kxEbn2Nh2ZoGg");
		var decryptedKey = encryptedKey.decryptString("TestingOneTwoThree");
		encryptedKey.clear();
		trace("private key (WIF) = " + decryptedKey.toWIF());
		var address = decryptedKey.toAddress();
		decryptedKey.clear();
		trace("address = " + address);
	}
	
	public static function main() : Void
	{
		privateKeyToAddress();
		decryptBIP0038();
	}
}