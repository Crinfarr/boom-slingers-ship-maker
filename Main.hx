import haxe.io.BytesData;
import sys.io.File;
import haxe.zip.Uncompress;
import haxe.io.Bytes;
import haxe.crypto.Base64;
import lzma.Lzma.LZMA;
import Sys;

class Main {
	private static function binToBytes(A:Array<Bool>):Bytes {
		var out:BytesData = [];
		var b:Int=0;
		while (A.length > 0) {
			for (i in 0...8) {
				b += (A.shift()?1<<i:0);
			}
			out.push(b);
			trace(b);
			b=0;
		}
		return Bytes.ofData(out);
	}
	public static function main() {
		var shipbytes = Base64.decode(Sys.args()[0]);
		//trace(Base64.decode(Sys.args()[0]).toHex());
		var shipdata = LZMA.lzma(shipbytes);
		var bin = "";
		for (i in 0...shipdata.length) {
			bin += (shipdata[i]?"1": "0");
		}
		trace(bin);
		trace(binToBytes(shipdata).toHex());
	}
}
