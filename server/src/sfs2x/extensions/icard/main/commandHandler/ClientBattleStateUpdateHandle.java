package sfs2x.extensions.icard.main.commandHandler;

import com.icard.user.CardUser;
import com.icard.user.CardUserManager;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

import sfs2x.extensions.icard.bsn.*;
import sfs2x.extensions.icard.beans.*;
import sfs2x.extensions.icard.utils.Commands;
public class ClientBattleStateUpdateHandle extends ICardClientRequestHandler {

	@Override
	public void handleClientRequest(User sender, ISFSObject paramISFSObject) {
		//int statVal = paramISFSObject.getInt("state");

		int playerID = sender.getId();
		//SFSExtension this.getParentExtension()
		CardGameBean newGame = GameBsn.CreateVSAIGame();
		
		if(newGame!=null)
		{
			Integer ai=0;
			for (CardSiteBean site : newGame.getSites().values())
			{
				ai = site.getPlayerID();
				break;
			}
			newGame.AddPlayer(playerID);	
			ISFSObject params = new SFSObject();
			params.putInt("me", playerID);
			params.putInt("you", ai.intValue());
			send(Commands.CMD_S2C_GAME_START, params, sender);
			
		}
		else
		{
			SendErrorMsg(sender,"Fail to Create Game!");
		}
	}

}