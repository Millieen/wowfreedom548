#include "ScriptMgr.h"
#include "ObjectMgr.h"
#include "Chat.h"
#include "World.h"
#include "Player.h"
#include "Group.h"
#include "Language.h"

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
            { "unlock",             rbac::RBAC_PERM_COMMAND_FREEDOM_RAID,               false, &HandleRaidUnlockCommand,           "", NULL },
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
        if (FRaid::IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are already in a raid. To create a new one, you need to leave/disband your current raid group.");
            return true;
        }
        else
        {
            FRaid::InsertRaidMember(source_guid, source_guid, 1);
            handler->PSendSysMessage("Raid group successfully created.");
            return true;
        }
    }

    static bool HandleRaidDisbandCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();
        

        if (!FRaid::IsRaidLeader(source_guid))
        {
            handler->PSendSysMessage("You must be in a raid group AND you need to be the leader of that raid group.");
            return true;
        }

        // delete raid group entries
        FRaid::DeleteRaid(source_guid);

        handler->PSendSysMessage("Raid group successfully disbanded.");
        return true;
    }

    static bool HandleRaidInviteCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();

        // target can't be in raid
        if (!FRaid::IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You must first create a raid group to invite people.");
            return true;
        }

        // executor needs to be assistant or leader to invite
        if (!FRaid::IsAssistant(source_guid))
        {
            handler->PSendSysMessage("You need to be assistant or raid leader to perform this command.");
            return true;
        }

        // get target
        Player* target;
        handler->extractPlayerTarget((char*)args, &target);

        if (!target)
        {
            return true;
        }

        uint32 target_guid = target->GetGUIDLow();

        // target can't be in already existing raid group
        if (FRaid::IsInRaid(target_guid))
        {
            handler->PSendSysMessage("Target is already in a raid.");
            return true;
        }

        target->SetRaidInviteLeaderGuid(FRaid::GetLeaderGuid(source_guid));
        target->SetRaidInviteExpire(time(NULL) + 5*MINUTE);

        handler->PSendSysMessage("%s has received your raid invite.", handler->GetNameLink(target).c_str());
        ChatHandler(target->GetSession()).PSendSysMessage("%s invited you to his raid. Type '.raid accept' (without quotes) to accept it.", handler->GetNameLink().c_str());

        return true;
    }

    static bool HandleRaidAcceptCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();
        uint32 leader_guid = source->GetRaidInviteLeaderGuid();

        // if expired
        if (source->GetRaidInviteExpire() < time(NULL))
        {
            handler->PSendSysMessage("Your last raid invite has expired.");
            return true;
        }

        source->SetRaidInviteExpire(time(NULL));
        source->SetRaidInviteLeaderGuid(0);

        // if raid group does not exist or its leader changed
        if (!FRaid::IsInRaid(leader_guid) || !FRaid::IsRaidLeader(leader_guid))
        {
            handler->PSendSysMessage("Raid group no longer exists or it's leader has recently changed.");
            return true;
        }

        FRaid::InsertRaidMember(leader_guid, source_guid, 0);
        FRaid::BroadcastRaidMsg(source, leader_guid, handler->GetNameLink(source) + " has joined the raid.", CHAT_MSG_SYSTEM);
        return true;
    }

    static bool HandleRaidLeaveCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();

        // if not in raid
        if (!FRaid::IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are not in a raid party.");
            return true;
        }

        // raid leaders cant leave, instead they can disband
        if (FRaid::IsRaidLeader(source_guid))
        {
            handler->PSendSysMessage("You can't leave raid group as raid leader. Make someone else a raid leader or disband raid.");
            return true;
        }

        uint32 leader_guid = FRaid::GetLeaderGuid(source_guid);

        FRaid::DeleteMember(source_guid);

        FRaid::BroadcastRaidMsg(source, leader_guid, handler->GetNameLink() + " has left the raid.", CHAT_MSG_SYSTEM);
        handler->PSendSysMessage("Successfully left the raid.");

        return true;
    }

    static bool HandleRaidKickCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();

        if (!FRaid::IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are not in a raid party.");
            return true;
        }

        if (!FRaid::IsAssistant(source_guid))
        {
            handler->PSendSysMessage("You need to have assistant permissions of the raid to perform this command.");
            return true;
        }

        // get target
        uint32 target_guid;
        std::string target_name;
        Player* target = NULL;
        if (!*args)
        {
            handler->extractPlayerTarget((char*)args, &target);
            if (!target)
                return true;
            target_guid = target->GetGUIDLow();
            target_name = target->GetName();
        }
        else
        {
            target_name = args;
            target_guid = GUID_LOPART(sObjectMgr->GetPlayerGUIDByName(args));
            target = sObjectMgr->GetPlayerByLowGUID(target_guid);
            if (!target_guid)
            {
                handler->SendSysMessage(LANG_PLAYER_NOT_FOUND);
                return true;
            }
        }

        uint32 leader_guid = FRaid::GetLeaderGuid(source_guid);

        if (leader_guid != FRaid::GetLeaderGuid(target_guid))
        {
            handler->PSendSysMessage("Target not in your raid.");
            return true;
        }

        if (source_guid == target_guid)
        {
            handler->PSendSysMessage("Can't kick yourself.");
            return true;
        }

        if (FRaid::IsRaidLeader(target_guid))
        {
            handler->PSendSysMessage("Can't kick raid leader.");
            return true;
        }

        if (FRaid::IsAssistant(target_guid) && !FRaid::IsRaidLeader(source_guid))
        {
            handler->PSendSysMessage("Only leader raid leader can kick assistants.");
            return true;
        }

        FRaid::DeleteMember(target_guid);
        if (handler->needReportToTarget(target))
            ChatHandler(target->GetSession()).PSendSysMessage("You have been kicked from the raid.");

        FRaid::BroadcastRaidMsg(source, leader_guid, handler->playerLink(target_name) + " has been kicked from the raid.", CHAT_MSG_SYSTEM);

        return true;
    }

    static bool HandleRaidMoveCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();
        char* params[2];

        // params:
        // [0] - required, subgroup name
        // [1] - optional, player name (will try to use targeted player without this param)
        params[0] = strtok((char*)args, " ");
        params[1] = strtok(NULL, " ");

        if (!params[0])
        {
            handler->PSendSysMessage("Not enough arguments. Syntax: .raid move $subgroupName [$playerName]");
            return true;
        }

        if (!FRaid::IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are not in a raid party.");
            return true;
        }

        if (!FRaid::IsAssistant(source_guid))
        {
            handler->PSendSysMessage("You need to have assistant permissions of the raid to perform this command.");
            return true;
        }

        // get target
        uint32 target_guid;
        std::string target_name;
        Player* target = NULL;
        if (!params[1])
        {
            handler->extractPlayerTarget(NULL, &target);
            if (!target)
                return true;
            target_guid = target->GetGUIDLow();
            target_name = target->GetName();
        }
        else
        {
            target_name = params[1];
            target_guid = GUID_LOPART(sObjectMgr->GetPlayerGUIDByName(params[1]));
            target = sObjectMgr->GetPlayerByLowGUID(target_guid);
            if (!target_guid)
            {
                handler->SendSysMessage(LANG_PLAYER_NOT_FOUND);
                return true;
            }
        }

        uint32 leader_guid = FRaid::GetLeaderGuid(source_guid);

        if (leader_guid != FRaid::GetLeaderGuid(target_guid))
        {
            handler->PSendSysMessage("Target not in your raid.");
            return true;
        }

        std::string old_subgroup = FRaid::GetSubgroup(target_guid);
        std::string new_subgroup = params[0];

        // capitalize letters for better consistency, since subgroup SQL queries are case-insensitive
        std::transform(new_subgroup.begin(), new_subgroup.end(), new_subgroup.begin(), toupper);

        FRaid::MoveMember(target_guid, new_subgroup);

        FRaid::BroadcastRaidMsg(source, leader_guid, handler->playerLink(target_name) +
            " has been moved from subgroup |cFF00ADEF" + old_subgroup + "|r to subgroup |cFF00ADEF" + new_subgroup + "|r.", CHAT_MSG_SYSTEM);
        return true;
    }

    static bool HandleRaidPromoteCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();

        if (!FRaid::IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are not in a raid party.");
            return true;
        }

        if (!FRaid::IsRaidLeader(source_guid))
        {
            handler->PSendSysMessage("You need to be leader of the raid to perform this command.");
            return true;
        }

        // get target
        uint32 target_guid;
        std::string target_name;
        Player* target = NULL;
        if (!*args)
        {
            handler->extractPlayerTarget((char*)args, &target);
            if (!target)
                return true;
            target_guid = target->GetGUIDLow();
            target_name = target->GetName();
        }
        else
        {
            target_name = args;
            target_guid = GUID_LOPART(sObjectMgr->GetPlayerGUIDByName(args));
            target = sObjectMgr->GetPlayerByLowGUID(target_guid);
            if (!target_guid)
            {
                handler->SendSysMessage(LANG_PLAYER_NOT_FOUND);
                return true;
            }
        }

        uint32 leader_guid = FRaid::GetLeaderGuid(source_guid);

        if (leader_guid != FRaid::GetLeaderGuid(target_guid))
        {
            handler->PSendSysMessage("Target not in your raid.");
            return true;
        }

        if (source_guid == target_guid)
        {
            handler->PSendSysMessage("Can't assist-promote yourself.");
            return true;
        }

        if (FRaid::IsAssistant(target_guid))
        {
            handler->PSendSysMessage("Target already is an assistant.");
            return true;
        }

        FRaid::UpdateAssist(target_guid, 1);

        FRaid::BroadcastRaidMsg(source, leader_guid, handler->playerLink(target_name) + " has been promoted to assistant.", CHAT_MSG_SYSTEM);
        return true;
    }

    static bool HandleRaidDemoteCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();

        if (!FRaid::IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are not in a raid party.");
            return true;
        }

        if (!FRaid::IsRaidLeader(source_guid))
        {
            handler->PSendSysMessage("You need to be leader of the raid to perform this command.");
            return true;
        }

        // get target
        uint32 target_guid;
        std::string target_name;
        Player* target = NULL;
        if (!*args)
        {
            handler->extractPlayerTarget((char*)args, &target);
            if (!target)
                return true;
            target_guid = target->GetGUIDLow();
            target_name = target->GetName();
        }
        else
        {
            target_name = args;
            target_guid = GUID_LOPART(sObjectMgr->GetPlayerGUIDByName(args));
            target = sObjectMgr->GetPlayerByLowGUID(target_guid);
            if (!target_guid)
            {
                handler->SendSysMessage(LANG_PLAYER_NOT_FOUND);
                return true;
            }
        }

        uint32 leader_guid = FRaid::GetLeaderGuid(source_guid);

        if (leader_guid != FRaid::GetLeaderGuid(target_guid))
        {
            handler->PSendSysMessage("Target not in your raid.");
            return true;
        }

        if (source_guid == target_guid)
        {
            handler->PSendSysMessage("Can't assist-demote yourself.");
            return true;
        }

        if (!FRaid::IsAssistant(target_guid))
        {
            handler->PSendSysMessage("Target is not an assistant.");
            return true;
        }

        FRaid::UpdateAssist(target_guid, 0);

        FRaid::BroadcastRaidMsg(source, leader_guid, handler->playerLink(target_name) + " has been demoted from being an assistant.", CHAT_MSG_SYSTEM);
        return true;
    }

    static bool HandleRaidLeaderCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();

        if (!FRaid::IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are not in a raid party.");
            return true;
        }

        if (!FRaid::IsRaidLeader(source_guid))
        {
            handler->PSendSysMessage("You need to be leader of the raid to perform this command.");
            return true;
        }

        // get target
        uint32 new_leader_guid;
        std::string target_name;
        Player* target = NULL;
        if (!*args)
        {
            handler->extractPlayerTarget((char*)args, &target);
            if (!target)
                return true;
            new_leader_guid = target->GetGUIDLow();
            target_name = target->GetName();
        }
        else
        {
            target_name = args;
            new_leader_guid = GUID_LOPART(sObjectMgr->GetPlayerGUIDByName(args));
            target = sObjectMgr->GetPlayerByLowGUID(new_leader_guid);
            if (!new_leader_guid)
            {
                handler->SendSysMessage(LANG_PLAYER_NOT_FOUND);
                return true;
            }
        }

        if (source_guid != FRaid::GetLeaderGuid(new_leader_guid))
        {
            handler->PSendSysMessage("Target not in your raid.");
            return true;
        }

        if (source_guid == new_leader_guid)
        {
            handler->PSendSysMessage("Can't transfer leadership to yourself. That would be pointless.");
            return true;
        }

        std::string subgroup = FRaid::GetSubgroup(new_leader_guid);
        FRaid::DeleteMember(new_leader_guid);
        FRaid::InsertRaidMember(new_leader_guid, new_leader_guid, 1, subgroup);

        // begin member transfer to the new raid group
        PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_RAID_MEMBERS);
        stmt->setUInt32(0, source_guid);
        PreparedQueryResult result = WorldDatabase.Query(stmt);

        do
        {
            Field* fields = result->Fetch();
            uint32 raid_member_guid = fields[1].GetUInt32();
            subgroup = fields[2].GetString();
            uint8 assistant = fields[3].GetUInt8();
            FRaid::DeleteMember(raid_member_guid);
            FRaid::InsertRaidMember(new_leader_guid, raid_member_guid, assistant, subgroup);
        } while (result->NextRow());

        // just to be safe, since above iteration should delete old raid
        FRaid::DeleteRaid(source_guid);

        FRaid::BroadcastRaidMsg(source, new_leader_guid, handler->playerLink(target_name) + " has been given leadership of the raid.", CHAT_MSG_SYSTEM);
        return true;
    }

    static bool HandleRaidListCommand(ChatHandler* handler, char const* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        uint32 source_guid = source->GetGUIDLow();

        if (!FRaid::IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are not in a raid party.");
            return true;
        }

        uint32 leader_guid = FRaid::GetLeaderGuid(source_guid);

        // begin member transfer to the new raid group
        PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_RAID_MEMBERS);
        stmt->setUInt32(0, leader_guid);
        PreparedQueryResult result = WorldDatabase.Query(stmt);

        // COLOR CODES:
        // Leader = |cFFFF4709
        // Subgroup = |cFF00ADEF
        // Assist = |cFFE6CC80
        // Member = |cFFFFFFFF

        // list leader at the top
        const CharacterNameData* name_data = sWorld->GetCharacterNameData(leader_guid);

        // raid leader player probably deleted, raid needs to be disbanded
        if (name_data == NULL) 
        {
            FRaid::BroadcastRaidMsg(NULL, leader_guid, "Raid leader character no longer exists. Raid is disbanded!", CHAT_MSG_SYSTEM);
            FRaid::DeleteRaid(leader_guid);
        }

        handler->PSendSysMessage("Listing raid members. Following list entry format is used:");
        handler->PSendSysMessage("[Player name] - [Leader/Assist/Member] - [Subgroup name]");

        std::string target_name = name_data->m_name;
        handler->PSendSysMessage("%s - [|cFFFF4709Leader|r] - [|cFF00ADEF%s|r]", handler->playerLink(target_name).c_str(), FRaid::GetSubgroup(leader_guid).c_str());

        do
        {
            Field* fields = result->Fetch();
            uint32 raid_member_guid = fields[1].GetUInt32();
            std::string subgroup = fields[2].GetString();
            uint8 assistant = fields[3].GetUInt8();

            if (raid_member_guid == leader_guid)
            {
                continue;
            }

            name_data = sWorld->GetCharacterNameData(raid_member_guid);
            
            // if character no longer exists, remove it from the raid
            if (name_data == NULL) 
            {
                FRaid::DeleteMember(raid_member_guid);
            }
            else 
            {
                // "|cffffffff|Hplayer:"+name+"|h["+name+"]|h|r"
                std::string target_name = name_data->m_name;
                std::string raid_rank = assistant != 0 ? "|cFFE6CC80Assist|r" : "|cFFFFFFFFMember|r";
                handler->PSendSysMessage("%s - [%s] - [|cFF00ADEF%s|r]", handler->playerLink(target_name).c_str(), raid_rank.c_str(), subgroup.c_str());
            }
        } while (result->NextRow());

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
        if (!FRaid::IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are not in a raid party.");
            return true;
        }
        
        // broadcast raid say
        uint32 leader_guid = FRaid::GetLeaderGuid(source_guid);
        std::string msg = (char*)args;
        ChatMsg msg_type = leader_guid == source_guid ? CHAT_MSG_RAID_LEADER : CHAT_MSG_RAID;
        FRaid::BroadcastRaidMsg(source, leader_guid, msg, msg_type);

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
        if (!FRaid::IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are not in a raid party.");
            return true;
        }

        // need to be assistant or leader to use raid warning
        if (!FRaid::IsAssistant(source_guid))
        {
            handler->PSendSysMessage("You need to have assistant permissions of the raid to execute raid warnings.");
            return true;
        }

        // broadcast raid say
        uint32 leader_guid = FRaid::GetLeaderGuid(source_guid);
        std::string msg = (char*)args;
        FRaid::BroadcastRaidMsg(source, leader_guid, msg, CHAT_MSG_RAID_WARNING);

        return true;
    }

    static bool HandleRaidUnlockCommand(ChatHandler* handler, char const* args)
    {
        FRaid::UnlockRaidPartyChat(handler->GetSession()->GetPlayer());
        handler->PSendSysMessage("Force-unlocked raid/party chat.");
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
        if (!FRaid::IsInRaid(source_guid))
        {
            handler->PSendSysMessage("You are not in a raid party.");
            return true;
        }

        // broadcast raid say
        uint32 leader_guid = FRaid::GetLeaderGuid(source_guid);
        std::string subgroup = FRaid::GetSubgroup(source_guid);
        std::string msg = (char*)args;
        FRaid::BroadcastPartyMsg(source, leader_guid, subgroup, msg, CHAT_MSG_PARTY);

        return true;
    }

    #pragma endregion
};

void AddSC_fraid_commandscript()
{
    new fraid_commandscript();
}