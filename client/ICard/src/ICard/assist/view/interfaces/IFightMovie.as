﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package ICard.assist.view.interfaces {
    import flash.display.*;
	

    public interface IFightMovie {
      function get content():MovieClip;
			function show(srcID:int,targets:Array,oldCards:Array,bEnemy:Boolean):void;
			function set onClose(_arg1:Function):void;
			function initFade(a1:float,a2:float,secNum:int):void;
	  }
}//package com.assist.view.interfaces 
