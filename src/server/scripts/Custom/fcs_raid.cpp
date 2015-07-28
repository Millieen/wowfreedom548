#include "ScriptMgr.h"
#include "ObjectMgr.h"
#include "Chat.h"
#include "World.h"
#include "Player.h"

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
            { NULL, 0, false, NULL, "", NULL }
        };

        static ChatCommand raidCommandTable[] =
        {
            { "create",             rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidCreateCommand,            "", NULL },
            { "disband",            rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidDisbandCommand,           "", NULL },
            { "invite",             rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidInviteCommand,            "", NULL },
            { "accept",             rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidAcceptCommand,            "", NULL },
            { "leave",              rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidLeaveCommand,             "", NULL },
            { "kick",               rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidKickCommand,              "", NULL },
            { "move",               rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidMoveCommand,              "", NULL },
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

        // cant be already in raid
        if (IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are already in a raid. To create a new one, you need to leave/disband your current raid group.");
            return true;
        }
        else
        {
            InsertRaidMember(source_guid, source_guid, 1);
            handler->PSendSysMessage("Raid group successfully created.");
            return true;
        }
    }

    static bool HandleRaidDisbandCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();

        if (!IsRaidLeader(source_guid))
        {
            handler->PSendSysMessage("You must be in a raid group AND you need to be the leader of that raid group.");
            return true;
        }

        // delete raid group entries
        DeleteRaid(source_guid);

        handler->PSendSysMessage("Raid group successfully disbanded.");
        return true;
    }

    static bool HandleRaidInviteCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();

        // target can't be in raid
        if (!IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You must first create a raid group to invite people.");
            return true;
        }

        // executor needs to be assistant or leader to invite
        if (!IsAssistant(source_guid))
        {
            handler->PSendSysMessage("You need to be assistant or raid leader to invite people.");
            return true;
        }

        // get target
        Player* target;
        handler->extractPlayerTarget((char*)args, &target);

        if (!target)
        {
            handler->PSendSysMessage("Target not found or not online.");
            return true;
        }

        uint32 target_guid = target->GetGUIDLow();

        // target can't be in already existing raid group
        if (IsInRaid(target_guid))
        {
            handler->PSendSysMessage("Target is already in a raid.");
            return true;
        }

        target->SetRaidInviteLeaderGuid(GetLeaderGuid(source_guid));
        target->SetRaidInviteExpire(time(NULL) + 5*MINUTE);

        handler->PSendSysMessage("Invite sent to %s.", handler->GetNameLink(target).c_str());
        ChatHandler(target->GetSession()).PSendSysMessage("> Received raid invite from %s. Type '.raid accept' (without quotes) to accept it.", handler->GetNameLink().c_str());

        return true;
    }

    static bool HandleRaidAcceptCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();
        uint32 leader_guid = source->GetRaidInviteLeaderGuid();

        // if expired
        if (source->GetRaidInviteExpire() <= time(NULL))
        {
            handler->PSendSysMessage("Your last raid invite has expired.");
            return true;
        }

        // if raid group does not exist or its leader changed
        if (!IsInRaid(leader_guid) || !IsRaidLeader(leader_guid))
        {
            handler->PSendSysMessage("Raid group no longer exists or it's leader has recently changed.");
            return true;
        }

        InsertRaidMember(leader_guid, source_guid, 0);
        BroadcastRaidMsg(handler, leader_guid, "Player " + handler->GetNameLink(source) + " has joined the raid.", CHAT_MSG_SYSTEM);
        handler->PSendSysMessage("Successfully joined the raid.");
        return true;
    }

    static bool HandleRaidLeaveCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();

        // if not in raid
        if (!IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are not in a raid party.");
            return true;
        }

        // raid leaders cant leave, instead they can disband
        if (IsRaidLeader(source_guid))
        {
            handler->PSendSysMessage("You can't leave raid group as raid leader. Make someone else a raid leader or disband raid.");
            return true;
        }

        uint32 leader_guid = GetLeaderGuid(source_guid);

        DeleteMember(source_guid);

        BroadcastRaidMsg(handler, leader_guid, "Player " + handler->GetNameLink() + " has left the raid.", CHAT_MSG_SYSTEM);

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
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();

        // need to say something
        if (!*args)
        {
            handler->PSendSysMessage("Command needs text to display.");
            return true;
        }

        // need to be in raid to use raid chat
        if (!IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are not in a raid party.");
            return true;
        }
        
        // broadcast raid say
        uint32 leader_guid = GetLeaderGuid(source_guid);
        std::string msg = (char*)args;
        ChatMsg msg_type = leader_guid == source_guid ? CHAT_MSG_RAID_LEADER : CHAT_MSG_RAID;
        BroadcastRaidMsg(handler, leader_guid, msg, msg_type);

        return true;
    }

    static bool HandleRaidWarningCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();

        // need to say something
        if (!*args)
        {
            handler->PSendSysMessage("Command needs text to display.");
            return true;
        }

        // need to be in raid to use raid chat
        if (!IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are not in a raid party.");
            return true;
        }

        // need to be assistant or leader to use raid warning
        if (!IsAssistant(source_guid))
        {
            handler->PSendSysMessage("You need to have assistant permissions of the raid to execute raid warnings.");
            return true;
        }

        // broadcast raid say
        uint32 leader_guid = GetLeaderGuid(source_guid);
        std::string msg = (char*)args;
        BroadcastRaidMsg(handler, leader_guid, msg, CHAT_MSG_RAID_WARNING);

        return true;
    }

    #pragma endregion

    #pragma region PARTY COMMAND REGION

    static bool HandlePartySayCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();

        // need to say something
        if (!*args)
        {
            handler->PSendSysMessage("Command needs text to display.");
            return true;
        }

        // need to be in raid to use raid chat
        if (!IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are not in a raid party.");
            return true;
        }

        // broadcast raid say
        uint32 leader_guid = GetLeaderGuid(source_guid);
        std::string subgroup = GetSubgroup(source_guid);
        std::string msg = (char*)args;
        BroadcastPartyMsg(handler, leader_guid, subgroup, msg, CHAT_MSG_PARTY);

        return true;
    }

    #pragma endregion

