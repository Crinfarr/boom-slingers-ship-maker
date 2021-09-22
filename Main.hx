import haxe.zip.Uncompress;
import haxe.zip.Compress;
import haxe.io.Bytes;
import haxe.crypto.Base64;
import Sys;

class Main {
    public static function main() {
        var shipbytes = Bytes.ofString(Sys.args()[0]);
        var ship64 = Base64.decode(Sys.args()[0]);
        var shipdata:Array<String> = [];
        trace('string stats: \n  Length: ${Sys.args()[0].length}\n\n');
        trace("Trying raw bytes...");
        for (byte in 0...shipbytes.length) {
            shipdata[byte] = StringTools.hex(shipbytes.get(byte));
        }
        trace("ship data: "+shipdata);
        trace ("data length: "+shipdata.length);
        try {
            shipbytes = Uncompress.run(shipbytes);
            trace("BZIP success, output: ");
            shipdata = [];
            for (byte in 0...shipbytes.length) {
                shipdata[byte] = StringTools.hex(shipbytes.get(byte));
            }
            trace(shipdata+"\n\n");
        }
        catch(error) {
            trace("BZIP failed\n\n");
        }

        trace("Trying base64 decoded bytes...");
        shipdata = [];
        for (byte in 0...ship64.length) {
            shipdata[byte] = StringTools.hex(ship64.get(byte));
        }
        trace("ship data: "+shipdata);
        trace ("data length: "+shipdata.length);
        try {
            ship64 = Uncompress.run(ship64);
            trace("BZIP success, output:");
            shipdata = [];
            for (byte in 0...ship64.length) {
                shipdata[byte] = StringTools.hex(ship64.get(byte));
            }
            trace(shipdata+"\n\n");
        }
        catch (err) {
            trace("BZIP failed\n\n");
        }

        trace("All tests finished");
    }
}