﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package ICard.assist.data{
    import flash.display.*;

    public interface IBattleStage {
		function CardMenuFlag(realID:int):Object;
		function AskCard2FightSlot(realID:int):Boolean;
		function AskCard2ResSlot(realID:int):Boolean;
		function AskTurnCard(realID:int):Boolean;
    }
}//package com.assist.view.interfaces 