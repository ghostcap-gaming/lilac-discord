#include <sourcemod>
#include <discord>
#include <lilac>

#define WEBHOOK ""

char g_sServerName[256];

public Plugin myinfo = 
{
	name = "[LilAC] Discord",
	author = "Cruze",
	description = "Send a webhook when cheater is detected.",
	version = "1.1",
	url = "https://github.com/Cruze03"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_la_discord_test", Command_Test, ADMFLAG_ROOT);
}

public void OnMapStart()
{
	FindConVar("hostname").GetString(g_sServerName, 256);
}

public Action Command_Test(int client, int args)
{
	lilac_cheater_detected(client, GetRandomInt(0, 10));
	return Plugin_Handled;
}

public void lilac_cheater_detected(int client, int cheat)
{
	if(!IsClientConnected(client) || !IsClientInGame(client) || IsFakeClient(client))
		return;
	
	char sName[MAX_NAME_LENGTH], sSteamID32[32], sSteamID64[32], buffer[128];
	
	GetClientAuthId(client, AuthId_Steam2, sSteamID32, 32);
	GetClientAuthId(client, AuthId_SteamID64, sSteamID64, 32);
	GetClientName(client, sName, sizeof(sName));
	Discord_EscapeString(sName, sizeof(sName));
	
	
	DiscordWebHook hook = new DiscordWebHook(WEBHOOK);
	
	hook.SlackMode = true;
	
	hook.SetUsername("LilAC");

	//hook.SetAvatar( "" );
	
	MessageEmbed embed = new MessageEmbed();
	
	embed.SetColor("#6DDBE8");

	embed.SetTitle("Possible Cheater");
	
	Format(buffer, sizeof(buffer), sName);
	
	embed.AddField("Name:", buffer, true);
	
	Format(buffer, sizeof(buffer), "[%s](http://www.steamcommunity.com/profiles/%s)", sSteamID32, sSteamID64);
	
	embed.AddField("SteamID:", buffer, true);
	
	GetClientIP(client, buffer, sizeof(buffer));
	
	if(!buffer[0])
	{
		Format(buffer, sizeof(buffer), "Could not be retrieved.");
	}
	
	embed.AddField("IP:", buffer, true);
	
	switch(cheat)
	{
		case 0:
		{
			Format(buffer, sizeof(buffer), "Angles Cheat");
		}
		case 1:
		{
			Format(buffer, sizeof(buffer), "Chat Clear Cheat");
		}
		case 2:
		{
			Format(buffer, sizeof(buffer), "Convar Cheat");
		}
		case 3:
		{
			Format(buffer, sizeof(buffer), "Nolerp Cheat");
		}
		case 4:
		{
			Format(buffer, sizeof(buffer), "Bhop Cheat");
		}
		case 5:
		{
			Format(buffer, sizeof(buffer), "Aimbot");
		}
		case 6:
		{
			Format(buffer, sizeof(buffer), "Aimlock");
		}
		case 7:
		{
			Format(buffer, sizeof(buffer), "Anti Duck Delay Cheat");
		}
		case 8:
		{
			Format(buffer, sizeof(buffer), "Noisemaker Spam Cheat");
		}
		case 9:
		{
			Format(buffer, sizeof(buffer), "Macro");
		}
		case 10:
		{
			Format(buffer, sizeof(buffer), "Multi-line Name Cheat");
		}
	}
	
	embed.AddField("Type:", buffer, true);
	
	embed.SetFooter( g_sServerName );
	
	hook.Embed(embed);
	hook.Send();
	
	delete hook;
}

stock void Discord_EscapeString(char[] string, int maxlen, bool name = false)
{
	if(name)
	{
		ReplaceString(string, maxlen, "everyone", "everyonｅ");
		ReplaceString(string, maxlen, "here", "herｅ");
		ReplaceString(string, maxlen, "discordtag", "dｉscordtag");
	}
	ReplaceString(string, maxlen, "#", "＃");
	ReplaceString(string, maxlen, "@", "＠");
	//ReplaceString(string, maxlen, ":", "");
	ReplaceString(string, maxlen, "_", "ˍ");
	ReplaceString(string, maxlen, "'", "＇");
	ReplaceString(string, maxlen, "`", "＇");
	ReplaceString(string, maxlen, "~", "∽");
	ReplaceString(string, maxlen, "\"", "＂");
}