#include "ScriptMgr.h"
#include "ObjectMgr.h"
#include "Chat.h"
#include "AccountMgr.h"
#include "Language.h"
#include "World.h"
#include "Player.h"
#include "Opcodes.h"

class fraid_commandscript : public CommandScript
{
public:
    fraid_commandscript() : CommandScript("fraid_commandscript") { }

    ChatCommand* GetCommands() const
    {
        static ChatCommand partyCommandTable[] =
        {
            { "create",             rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandlePartyCreateCommand,           "", NULL },
            { "disband",            rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandlePartyDisbandCommand,          "", NULL },
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
            { "accept",             rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidAcceptCommand,            "", NULL },
            { "assist",             rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidAssistCommand,            "", NULL },
            { "leader",             rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidLeaderCommand,            "", NULL },
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
        return true;
    }

    static bool HandleRaidDisbandCommand(ChatHandler* handler, char const* args)
    {
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

    static bool HandleRaidAcceptCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    static bool HandleRaidAssistCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    static bool HandleRaidLeaderCommand(ChatHandler* handler, char const* args)
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

    static bool HandlePartyCreateCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

    static bool HandlePartyDisbandCommand(ChatHandler* handler, char const* args)
    {
        return true;
    }

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