#include "ScriptMgr.h"
#include "ObjectMgr.h"
#include "Chat.h"
#include "AccountMgr.h"
#include "Language.h"
#include "World.h"
#include "Player.h"
#include "Opcodes.h"

#define DEFAULT_SUBGROUP "MAIN"

class fraid_commandscript : public CommandScript
{
public:
    fraid_commandscript() : CommandScript("fraid_commandscript") { }

    ChatCommand* GetCommands() const
    {
        static ChatCommand partyCommandTable[] =
        {
            { "say",                rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandlePartySayCommand,              "", NULL },
            { "warning",            rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandlePartyWarningCommand,          "", NULL },
            { NULL, 0, false, NULL, "", NULL }
        };

        static ChatCommand raidCommandTable[] =
        {
            { "create",             rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidCreateCommand,            "", NULL },
            { "disband",            rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidDisbandCommand,           "", NULL },
            { "invite",             rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidInviteCommand,            "", NULL },
            { "kick",               rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidKickCommand,              "", NULL },
            { "move",               rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidMoveCommand,              "", NULL },
            { "accept",             rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidAcceptCommand,            "", NULL },
            { "promote",            rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidPromoteCommand,           "", NULL },
            { "demote",             rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidDemoteCommand,            "", NULL },
            { "leader",             rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidLeaderCommand,            "", NULL },
            { "list",               rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidListCommand,              "", NULL },
            { "say",                rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidSayCommand,               "", NULL },
            { "warning",            rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidWarningCommand,           "", NULL },
            { NULL, 0, false, NULL, "", NULL }
        };

        static ChatCommand commandTable[] =
        {
            { "raid",               rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, NULL,                                "", raidCommandTable },
            { "party",              rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, NULL,                                "", partyCommandTable },
            { NULL, 0, false, NULL, "", NULL }
        };

        return commandTable;
    }

    #pragma region RAID COMMAND REGION

    static bool HandleRaidCreateCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();
        PreparedStatement* stmt;
        PreparedQueryResult result;

        // check if already in raid
        stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_RAID_BY_MEMBER);
        stmt->setUInt32(0, source_guid);
        result = WorldDatabase.Query(stmt);

        if (result)
        {
            handler->PSendSysMessage("> You are already in a raid. To create a new one, you need to leave/disband your current raid group.");
            return true;
        }

        // create new raid entry and set cmd executor as leader
        stmt = WorldDatabase.GetPreparedStatement(WORLD_INS_RAID);
        stmt->setUInt32(0, source_guid);
        stmt->setUInt32(1, source_guid);
        stmt->setString(2, DEFAULT_SUBGROUP);
        stmt->setUInt8(3, 1); // 1: assistant perms, 0: no assistant perms
        WorldDatabase.Execute(stmt);

        handler->PSendSysMessage("> Raid group successfully created.");
        return true;
    }

    static bool HandleRaidDisbandCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();
        PreparedStatement* stmt;
        PreparedQueryResult result;

        // check if leader
        stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_RAID_IS_LEADER);
        stmt->setUInt32(0, source_guid);
        result = WorldDatabase.Query(stmt);

        if (!result)
        {
            handler->PSendSysMessage("> You must be in a raid group AND you need to be the leader of that raid group.");
            return true;
        }

        // delete raid group entries
        stmt = WorldDatabase.GetPreparedStatement(WORLD_DEL_RAID_ALL);
        stmt->setUInt32(0, source_guid);
        WorldDatabase.Execute(stmt);

        handler->PSendSysMessage("> Raid group successfully disbanded.");
        return true;
    }

    static bool HandleRaidInviteCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    static bool HandleRaidKickCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    static bool HandleRaidMoveCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    static bool HandleRaidAcceptCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    static bool HandleRaidPromoteCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    static bool HandleRaidDemoteCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    static bool HandleRaidLeaderCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    static bool HandleRaidListCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    static bool HandleRaidSayCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    static bool HandleRaidWarningCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    #pragma endregion

    #pragma region PARTY COMMAND REGION

    static bool HandlePartySayCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    static bool HandlePartyWarningCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    #pragma endregion
};

void AddSC_fraid_commandscript()
{
    new fraid_commandscript();
}