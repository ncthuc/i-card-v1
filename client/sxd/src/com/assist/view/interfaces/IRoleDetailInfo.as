﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package com.assist.view.interfaces {
    import flash.display.*;

    public interface IRoleDetailInfo {

        function get content():MovieClip;
        function set onClose(_arg1:Function):void;
        function set tip(_arg1:ITip):void;
        function set drag(_arg1:IDrag):void;
        function clear():void;
        function renderDetailInfo(_arg1:Object):void;
        function init():void;

    }
}//package com.assist.view.interfaces 
