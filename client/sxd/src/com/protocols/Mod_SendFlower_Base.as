﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package com.protocols {
    import com.haloer.utils.*;

    public class Mod_SendFlower_Base {

        public static const SUCCESS:int = 0;
        public static const FUN_OPENED:int = 1;
        public static const SAME_SEX:int = 2;
        public static const YES:int = 3;
        public static const NO:int = 4;
        public static const NOT_ENOUGH_INGOT:int = 5;
        public static const NOT_ENOUGH_COIN:int = 6;
        public static const SEND_SELF:int = 7;
        public static const player_send_flower_info:Object = {
            module:31,
            action:0,
            request:[Utils.IntUtil],
            response:[Utils.ByteUtil, Utils.IntUtil, Utils.StringUtil, Utils.IntUtil, Utils.IntUtil, Utils.StringUtil, Utils.IntUtil, Utils.IntUtil, Utils.ByteUtil, [Utils.IntUtil, Utils.StringUtil, Utils.IntUtil, Utils.IntUtil, Utils.IntUtil]]
        };
        public static const send_player_flower:Object = {
            module:31,
            action:1,
            request:[Utils.IntUtil, Utils.IntUtil],
            response:[Utils.ByteUtil]
        };
        public static const send_flower_ranking:Object = {
            module:31,
            action:2,
            request:[],
            response:[[Utils.IntUtil, Utils.StringUtil, Utils.IntUtil, Utils.IntUtil]]
        };
        public static const Actions:Array = ["player_send_flower_info", "send_player_flower", "send_flower_ranking"];

    }
}//package com.protocols 
