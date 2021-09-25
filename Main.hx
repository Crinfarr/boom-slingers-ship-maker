import sys.io.File;
import haxe.zip.Uncompress;
import haxe.io.Bytes;
import haxe.crypto.Base64;
import lzma.Lzma.LZMA;
import Sys;

class Main {
	public static function main() {
		var shipbytes = Base64.decode(Sys.args()[0].substr(19));
		var shipdata = LZMA.lzma(shipbytes);
		var bin = "";
		for (i in 0...shipdata.length) {
			bin += (shipdata[i]?"1": "0");
		}
		trace(bin);
	}
}
