﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package com.views {
    import com.*;
    import com.assist.*;
    import com.assist.server.*;
    import com.assist.view.*;
    import com.assist.view.controls.*;
    import com.assist.view.info.*;
    import com.assist.view.interfaces.*;
    import com.assist.view.interfaces.map.*;
    import com.assist.view.pack.*;
    import com.assist.view.sound.*;
    import com.assist.view.toolbar.*;
    import com.haloer.data.*;
    import com.haloer.net.*;
    import com.lang.client.com.views.toolbar.*;
    import com.protocols.*;
    
    import flash.desktop.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class ToolbarView extends Base implements IView {

        private static var CleanUpgradeCdSign:String = "CleanUpgradeCd";

        private var _toolbar:IToolbar;
        private var _alert:IAlert;
        private var _firstInTown:Boolean = true;
        private var _soundMuteEnabled:Boolean = false;
        public var isBuy:Boolean = false;
        public var isCanBuy:Boolean = true;
        private var _travelEventEndTime:Number;
        public var travelEventCdTime:int;
        public var travelEventJoinCount:int;
        public var travelEventTotalCount:int;
        private var _lastTraceVisible:Boolean = true;
        private var _first:Boolean = true;
        private var _fateTipSprite:FateTipSprite;
        private var _soulTipSprite:SoulTipSprite;
        private var _isOpenFactionActivity:Boolean = false;
        public var showChatId:int = 0;
        private var _hasDeploy:Boolean = false;
        private var _hasFate:Boolean = false;
        private var _takeBibleData:Object = null;
        private var _robList:Array;
        private var _showMessageList:Array;
        private var thisAwardList:Array;
        private var _blockedHealth:Boolean = false;
        private var _oldPower:int = 0;
        private var _loadEffectCircle:Class;
        private var _miniMap:IMiniMap;
        private var _practiceTime:int = 0;
        private var _px:int = 0xFFFFFF;
        private var _py:int = 0xFFFFFF;

        public function ToolbarView(){
            this._robList = [];
            this._showMessageList = [];
            this.thisAwardList = [];
            super();
        }
        public function get width():Number{
            return (this._toolbar.content.width);
        }
        public function get height():Number{
            return (this._toolbar.content.height);
        }
        public function get content():Sprite{
            return (this._toolbar.content);
        }
        override public function get inStage():Boolean{
            return (((this._toolbar) && (this._toolbar.content.parent)));
        }
        public function init():void{
            this._toolbar = (_view.getAssetsObject("Toolbar", "Toolbar") as IToolbar);
            this._toolbar.tip = _view.tip.iTip;
            this._toolbar.goodsIconUrl = URI.goodsIconUrl;
            this._toolbar.addonsUrl = URI.addonsUrl;
            this._toolbar.init();
            this._toolbar.alert = _view.alert.iAlert;
            this._alert = _view.alert.iAlert;
            this.playerData();
            this.buffInfo();
            this.functionLink();
            this.activityInfo();
            this.initMiniMap();
            this.questTrace();
            this.chat();
            this.functionBar();
            this.keepAlive();
            this.friend();
            _view.addToPositionList(sign, this.reposition);
            this.autoPractice();
            _view.whatsNew.show();
            this.load_effect_circle();
            this.loadFunctionBarEffect();
            _view.addToFrameProcessList("ToolbarUpdateMouseCursor", this.updateMouseCursor);
        }
        private function updateMouseCursor():void{
            MouseCursor.updateCursorXY();
        }
        public function show():void{
            this._toolbar.content.visible = true;
        }
        public function hide():void{
            this._toolbar.content.visible = false;
        }
        public function close():void{
            this.clear();
            if (this._toolbar.content.parent){
                this._toolbar.content.parent.removeChild(this._toolbar.content);
            };
        }
        public function clear():void{
            _data.cancelPatch(Mod_Player_Base.receive_player_delay_notify_message);
            _data.cancelPatch(Mod_Notify_Base.mission_award);
            _data.cancelPatch(Mod_Notify_Base.pk_award);
            _data.cancelPatch(Mod_Friend_Base.notify_online_state);
            _data.cancelPatch(Mod_Friend_Base.notify_message_count);
            _data.cancelPatch(Mod_CampWar_Base.notify);
            _data.cancelPatch(Mod_HeroesWar_Base.notify);
            _data.cancelPatch(Mod_Notify_Base.role_num_notify);
            _data.cancelPatch(Mod_Notify_Base.new_research_notify);
            _data.cancelPatch(Mod_Notify_Base.new_partners_notify);
            this._toolbar.clear();
        }
        public function set playerDataVisible(_arg1:Boolean):void{
            this._toolbar.playerDataVisible = _arg1;
            this._toolbar.visibleBuff = _arg1;
        }
        public function set functionLinkVisible(_arg1:Boolean):void{
            this._toolbar.functionLinkVisible = _arg1;
        }
        public function reposition():void{
            if (this.inStage == true){
                this._toolbar.reposition(Structure.minStageWidth, Structure.minStageHeight, Structure.maxStageWidth, Structure.maxStageHeight, Structure.stageClip);
            };
            Tip.offset = Structure.stageOffset;
            _structure.reposition();
            _view.reposition();
            _view.achievementComplete.reposition(false);
            _view.activities.reposition(false);
            _view.alert.reposition();
            _view.chat.reposition(false);
            _view.delayMessage.reposition(false);
            _view.dujieWar.reposition(false);
            _view.factionWar.reposition(false);
            _view.fate.reposition(false);
            _view.factionWarMap.reposition(false);
            _view.friendMessage.reposition(false);
            _view.getPeachWar.reposition(false);
            _view.guide.reposition();
            _view.inCampWar.reposition(false);
            _view.initLoading.reposition(false);
            _view.lodge.reposition(false);
            _view.miniFactionWar.reposition(false);
            _view.missionMap.reposition(false);
            _view.missionFailedTips.reposition(false);
            _view.multiWar.reposition(false);
            _view.pkWar.reposition(false);
            _view.processTip.reposition(false);
            _view.sealSoul.reposition(false);
            _view.sendFlower.reposition(false);
            _view.sportWar.reposition(false);
            _view.superSport.reposition(false);
            _view.superSportWar.reposition(false);
            _view.takeBibleRoad.reposition(false);
            _view.takeBibleWar.reposition(false);
            _view.tip2.reposition();
            _view.towerWar.reposition(false);
            _view.townMap.reposition(false);
            _view.war.reposition(false);
            _view.world.reposition(false);
            _view.worldBossMap.reposition(false);
            _view.worldBossWar.reposition(false);
            _view.worldNotice.reposition(false);
            _view.rollCake.reposition(false);
            _view.factionRollCake.reposition(false);
            _view.zodiacWar.reposition(false);
            _view.studyStunt.reposition(false);
            _view.activitiesShow.reposition();
        }
        public function repositionInTown():void{
            if (((_view.townMap.inStage) && ((true == this._firstInTown)))){
                this._firstInTown = false;
                this.reposition();
            };
        }
        public function set vipLevel(_arg1:int):void{
            this._toolbar.vipLevel = _arg1;
        }
        public function checkRechargeVisible():void{
            this._toolbar.rechargeVisible = VIPType.enabled;
        }
        public function soundMute(_arg1:Boolean):void{
            this._toolbar.soundMute(_arg1);
            this._soundMuteEnabled = _arg1;
        }
        private function playerData():void{
            this.vipLevel = _ctrl.player.vipLevel;
            this._toolbar.onPlayerIcon = _view.roleMsg.switchSelf;
            this._toolbar.onAchievement = function ():void{
                _view.achievement.switchSelf();
            };
            var url:* = ((URI.avatarUrl + RoleType.getRoleSign(_ctrl.player.mainRoleId)) + ".swf");
            this._toolbar.loadPlayerAvatar(url);
            this._toolbar.onSoundControl = function ():void{
                if (_soundMuteEnabled){
                    _view.setting.openSound();
                } else {
                    _view.setting.closeSound();
                };
            };
            this._toolbar.onBuyPower = this.buy_power;
            this._toolbar.onPlayerIconOver = this.MainPlayerInfo;
            this.MainPlayerInfo();
            this._toolbar.onRecharge = _view.vip.switchSelf;
            this.checkRechargeVisible();
            this.updateCoins();
            this.updateIngot();
            this._toolbar.nickName = _ctrl.player.nickname;
            this.updateHealth();
            this.updatePower();
            this.updateLevel();
            this.initBuffer();
            this.rune();
        }
        public function buy_power():void{
            this.isBuy = true;
            _data.call(Mod_Player_Base.buy_power, this.buyPowerCallBack, []);
        }
        private function buyPowerCallBack():void{
            var _local1:Object = this._ctrl.player.buyPower;
            switch (_local1.msg){
                case Mod_Player_Base.NOT_ENOUGH_INGOT:
                    _view.showTip(playerDataLang.NoIngot);
                    this.isCanBuy = false;
                    break;
                case Mod_Player_Base.FULL_BUY_TIMES:
                    _view.showTip(playerDataLang.NoPowerCount);
                    this.isCanBuy = false;
                    break;
                case Mod_Player_Base.SUCCESS:
                    this._toolbar.powerInfo = _local1;
                    this.isCanBuy = true;
                    this._view.missionPractice.getLostPowerNum = _local1.buyNum;
                    this._view.heroPractice.getLostPowerNum = _local1.buyNum;
                    break;
            };
            this.isBuy = false;
        }
        private function MainPlayerInfo():void{
            _data.call(Mod_Player_Base.player_info_contrast, this.PlayerInfoContrastCallBack, [this._ctrl.player.playerId], false);
        }
        private function PlayerInfoContrastCallBack():void{
            var _local1:Object = this._ctrl.player.playerInfoContrastData;
            var _local2:Boolean = this.isShowPlayerInfo;
            if (_local2 == false){
                this._toolbar.PlayerInfo = "";
                return;
            };
            var _local3:String = "";
            if (ActivityType.FactionLevel >= 1){
                _local3 = ((playerDataLang.FactionName + _local1.factionName) + "\n");
            };
            var _local4:String = (((((((((((((((((((((((playerDataLang.RankIng + _local1.rankIng) + "\n") + _local3) + playerDataLang.Combat) + _local1.combat) + "\n") + playerDataLang.Fame) + _local1.fame) + "\n") + playerDataLang.Skill) + _local1.skill) + "\n") + playerDataLang.AchievmentPoints) + _local1.achievmentPoints) + "\n") + playerDataLang.FirstAttack) + _local1.firstAttack) + "\n") + playerDataLang.StatePoint) + _local1.statePoint) + "\n") + playerDataLang.FlowerCount) + _local1.flowerCount);
            this._toolbar.PlayerInfo = (("<font color=\"#ffffff\">" + _local4) + "</font>");
        }
        public function get isShowPlayerInfo():Boolean{
            var _local1:Array = this._ctrl.mission.renderTownMission(TownType.getId(TownType.LiShuShan));
            var _local2:Object = _local1[0];
            var _local3:Boolean = (this._ctrl.player.missionKey >= _local2.lock);
            return (_local3);
        }
        private function rune():void{
            this.runeVisible = false;
            this._toolbar.onOpenRune = _view.rune.switchSelf;
        }
        public function set runeVisible(_arg1:Boolean):void{
            this._toolbar.runeVisible = _arg1;
        }
        public function set showBuff(_arg1:Object):void{
            this._toolbar.addBuff = _arg1;
        }
        public function set removeBuff(_arg1:String):void{
            this._toolbar.removeBuff = _arg1;
        }
        public function set visbleBuff(_arg1:Boolean):void{
            this._toolbar.visibleBuff = _arg1;
        }
        private function buffInfo():void{
            this._toolbar.onDoubleRemoveBuff = function (_arg1:String):void{
                if (_arg1 == BufferType.Mounts){
                    _data.call(Mod_Item_Base.dismount_transport, null, []);
                } else {
                    if (_arg1 == BufferType.Avatar){
                        _data.call(Mod_Item_Base.avatar_card_off, null, []);
                    };
                };
            };
        }
        private function updateExtraPower():void{
            var _local1:int = this._ctrl.player.extraPower;
            var _local2:int = this._ctrl.player.maxExtraPower;
            if (_local1 <= 0){
                this.removeBuff = BufferType.ExtraPower;
            } else {
                this.showBuff = {
                    type:BufferType.ExtraPower,
                    doubleClickable:false,
                    sign:BufferType.ExtraPower,
                    name:buffInfoLang.PowerName,
                    effect:Lang.sprintf(buffInfoLang.Powereffect, _local1),
                    info:buffInfoLang.PowerInfo
                };
            };
        }
        private function updateMountsBuffer():void{
            var _local2:Object;
            var _local1:int = this._ctrl.player.mounts;
            if (_local1 == 0){
                this.removeBuff = BufferType.Mounts;
            } else {
                if (BufferType.MountsSign.length == 0){
                    BufferType.MountsSign[32] = "Cloud";
                    BufferType.MountsSign[1055] = "BaiHu";
                    BufferType.MountsSign[1008] = "FeiJian";
                    BufferType.MountsSign[1094] = "LiuGuangXiangYun";
                    BufferType.MountsSign[1177] = "JinYu";
                    BufferType.MountsSign[1192] = "HuLu";
                    BufferType.MountsSign[1195] = "HuLu2";
                    BufferType.MountsSign[1196] = "FengLeiYi";
                };
                _local2 = {};
                _local2.doubleClickable = true;
                _local2.type = BufferType.Mounts;
                _local2.sign = ((BufferType.MountsSign[_local1]) || ("Cloud"));
                _local2.name = ItemType.getName(_local1);
                _local2.info = buffInfoLang.ClickCancel;
                _local2.effect = ItemType.getDescription(_local1);
                this.showBuff = _local2;
            };
        }
        private function updateAvatarBuffer():void{
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:String;
            var _local7:Object;
            var _local1:int = this._ctrl.player.avatar;
            var _local2:int = ((this._ctrl.player.avatarCD - getTimer()) * 0.001);
            if ((_local2 < 0)){
                _local2 = 0;
            };
            if (_local1 == 0){
                this.removeBuff = BufferType.Avatar;
                this._view.removeFromTimerProcessList(BufferType.Avatar);
            } else {
                _local3 = int((_local2 / 3600));
                _local4 = (int((_local2 / 60)) % 60);
                _local5 = (_local2 % 60);
                _local6 = buffInfoLang.RemainingTime;
                if (_local3 > 0){
                    _local6 = (_local6 + (_local3 + buffInfoLang.Hours));
                };
                if (_local4 > 0){
                    _local6 = (_local6 + (_local4 + buffInfoLang.Minute));
                };
                _local6 = (_local6 + (_local5 + buffInfoLang.Second));
                if (BufferType.AvatarSign.length == 0){
                    BufferType.AvatarSign[1273] = "QingRenJieZhiYi";
                };
                _local7 = {};
                _local7.doubleClickable = true;
                _local7.type = BufferType.Avatar;
                _local7.sign = ((BufferType.AvatarSign[_local1]) || (BufferType.Avatar));
                _local7.name = ItemType.getName(_local1);
                _local7.info = ((_local6 + "\n") + buffInfoLang.ClickCancel);
                _local7.effect = ItemType.getDescription(_local1);
                this.showBuff = _local7;
                this._view.addToTimerProcessList(BufferType.Avatar, this.updateAvatarBuffer);
            };
        }
        public function updateFactionBlessing(_arg1:Object):void{
            if (_arg1["count"] <= 0){
                this.removeBuff = BufferType.FactionBlessing;
                return;
            };
            this.showBuff = {
                type:BufferType.FactionBlessing,
                doubleClickable:false,
                sign:BufferType.FactionBlessing,
                name:buffInfoLang.FactionBlessingName,
                effect:Lang.sprintf(buffInfoLang.FactionBlessingEffect, HtmlText.green(_arg1["count"])),
                info:Lang.sprintf(buffInfoLang.FactionBlessingInfo, HtmlText.green((("+" + _arg1["coin_add"]) + "%")))
            };
        }
        public function updateMarsBlessing(_arg1:Object):void{
            if (_arg1["count"] <= 0){
                this.removeBuff = BufferType.MarsBlessing;
                return;
            };
            this.showBuff = {
                type:BufferType.MarsBlessing,
                doubleClickable:false,
                sign:BufferType.MarsBlessing,
                name:buffInfoLang.MarsBlessingName,
                effect:Lang.sprintf(buffInfoLang.MarsBlessingEffect, HtmlText.green(_arg1["count"])),
                info:Lang.sprintf(buffInfoLang.MarsBlessingInfo, HtmlText.green((("+" + _arg1["exp_add"]) + "%")))
            };
        }
        public function updateCampWarInspire(_arg1:int):void{
            if (_arg1 <= 0){
                this.removeBuff = BufferType.CampWarInspire;
                return;
            };
            this.showBuff = {
                type:BufferType.CampWarInspire,
                doubleClickable:false,
                sign:BufferType.CampWarInspire,
                name:buffInfoLang.WarName,
                effect:Lang.sprintf(buffInfoLang.WarEffect, _arg1),
                info:buffInfoLang.WarInfo
            };
        }
        private function initBuffer():void{
            this.updateMountsBuffer();
            this.updateAvatarBuffer();
            this.updateExtraPower();
            this._view.factionBlessing.getBlessingCount();
            this._data.call(Mod_Player_Base.update_player_data, null, [Mod_Player_Base.PLAYER_INIT_MEDICAL]);
            this._data.call(Mod_Player_Base.update_player_data, null, [Mod_Player_Base.PLAYER_MEDICAL]);
            this._data.call(Mod_Player_Base.update_player_data, null, [Mod_Player_Base.CAN_INCENSE_COUNT]);
        }
        public function updateWorldBossInspireBuffer(_arg1:int, _arg2:String):void{
            if (_arg1 <= 0){
                this.removeBuff = _arg2;
                return;
            };
            this.showBuff = {
                type:_arg2,
                doubleClickable:false,
                sign:BufferType.WorldBossInspire,
                name:buffInfoLang.WarName,
                effect:Lang.sprintf(buffInfoLang.WarEffect, _arg1),
                info:buffInfoLang.WarInfo
            };
        }
        public function renderFunctionLink(_arg1:Object):void{
            this._toolbar.renderFunctionLink(_arg1);
        }
        public function renderFunctionLinkBtnTip(_arg1:String, _arg2:String):void{
            this._toolbar.renderFunctionLinkBtnTip(_arg1, _arg2);
        }
        public function renderFunctionTextTip(_arg1:String, _arg2:String):void{
            this._toolbar.renderFunctionTextTip(_arg1, _arg2);
        }
        private function functionLink():void{
            this._toolbar.onLinkTextClick = this.onLinkTextClick;
            this._toolbar.onLinkBtnClick = this.onLinkBtnClick;
            _view.addToTimerProcessList((sign + Math.random()), this.functionLinkTimer);
        }
        private function functionLinkTimer():void{
            this.travelEventCdTime = Math.ceil(((this._travelEventEndTime - new Date().time) / 1000));
            if (this.travelEventCdTime > 0){
                if ((this.travelEventCdTime % 60) == 0){
                    this.renderTravelEventTip(Math.ceil((this.travelEventCdTime / 60)));
                };
            } else {
                this.travelEventCdTime = 0;
            };
            this.renderTravelEventLink(this.travelEventCdTime);
            this.setFunctionLinkPoint();
        }
        private function onLinkTextClick(_arg1:String):void{
            switch (_arg1){
                case FunctionType.Farm:
                    _view.farm.switchSelf();
                    break;
                case FunctionType.MultiMission:
                    if (_view.multiMission.inStage){
                        _view.multiMission.clear();
                    } else {
                        _view.multiMission.show();
                    };
                    break;
                case FunctionType.TravelEvent:
                    if (this.travelEventJoinCount >= this.travelEventTotalCount){
                        _view.showTip(functionLinkLang.CountUsed);
                        return;
                    };
                    if (this.travelEventCdTime > 0){
                        _view.travelEvent.cancelCd();
                        return;
                    };
                    _view.travelEvent.switchSelf();
                    break;
            };
        }
        private function onLinkBtnClick(_arg1:String):void{
            switch (_arg1){
                case FunctionType.TravelEvent:
                    _view.travelEvent.cancelCd();
                    break;
            };
        }
        public function clearFunctionLink():void{
            this._toolbar.clearFunctionLink();
            (this.travelEventCdTime = 0);
        }
        public function removeFunctionLink(_arg1:String):void{
            this._toolbar.removeFunctionLink(_arg1);
        }
        private function getFunctionLink(_arg1:String):void{
            switch (_arg1){
                case FunctionType.Farm:
                    _view.farm.getFarmState();
                    break;
                case FunctionType.TravelEvent:
                    _view.travelEvent.get_activity_info();
                    break;
            };
        }
        public function showFunctionLink():void{
            if (FunctionType.isOpened(FunctionType.TravelEvent)){
                this.getFunctionLink(FunctionType.TravelEvent);
            };
            if (FunctionType.isOpened(FunctionType.Farm)){
                this.getFunctionLink(FunctionType.Farm);
            };
            setTimeout(this.setFunctionLinkPoint, 1000);
            setTimeout(this.setFunctionLinkPoint, 2000);
        }
        public function setFunctionLinkPoint():void{
            this._toolbar.setFunctionLinkPoint();
        }
        private function getFunctionLinkIndex(_arg1:String):int{
            var _local2:int;
            switch (_arg1){
                case FunctionType.TravelEvent:
                    _local2 = 4;
                    _local2;
                    break;
                case FunctionType.Farm:
                    _local2 = 5;
                    _local2;
                    break;
                case FunctionType.MultiMission:
                    _local2 = 6;
                    _local2;
                    break;
                case ActivityType.FactionSeal:
                    _local2 = 7;
                    _local2;
                    break;
            };
            return (_local2);
        }
        public function set travelEventEndTime(_arg1:Number):void{
            (this._travelEventEndTime = _arg1);
        }
        public function renderTravelEventLink(_arg1:int):void{
            if (!FunctionType.isOpened(FunctionType.TravelEvent)){
                return;
            };
            var _local2:uint = ((((this.travelEventJoinCount == this.travelEventTotalCount)) || ((_arg1 > 0)))) ? 0xFFFFFF : 0xFF00;
            var _local3:Object = {
                sign:FunctionType.TravelEvent,
                timeText:((_arg1 == 0)) ? "" : DateTime.formatFromSecond(_arg1),
                stopText:htmlFormat((((((functionLinkLang.TravelEvent + "(") + this.travelEventJoinCount) + "/") + this.travelEventTotalCount) + ")"), 12, _local2, false, true),
                runText:htmlFormat(functionLinkLang.InTravelCd, 12, _local2),
                index:this.getFunctionLinkIndex(FunctionType.TravelEvent),
                time:_arg1
            };
            this.renderFunctionLink(_local3);
        }
        public function renderTravelEventTip(_arg1:int):void{
            this._view.toolbar.renderFunctionLinkBtnTip(FunctionType.TravelEvent, HtmlText.orange(Lang.sprintf(functionLinkLang.ClearCd, _arg1)));
        }
        public function setFarmLink(_arg1:int, _arg2:int):void{
            this.renderFarmLink(_arg1, _arg2);
        }
        private function renderFarmLink(_arg1:int, _arg2:int):void{
            if (!FunctionType.isOpened(FunctionType.Farm)){
                return;
            };
            var _local3:uint = ((_arg1 < _arg2)) ? 0xFF00 : 0xFFFFFF;
            var _local4:Object = {
                sign:FunctionType.Farm,
                timeText:"",
                stopText:htmlFormat((((((functionLinkLang.Farm + "(") + _arg1) + "/") + _arg2) + ")"), 12, _local3, false, true),
                runText:"",
                index:this.getFunctionLinkIndex(FunctionType.Farm),
                time:0
            };
            this.renderFunctionLink(_local4);
        }
        public function renderMultMissionLink(_arg1:String):void{
            if (!FunctionType.isOpened(FunctionType.MultiMission)){
                return;
            };
            this.renderFunctionLink({
                sign:FunctionType.MultiMission,
                timeText:"",
                stopText:_arg1,
                runText:"",
                index:this.getFunctionLinkIndex(FunctionType.MultiMission),
                time:0
            });
            this.setFunctionLinkPoint();
        }
        public function renderFactionSealLink(_arg1:Boolean, _arg2:int, _arg3:int):void{
            if (!FunctionType.isOpened(FunctionType.Faction)){
                return;
            };
            var _local4:uint = ((_arg2 < _arg3)) ? 0xFF00 : 0xFFFFFF;
            var _local5:String = (_arg1) ? htmlFormat((((((functionLinkLang.FactionSeal + "(") + _arg2) + "/") + _arg3) + ")"), 12, _local4, false, true) : "";
            var _local6:Object = {
                sign:ActivityType.FactionSeal,
                timeText:"",
                stopText:_local5,
                runText:"",
                index:this.getFunctionLinkIndex(FunctionType.MultiMission),
                time:0
            };
            this.renderFunctionLink(_local6);
        }
        public function set questTraceVisible(_arg1:Boolean):void{
            (this._toolbar.questTraceVisible = _arg1);
            (this._lastTraceVisible = _arg1);
        }
        public function get questTraceVisible():Boolean{
            return (this._toolbar.questTraceVisible);
        }
        private function set tempTraceVisible(_arg1:Boolean):void{
            (this._toolbar.questTraceVisible = _arg1);
        }
        private function restoreTraceVisible():void{
            (this._toolbar.questTraceVisible = this._lastTraceVisible);
        }
        public function set questTraceTipVisible(_arg1:Boolean):void{
            (this._toolbar.questTraceTipVisible = _arg1);
        }
        private function questTrace():void{
            (this.questTraceVisible = true);
            (this._toolbar.questTraceLink = function (_arg1:String):void{
                if (_view.campWar.inStageWithTip){
                    return;
                };
                if (_view.heroesWar.inStageWithTip){
                    return;
                };
                if (_view.multiMission.isMinimumWithTip){
                    return;
                };
                if (_view.zodiac.inStageWithTip){
                    return;
                };
                _view.guide.hideAlongGuide();
                _view.quest.wayFinding(_arg1);
            });
        }
        public function get questTraceContent():Sprite{
            return (this._toolbar.questTraceContent);
        }
        public function loadQuestTrace():void{
            _data.call(Mod_Quest_Base.town_quest_show, this.renderQuestTrace, []);
        }
        public function renderQuestTrace():void{
            if (_ctrl.quest.townQuestData == null){
                return;
            };
            this._toolbar.renderQuestTrace(_ctrl.quest.townQuest);
            this.renderQuestStatus();
        }
        private function renderQuestStatus():void{
            var _local1:Object = _ctrl.quest.relatedNPC;
            _view.townMap.resetNPCHead(_local1);
            _view.guide.open();
            (this.questTraceVisible = true);
            (this.questTraceTipVisible = _view.townMap.inStage);
            if (((this.questTraceVisible) && (_ctrl.quest.hasMasterCompleted))){
                _view.quest.haltWayFinding(true);
            };
        }
        public function loadQuestTraceInTown():void{
            if (true == this._first){
                (this._first = false);
                this.loadQuestTrace();
            } else {
                this.renderQuestStatus();
            };
        }
        private function chat():void{
            this._view.chat.show();
        }
        public function set chatVisible(_arg1:Boolean):void{
            (this._view.chat.chatVisible = _arg1);
        }
        public function receiveTown(_arg1:String, _arg2:Boolean=true, _arg3:int=99):void{
            this._view.chat.receive(_arg1, _arg2, _arg3);
        }
        public function onTextLink(_arg1:*):void{
            var _local6:int;
            var _local7:int;
            var _local8:int;
            var _local9:int;
            var _local10:int;
            var _local11:int;
            var _local12:int;
            var _local13:int;
            var _local14:int;
            var _local2:String = ((_arg1 is TextEvent)) ? _arg1.text : String(_arg1);
            var _local3:Array = _local2.split("_");
            var _local4:String = _local3[0];
            var _local5:int = _local3[1];
            switch (_local4){
                case TextLinkType.Player:
                    setTimeout(this.showPlayerInfo, 50, _local5, String(_local3[2]), ((_local3[3]) || ("")));
                    break;
                case TextLinkType.Item:
                    setTimeout(this.showItemInfo, 50, int(_local3[1]), int(_local3[2]), int(_local3[3]), int(_local3[4]), _local3[5]);
                    break;
                case TextLinkType.SeeMsg:
                    this._view.otherRoleMsg.init(_local5, _local3[2]);
                    this._view.otherRoleMsg.show();
                    break;
                case TextLinkType.AddFocus:
                    this._view.friendList.addFriend("", _local5);
                    break;
                case TextLinkType.Fate:
                    _local6 = _local3[1];
                    setTimeout(this.showFateInfo, 50, _local6);
                    break;
                case TextLinkType.ViewReport:
                    this._view.war.formatReportUrl(_local3.slice(1));
                    break;
                case TextLinkType.Gag:
                    this._view.chat.disableTalkPlayer(_local5, _local3[2]);
                    break;
                case TextLinkType.Shield:
                    this._view.chat.isShieldPlayerTalk(_local5, _local3[2]);
                    break;
                case TextLinkType.PM:
                    this._view.friendChat.get_friendinfo_chatrecord_list(_local5);
                    break;
                case TextLinkType.PK:
                    if (this._view.factionWarMap.inStageWithTip){
                        return;
                    };
                    (this._view.pkWar.defenderPlayerId = _local5);
                    this._view.pkWar.show();
                    break;
                case TextLinkType.CopyName:
                    Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _local3[2]);
                    this._view.showTip(Lang.sprintf(chatLang.CopySuccess, _local3[2]), "", TipType.Success);
                    break;
                case TextLinkType.SendFlower:
                    (this._view.sendFlower.sendPlayerID = _local5);
                    this._view.sendFlower.show();
                    break;
                case TextLinkType.soul:
                    _local7 = _local3[1];
                    _local8 = _local3[2];
                    _local9 = _local3[3];
                    _local10 = _local3[4];
                    _local11 = _local3[5];
                    _local12 = _local3[6];
                    _local13 = _local3[7];
                    setTimeout(this.showSoulInfo, 50, _local7, _local8, _local9, _local10, _local11, _local12, _local13);
                    break;
                case TextLinkType.Achievement:
                    _local14 = _local3[1];
                    this._view.achievement.gotoAchievementLabel(_local14);
            };
        }
        private function showPlayerInfo(_arg1:int, _arg2:String, _arg3:String):void{
            if (_arg1 == this._ctrl.player.playerId){
                return;
            };
            var _local4:Array = [chatLang.CopyData];
            var _local5:Array = [[TextLinkType.SeeMsg, _arg1].join("_")];
            if (FunctionType.isOpened(FunctionType.Friend)){
                _local4.push(chatLang.AddAttention, chatLang.SendTalk);
                _local5.push([TextLinkType.AddFocus, _arg1, _arg2].join("_"), [TextLinkType.PM, _arg1, _arg2].join("_"));
            };
            if (this._ctrl.player.isAdvancedTester == true){
                _local4.push(chatLang.Gag);
                _local5.push([TextLinkType.Gag, _arg1, _arg2].join("_"));
            };
            _local4.push(chatLang.ShieldTalk, chatLang.CopyName);
            _local5.push([TextLinkType.Shield, _arg1, _arg2].join("_"), [TextLinkType.CopyName, _arg1, _arg2].join("_"));
            if (FunctionType.isOpened(FunctionType.SendFlower)){
                _local4.push(chatLang.SendFlower);
                _local5.push([TextLinkType.SendFlower, _arg1, _arg2].join("_"));
            };
            var _local6:ClickTipList = new ClickTipList(_local4, _local5, this.onTextLink);
            this._view.tip.iTip.clickToOpen(_local6);
        }
        private function showItemInfo(_arg1:int, _arg2:int, _arg3:int, _arg4:int, _arg5:String):void{
            var _local6:ItemInfo = new ItemInfo();
            _local6.parseSee(_arg1, _arg2, _arg4);
            (_local6.playerItemId = _arg3);
            _arg5 = ((_arg5) || (""));
            _arg5;
            var _local7:Sprite = _local6.getTipsSprite1("", ((_arg5)=="") ? "" : (chatLang.Owner + _arg5));
            this._view.tip.iTip.clickToOpen(_local7);
        }
        private function showFateInfo(_arg1:int):void{
            if (this._fateTipSprite == null){
                (this._fateTipSprite = new FateTipSprite());
                (this._fateTipSprite.tip = this._view.tip.iTip);
            };
            (this._fateTipSprite.getFateId = _arg1);
            (this._fateTipSprite.target = this._toolbar.content);
        }
        private function showSoulInfo(_arg1:int, _arg2:int, _arg3:int, _arg4:int, _arg5:int, _arg6:int, _arg7:int):void{
            var _local17:int;
            var _local18:int;
            var _local19:int;
            var _local8:String = SoulType.getSoulName(_arg1);
            var _local9:int = SoulType.getSoulQualityId(_arg1);
            var _local10:uint = SoulType.getQualityColor(_local9);
            var _local11:int = SoulType.getSoulSubTypeId(_arg1);
            var _local12:int = SoulType.getSoulTypeIdByAllTypeId(_local11);
            var _local13:String = SoulType.getJobNameToTypeId(_local12);
            var _local14:String = URI.getSoulsIconUrl(_arg1);
            var _local15:String = "";
            var _local16:Object = {};
            if (this._soulTipSprite == null){
                (this._soulTipSprite = new SoulTipSprite());
            } else {
                (this._soulTipSprite.ischange = true);
            };
            (this._soulTipSprite.iconUrl = _local14);
            (this._soulTipSprite.star1 = 0);
            (this._soulTipSprite.star2 = 0);
            (this._soulTipSprite.star3 = 0);
            if (_arg2 != 0){
                _local16 = this._ctrl.sealSoul.renderLocationList(_arg2, _local9, _arg5);
                _local16;
                _local15 = (_local15 + (HtmlText.format(((_local16.name + " +") + _local16.valueInfo), _local16.color) + "\n"));
                _local15;
                _local17 = SoulType.getQualityForIDValue(_arg2, _local9, _arg5);
                (this._soulTipSprite.star1 = _local17);
            };
            if (_arg3 != 0){
                _local16 = this._ctrl.sealSoul.renderLocationList(_arg3, _local9, _arg6);
                _local16;
                _local15 = (_local15 + (HtmlText.format(((_local16.name + " +") + _local16.valueInfo), _local16.color) + "\n"));
                _local15;
                _local18 = SoulType.getQualityForIDValue(_arg3, _local9, _arg6);
                (this._soulTipSprite.star2 = _local18);
            };
            if (_arg4 != 0){
                _local16 = this._ctrl.sealSoul.renderLocationList(_arg4, _local9, _arg7);
                _local16;
                _local15 = (_local15 + (HtmlText.format(((_local16.name + " +") + _local16.valueInfo), _local16.color) + "\n"));
                _local15;
                _local19 = SoulType.getQualityForIDValue(_arg4, _local9, _arg7);
                (this._soulTipSprite.star3 = _local19);
            };
            (this._soulTipSprite.nameHtml = HtmlText.format(_local8, _local10));
            (this._soulTipSprite.desHtml = "");
            (this._soulTipSprite.addHtml = _local15);
            this._view.tip.iTip.clickToOpen(this._soulTipSprite);
        }
        private function functionBar():void{
            (this._toolbar.onBody = function ():void{
                SoundEffect.play(SoundEffect.Button);
                _view.roleMsg.switchSelf();
            });
            (this._toolbar.onPack = function ():void{
                SoundEffect.play(SoundEffect.Button);
                _view.pack.switchSelf();
            });
            (this._toolbar.onUpgrade = function ():void{
                SoundEffect.play(SoundEffect.Button);
                _view.upgrade.switchSelf();
            });
            (this._toolbar.onDeploy = function ():void{
                SoundEffect.play(SoundEffect.Button);
                _view.superDeploy.switchSelf();
            });
            (this._toolbar.onResearch = function ():void{
                SoundEffect.play(SoundEffect.Button);
                _view.research.switchSelf();
            });
            (this._toolbar.onFate = function ():void{
                SoundEffect.play(SoundEffect.Button);
                _view.fate.switchSelf();
            });
            (this._toolbar.onSealSoul = function ():void{
                SoundEffect.play(SoundEffect.Button);
                _view.sealSoul.switchSelf();
            });
            (this._toolbar.onStudyStunt = function ():void{
                SoundEffect.play(SoundEffect.Button);
                _view.studyStunt.switchSelf();
            });
            (this._toolbar.onQuest = function ():void{
                SoundEffect.play(SoundEffect.Button);
                _view.quest.switchSelf();
            });
            (this._toolbar.onPetAnimal = function ():void{
                SoundEffect.play(SoundEffect.Button);
                _view.pet.switchSelf();
            });
            (this._toolbar.onFriend = function ():void{
                SoundEffect.play(SoundEffect.Button);
                if (_view.friendMessage.isShowMostBox){
                    _view.friendMessage.clear();
                } else {
                    _view.friendMessage.message_box_list();
                };
            });
            (this._toolbar.onFaction = function ():void{
                SoundEffect.play(SoundEffect.Button);
                _view.myFaction.switchSelf();
            });
            (this._toolbar.onPractice = function ():void{
                SoundEffect.play(SoundEffect.Button);
                switchPractice();
            });
            this.renderFunctionBar();
            this.bubble();
            this.updateExperience();
        }
        public function set functionBarParent(_arg1:Sprite):void{
            (this._toolbar.functionBarParent = _arg1);
        }
        public function switchPractice():void{
            if (this._ctrl.player.playerInfo.practice == Mod_Town_Base.ON_PRACTICE){
                this.closePractice();
            } else {
                if (this._view.factionWarMap.isFactionWarStart == true){
                    return;
                };
                this.startPractice();
            };
        }
        private function renderFunctionBar():void{
            this._toolbar.newFunctionBar(FunctionType.DefaultList, FunctionType.DefaultList);
            this.get_player_function();
        }
        private function get_player_function():void{
            this._data.call(Mod_Player_Base.get_player_function, this.getPlayerFunctionCallback, []);
        }
        private function getPlayerFunctionCallback(_arg1:Boolean=false):void{
            var downOldList:* = null;
            var downNewList:* = null;
            var sign:* = null;
            var index:* = 0;
            var newAddedIds:* = null;
            var newAddedSigns:* = null;
            var item:* = null;
            var id:* = null;
            var trigger:Boolean = _arg1;
            var list:* = this._ctrl.player.functionList;
            var upList:* = [];
            downOldList = [];
            downNewList = [];
            this.checkHasManual(list);
            FunctionType.updateOpenedList(list);
            for each (var _local5:* in FunctionType.DefaultList) {
                sign = _local5;
                _local5;
                _local5 = FunctionType.functionIndex(sign);
                index = _local5;
                _local5;
                (downOldList[index] = sign);
                (downNewList[index] = sign);
            };
            newAddedIds = [];
            newAddedSigns = [];
            for each (_local5 in list) {
                item = _local5;
                _local5;
                _local5 = FunctionType.sign(item["id"]);
                sign = _local5;
                _local5;
                _local5 = FunctionType.functionIndex(sign);
                index = _local5;
                _local5;
                if ((((false == trigger)) && (((this.isDeploy(sign)) || (this.isFate(sign)))))){
                } else {
                    if (index > -1){
                        if (1 == item["isPlayed"]){
                            (downOldList[index] = sign);
                        };
                        (downNewList[index] = sign);
                    } else {
                        upList.push(sign);
                    };
                    if (0 == item["isPlayed"]){
                        (item["isPlayed"] = 1);
                        newAddedIds.push(item["id"]);
                        if ((((sign == FunctionType.Robot)) && ((VIPType.check(VIPType.Level5) == false)))){
                        } else {
                            if (FunctionType.isIgnoreTip(sign) == false){
                                if (index == -1){
                                    newAddedSigns.push(sign);
                                } else {
                                    newAddedSigns.unshift(sign);
                                };
                            };
                        };
                    };
                };
            };
            this.removeUndefined(downOldList);
            this.removeUndefined(downNewList);
            this._toolbar.newFunctionBar(downOldList, downOldList);
            if (newAddedSigns.length > 0){
                if (downNewList.length > downOldList.length){
                    (_view.triggerFunction.onStart = function ():void{
                        _toolbar.newFunctionBar(downOldList, downNewList);
                        (_view.triggerFunction.onStart = null);
                    });
                    (this._toolbar.onEnd = function ():void{
                        _toolbar.updatePackMessageXY();
                        _view.guide.stopPartnersGuide();
                        _view.guide.startUpgradeGuides();
                        _view.guide.startFateLodgeGuide();
                    });
                };
                _view.triggerFunction.triggerList(newAddedSigns);
                _view.triggerFunction.switchSelf();
            };
            this.updateFunction();
            this.openOtherFunction(upList);
            for each (_local5 in newAddedIds) {
                id = _local5;
                _local5;
                this._data.call(Mod_Player_Base.sign_play_player_function, null, [parseInt(id)]);
                switch (FunctionType.sign(parseInt(id))){
                    case FunctionType.LuckyShop:
                        _view.processTip.open(ProcessTipsType.LuckyShop);
                        break;
                };
            };
        }
        private function updateFunction():void{
            this.showFunctionLink();
            this._toolbar.updatePackMessageXY();
            _view.chat.chatOpenFunction();
            if (FunctionType.isOpened(FunctionType.Friend)){
                this._data.patch(Mod_Friend_Base.get_unreceive_friend_list, this.unreceiveMsg);
                this._data.call(Mod_Friend_Base.get_unreceive_friend_list, this.unreceiveMsg, []);
            };
            if (FunctionType.isOpened(FunctionType.Faction)){
                (this._view.chat.isOpenFaction = true);
                this.get_faction_level();
            } else {
                (this._view.chat.isOpenFaction = false);
            };
            if (FunctionType.isOpened(FunctionType.MultiMission)){
                this._view.activities.openActivity(TownType.All);
                this._view.activities.openActivity(TownType.MultiMission);
                (this._view.chat.isOpenActivity = true);
            };
            if (FunctionType.isOpened(FunctionType.Farm)){
                this._data.patch(Mod_Farm_Base.get_simple_farmlandinfo, this._view.farm.getSimpleFarmlandinfoCallBack);
            };
            if (FunctionType.isOpened(FunctionType.TakeBible)){
                this._view.takeBibleRoad.get_rulai_open_time();
            };
            if (FunctionType.isOpened(FunctionType.Friend)){
                this._view.friendMessage.show();
            };
            if (FunctionType.isOpened(FunctionType.RollCake)){
                this._data.call(Mod_Player_Base.update_player_data, null, [Mod_Player_Base.STATE_POINT]);
            };
            if (FunctionType.isOpened(FunctionType.TakeBible)){
                this.takeBibleInfo();
            };
            if (FunctionType.isOpened(FunctionType.HeroMission)){
                this._view.activities.addActivity(FunctionType.HeroMission);
            };
            var _local1:Boolean = FunctionType.isOpened(FunctionType.Achievement);
            this._toolbar.visibleAchievement(FunctionType.isOpened(FunctionType.Achievement));
            if (_local1){
                this._view.activities.addActivity(ActivityType.GameHelper);
            };
        }
        private function openOtherFunction(_arg1:Array):void{
            var _local2:String;
            for each (_local2 in _arg1) {
       
                switch (_local2){
                    case FunctionType.World:
                        (this._miniMap.gameHelpVisible = true);
                        (this._miniMap.worldVisible = true);
                        (this._miniMap.hideVisible = true);
                        (this._miniMap.settingVisible = true);
                        this._data.call(Mod_Item_Base.has_level_gift_item, null, []);
                        break;
                    case FunctionType.MultiMission:
                        this._view.activities.openActivity(TownType.MultiMission);
                        break;
                    case FunctionType.DailyQuest:
                        this._view.activities.openActivity(FunctionType.DailyQuest);
                        break;
                    case FunctionType.SuperSport:
                        this.patchNotifyGlobal();
                        this._view.activities.openActivity(FunctionType.SuperSport);
                        break;
                    case FunctionType.OfflineExp:
                        this._view.activities.openActivity(TownType.OfflineExp);
                        break;
                    case FunctionType.Rune:
                        this._view.rune.rune_list();
                        break;
                    case FunctionType.OnlineGift:
                        if (this._ctrl.player.onlineGiftTime > 0){
                            this._view.activities.openActivity(TownType.OnlineGift);
                        };
                        break;
                    case FunctionType.CampWar:
                        this._view.activities.openActivity(FunctionType.CampWar);
                        break;
                    case FunctionType.BuyPower:
                        (this._toolbar.powerVisible = (((this._ctrl.player.power < 200)) && (VIPType.enabled)));
                        this.updatePower();
                        break;
                    case FunctionType.WorldBoss:
                        this._view.activityWindow.get_world_boss_list();
                        break;
                    case FunctionType.TakeBible:
                        this._view.activities.openActivity(FunctionType.TakeBible);
                        break;
                    case FunctionType.Tower:
                        this._view.sealStone.notifyGet();
                        this._view.tower.get_tower_info3();
                        this._view.activities.addActivity(FunctionType.Tower);
                        break;
                    case FunctionType.RollCake:
                        this._view.rollCake.get_count();
                        break;
                    case FunctionType.GetPeach:
                        this.peach_info();
                        break;
                    case FunctionType.WorshipMars:
                        this._view.activities.openActivity(FunctionType.WorshipMars);
                        break;
                    case FunctionType.Zodiac:
                        this._view.activities.openActivity(FunctionType.Zodiac);
                        break;
                    case FunctionType.PetAnimal:
                        this._view.activities.addActivity(FunctionType.PetAnimal);
                        break;
                    case FunctionType.StudyStunt:
                        this._view.activities.openActivity(FunctionType.StudyStunt);
                        break;
                };
            };
        }
        public function peach_info():void{
            if (FunctionType.isOpened(FunctionType.GetPeach)){
                _data.call(Mod_GetPeach_Base.peach_info, this.peachInfoCallback, []);
            };
        }
        private function peachInfoCallback():void{
            var _local1:Object = this._ctrl.getPeach.peachInfo;
            if (_local1.peachNum <= 0){
                this._view.activities.removeActivity(FunctionType.GetPeach);
            } else {
                this._view.activities.addActivity(FunctionType.GetPeach);
            };
        }
        public function get_faction_level():void{
            this._data.patch(Mod_Faction_Base.get_faction_level, this.getFactionLevelCallBack);
            this._data.call(Mod_Faction_Base.get_faction_level, this.getFactionLevelCallBack, []);
        }
        private function getFactionLevelCallBack():void{
            var _local1:int = _ctrl.faction.getFactionLevel;
            (ActivityType.FactionLevel = _local1);
            if ((((_local1 > 0)) && ((this._isOpenFactionActivity == false)))){
                this._view.activities.openActivity(ActivityType.FactionAll);
                (this._isOpenFactionActivity = true);
                this._data.call(Mod_Faction_Base.is_can_join_activity, null, []);
                this._view.factionSeal.seal_satan_info();
                this._data.patch(Mod_Faction_Base.seal_satan_info, _view.factionSeal.sealSatanInfoCallBack);
                this._data.patch(Mod_Faction_Base.call_eat_detailed_info, _view.factionEat.callEatDetailedInfoCallBack);
            } else {
                if (((this._isOpenFactionActivity) && ((_local1 <= 0)))){
                    this._view.activities.removeActivity(ActivityType.FactionAll);
                    (this._isOpenFactionActivity = false);
                };
            };
            this._view.factionBlessing.checkIncense();
            this._view.factionEat.checkFactionEat();
        }
        private function removeUndefined(_arg1:Array):void{
            var _local2:int = _arg1.length;
            var _local3:int = (_local2 - 1);
            while (_local3 > -1) {
                if (undefined == _arg1[_local3]){
                    _arg1.splice(_local3, 1);
                };
                _local3--;
            };
        }
        private function bubble():void{
            this._data.call(Mod_Player_Base.update_player_data, this.updatePlayerDataCallback, [Mod_Player_Base.PLAYER_PACK_EMPTY_NUM]);
        }
        private function unreceiveMsg():void{
            var _local4:int;
            var _local5:Boolean;
            var _local1:Array = this._ctrl.friend.getUnreceiveFriendList;
            if (_local1.length <= 0){
                this._view.friendMessage.clearList();
            };
            if ((((((_local1 == null)) || ((_local1.length <= 0)))) || (this._view.friendMessage.isShowMostBox))){
                this.friendMsg(0);
                return;
            };
            var _local2:int = _local1.length;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = _local1[_local3];
                _local5 = this._view.friendChat.checkPlayerId(_local4);
                if (_local5){
                    this._view.friendList.check_receive_message(_local4);
                    (this._ctrl.friend.clearPlayerId = _local4);
                } else {
                    (this.showChatId = _local4);
                };
                _local3++;
            };
            _local1 = this._ctrl.friend.getUnreceiveFriendList;
            _local1;
            _local2 = _local1.length;
            _local2;
            this.friendMsg(_local2);
        }
        public function friendMsg(_arg1:int):void{
            this._toolbar.switchBubble(_arg1);
        }
        public function playGoodsEffect(_arg1:String):void{
            var url:* = _arg1;
            var callback:* = function (_arg1:Array):void{
                var obj:* = null;
                var list:* = _arg1;
                var QuestGoods:* = list[1].getClassByName("QuestGoods");
                obj = new QuestGoods(list[0].bitmap.bitmapData);
                _toolbar.content.addChild((obj as MovieClip));
                var handler:* = function ():void{
                    var _local1:Point = _toolbar.getFunctionPoint(FunctionType.Pack);
                    (obj.x = ((_local1.x - 67) - Structure.stageOffset.x));
                    (obj.y = ((_local1.y - 147) - Structure.stageOffset.y));
                };
                handler();
                (obj.onEnterFrame = handler);
                obj.gotoAndPlay(2);
            };
            File.loadList([url, (URI.addonsUrl + "quest_goods.swf")], callback);
        }
        private function takeBibleInfo():void{
            this._data.call(Mod_TakeBible_Base.take_bible_info, this.takeBibleInfoCallBack, []);
        }
        private function takeBibleInfoCallBack():void{
            this._view.takeBibleRoad.getRulaiOpenTimeCallBack();
        }
        private function checkHasManual(_arg1:Array):void{
            var _local2:Object;
            var _local3:int;
            var _local4:String;
            var _local5:int;
            for (_local2 in _arg1) {

                _local3 = _arg1[_local2]["id"];
                _local4 = FunctionType.sign(_local3);
                _local5 = _arg1[_local2]["isPlayed"];
                if ((((FunctionType.Deploy == _local4)) && ((0 == _local5)))){
                    (this._hasDeploy = true);
                    break;
                };
                if ((((FunctionType.Fate == _local4)) && ((0 == _local5)))){
                    (this._hasFate = true);
                    break;
                };
            };
        }
        private function isDeploy(_arg1:String):Boolean{
            return (((this._hasDeploy) && ((FunctionType.Deploy == _arg1))));
        }
        private function isFate(_arg1:String):Boolean{
            return (((this._hasFate) && ((FunctionType.Fate == _arg1))));
        }
        public function triggerDeploy():void{
            this.getPlayerFunctionCallback(true);
            (this._hasDeploy = false);
        }
        public function triggerFate():void{
            this.getPlayerFunctionCallback(true);
            (this._hasFate = false);
        }
        public function getFunctionPoint(_arg1:String):Point{
            var _local2:Point = this._toolbar.getFunctionPoint(_arg1);
            return (_local2);
        }
        private function keepAlive():void{
            this._view.consumeAlertSetting.loadSettingInfo();
            this._view.delayMessage.init();
            this._view.worldNotice.preLoad();
            this._data.patch(Mod_Player_Base.update_player_data, this.updatePlayerDataCallback);
            this._data.patch(Mod_CampWar_Base.notify, this.campWarNotifyCallBack);
            this._data.patch(Mod_HeroesWar_Base.notify, this.heroesWarNotifyCallBack);
            this._data.patch(Mod_Notify_Base.mission_award, this.mission_award_back);
            this._data.patch(Mod_Notify_Base.pk_award, this.pkAwardCallBack);
            this._data.patch(Mod_Notify_Base.notify_get_good_fate, this.goodFateCallBack);
            this._data.patch(Mod_Notify_Base.complete_reel_production, this.completeReelProduction);
            this._data.patch(Mod_Notify_Base.role_num_notify, this.roleNumNotifyCallBack);
            this._data.patch(Mod_Notify_Base.new_research_notify, this.newResearchNotifyCallBack);
            this._data.patch(Mod_SuperDeploy_Base.new_deploy_grid_open_notify, this.newDeployGridOpenNotifyCallBack);
            this._data.patch(Mod_Notify_Base.new_partners_notify, this.newPartnersNotifyCallBack);
            this._data.patch(Mod_Notify_Base.buy_good_stuff_in_lucky_shop, this.buyGoodStuffInLuckyShopCallBack);
            this._data.patch(Mod_Notify_Base.player_take_bible, this.playerTakeBibleCallBack);
            this._data.patch(Mod_Notify_Base.player_take_bible_berobbed, this.playerTakeBibleBerobbedCallBack);
            this._data.patch(Mod_WorldBoss_Base.open_world_boss, this.open_world_boss_back);
            this._data.patch(Mod_WorldBoss_Base.close_world_boss, this.close_world_boss_back);
            this._data.patch(Mod_WorldBoss_Base.defeat_world_boss, this.defeat_world_boss_back);
            this._data.patch(Mod_Notify_Base.disband_faction_notify, this.disband_faction_notify_back);
            this._data.patch(Mod_Notify_Base.kickout_member_notify, this.kickout_member_notify_back);
            this._data.patch(Mod_Faction_Base.faction_message_notify, this.faction_message_notify_back);
            this._data.patch(Mod_FactionWar_Base.notify_good_faction_war_gift, this.notify_good_faction_war_gift_back);
            this._data.patch(Mod_FactionWar_Base.notify_faction_war_over, this.notify_faction_war_over_back);
            this._data.patch(Mod_FactionWar_Base.notify_give_faction_war_gift, this.notify_give_faction_war_gift_back);
            this._data.patch(Mod_Faction_Base.blessing_count_change, this.blessingCountChangeCallBack);
            this._data.patch(Mod_WorshipMars_Base.blessing_times_and_exp_add_notify, this.blessingCountAndExpAddNotifyCallBack);
            this._data.patch(Mod_Notify_Base.game_timer, this.server_time);
            this._data.call(Mod_Player_Base.update_player_data, null, [Mod_Player_Base.PLAYER_SKILL]);
            this._view.addToTimerProcessList((this.sign + Math.random()), this.hourlyRefresh);
            this._data.patch(Mod_Rune_Base.rune_use_notify, this.runeUseNotifyCallback);
            this._data.patch(Mod_TakeBible_Base.notify_global, this.takeBibleNotifyCallBack);
            this._data.patch(Mod_Notify_Base.send_flower, this.sendFlowerCallBack);
            this._data.patch(Mod_Notify_Base.pass_tower, this.pass_tower_back);
            this._data.patch(Mod_Notify_Base.update_rulai_status, this.rulaiStateCallBack);
            this._data.patch(Mod_Notify_Base.roll_cake, this.rollCakeCallBack);
            this._data.patch(Mod_Achievement_Base.notify_complete_achievement, this.notifyCompleteAchievementCallBack);
            this._view.dailyQuest.finish_all_day_quest();
            this._data.patch(Mod_Item_Base.notify_super_gift_items, this.notify_super_gift_items_back);
            this._data.patch(Mod_Notify_Base.server_war_winner, this.server_war_winner_back);
            this._data.patch(Mod_Notify_Base.world_war_top_login, this.world_war_top_login_back);
            this._data.patch(Mod_SealSoul_Base.notify_get, this.sealStoneNotifyGetCallBack);
            this._data.patch(Mod_Notify_Base.zodiac_entry_notify, this.zodiacEntryNotifyCallBack);
            this._data.patch(Mod_Notify_Base.get_pet_animal_exp, this.get_pet_animal_exp_back);
            this._data.patch(Mod_Notify_Base.study_stunt_notify, this.studyStuntNotifyCallBack);
            this._data.patch(Mod_StudyStunt_Base.player_can_study_stunt, this.playerCanStudyStuntNotifyCallBack);
            this._data.patch(Mod_FactionWar_Base.notify_faction_war_gift, this.notify_faction_war_gift_back);
            this._data.patch(Mod_Notify_Base.update_player_super_gift, this.update_player_super_gift_back);
            this._view.factionWindow.factionWarInit();
        }
        private function notify_faction_war_gift_back():void{
            if (this._ctrl.factionWarMap.result == 1){
                this._view.activities.addActivity(ActivityType.FactionWarGift);
                this._view.activities.showActivityTitle(ActivityType.FactionWarGift, keepAliveLang.ClickAssign);
            } else {
                this._view.activities.removeActivity(ActivityType.FactionWarGift);
            };
        }
        public function update_player_super_gift_back():void{
            var _local3:Object;
            var _local1:int = 20;
            while (_local1 > 0) {
                this._view.activities.removeActivity((ActivityType.GiftStr + _local1));
                var _temp1:int = _local1;
                _local1 = (_local1 - 1);
                _temp1;
            };
            var _local2:Array = this._ctrl.notify.giftList;
            for each (_local3 in _local2) {
 
                this._view.activities.addActivity(_local3.sign);
                this._view.activities.showActivityTitle(_local3.sign, keepAliveLang.ClickGet);
            };
        }
        private function get_pet_animal_exp_back():void{
            this._view.worldNotice.showMessage(this._ctrl.notify.petBaoJi);
        }
        private function pass_tower_back():void{
            this._view.tower.updateNotice(this._ctrl.notify.passTowerMsg);
        }
        private function rollCakeCallBack():void{
            RollCakeType.loadData(function ():void{
                var _local1:Object = _ctrl.notify.rollCakInfo;
                _view.chat.receive(_local1.info, true);
            });
        }
        private function notify_super_gift_items_back():void{
            this._view.alert.confirm(this._ctrl.item.giftUseMsg);
        }
        private function server_war_winner_back():void{
            this._view.worldNotice.showMessage(this._ctrl.notify.serverWarWinnerMsg);
        }
        public function world_war_top_login_back():void{
            if (this._ctrl.notify.firstLoginWorld == ""){
                return;
            };
            this._view.worldNotice.showMessage(this._ctrl.notify.firstLoginWorld);
            this._view.chat.receive(this._ctrl.notify.firstLoginChat, true, Mod_Chat_Base.WORLD);
            (this._ctrl.notify.firstLoginWorld = "");
        }
        public function rulaiStateCallBack():void{
            var _local1:Object;
            var _local2:Number;
            var _local3:int;
            var _local4:Object;
            if (FunctionType.isOpened(FunctionType.TakeBible)){
                _local1 = this._ctrl.notify.rulaiStatus;
                (this._view.takeBibleRoad.rulaiType = _local1.type);
                switch (_local1.type){
                    case Mod_Notify_Base.RULAI_OPEN_FOR_CALL:
                        this.rulaiType(1);
                        (_view.takeBibleReady.awardState = 0);
                        break;
                    case Mod_Notify_Base.RULAI_OPEN:
                        _local2 = ((_local1.isSelf == true)) ? 1 : 0.2;
                        (this._view.takeBibleReady.awardState = _local2);
                        this.rulaiType(2);
                        break;
                    case Mod_Notify_Base.RULAI_CLOSE:
                        if (this._view.takeBibleReady.inStage){
                            (_view.takeBibleReady.awardState = 0);
                            this._view.takeBibleReady.get_take_bible_info();
                        };
                        this.rulaiType(3);
                        _local3 = this._view.takeBibleRoad.getStartTime;
                        if (_local3 == 0){
                            _local4 = this._view.takeBibleRoad._rulaiStartTimeList[0];
                            _local3 = _local4.startTime;
                            _local3;
                        };
                        (_local1.time = _local3);
                        break;
                };
                if (this._view.takeBibleReady.inStage){
                    this._view.takeBibleReady.get_take_bible_info();
                };
                (this._view.takeBibleRoad.getRuLaiData = _local1);
                this._view.takeBibleRoad.get_take_bible_updata_data();
                if (_local1.type == Mod_Notify_Base.RULAI_OPEN){
                    this._view.worldNotice.showMessage(_local1.info);
                };
            };
        }
        public function rulaiType(_arg1:int):void{
            var _local2:Boolean = VIPType.check(VIPType.Level5);
            switch (_arg1){
                case 1:
                    _view.activities.showActivityTitle(FunctionType.TakeBible, keepAliveLang.CanCall);
                    this._view.activities.visibleBtnEffect(FunctionType.TakeBible, keepAliveLang.RuLaiSpirit, false);
                    this._view.activities.visibleBtnEffect(FunctionType.TakeBible, keepAliveLang.CanCall, false);
                    if (_local2 == false){
                        this._view.activities.hideActivityTimer(FunctionType.TakeBible, keepAliveLang.CanCall);
                    };
                    break;
                case 2:
                    if (this._ctrl.TakeBible.canTakeBibleTimes > 0){
                        this._view.activities.visibleBtnEffect(FunctionType.TakeBible, keepAliveLang.RuLaiSpirit, true);
                    } else {
                        this._view.activities.visibleBtnEffect(FunctionType.TakeBible, keepAliveLang.CanCall, false);
                        this._view.activities.visibleBtnEffect(FunctionType.TakeBible, keepAliveLang.RuLaiSpirit, false);
                    };
                    _view.activities.showActivityTitle(FunctionType.TakeBible, keepAliveLang.RuLaiSpirit);
                    break;
                case 3:
                    _view.activities.showActivityTitle(FunctionType.TakeBible, keepAliveLang.RuLaiSpirit);
                    this._view.activities.hideActivityTimer(FunctionType.TakeBible, keepAliveLang.RuLaiSpirit);
                    break;
            };
        }
        private function playerTakeBibleCallBack():void{
            var _local1:Object;
            if (FunctionType.isOpened(FunctionType.TakeBible)){
                _local1 = this._ctrl.notify.takeBible;
                this._view.worldNotice.showMessage(_local1.info);
            };
        }
        private function playerTakeBibleBerobbedCallBack():void{
            var _local1:Object;
            if (FunctionType.isOpened(FunctionType.TakeBible)){
                _local1 = this._ctrl.notify.takeBibleBerobbed;
                if (_local1.robPlayerNickname != this._ctrl.player.nickname){
                    this._view.worldNotice.showMessage(_local1.info);
                } else {
                    (this._takeBibleData = _local1);
                };
            };
        }
        public function renderTakeBibleBerobbed():void{
            if (this._takeBibleData == null){
                return;
            };
            this._view.worldNotice.showMessage(this._takeBibleData.info);
            (this._takeBibleData = null);
        }
        private function takeBibleNotifyCallBack():void{
            var data:* = this._ctrl.TakeBible.notifyGlobal;
            switch (data.type){
                case Mod_TakeBible_Base.BEROB:
                    if (this._view.inWar){
                        this._robList.push(data);
                        (this._view.onWarClose = function ():void{
                            robShow();
                        });
                    } else {
                        (this._view.takeBibleRoad.beRob = data);
                    };
                    break;
                case Mod_TakeBible_Base.PROTECT_BEROB:
                    if (this._view.inWar){
                        this._robList.push(data);
                        (this._view.onWarClose = function ():void{
                            robShow();
                        });
                    } else {
                        (this._view.takeBibleRoad.beRob = data);
                    };
                    break;
                case Mod_TakeBible_Base.APPLY_PROTECT:
                    this.applyProtectList();
                    break;
            };
        }
        public function robShow():void{
            var _local1:Object;
            if (this._robList.length > 0){
                _local1 = this._robList[0];
                switch (_local1.type){
                    case Mod_TakeBible_Base.BEROB:
                        (this._view.takeBibleRoad.beRob = _local1);
                        break;
                    case Mod_TakeBible_Base.PROTECT_BEROB:
                        (this._view.takeBibleRoad.protectRob = _local1);
                        break;
                };
                this._robList.splice(0, 1);
            };
        }
        private function applyProtectList():void{
            var _local4:Object;
            var _local5:String;
            var _local6:uint;
            var _local1:Array = this._ctrl.TakeBible.applyProtectList;
            var _local2:int = _local1.length;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = _local1[_local3];
                _local5 = Lang.sprintf(keepAliveLang.Invite, (("<【" + _local4.playerShowName) + "】&Y>"), _local4.protectName, _local4.protectAwardFame);
                _local6 = (AlertButtonType.Yes | AlertButtonType.No);
                _local6;
                this._view.delayMessage.addDelayMessage(DelayNotifyType.TakeBibleApplyProtect, _local5, _local6, this.applyProtectCallback(_local4));
                this._ctrl.TakeBible.removeApplyProtect(_local4.playerId);
                _local3++;
            };
        }
        private function applyProtectCallback(_arg1:Object):Function{
            var data:* = _arg1;
            var handler:* = function (_arg1:uint):void{
                if (AlertButtonType.Yes == _arg1){
                    _view.takeBibleReady.approve_apply(data.playerId);
                } else {
                    _view.takeBibleReady.reject_apply(data.playerId);
                };
            };
            return (handler);
        }
        private function faction_message_notify_back():void{
            var _local1:Object = this._ctrl.faction.factionMessage;
            this._view.chat.receive(_local1.info, false, Mod_Chat_Base.FACTION);
        }
        private function runeUseNotifyCallback():void{
            var _local1:Object = this._ctrl.rune.runeUseNotify;
            this._view.chat.addSystemMessage(Lang.sprintf(keepAliveLang.Rune, _local1.coins));
            this._view.rune.isBtnUser(_local1);
        }
        private function disband_faction_notify_back():void{
            this._view.townMap.quitJiHuiSuo();
            (this._ctrl.player.playerInfo.factionId = 0);
            (this._ctrl.player.playerInfo.factionName = "");
        }
        private function kickout_member_notify_back():void{
            this._view.townMap.quitJiHuiSuo();
            (this._ctrl.player.playerInfo.factionId = 0);
            (this._ctrl.player.playerInfo.factionName = "");
        }
        private function notify_faction_war_over_back():void{
            this._view.factionWarMap.showWorldNotice(this._ctrl.factionWarMap.overWorldMsg);
            var _local1:String = this._ctrl.factionWarMap.overChatMsg;
            if (_local1 != ""){
                this.receiveTown(_local1, true, Mod_Chat_Base.FACTION);
            };
        }
        private function notify_give_faction_war_gift_back():void{
            var _local2:String;
            var _local1:Array = this._ctrl.factionWarMap.chatFaction;
            for each (_local2 in _local1) {
        
                this.receiveTown(_local2, true, Mod_Chat_Base.FACTION);
            };
        }
        private function notify_good_faction_war_gift_back():void{
            var _local2:String;
            var _local1:Array = this._ctrl.factionWarMap.chatWorld;
            for each (_local2 in _local1) {

                this.receiveTown(_local2);
            };
            _local1 = this._ctrl.factionWarMap.chatFaction;
            _local1;
            for each (_local2 in _local1) {

                this.receiveTown(_local2, false, Mod_Chat_Base.FACTION);
            };
            _local1 = this._ctrl.factionWarMap.showWorld;
            _local1;
            for each (_local2 in _local1) {

                this._view.worldNotice.showMessage(_local2, 9);
            };
        }
        private function hourlyRefresh():void{
            var _local1:Number = this._view.ctrl.player.serverTime;
            var _local2:String = TimeChange.timerToNum(_local1);
            if (_local2 == "00:00"){
                this._view.rune.rune_list();
            };
        }
        private function completeReelProduction():void{
            var _local2:String;
            var _local1:Array = this._ctrl.notify.reelList;
            for each (var _local5:String in _local1) {
                _local2 = _local5;
                _local5;
                this.receiveTown(_local2);
            };
        }
        public function patchNotifyGlobal():void{
            this._data.patch(Mod_SuperSport_Base.notify_global, this.notifyGlobalCallBack);
        }
        public function cancelPatchNotifyGlobal():void{
            this._data.cancelPatch(Mod_SuperSport_Base.notify_global);
        }
        private function open_world_boss_back():void{
            var _local1:String = this._ctrl.worldBossMap.notifyBoss.worldTips;
            if (_local1 != ""){
                this._view.worldNotice.showMessage(_local1);
            };
            var _local2:String = this._ctrl.worldBossMap.notifyBoss.chatTips;
            if (_local2 != ""){
                this.receiveTown(_local2, false, Mod_Chat_Base.FACTION);
            };
            this._view.activityWindow.get_world_boss_list();
            this._view.worldBossMap.updateBossOpen();
        }
        private function close_world_boss_back():void{
            var _local1:String = this._ctrl.worldBossMap.notifyBoss.chatTips;
            setTimeout(this.receiveTown, 5000, _local1);
            setTimeout(this.receiveTown, 30000, _local1);
            this._view.activityWindow.get_world_boss_list();
            this._view.worldBossMap.updateBossOver();
        }
        private function defeat_world_boss_back():void{
            var _local1:String = this._ctrl.worldBossMap.notifyBoss.chatTips;
            setTimeout(this.receiveTown, 5000, _local1);
            setTimeout(this.receiveTown, 30000, _local1);
            this._view.activityWindow.get_world_boss_list();
            this._view.worldBossMap.updateBossKill();
        }
        private function pkAwardCallBack():void{
            var _local1:String = this._ctrl.notify.pkAward;
            this.receiveTown(_local1);
        }
        private function goodFateCallBack():void{
            var _local1:String = this._ctrl.notify.getGoodFate;
            this.receiveTown(_local1);
        }
        public function notifyGlobalCallBack():void{
            var _local1:Object = this._ctrl.superSport.notifyGlobal;
            if (_local1.type == Mod_SuperSport_Base.AWARD_TOP){
                this.receiveTown(_local1.info);
            } else {
                if (this._view.superSport.startChallenge){
                    this._showMessageList.push(_local1);
                } else {
                    this.hasGlobalShow(_local1);
                };
            };
        }
        public function saveNotifyGlobal():void{
            var _local3:Object;
            var _local1:int = this._showMessageList.length;
            var _local2:int;
            while (_local2 < _local1) {
                _local3 = this._showMessageList[_local2];
                this.hasGlobalShow(_local3);
                _local2++;
            };
            (this._showMessageList = []);
        }
        private function hasGlobalShow(_arg1:Object):void{
            if (_arg1.type == Mod_SuperSport_Base.WIN_TOP){
                if (_arg1.winTimesTop >= 5){
                    this.sendGlobalShow(_arg1);
                };
            } else {
                if (_arg1.type == Mod_SuperSport_Base.KILL_WIN_TOP){
                    if (_arg1.timesTop >= 5){
                        this.sendGlobalShow(_arg1);
                    };
                } else {
                    this.sendGlobalShow(_arg1);
                };
            };
        }
        private function sendGlobalShow(_arg1:Object):void{
            this._view.worldNotice.showMessage(_arg1.worldInfo);
            this._view.superSport.changeNotife(_arg1.info);
        }
        private function mission_award_back():void{
            var _local2:Array;
            var _local3:int;
            var _local1:Array = this._ctrl.notify.missionAwardList;
            for each (_local2 in _local1) {
                
                _local3 = _local2.shift();
                if ((((_local3 == this._ctrl.player.playerId)) && ((this._view.war.requested == true)))){
                    (this.thisAwardList = this.thisAwardList.concat(_local2));
                    this._view.delayExecute(DelayType.MissionAward, this.mission_award_back);
                } else {
                    while (_local2.length) {
                        this.receiveTown(_local2.pop());
                    };
                };
            };
            if (this._view.war.requested == false){
                while (this.thisAwardList.length) {
                    this.receiveTown(this.thisAwardList.pop());
                };
            };
        }
        private function updatePlayerDataCallback():void{
            var change:* = 0;
            var str:* = null;
            var control:* = this._ctrl.player;
            if (control.isChanged(Mod_Player_Base.PLAYER_COINS)){
                this.updateCoins();
            };
            if (control.isChanged(Mod_Player_Base.PLAYER_INGOT)){
                this.updateIngot();
            };
            if (((control.isChanged(Mod_Player_Base.PLAYER_HEALTH)) || (control.isChanged(Mod_Player_Base.PLAYER_MAX_HEALTH)))){
                this.updateHealth();
            };
            if (control.isChanged(Mod_Player_Base.PLAYER_POWER)){
                this.updatePower();
            };
            if (control.isChanged(Mod_Player_Base.PLAYER_EXPERIENCE)){
                this.updateExperience();
            };
            if (control.isChanged(Mod_Player_Base.PLAYER_TOWN_KEY)){
                this._view.heroMission.changeTownKey();
            };
            if (control.isChanged(Mod_Player_Base.PLAYER_PACK_EMPTY_NUM)){
                (this._view.missionPractice.pickNum = control.packNum);
                if (control.packNum == 0){
                    this._toolbar.addPackFull();
                } else {
                    this._toolbar.removePackFull();
                };
            };
            if (control.isChanged(Mod_Player_Base.PLAYER_LEVEL)){
                this.updateLevel();
            };
            this.partnerUpgrade();
            if (control.isChanged(Mod_Player_Base.PLAYER_TRANSPORT)){
                this._view.missionMap.updatePlayerBody();
                this.updateMountsBuffer();
            };
            if (control.isChanged(Mod_Player_Base.PLAYER_AVATAR)){
                this._view.missionMap.updatePlayerBody();
                this.updateAvatarBuffer();
            };
            this.updateExtraPower();
            if (control.hasNewFunction){
                (control.hasNewFunction = false);
                this._view.screen.currentMap.updateNpcLoack(control.functionLock);
                this.delayOpenFunction();
            };
            if (control.hasQuestState){
                (control.hasQuestState = false);
                this.delayLoadQuestTrace();
            };
            if (control.isChanged(Mod_Player_Base.HEALTH_UP_SYS)){
                this._view.delayExecute(DelayType.HealthUpdateMessage, function ():void{
                    _view.chat.addSystemMessage(keepAliveLang.HealthFull);
                });
            };
            if (control.isChanged(Mod_Player_Base.GET_ONLINE_GIFT)){
                this._view.activities.onlineGiftActivity();
            };
            if (control.isChanged(Mod_Player_Base.CAMP_SALARY)){
                if (this._ctrl.player.campSalaryEnabled){
                    this._view.activities.openActivity(TownType.CampSalary);
                    this._view.activities.addCampSalaryActivityTip();
                } else {
                    this._view.activities.removeActivity(TownType.CampSalary);
                };
            };
            if (control.isChanged(Mod_Player_Base.PLAYER_DAY_QUEST)){
                if (this._ctrl.player.dayQuestState == 1){
                    this._view.activities.showActivityTitle(FunctionType.DailyQuest, keepAliveLang.CanComplete);
                    this._view.activities.visibleBtnEffect(FunctionType.DailyQuest, FunctionType.DailyQuest, true);
                } else {
                    if (this._ctrl.player.dayQuestState == 0){
                        this._view.activities.hideActivityTimer(FunctionType.DailyQuest, keepAliveLang.CanComplete);
                        this._view.activities.visibleBtnEffect(FunctionType.DailyQuest, FunctionType.DailyQuest, false);
                    };
                };
            };
            if (control.isChanged(Mod_Player_Base.FINISH_DAY_QUEST)){
                if (this._ctrl.player.finishDayQuest == 1){
                    this._view.activities.removeActivity(FunctionType.DailyQuest);
                } else {
                    if (this._ctrl.player.finishDayQuest == 0){
                        this._view.activities.addActivity(FunctionType.DailyQuest);
                    };
                };
            };
            if (control.isChanged(Mod_Player_Base.CAN_INCENSE_COUNT)){
                this._view.factionBlessing.checkIncense();
            };
            if (control.isChanged(Mod_Player_Base.VIP_LEVEL)){
                if (FunctionType.isOpened(FunctionType.Rune)){
                    this._view.rune.rune_list();
                };
                if (FunctionType.isOpened(FunctionType.EquipUpgradeQueue)){
                    this.getFunctionLink(FunctionType.Upgrade);
                };
                this.checkRechargeVisible();
                this.updatePower();
            };
            if (control.isChanged(Mod_Player_Base.PLAYER_SKILL)){
                this._view.campWar.updateSkill(this._ctrl.player.skill);
                this._view.heroesWar.updateSkill(this._ctrl.player.skill);
				change = this._ctrl.player.skillChange;
                
                
                if (change > 0){
					str = (("+" + change) + keepAliveLang.Skill);
                    this.showPlayerTextEffect(str, 0xFF6600);
                };
            };
            if (control.isChanged(Mod_Player_Base.FAME)){
				change = this._ctrl.player.fameChange;
                 if (change > 0){
					 str = (("+" + change) + keepAliveLang.Fame);
 
                    this.showPlayerTextEffect(str, 0xEEEEEE);
                };
            };
            if (control.isChanged(Mod_Player_Base.STATE_POINT)){
                this.updateStatePoint();
            };
            (this.vipLevel = control.vipLevel);
            this._view.processTip.checkOpenGift();
        }
        private function updateCoins():void{
            var _local2:String;
            (this._toolbar.coins = this._ctrl.player.coins);
            (this._view.superSport.renderCoins = this._ctrl.player.coins);
            (this._view.lodge.renderCoins = this._ctrl.player.coins);
            (this._view.upgrade.updateCoins = this._ctrl.player.coins);
            (this._view.takeBibleRoad.renderCoins = this._ctrl.player.coins);
            (this._view.serverWarCup.renderCoins = this._ctrl.player.coins);
            var _local1:Number = this._ctrl.player.coinChange;
            if (_local1 > 0){
                _local2 = (("+" + _local1) + keepAliveLang.Coin);
                this.showPlayerTextEffect(_local2, 0xEEEEEE);
            };
        }
        private function updateIngot():void{
            var _local2:String;
            (this._toolbar.ingot = this._ctrl.player.ingot);
            (this._view.superSport.renderIngot = this._ctrl.player.ingot);
            (this._view.lodge.renderIngot = this._ctrl.player.ingot);
            (this._view.takeBibleRoad.renderIngot = this._ctrl.player.ingot);
            (this._view.serverWarCup.renderIngot = this._ctrl.player.ingot);
            var _local1:int = this._ctrl.player.ingotChange;
            if (_local1 > 0){
                _local2 = (("+" + _local1) + keepAliveLang.Ingot);
                this.showPlayerTextEffect(_local2, 0xFFF200);
            };
        }
        private function updateStatePoint():void{
            this._view.goldOilShop.updateStatePoint();
        }
        private function showPlayerTextEffect(_arg1:String, _arg2:uint):void{
            if (this._view.screen.currentMap != null){
                this._view.screen.currentMap.showTextEffect(_arg1, _arg2);
            };
        }
        private function updateHealth():void{
            var _local1:int = this._ctrl.player.health;
            var _local2:int = this._ctrl.player.maxHealth;
            if (true == this._blockedHealth){
                this._toolbar.health(_local2, _local2);
                return;
            };
            if (this._view.war.requested == true){
                this._view.delayExecute(DelayType.UpdateHealth, this.updateHealth);
            } else {
                if (_local1 > _local2){
                    Helper.alert(keepAliveLang.Health, _local1, keepAliveLang.MaxHealth, _local2, keepAliveLang.CheckReturn);
                    _local1 = _local2;
                    _local1;
                };
                this._toolbar.health(_local1, _local2);
            };
        }
        public function blockHealthInCampWar():void{
            (this._blockedHealth = true);
            this.updateHealth();
        }
        public function unblockHealthInCampWar():void{
            (this._blockedHealth = false);
            this.updateHealth();
        }
        private function updatePower():void{
            var _local3:String;
            var _local1:int = this._ctrl.player.power;
            this._data.call(Mod_Player_Base.get_buy_power_data, this.buyPowerDataCallBack, []);
            (this._toolbar.powerVisible = ((((FunctionType.isOpened(FunctionType.BuyPower)) && ((_local1 < 200)))) && (VIPType.enabled)));
            if (_local1 < 5){
                this._view.processTip.openPracticeTip();
            } else {
                this._view.processTip.removeType(ProcessTipsType.Practice);
            };
            this._view.gameHelper.updateGameAssistant();
            (this._view.missionPractice.upDataPower = _local1);
            (this._view.heroPractice.upDataPower = _local1);
            this._toolbar.power(_local1, ((_local1 > 200)) ? _local1 : 200);
            var _local2:int = (_local1 - this._oldPower);
            if (_local2 > 0){
                this._view.chat.addSystemMessage(Lang.sprintf(keepAliveLang.GetPower, _local2));
                _local3 = (("+" + _local2) + keepAliveLang.Power);
                this.showPlayerTextEffect(_local3, 2552101);
            };
            (this._oldPower = _local1);
        }
        private function buyPowerDataCallBack():void{
            var _local1:Object = this._ctrl.player.buyPowerData;
            (this._toolbar.powerInfo = _local1);
            (this._view.missionPractice.getLostPowerNum = _local1.buyNum);
            (this._view.heroPractice.getLostPowerNum = _local1.buyNum);
        }
        public function checkWarCdTime(_arg1:Function):void{
            var callback:* = _arg1;
            var handle:* = function ():void{
                var _local1:Object = _ctrl.player.hasWarCdTime;
                if (_local1.hasWarTime){
                    _view.tip2.showHackToolsTip(_local1.cdTimer);
                };
                callback(_local1.hasWarTime);
            };
            this._data.call(Mod_Player_Base.get_player_war_cd_time, handle, []);
        }
        private function buyGoodStuffInLuckyShopCallBack():void{
            var _local1:Object = this._ctrl.notify.getBuyGoodStuffInLuckyShop();
            this._view.chat.addSystemMessage((_local1["chat"] as String));
        }
        private function blessingCountChangeCallBack():void{
            this._view.factionBlessing.getBlessingCount();
        }
        private function blessingCountAndExpAddNotifyCallBack():void{
            this._view.worshipMars.getBlessingTimesAndExpAdd();
        }
        private function gameTimerCallBack():void{
            var callBack:* = null;
            callBack = function ():void{
                if (_view.factionWindow.inStage){
                    _view.factionEat.call_eat_info();
                    _view.factionSeal.seal_satan_info();
                } else {
                    if (_view.factionSeal.inStage){
                        _view.factionSeal.seal_satan_member_list();
                        _view.factionSeal.seal_satan_info();
                    };
                };
            };
            if (this._ctrl.notify.gameTimer["timer_type"] == Mod_Notify_Base.FACTION){
                this._data.call(Mod_Faction_Base.is_can_join_activity, callBack, []);
            };
            if (this._ctrl.notify.gameTimer["timer_type"] == Mod_Notify_Base.CHANGE_MONEY){
                this._view.rune.rune_list();
            };
            this._view.sealStone.notifyGet();
            this._view.rollCake.get_count();
            this._view.activities.redEnvelopes();
            this.peach_info();
            this._view.farm.getFarmlandinfoList();
            this._view.worshipMars.getRemainIncenseTimes();
            this._view.travelEvent.get_activity_info();
            this._view.sendFlower.update();
        }
        private function server_time():void{
            _data.call(Mod_Player_Base.server_time, this.gameTimerCallBack, []);
        }
        private function sendFlowerCallBack():void{
            var _local1:Object = this._ctrl.notify.sendFlowerInfo;
            var _local2:String = "";
            if (this.isNewYear()){
                if (_local1["receive_player_sex"] == 0){
                    _local2 = Lang.sprintf(keepAliveLang.SendFlowerToMan, _local1["send_player_nickname"], _local1["receive_player_nickname"], HtmlText.format(_local1["flower_count"], HtmlText.Green, 24));
                    _local2;
                } else {
                    _local2 = Lang.sprintf(keepAliveLang.SendFlowerToWoman, _local1["send_player_nickname"], _local1["receive_player_nickname"], HtmlText.format(_local1["flower_count"], HtmlText.Green, 24));
                    _local2;
                };
            } else {
                _local2 = Lang.sprintf(keepAliveLang.SendFlower, _local1["send_player_nickname"], _local1["receive_player_nickname"], HtmlText.format(_local1["flower_count"], HtmlText.Green, 24));
                _local2;
            };
            this._view.worldNotice.showMessage(_local2);
        }
        private function notifyCompleteAchievementCallBack():void{
            this._view.achievementComplete.notifyCompleteAchievementCallBack();
        }
        private function isNewYear():Boolean{
            var _local1:Date = new Date((this._ctrl.player.serverTime * 1000));
            var _local2:Boolean = (((((_local1.month == 0)) && ((((_local1.date >= 18)) && ((_local1.date <= 31)))))) || ((((_local1.month == 1)) && ((((_local1.date >= 1)) && ((_local1.date <= 6)))))));
            return (_local2);
        }
        private function sealStoneNotifyGetCallBack():void{
            if (FunctionType.isOpened(FunctionType.SealSoul)){
                this._view.sealStone.notifyGetCallBack();
            };
        }
        private function zodiacEntryNotifyCallBack():void{
            var _local1:Object = this._ctrl.notify.zodiacEntryNotify;
            this._view.worldNotice.showMessage(Lang.sprintf(keepAliveLang.ZodiacEntryNotify, _local1["nickname"], this.getChineseNumber(_local1["zodiac_leve"])));
        }
        private function getChineseNumber(_arg1:int):String{
            var _local2:Object = {
                1:"一",
                2:"二",
                3:"三",
                4:"四",
                5:"五",
                6:"六",
                7:"七",
                8:"八",
                9:"九",
                10:"十"
            };
            return (_local2[_arg1]);
        }
        private function studyStuntNotifyCallBack():void{
            var _local1:Object = this._ctrl.notify.studyStuntNotify;
            this._view.worldNotice.showMessage(Lang.sprintf(keepAliveLang.StudyStuntNotify, _local1["nickname"], _local1["stunt_name"]));
        }
        private function updateExperience():void{
            var _local1:int;
            var _local2:String;
            if ((((((this._view.war.requested == true)) || ((this._view.missionRank.requested == true)))) || ((this._view.getPeachWar.requested == true)))){
                this._view.delayExecute(DelayType.Experience, this.updateExperience);
            } else {
                this._toolbar.updateExperience(this._ctrl.player.experience, this._ctrl.player.maxExperience);
                _local1 = this._ctrl.rolemsg.ExpChange;
                if (_local1 > 0){
                    _local2 = (("+" + _local1) + keepAliveLang.Exp);
                    this.showPlayerTextEffect(_local2, 2552101);
                };
            };
        }
        private function updateLevel():void{
            if ((((((((this._view.war.requested == true)) || ((this._view.missionRank.requested == true)))) || (this._view.drama.inStage))) || ((this._view.getPeachWar.requested == true)))){
                this._view.delayExecute(DelayType.LevelUp, this.updateLevel);
            } else {
                (this._toolbar.level = this._ctrl.player.level);
                this._view.chat.addSystemMessage(((this._ctrl.player.nickname + " ") + keepAliveLang.LevelUp), 0xFFFF00);
                if (this._view.screen.currentMap != null){
                    this._view.screen.currentMap.showLevelUp();
                };
                if (((this._ctrl.quest.hasLevelLimit) && ((this._view.townMap.inStage == true)))){
                    this.loadQuestTrace();
                };
            };
        }
        private function partnerUpgrade():void{
            var _local1:Array;
            var _local2:int;
            if ((((this._view.war.requested == true)) || ((this._view.getPeachWar.requested == true)))){
                this._view.delayExecute(DelayType.PartnerUpgrade, this.partnerUpgrade);
            } else {
                _local1 = this._ctrl.player.upLevelRoles;
                for each (_local2 in _local1) {
                    delete _local1[_local2];
                    this._view.chat.addSystemMessage(((RoleType.getRoleName(_local2) + " ") + keepAliveLang.LevelUp), 0xFFFF00);
                };
            };
        }
        private function delayOpenFunction():void{
            if (this._view.townMap.inStage == false){
                this._view.delayExecute(DelayType.OpenFunction, this.get_player_function);
            } else {
                this.get_player_function();
            };
        }
        private function delayLoadQuestTrace():void{
            if ((((this._view.townMap.inStage == false)) && ((this._view.war.requested == true)))){
                this._view.delayExecute(DelayType.QuestTrace, this.loadQuestTrace);
            } else {
                this.loadQuestTrace();
            };
        }
        private function campWarNotifyCallBack():void{
            var _local2:Object;
            if (FunctionType.isPlayed(FunctionType.CampWar) == false){
                return;
            };
            var _local1:Object = this._ctrl.campWar.getNotifyType();
            if (_local1["notify_type"] == Mod_CampWar_Base.END_CAMP_WAR){
                this.showCampTopWinMessage();
                this.showCampWinMessage();
            };
            if (_local1["notify_type"] == Mod_CampWar_Base.OPEN_CAMP_WAR){
                this._view.worldNotice.showMessage(keepAliveLang.CampWarOpen);
                _local2 = this._ctrl.campWar.getCurrentCampOpenTime();
                this._view.activities.activityShowCampWar(1, _local2["start_time"], _local2["end_time"]);
            };
            this._view.campWar.notifyCallBack(_local1);
        }
        private function showCampTopWinMessage():void{
            var _local2:Object;
            var _local3:String;
            var _local1:Array = this._ctrl.campWar.getNotifyTopWinner();
            for each (_local2 in _local1) {

                if ((((((_local2["min_level"] <= this._ctrl.player.level)) && ((_local2["max_level"] >= this._ctrl.player.level)))) && ((_local2["top_win_times"] > 8)))){
                    _local3 = Lang.sprintf(keepAliveLang.CampTopWin, htmlFormat(_local2["top_player_nick_name"], 24, 0xFFFF00), htmlFormat(_local2["top_win_times"], 24, 0xFFFF00));
                    this._view.worldNotice.showMessage(_local3);
                    break;
                };
            };
        }
        private function showCampWinMessage():void{
            var strMsg:* = null;
            var showMessage:* = null;
            showMessage = function ():void{
                _view.chat.addSystemMessage(strMsg);
            };
            var obj:* = this._ctrl.campWar.getNotifyIntegral();
            if (obj["win_camp_id"] == 0){
                return;
            };
            var strWinCampName:* = FactionType.campName(obj["win_camp_id"]);
            var strLoseCampName:* = ((obj["win_camp_id"] == FactionType.campId(FactionType.KunLunCheng))) ? FactionType.campName(FactionType.campId(FactionType.ShuShanCheng)) : FactionType.campName(FactionType.campId(FactionType.KunLunCheng));
            strMsg = Lang.sprintf(keepAliveLang.CampWin, strWinCampName, strLoseCampName);
            this._view.worldNotice.showMessage(strMsg);
            var _local2:String = (("<font color=\"#fff200\">" + Lang.sprintf(keepAliveLang.CampDisciple, strWinCampName, strLoseCampName, strWinCampName)) + "</font>");
            strMsg = _local2;
            _local2;
            showMessage();
            setTimeout(showMessage, 3000);
        }
        private function heroesWarNotifyCallBack():void{
            var _local1:Object;
            var _local2:Object;
            if (FunctionType.isPlayed(FunctionType.CampWar) == false){
                return;
            };
            _local1 = this._ctrl.heroesWar.getNotifyType();
            if (_local1["notify_type"] == Mod_HeroesWar_Base.END_HEROES_WAR){
                this.showHeroesTopWinMessage();
                this.showHeroesWinMessage();
            };
            if (_local1["notify_type"] == Mod_HeroesWar_Base.OPEN_HEROES_WAR){
                this._view.worldNotice.showMessage(keepAliveLang.HeroesWarOpen);
                _local2 = this._ctrl.heroesWar.getCurrentHeroesOpenTime();
                this._view.activities.activityShowHeroesWar(1, _local2["start_time"], _local2["end_time"]);
            };
            this._view.heroesWar.notifyCallBack(_local1);
        }
        private function showHeroesTopWinMessage():void{
            var _local1:Array;
            var _local2:Object;
            var _local3:String;
            _local1 = this._ctrl.heroesWar.getNotifyTopWinner();
            for each (_local2 in _local1) {

                if ((((((_local2["min_level"] <= this._ctrl.player.level)) && ((_local2["max_level"] >= this._ctrl.player.level)))) && ((_local2["top_win_times"] > 8)))){
                    _local3 = Lang.sprintf(keepAliveLang.HeroesTopWin, htmlFormat(_local2["top_player_nick_name"], 24, 0xFFFF00), htmlFormat(_local2["top_win_times"], 24, 0xFFFF00));
                    this._view.worldNotice.showMessage(_local3);
                    break;
                };
            };
        }
        private function showHeroesWinMessage():void{
        }
        private function roleNumNotifyCallBack():void{
            if (this._view.townMap.inStage == false){
                this._view.delayExecute(DelayType.PartnersCount, this._view.processTip.openPartnersCount);
            } else {
                this._view.processTip.openPartnersCount();
            };
        }
        private function newResearchNotifyCallBack():void{
            if (!FunctionType.isOpened(FunctionType.Research)){
                return;
            };
            if (this._view.townMap.inStage == false){
                this._view.delayExecute(DelayType.Research, this._view.processTip.openResearch);
            } else {
                this._view.processTip.openResearch();
            };
        }
        private function newPartnersNotifyCallBack():void{
            if (this._view.townMap.inStage == false){
                this._view.delayExecute(DelayType.Partners, this._view.processTip.openPartners);
            } else {
                this._view.processTip.openPartners();
            };
        }
        private function newDeployGridOpenNotifyCallBack():void{
            var _local1:Object;
            if (!FunctionType.isOpened(FunctionType.Deploy)){
                return;
            };
            _local1 = this._ctrl.superDeploy.newDeployGridOpenNotify;
            if ((((_local1["id"] == 1)) || ((_local1["id"] == 3)))){
                return;
            };
            if (this._view.townMap.inStage == false){
                this._view.delayExecute(DelayType.SuperDeploy, this._view.processTip.openSuperDeploy);
            } else {
                this._view.processTip.openSuperDeploy();
            };
        }
        private function playerCanStudyStuntNotifyCallBack():void{
            if (!FunctionType.isOpened(FunctionType.StudyStunt)){
                return;
            };
            if (this._view.inWar){
                (this._view.onWarClose = function ():void{
                    _view.processTip.openStudyStunt();
                    (_view.onWarClose = null);
                });
            } else {
                this._view.processTip.openStudyStunt();
            };
        }
        private function friend():void{
            _data.patch(Mod_Friend_Base.notify_online_state, this.onlineStateCallBack);
            _data.patch(Mod_Friend_Base.notify_message_count, this.messageCountCallBack);
        }
        private function onlineStateCallBack():void{
            var _local1:Object;
            _local1 = _ctrl.friend.onlineState();
            (_view.friendList.onlineState = _local1);
            (_view.friendChat.onlineState = _local1);
            (_view.audience.onlineState = _local1);
        }
        private function messageCountCallBack():void{
            var _local1:Object;
            _local1 = _ctrl.friend.messageCount();
            (_view.friendList.messageCount = _local1);
        }
        private function activityInfo():void{
            _view.activities.activityInfo();
        }
        public function startPractice():void{
            _view.screen.currentMap.startPractice();
        }
        public function closePractice():void{
            _view.screen.currentMap.closePractice(true);
        }
        private function load_effect_circle():void{
            var _local1:Array;
            _local1 = [(URI.addonsUrl + "load_effect_circle.swf")];
            File.loadList(_local1, this.loadEffectCircle);
        }
        private function loadEffectCircle(_arg1:Array):void{
            (this._loadEffectCircle = ((_arg1[0] as File).getClassByName("LoadEffectCircle") as Class));
        }
        public function get getLoadEffectCircle():Class{
            return (this._loadEffectCircle);
        }
        private function loadFunctionBarEffect():void{
            FunctionBarEffect.loadEffect();
        }
        public function playFlowerRain():void{
            this._toolbar.playFlowerRain(URI.flowerUrl, Structure.maxStageHeight, Structure.maxStageWidth);
        }
        public function playAchievementMc():void{
            this._toolbar.playAchievementMc();
        }
        public function get miniMap():IMiniMap{
            return (this._miniMap);
        }
        private function initMiniMap():void{
            (this._miniMap = this._toolbar.miniMap);
            (this._miniMap.tip = _view.tip.iTip);
            (this._miniMap.gameHelpVisible = false);
            (this._miniMap.worldVisible = false);
            (this._miniMap.settingVisible = false);
            (this._miniMap.showVisible = false);
            (this._miniMap.hideVisible = false);
            (this._miniMap.onWorld = _view.world.switchSelf);
            (this._miniMap.onSetting = _view.setting.switchSelf);
            (this._miniMap.onGameHelp = this._view.gameHelper.switchSelf);
            (this._miniMap.onShow = this._view.townMap.otherShow);
            (this._miniMap.onHide = this._view.townMap.otherHide);
        }
        private function autoPractice():void{
            var _local1:int;
            var _local2:int;
            setTimeout(this.autoPractice, 60000);
            _local1 = int(_view.stage.mouseX);
            _local2 = int(_view.stage.mouseY);
            if (((!((_local1 == this._px))) || (!((_local2 == this._py))))){
                (this._px = _local1);
                (this._py = _local2);
                (this._practiceTime = (getTimer() + 300000));
                return;
            };
            if (getTimer() < this._practiceTime){
                return;
            };
            if (_ctrl.player.playerInfo.practice == Mod_Town_Base.ON_PRACTICE){
                return;
            };
            if (_view.missionPractice.isBatton){
                return;
            };
            if (_view.heroPractice.isBatton){
                return;
            };
            if (FunctionType.isOpened(FunctionType.Practice) == false){
                return;
            };
            if (_view.screen.currentMap == null){
                return;
            };
            _view.screen.currentMap.startPractice();
        }

    }
}//package com.views 
