package lzma;

import cpp.UInt32;
import cpp.UInt16;
import haxe.io.BytesData;
import haxe.crypto.BaseCode;
import haxe.io.BytesBuffer;
import haxe.io.Bytes;

class LZMA {
    public static function lzma(input:Bytes):Array<Bool> {
        var bytes:BytesData = input.getData();
        bytes.shift();

        var prob:UInt = 0x400; // 0000 0000 0100 0000 0000, reset to 11 by prob&(0000 0000 0111 1111 1111) [2047] 

        var code:UInt = ((bytes.shift()<<24)+(bytes.shift()<<16)+(bytes.shift()<<8)+(bytes.shift()));
        //0000 0000 0000 0000 0000 0000 0000 0000
        //00 00 00 00
        //mask for last 8: 1111 1111 1111 1111 1111 1111 0000 0000
        //            hex: 0xffffff00
        var range:UInt = 0xffffffff;
        var bound:UInt;
        trace(code);
        trace(range);

        var output:Array<Bool> = [];
        while (bytes.length > 0) {
            if (range < (0x800000:UInt)) { //normalization
                range = range<<8;
                code = code<<8;

                code = (code&(0xffffff00:UInt)+bytes.shift());
            /**
             * 0xffffff00 = 
             *    1111 1111 1111 1111 1111 1111 0000 0000
             * bytes.shift() =>                 xxxx xxxx
             * sets least significant 8 figs to new byte 
             */
            }

            bound = Math.floor(range/0x800)*prob;

            if (code < bound) {
                range = bound;
                prob += Math.floor((0x800-prob)/0x10);
                output.push(false);
            }
            else {
                range -= bound;
                code -= bound;
                prob -= Math.floor(prob/0x10);
                output.push(true);
            }
        }
        return output;
    }
}