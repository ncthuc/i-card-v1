﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package ICard.views {
    import ICard.*;
    import ICard.assist.*;
    import ICard.assist.server.*;
    import ICard.assist.view.*;
    import ICard.assist.view.controls.BattleFieldType;
    import ICard.assist.view.interfaces.*;
    import ICard.datas.BattleGuyData;
    import ICard.datas.CardDiffData;
    import ICard.datas.card.*;
    import ICard.lang.client.com.views.*;
    import ICard.logic.*;
    import ICard.logic.BattleStage;
    import ICard.protocols.*;
    
    import com.smartfoxserver.v2.core.SFSEvent;
    
    import flash.display.MovieClip;
    import flash.events.*;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.net.*;
    import flash.utils.*;
    public class BattleFieldView extends Base implements IView {
		private var _updateFrameCardNotify:String = "frame_card_notify";
		private var _battleField:IBattleField;
		private var _cardDB:ICardDB;
		private var _battleStage:BattleStage;
		private static var _Inst:BattleFieldView;
		private var _priLoopTimer:Timer;
		public function show():void{
			loadAssets("battlefield", this.loadCallback, "");
			QueryNewGame();	
		}
		
		private function loadCallback():void
		{
			_battleStage = BattleStage.getInstance();
			_battleStage.settle(_data,this);
			_battleField = (_viewMgr.getAssetsObject("battlefield", "battleField") as IBattleField);
			_battleField.tip = _viewMgr.tip.iTip;
			_battleField.BattleStage = _battleStage;
			_battleField.onFight = _battleStage.DoQueryFight;
			this._cardDB = (_viewMgr.getAssetsObject("carddb", "carddb") as ICardDB);
			_viewMgr.addToFrameProcessList(this._updateFrameCardNotify, this.CardNotifyFrame);
			
			this.render();
		}
		
		private function CardNotifyFrame():void{
			var cardInfo:Array = CardDiffData.PopCard();
			if(cardInfo!=null)
			{
				var cardObj:CardData = (cardInfo[1] as CardData);
				var newCard:MovieClip = CreateCard(cardObj);
				var slotId:int = _battleStage.GetUISlot(cardObj.Info);
				_battleField.Add2Slot(slotId,newCard,cardObj.Info);
			}
		}
		
		private function fillBufIcon(cardMC:MovieClip,card:CardData):void{
			for(var i:int=0;i<CardData.MaxBufNum;i++){
				var bufId:int = card.getBuf(i);
				var buf:CardAbility = CardAbilityDB.getCardBuf(bufId);
				if(buf==null)
					continue;
				var bufMC:MovieClip = _cardDB.AddCardBuf(cardMC,AbilityHelper.getIconID(bufId));
				bufMC.tipInfo = cardTipHtml.CreateCardHtmlTip(buf.CardID);
			}
		}
		private function CreateCard(card:CardData,bTip:Boolean=true):MovieClip{
				var info:Object = card.Info;
				trace("create card",info["cardID"]);
				if(info["cardID"]==0)
					return null;
				var cardMC:MovieClip = _cardDB.CreateCard(info);
				if(info["cardID"]==20001)
				{
					var kk:int = 0;
				}
				fillBufIcon(cardMC,card);
				if(cardMC==null || bTip==false)
						return cardMC;
				cardMC.tipInfo = cardTipHtml.CreateCardHtmlTip(info["cardID"]);		
				if(info["side"]==1)
				{
			//		cardMC.scaleX = 0.5;
					cardMC.rotation = 90;
				}
				return cardMC;
		}
		private function render():void{
			if(this._battleField){
				_popup.addView(this, this._battleField.content);
			}
			//_viewMgr.fightMovie.show();
		}
		private function DoTurnCard(arg1:int):Boolean{
			return true;	
		}
		
		public function onPriPlayerFresh(myLoop:Boolean,secNum:int):void{
		
		}
		public function onCardExOp(card:int,ability:int):void{
			_viewMgr.worldNotice.showMessage("",0.8,"select");
			_battleField.onCardExOp(card,ability);
		}
		public function onResetPlayerLoop(myLoop:Boolean,secNum:int):void{
			_battleField.LoopFresh(myLoop,secNum/1000);
		}
		public function onPlayerLoopFresh(myLoop:Boolean,secNum:int):void{
			var iconName:String=(myLoop)?"I_turn":"u_turn";
			_viewMgr.worldNotice.showMessage("",0.8,iconName);
			_battleField.LoopFresh(myLoop,secNum/1000);
		}
		public function onPreShowAction(srcID:int,targetArr:Array,bEnemy:Boolean):void{
			_viewMgr.fightmovie.InitFade(1,1.1,2.8);
			_viewMgr.fightmovie.InitShow(srcID,targetArr,targetArr,bEnemy);
		}
		public function onCardFightResult(srcID:int,targets:Array,oldCards:Array,bEnemy:Boolean):void{
			_viewMgr.fightmovie.InitFade(0,1,2.8);
			_viewMgr.fightMovie.InitShow(srcID,targets,oldCards,bEnemy);
		}
		public function onEndOpOk():void{
			_battleField.onEndOpOk();
		}
		public function onPriPlayerLoop(IsTurn:Boolean,secNum:int,showRpsInfo:Boolean):void{
			if(_priLoopTimer!=null)
				_priLoopTimer.stop();
			
			var showPriLoop:* = function(evt:TimerEvent):void{
				var iconName:String=(IsTurn)?"I_rsp":"U_rsp";
				if(showRpsInfo==true)
					_viewMgr.worldNotice.showMessage("",0.6,iconName);
				_battleField.PriFresh(IsTurn,30);
				_priLoopTimer.removeEventListener(TimerEvent.TIMER, showPriLoop);
				_priLoopTimer.stop();
			}
			
			var delayInterval:int = secNum - 30*1000;
			_priLoopTimer =  new Timer(delayInterval,1);
			_priLoopTimer.addEventListener(TimerEvent.TIMER, showPriLoop);
			_priLoopTimer.start();
		}
		private function test():void{
			
			_battleStage.InitGuy(1,2,0);
			
			//_viewMgr.fightMovie.show();
			//_battleStage.InitGuy(1,2);
			
			_battleStage.PlayerLoopFresh(1,30);
			var card1:Object={playerID:1,realID:1,cardID:20001,slot:BattleFieldType.HeroSlotId};
			var card2:Object={playerID:1,realID:2,cardID:31001,slot:BattleFieldType.HandSlotId};
			var card3:Object={playerID:1,realID:2,cardID:31001,side:1,slot:BattleFieldType.EquipSlotId};
		//	_battleStage.onUpdateCard(card1);
		//	_battleStage.onUpdateCard(card2);
			
			_battleStage.onUpdateCard(card3);
			
			
			//var card2:Object={realID:1,cardID:20001,hp:22,atk:0,def:0,side:false,turn:false,slot:BattleFieldType.MyResourceSlotId};
			
			//_battleStage.UpdateCards(1,[card2]);
			
//			var c1:MovieClip = CreateCard(card1);
//			_battleField.Add2Slot(card1["slot"],c1);
			

		
//			var i:int;
//			while(i<4)
//			{
//				var strCardHtml:String = cardTipHtml.CreateCardHtmlTip(card1,cardTitle);
//				var c1:MovieClip = _cardDB.CreateCard(1,card1);
//				var card2:Array = CardType.GetCardInfo(20002);
//				var c2:MovieClip = _cardDB.CreateCard(1,card2);
//				var strCardHtml2:String = cardTipHtml.CreateCardHtmlTip(card2,cardTitle);
//				//_battleField.RunTest();
//				
//				//_viewMgr.tip.iTip.addFixedTarget(c1,strCardHtml,new Point(0,0),true);
//				c1.tipInfo = strCardHtml;
//				c2.tipInfo = strCardHtml2;
//				_battleField.Add2Slot(BattleFieldType.MyHandSlotId,c1);
//				_battleField.Add2Slot(BattleFieldType.MyHandSlotId,c2);
//				i++;
//			}
		
			
		}
		private function QueryNewGame():void{
			_data._Mod_Battle.QueryStartGame();
		}
		public function close():void{

		}
		public function clear():void{
		}
		
	}
}//package com.views 
