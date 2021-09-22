package lzma;

import haxe.crypto.BaseCode;
import haxe.io.BytesBuffer;
import haxe.io.Bytes;

class LZMA {
    public static function lzma(input:Bytes) {
        var bytes = [];
        for (b in 0...input.length) bytes.push(input.get(b));
        // init byte array

        var out = [];
        // create output array

        var prob = 1024;
        var bound:Int;
        trace('set prob to ${prob}');
        // set base value for probability

        var decoder = {
            range: Math.floor(4294967295),
            code: 0
        }
        bytes.shift();
        for (i in 1...4) {
            decoder.code = decoder.code << 8;               // i have no fucking
            decoder.code += bytes.shift();                 // clue what I'm doing
        }
        trace('set range to ${decoder.range} and code to ${decoder.code}');
        // set base values for range and code

        while (bytes.length != 0) {
            if (decoder.range < Math.pow(2, 24)) {
                decoder.range = decoder.range << 8;
                decoder.code = decoder.code << 8;
                //shift range and code 8 bits left

                decoder.code = (decoder.code & 0xFFFFFF00) + bytes.shift(); 
                //set the last 8 bits to the first 8 bits of the buffer
            }
            //normalize

            bound = Math.floor(decoder.range/2048)*prob;
            //evil bit level hacking I guess

            if (decoder.code < bound) {
                decoder.range = bound;
                prob += Math.floor((2048-prob)/Math.pow(2, 5));
                out.push(0);
            }
            else {
                decoder.range -= bound;
                decoder.code -= bound;
                prob -= Math.floor(prob/Math.pow(2, 5));
                out.push(1);
            }
        }
        return out;
    }
}