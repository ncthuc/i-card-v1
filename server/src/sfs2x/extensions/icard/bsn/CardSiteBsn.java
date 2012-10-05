package sfs2x.extensions.icard.bsn;


import java.util.Vector;


import sfs2x.extensions.icard.beans.CardAbilityBean;
import sfs2x.extensions.icard.beans.CardAbilityStoreBean;
import sfs2x.extensions.icard.beans.CardBean;
import sfs2x.extensions.icard.beans.CardGameBean;

import sfs2x.extensions.icard.beans.CardDeckBean;
import sfs2x.extensions.icard.main.ICardExtension;




/**
 * GameBsn: class containing utility business classes for game processing
 * 
 * @author Ing. Ignazio Locatelli
 * @version 1.0
 */
public class CardSiteBsn
{	
	public static void onSupportEvent(CardGameBean game,CardDeckBean srcDeck,CardDeckBean desDeck,int when){
		for (CardBean card: srcDeck.getCardMap().values()){
			if(card.getZoneID()!=CardBean.SUPPORT_ZONE_ID)
				continue;
			card.getZoneID();
		
			Vector<CardAbilityBean> vec = CardAbilityStoreBean.GetInstance().getCardAbility(card.getCardID());
			if(vec==null)
				continue;

			for(int i=0;i<vec.size();i++){
				CardAbilityBean ability = vec.get(i);
				if(ability.IsWhenMatch(when)==false)
					continue;
				switch(ability.getType()){
				case CardAbilityBean.DO_DRAW_HAND_CARD:
					BattleBsn.drawCard(game,desDeck.getPlayerID(),ability.getVal());
					break;
				}
			}
		}
	}
	public static void onAttachCardEvent(CardGameBean game,CardDeckBean deck,int when){
		
		//buf event
		for (CardBean card : deck.getCardMap().values()){
			if(card.getZoneID()!=CardBean.ATTACH_ZONE_ID)
				continue;
			CardBean desCard = game.getCard(card.getAttachTo());
			if(desCard==null)
				continue;
			Vector<CardAbilityBean> vec = CardAbilityStoreBean.GetInstance().getCardAbilityOnWhen(card.getCardID(),when);
			if(vec==null)
				continue;
			for(int i=0;i<vec.size();i++){
				CardAbilityBean ability = vec.get(i);
				BufferBsn.callCardAbility(desCard,ability);
			}
		}
		//support event
		
	}
	public static int supportAtkVal(CardDeckBean site,int which,int when){
		int atk = 0;
		Vector<CardBean> vec = PickSlotCard(site,CardBean.SUPPORT_ZONE_ID,-1);
		for(int i=0;i<vec.size();i++){
			CardBean card = vec.get(i);
			
			Vector<CardAbilityBean> abiVec = CardAbilityStoreBean.GetInstance().getCardAbility(card.getCardID());
			for(int j=0;j<abiVec.size();j++){
				CardAbilityBean ability = abiVec.get(j);
				if(ability.getType()==CardAbilityBean.BUF_ATK_ADD && ability.IsWhichMatch(which)&& ability.IsWhenMatch(when))
					atk += ability.getVal();
			}
		}
		
		return atk;
	}
	public static void FillSlotCard(CardDeckBean site,int slotID,int cardType,Vector<CardBean> pickVect){
		for (CardBean card : site.getCardMap().values())
		{
				if(card.getZoneID() == slotID &&
				   (cardType==-1 || card.getCardType()==cardType))
					pickVect.add(card);
		}
	}
	
	public static Vector<CardBean> PickSlotCard(CardDeckBean site,int slotID,int cardType){
		Vector<CardBean> pickVect =new Vector<CardBean>();
		FillSlotCard(site,slotID,cardType,pickVect);
		return pickVect;
	}
	public static void onTurnEnd(CardGameBean game,ICardExtension ext,CardDeckBean deck){
		boolean bDirty = false;
		for (CardBean card : deck.getCardMap().values())
		{
			card.IncLoop();
			if(card.getZoneID()!=CardBean.SUPPORT_ZONE_ID)
				continue;
			Vector<CardAbilityBean> vec = CardAbilityStoreBean.GetInstance().getCardAbility(card.getCardID());
			if(vec.size()==0)
				continue;
			CardAbilityBean ability = vec.get(0);
			if(card.getLoopNum()>ability.getLoopNum())
			{
				card.setDead();
				bDirty = true;
			}
		}
		if(bDirty)
			ext.SendGameCardUpdate(game);
	}
	public static void IncCardLoop(CardDeckBean deck){
		
	}
	public static Boolean ExistDeckSupport(CardDeckBean deck,int which,int type){
		for (CardBean card : deck.getCardMap().values())
		{
			if(card.getZoneID() != CardBean.SUPPORT_ZONE_ID)
				continue;
			Vector<CardAbilityBean> vec = CardAbilityStoreBean.GetInstance().getCardAbility(card.getCardID());
			for(int i=0;i<vec.size();i++){
				CardAbilityBean ability = vec.get(i);
				if(ability.getType()!=type)
					continue;
				if(ability.IsWhichMatch(which))
					return true;
			}
		}
		return false;
	}
}