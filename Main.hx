import sys.io.File;
import haxe.zip.Uncompress;
import haxe.io.Bytes;
import haxe.crypto.Base64;
import lzma.Lzma.LZMA;
import Sys;

class Main {
	public static function main() {
		var shipbytes = Bytes.ofString(Sys.args()[0]);
		var ship64 = Base64.decode(Sys.args()[0]);
		var shipdata = [];

		trace('string stats: \n  Length: ${Sys.args()[0].length}\n\n');

		trace("Trying raw bytes...");

		for (byte in 0...shipbytes.length) {
			shipdata[byte] = StringTools.hex(shipbytes.get(byte));
		}
		trace("ship data: " + shipdata);
		trace("data length: " + shipdata.length);

		try {
			shipbytes = Uncompress.run(shipbytes);
			trace("BZIP success, output: ");
			shipdata = [];
			for (byte in 0...shipbytes.length) {
				shipdata[byte] = StringTools.hex(shipbytes.get(byte));
			}
			trace(shipdata + "\n\n");
		} catch (err) {
			trace("BZIP failed\n");
			trace(err);
		}

		trace("Trying base64 decoded bytes...");

		shipdata = [];
		for (byte in 0...ship64.length) {
			shipdata[byte] = StringTools.hex(ship64.get(byte));
		}
		trace("ship data: " + shipdata);
		trace("data length: " + shipdata.length);

		try {
			ship64 = Uncompress.run(ship64);
			trace("BZIP success, output:");
			shipdata = [];
			for (byte in 0...ship64.length) {
				shipdata[byte] = StringTools.hex(ship64.get(byte));
			}
			trace(shipdata + "\n\n");
		} catch (err) {
			trace("BZIP failed\n");
			trace(err + "\n\n");
		}
		try {
			var out = LZMA.lzma(ship64);
			trace("LZMA complete, output: "+out);
			var tuo=0;
			for (z in 0...out.length) {
				tuo += (out[z]==1?Math.floor(Math.pow(2, out.length-z)):0);
			}
			trace("as dec: "+tuo);
			trace("as hex: "+StringTools.hex(tuo));

		}
		catch (err) {
			trace("LZMA failed\n");
			trace(err+"\n\n");
		}

		trace("All tests finished");
	}
}