private:
    #pragma region RAID HELPERS

    static void BroadcastRaidMsg(ChatHandler* handler, uint32 leader_guid, std::string const msg, ChatMsg msg_type)
    {
        PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_RAID_MEMBERS);
        stmt->setUInt32(0, leader_guid);
        PreparedQueryResult result = WorldDatabase.Query(stmt);
        WorldPacket data;
        ChatHandler::BuildChatPacket(data, msg_type, LANG_UNIVERSAL, handler->GetSession()->GetPlayer(), NULL, msg);

        if (result)
        {
            do
            {
                Field* fields = result->Fetch();
                uint32 target_guid = fields[1].GetUInt32();
                Player* target = sObjectMgr->GetPlayerByLowGUID(target_guid);
                if (target)
                {
                    target->GetSession()->SendPacket(&data);
                }
            } while (result->NextRow());
        }
    }

    static void BroadcastPartyMsg(ChatHandler* handler, uint32 leader_guid, std::string const subgroup, std::string const msg, ChatMsg msg_type)
    {
        PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_RAID_SUBGROUP_MEMBERS);
        stmt->setString(0, subgroup);
        stmt->setUInt32(1, leader_guid);
        PreparedQueryResult result = WorldDatabase.Query(stmt);
        WorldPacket data;
        ChatHandler::BuildChatPacket(data, msg_type, LANG_UNIVERSAL, handler->GetSession()->GetPlayer(), NULL, msg);

        if (result)
        {
            do
            {
                Field* fields = result->Fetch();
                uint32 target_guid = fields[1].GetUInt32();
                Player* target = sObjectMgr->GetPlayerByLowGUID(target_guid);
                if (target)
                {
                    target->GetSession()->SendPacket(&data);
                }
            } while (result->NextRow());
        }
    }

    static bool IsInRaid(uint32 player_guid)
    {
        PreparedStatement* stmt;
        PreparedQueryResult result;
        stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_RAID_BY_MEMBER);
        stmt->setUInt32(0, player_guid);
        result = WorldDatabase.Query(stmt);
        return result;
    }

    static bool IsRaidLeader(uint32 player_guid)
    {
        PreparedStatement* stmt;
        PreparedQueryResult result;
        stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_RAID_IS_LEADER);
        stmt->setUInt32(0, player_guid);
        result = WorldDatabase.Query(stmt);
        return result;
    }

    static bool IsAssistant(uint32 player_guid)
    {
        PreparedStatement* stmt;
        PreparedQueryResult result;
        stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_RAID_IS_ASSISTANT);
        stmt->setUInt32(0, player_guid);
        result = WorldDatabase.Query(stmt);
        return result;
    }

    static void InsertRaidMember(uint32 leader_guid, uint32 member_guid, uint8 assistant)
    {
        PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_INS_RAID);
        stmt->setUInt32(0, leader_guid);
        stmt->setUInt32(1, member_guid);
        stmt->setString(2, DEFAULT_SUBGROUP);
        stmt->setUInt8(3, assistant); // 1: assistant perms, 0: no assistant perms
        WorldDatabase.DirectExecute(stmt);
    }

    static void DeleteRaid(uint32 leader_guid)
    {
        PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_DEL_RAID_ALL);
        stmt->setUInt32(0, leader_guid);
        WorldDatabase.DirectExecute(stmt);
    }

    static void DeleteMember(uint32 member_guid)
    {
        PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_DEL_RAID_MEMBER);
        stmt->setUInt32(0, member_guid);
        WorldDatabase.DirectExecute(stmt);
    }

    static int GetLeaderGuid(uint32 player_guid)
    {
        PreparedStatement* stmt;
        PreparedQueryResult result;
        stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_RAID_BY_MEMBER);
        stmt->setUInt32(0, player_guid);
        result = WorldDatabase.Query(stmt);
        return result ? result->Fetch()[0].GetUInt32() : 0;
    }

    static std::string GetSubgroup(uint32 player_guid)
    {
        PreparedStatement* stmt;
        PreparedQueryResult result;
        stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_RAID_BY_MEMBER);
        stmt->setUInt32(0, player_guid);
        result = WorldDatabase.Query(stmt);
        return result ? result->Fetch()[2].GetString() : DEFAULT_SUBGROUP;
    }

    #pragma endregion
};

void AddSC_fraid_commandscript()
{
    new fraid_commandscript();
}