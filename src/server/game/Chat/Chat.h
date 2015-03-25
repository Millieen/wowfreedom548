/*
 * Copyright (C) 2011-2015 Project SkyFire <http://www.projectskyfire.org/>
 * Copyright (C) 2008-2015 TrinityCore <http://www.trinitycore.org/>
 * Copyright (C) 2005-2015 MaNGOS <http://getmangos.com/>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 3 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef TRINITYCORE_CHAT_H
#define TRINITYCORE_CHAT_H

#include "SharedDefines.h"
#include "WorldSession.h"
#include "RBAC.h"

#include <vector>

class ChatHandler;
class Creature;
class Group;
class Player;
class Unit;
class WorldSession;
class WorldObject;

struct GameTele;

#define MSG_COLOR_ALICEBLUE "|cFFF0F8FF"
#define MSG_COLOR_ANTIQUEWHITE "|cFFFAEBD7"
#define MSG_COLOR_AQUA "|cFF00FFFF"
#define MSG_COLOR_AQUAMARINE "|cFF7FFFD4"
#define MSG_COLOR_AZURE "|cFFF0FFFF"
#define MSG_COLOR_BEIGE "|cFFF5F5DC"
#define MSG_COLOR_BISQUE "|cFFFFE4C4"
#define MSG_COLOR_BLACK "|cFF000000"
#define MSG_COLOR_BLANCHEDALMOND "|cFFFFEBCD"
#define MSG_COLOR_BLUE "|cFF0000FF"
#define MSG_COLOR_BLUEVIOLET "|cFF8A2BE2"
#define MSG_COLOR_BROWN "|cFFA52A2A"
#define MSG_COLOR_BURLYWOOD "|cFFDEB887"
#define MSG_COLOR_CADETBLUE "|cFF5F9EA0"
#define MSG_COLOR_CHARTREUSE "|cFF7FFF00"
#define MSG_COLOR_CHOCOLATE "|cFFD2691E"
#define MSG_COLOR_CORAL "|cFFFF7F50"
#define MSG_COLOR_CORNFLOWERBLUE "|cFF6495ED"
#define MSG_COLOR_CORNSILK "|cFFFFF8DC"
#define MSG_COLOR_CRIMSON "|cFFDC143C"
#define MSG_COLOR_CYAN "|cFF00FFFF"
#define MSG_COLOR_DARKBLUE "|cFF00008B"
#define MSG_COLOR_DARKCYAN "|cFF008B8B"
#define MSG_COLOR_DARKGOLDENROD "|cFFB8860B"
#define MSG_COLOR_DARKGRAY "|cFFA9A9A9"
#define MSG_COLOR_DARKGREEN "|cFF006400"
#define MSG_COLOR_DARKKHAKI "|cFFBDB76B"
#define MSG_COLOR_DARKMAGENTA "|cFF8B008B"
#define MSG_COLOR_DARKOLIVEGREEN "|cFF556B2F"
#define MSG_COLOR_DARKORANGE "|cFFFF8C00"
#define MSG_COLOR_DARKORCHID "|cFF9932CC"
#define MSG_COLOR_DARKRED "|cFF8B0000"
#define MSG_COLOR_DARKSALMON "|cFFE9967A"
#define MSG_COLOR_DARKSEAGREEN "|cFF8FBC8B"
#define MSG_COLOR_DARKSLATEBLUE "|cFF483D8B"
#define MSG_COLOR_DARKSLATEGRAY "|cFF2F4F4F"
#define MSG_COLOR_DARKTURQUOISE "|cFF00CED1"
#define MSG_COLOR_DARKVIOLET "|cFF9400D3"
#define MSG_COLOR_DEEPPINK "|cFFFF1493"
#define MSG_COLOR_DEEPSKYBLUE "|cFF00BFFF"
#define MSG_COLOR_DIMGRAY "|cFF696969"
#define MSG_COLOR_DODGERBLUE "|cFF1E90FF"
#define MSG_COLOR_FIREBRICK "|cFFB22222"
#define MSG_COLOR_FLORALWHITE "|cFFFFFAF0"
#define MSG_COLOR_FORESTGREEN "|cFF228B22"
#define MSG_COLOR_FUCHSIA "|cFFFF00FF"
#define MSG_COLOR_GAINSBORO "|cFFDCDCDC"
#define MSG_COLOR_GHOSTWHITE "|cFFF8F8FF"
#define MSG_COLOR_GOLD "|cFFFFD700"
#define MSG_COLOR_GOLDENROD "|cFFDAA520"
#define MSG_COLOR_GRAY "|cFF808080"
#define MSG_COLOR_GREEN "|cFF008000"
#define MSG_COLOR_GREENYELLOW "|cFFADFF2F"
#define MSG_COLOR_HONEYDEW "|cFFF0FFF0"
#define MSG_COLOR_HOTPINK "|cFFFF69B4"
#define MSG_COLOR_INDIANRED "|cFFCD5C5C"
#define MSG_COLOR_INDIGO "|cFF4B0082"
#define MSG_COLOR_IVORY "|cFFFFFFF0"
#define MSG_COLOR_KHAKI "|cFFF0E68C"
#define MSG_COLOR_LAVENDER "|cFFE6E6FA"
#define MSG_COLOR_LAVENDERBLUSH "|cFFFFF0F5"
#define MSG_COLOR_LAWNGREEN "|cFF7CFC00"
#define MSG_COLOR_LEMONCHIFFON "|cFFFFFACD"
#define MSG_COLOR_LIGHTBLUE "|cFFADD8E6"
#define MSG_COLOR_LIGHTCORAL "|cFFF08080"
#define MSG_COLOR_LIGHTCYAN "|cFFE0FFFF"
#define MSG_COLOR_LIGHTGRAY "|cFFD3D3D3"
#define MSG_COLOR_LIGHTGREEN "|cFF90EE90"
#define MSG_COLOR_LIGHTPINK "|cFFFFB6C1"
#define MSG_COLOR_LIGHTRED "|cFFFF6060"
#define MSG_COLOR_LIGHTSALMON "|cFFFFA07A"
#define MSG_COLOR_LIGHTSEAGREEN "|cFF20B2AA"
#define MSG_COLOR_LIGHTSKYBLUE "|cFF87CEFA"
#define MSG_COLOR_LIGHTSLATEGRAY "|cFF778899"
#define MSG_COLOR_LIGHTSTEELBLUE "|cFFB0C4DE"
#define MSG_COLOR_LIGHTYELLOW "|cFFFFFFE0"
#define MSG_COLOR_LIME "|cFF00FF00"
#define MSG_COLOR_LIMEGREEN "|cFF32CD32"
#define MSG_COLOR_LINEN "|cFFFAF0E6"
#define MSG_COLOR_MAGENTA "|cFFFF00FF"
#define MSG_COLOR_MAROON "|cFF800000"
#define MSG_COLOR_MEDIUMAQUAMARINE "|cFF66CDAA"
#define MSG_COLOR_MEDIUMBLUE "|cFF0000CD"
#define MSG_COLOR_MEDIUMORCHID "|cFFBA55D3"
#define MSG_COLOR_MEDIUMPURPLE "|cFF9370DB"
#define MSG_COLOR_MEDIUMSEAGREEN "|cFF3CB371"
#define MSG_COLOR_MEDIUMSLATEBLUE "|cFF7B68EE"
#define MSG_COLOR_MEDIUMSPRINGGREEN "|cFF00FA9A"
#define MSG_COLOR_MEDIUMTURQUOISE "|cFF48D1CC"
#define MSG_COLOR_MEDIUMVIOLETRED "|cFFC71585"
#define MSG_COLOR_MIDNIGHTBLUE "|cFF191970"
#define MSG_COLOR_MINTCREAM "|cFFF5FFFA"
#define MSG_COLOR_MISTYROSE "|cFFFFE4E1"
#define MSG_COLOR_MOCCASIN "|cFFFFE4B5"
#define MSG_COLOR_NAVAJOWHITE "|cFFFFDEAD"
#define MSG_COLOR_NAVY "|cFF000080"
#define MSG_COLOR_OLDLACE "|cFFFDF5E6"
#define MSG_COLOR_OLIVE "|cFF808000"
#define MSG_COLOR_OLIVEDRAB "|cFF6B8E23"
#define MSG_COLOR_ORANGE "|cFFFFA500"
#define MSG_COLOR_ORANGEY "|cFFFF4500"
#define MSG_COLOR_ORCHID "|cFFDA70D6"
#define MSG_COLOR_PALEGOLDENROD "|cFFEEE8AA"
#define MSG_COLOR_PALEGREEN "|cFF98FB98"
#define MSG_COLOR_PALETURQUOISE "|cFFAFEEEE"
#define MSG_COLOR_PALEVIOLETRED "|cFFDB7093"
#define MSG_COLOR_PAPAYAWHIP "|cFFFFEFD5"
#define MSG_COLOR_PEACHPUFF "|cFFFFDAB9"
#define MSG_COLOR_PERU "|cFFCD853F"
#define MSG_COLOR_PINK "|cFFFFC0CB"
#define MSG_COLOR_PLUM "|cFFDDA0DD"
#define MSG_COLOR_POWDERBLUE "|cFFB0E0E6"
#define MSG_COLOR_PURPLE "|cFF800080"
#define MSG_COLOR_RED "|cFFFF0000"
#define MSG_COLOR_ROSYBROWN "|cFFBC8F8F"
#define MSG_COLOR_ROYALBLUE "|cFF4169E1"
#define MSG_COLOR_SADDLEBROWN "|cFF8B4513"
#define MSG_COLOR_SALMON "|cFFFA8072"
#define MSG_COLOR_SANDYBROWN "|cFFF4A460"
#define MSG_COLOR_SEAGREEN "|cFF2E8B57"
#define MSG_COLOR_SEASHELL "|cFFFFF5EE"
#define MSG_COLOR_SIENNA "|cFFA0522D"
#define MSG_COLOR_SILVER "|cFFC0C0C0"
#define MSG_COLOR_SKYBLUE "|cFF87CEEB"
#define MSG_COLOR_SLATEBLUE "|cFF6A5ACD"
#define MSG_COLOR_SLATEGRAY "|cFF708090"
#define MSG_COLOR_SNOW "|cFFFFFAFA"
#define MSG_COLOR_SPRINGGREEN "|cFF00FF7F"
#define MSG_COLOR_STEELBLUE "|cFF4682B4"
#define MSG_COLOR_SUBWHITE "|cFFBBBBBB"
#define MSG_COLOR_TAN "|cFFD2B48C"
#define MSG_COLOR_TEAL "|cFF008080"
#define MSG_COLOR_THISTLE "|cFFD8BFD8"
#define MSG_COLOR_TOMATO "|cFFFF6347"
#define MSG_COLOR_TRANSPARENT "|c00FFFFFF"
#define MSG_COLOR_TURQUOISE "|cFF40E0D0"
#define MSG_COLOR_VIOLET "|cFFEE82EE"
#define MSG_COLOR_WHEAT "|cFFF5DEB3"
#define MSG_COLOR_WHITE "|cFFFFFFFF"
#define MSG_COLOR_WHITESMOKE "|cFFF5F5F5"
#define MSG_COLOR_YELLOW "|cFFFFFF00"
#define MSG_COLOR_YELLOWGREEN "|cFF9ACD32"


class ChatCommand
{
    public:
        const char *       Name;
        uint32             Permission;                   // function pointer required correct align (use uint32)
        bool               AllowConsole;
        bool (*Handler)(ChatHandler*, const char* args);
        std::string        Help;
        ChatCommand*      ChildCommands;
};

class ChatHandler
{
    public:
        WorldSession* GetSession() { return m_session; }
        explicit ChatHandler(WorldSession* session) : m_session(session), sentErrorMessage(false) { }
        virtual ~ChatHandler() { }

        // Builds chat packet and returns receiver guid position in the packet to substitute in whisper builders
        static size_t BuildChatPacket(WorldPacket& data, ChatMsg chatType, Language language, ObjectGuid senderGUID, ObjectGuid receiverGUID, std::string const& message, uint8 chatTag,
        std::string const& senderName = "", std::string const& receiverName = "",
        uint32 achievementId = 0, bool gmMessage = false, std::string const& channelName = "", std::string const& addonPrefix = "");

        // Builds chat packet and returns receiver guid position in the packet to substitute in whisper builders
        static size_t BuildChatPacket(WorldPacket& data, ChatMsg chatType, Language language, WorldObject const* sender, WorldObject const* receiver, std::string const& message, uint32 achievementId = 0, std::string const& channelName = "", LocaleConstant locale = DEFAULT_LOCALE, std::string const& addonPrefix = "");


        static char* LineFromMessage(char*& pos) { char* start = strtok(pos, "\n"); pos = NULL; return start; }

        // function with different implementation for chat/console
        virtual const char *GetTrinityString(int32 entry) const;
        virtual void SendSysMessage(const char *str);

        void SendSysMessage(int32     entry);
        void PSendSysMessage(const char *format, ...) ATTR_PRINTF(2, 3);
        void PSendSysMessage(int32     entry, ...);
        std::string PGetParseString(int32 entry, ...) const;

        bool ParseCommands(const char* text);

        static ChatCommand* getCommandTable();

        bool isValidChatMessage(const char* msg);
        void SendGlobalSysMessage(const char *str);

        bool hasStringAbbr(const char* name, const char* part);

        // function with different implementation for chat/console
        virtual bool isAvailable(ChatCommand const& cmd) const;
        virtual bool HasPermission(uint32 permission) const { return m_session->HasPermission(permission); }
        virtual std::string GetNameLink() const { return GetNameLink(m_session->GetPlayer()); }
        virtual bool needReportToTarget(Player* chr) const;
        virtual LocaleConstant GetSessionDbcLocale() const;
        virtual int GetSessionDbLocaleIndex() const;

        bool HasLowerSecurity(Player* target, uint64 guid, bool strong = false);
        bool HasLowerSecurityAccount(WorldSession* target, uint32 account, bool strong = false);

        void SendGlobalGMSysMessage(const char *str);
        Player*   getSelectedPlayer();
        Creature* getSelectedCreature();
        Unit*     getSelectedUnit();
        WorldObject* getSelectedObject();

        char*     extractKeyFromLink(char* text, char const* linkType, char** something1 = NULL);
        char*     extractKeyFromLink(char* text, char const* const* linkTypes, int* found_idx, char** something1 = NULL);

        // if args have single value then it return in arg2 and arg1 == NULL
        void      extractOptFirstArg(char* args, char** arg1, char** arg2);
        char*     extractQuotedArg(char* args);

        uint32    extractSpellIdFromLink(char* text);
        uint64    extractGuidFromLink(char* text);
        GameTele const* extractGameTeleFromLink(char* text);
        bool GetPlayerGroupAndGUIDByName(const char* cname, Player* &player, Group* &group, uint64 &guid, bool offline = false);
        std::string extractPlayerNameFromLink(char* text);
        // select by arg (name/link) or in-game selection online/offline player
        bool extractPlayerTarget(char* args, Player** player, uint64* player_guid = NULL, std::string* player_name = NULL);

        std::string playerLink(std::string const& name) const { return m_session ? "|cffffffff|Hplayer:"+name+"|h["+name+"]|h|r" : name; }
        std::string GetNameLink(Player* chr) const;

        GameObject* GetNearbyGameObject();
        GameObject* GetObjectGlobalyWithGuidOrNearWithDbGuid(uint32 lowguid, uint32 entry);
        bool HasSentErrorMessage() const { return sentErrorMessage; }
        void SetSentErrorMessage(bool val){ sentErrorMessage = val; }
        static bool LoadCommandTable() { return load_command_table; }
        static void SetLoadCommandTable(bool val) { load_command_table = val; }

        bool ShowHelpForCommand(ChatCommand* table, const char* cmd);
    protected:
        explicit ChatHandler() : m_session(NULL), sentErrorMessage(false) { }     // for CLI subclass
        static bool SetDataForCommandInTable(ChatCommand* table, const char* text, uint32 permission, std::string const& help, std::string const& fullcommand);
        bool ExecuteCommandInTable(ChatCommand* table, const char* text, std::string const& fullcmd);
        bool ShowHelpForSubCommands(ChatCommand* table, char const* cmd, char const* subcmd);

    private:
        WorldSession* m_session;                           // != NULL for chat command call and NULL for CLI command

        // common global flag
        static bool load_command_table;
        bool sentErrorMessage;
};

class CliHandler : public ChatHandler
{
    public:
        typedef void Print(void*, char const*);
        explicit CliHandler(void* callbackArg, Print* zprint) : m_callbackArg(callbackArg), m_print(zprint) { }

        // overwrite functions
        const char *GetTrinityString(int32 entry) const;
        bool isAvailable(ChatCommand const& cmd) const;
        bool HasPermission(uint32 /*permission*/) const { return true; }
        void SendSysMessage(const char *str);
        std::string GetNameLink() const;
        bool needReportToTarget(Player* chr) const;
        LocaleConstant GetSessionDbcLocale() const;
        int GetSessionDbLocaleIndex() const;

    private:
        void* m_callbackArg;
        Print* m_print;
};

#endif
