#include "ScriptMgr.h"
#include "ObjectMgr.h"
#include "AccountMgr.h"
#include "Config.h"
#include "SocialMgr.h"
#include "Chat.h"
#include "Language.h"
#include "World.h"
#include "Player.h"
#include "Opcodes.h"
#include "MovementStructures.h"

// helper function to replace all occurance strings with another string
void replaceAll(std::string &str, std::string from, std::string to)
{
    std::string::size_type n = 0;
    while ((n = str.find(from, n)) != std::string::npos)
    {
        str.replace(n, from.size(), to);
        n += to.size();
    }
}

class freedom_commandscript : public CommandScript
{
public:
    freedom_commandscript() : CommandScript("freedom_commandscript") { }

    ChatCommand* GetCommands() const OVERRIDE
    {
        static ChatCommand freedomMorphCommandTable[] = {
                { "add",            rbac::RBAC_PERM_COMMAND_FREEDOM_MORPH_MODIFY,       false, &HandleFreedomMorphAddCommand,       "", NULL },
                { "delete",         rbac::RBAC_PERM_COMMAND_FREEDOM_MORPH_MODIFY,       false, &HandleFreedomMorphDelCommand,       "", NULL },
                { "",               rbac::RBAC_PERM_COMMAND_FREEDOM_MORPH,              false, &HandleFreedomMorphCommand,          "", NULL },
                { NULL, 0, false, NULL, "", NULL }
        };

        static ChatCommand freedomTeleportCommandTable[] = {
                { "add",            rbac::RBAC_PERM_COMMAND_FREEDOM_TELE_MODIFY,        false, &HandleFreedomTeleAddCommand,        "", NULL },
                { "delete",         rbac::RBAC_PERM_COMMAND_FREEDOM_TELE_MODIFY,        false, &HandleFreedomTeleDelCommand,        "", NULL },
                { "",               rbac::RBAC_PERM_COMMAND_FREEDOM_TELE,               false, &HandleFreedomTeleCommand,           "", NULL },
                { NULL, 0, false, NULL, "", NULL }
        };

        static ChatCommand freedomPrivateTeleportCommandTable[] = {
                { "add",            rbac::RBAC_PERM_COMMAND_FREEDOM_PTELE,              false, &HandleFreedomPrivateTeleAddCommand, "", NULL },
                { "delete",         rbac::RBAC_PERM_COMMAND_FREEDOM_PTELE,              false, &HandleFreedomPrivateTeleDelCommand, "", NULL },
                { "",               rbac::RBAC_PERM_COMMAND_FREEDOM_PTELE,              false, &HandleFreedomPrivateTeleCommand,    "", NULL },
                { NULL, 0, false, NULL, "", NULL }
        };

        static ChatCommand freedomCommandTable[] = {
                { "morph",          rbac::RBAC_PERM_COMMAND_FREEDOM_MORPH,              false, NULL,                                "", freedomMorphCommandTable },
                { "teleport",       rbac::RBAC_PERM_COMMAND_FREEDOM_TELE,               false, NULL,                                "", freedomTeleportCommandTable },
                { "pteleport",      rbac::RBAC_PERM_COMMAND_FREEDOM_PTELE,              false, NULL,                                "", freedomPrivateTeleportCommandTable },
                { "summon",         rbac::RBAC_PERM_COMMAND_FREEDOM_SUMMON,             false, &HandleFreedomSummonCommand,         "", NULL },
                { "demorph",        rbac::RBAC_PERM_COMMAND_FREEDOM_DEMORPH,            false, &HandleFreedomDemorphCommand,        "", NULL },
                { "fly",            rbac::RBAC_PERM_COMMAND_FREEDOM_FLY,                false, &HandleFreedomFlyCommand,            "", NULL },
                { "revive",         rbac::RBAC_PERM_COMMAND_FREEDOM_REVIVE,             false, &HandleFreedomReviveCommand,         "", NULL },
                { "unaura",         rbac::RBAC_PERM_COMMAND_FREEDOM_UNAURA,             false, &HandleFreedomUnAuraCommand,         "", NULL },
                { "speed",          rbac::RBAC_PERM_COMMAND_FREEDOM_SPEEDS,             false, &HandleFreedomSpeedCommand,          "", NULL },
                { "walk",           rbac::RBAC_PERM_COMMAND_FREEDOM_WALK,               false, &HandleFreedomWalkCommand,           "", NULL },
                { "run",            rbac::RBAC_PERM_COMMAND_FREEDOM_RUN,                false, &HandleFreedomRunCommand,            "", NULL },
                { "swim",           rbac::RBAC_PERM_COMMAND_FREEDOM_SWIM,               false, &HandleFreedomSwimCommand,           "", NULL },
                { "scale",          rbac::RBAC_PERM_COMMAND_FREEDOM_SCALE,              false, &HandleFreedomScaleCommand,          "", NULL },
                { "drunk",          rbac::RBAC_PERM_COMMAND_FREEDOM_DRUNK,              false, &HandleFreedomDrunkCommand,          "", NULL },
                { "waterwalk",      rbac::RBAC_PERM_COMMAND_FREEDOM_WATERWALK,          false, &HandleFreedomWaterwalkCommand,      "", NULL },
                { "fix",            rbac::RBAC_PERM_COMMAND_FREEDOM_FIX,                false, &HandleFreedomFixCommand,            "", NULL },
                //{ "mailbox",        rbac::RBAC_PERM_COMMAND_FREEDOM_MAILBOX,            false, &HandleFreedomMailboxCommand,        "", NULL }, TODO: implement mailbox command when SMSG_SHOW_MAILBOX or similar opcode is implemented
                { "money",          rbac::RBAC_PERM_COMMAND_FREEDOM_MONEY,              false, &HandleFreedomMoneyCommand,          "", NULL },
                { "bank",           rbac::RBAC_PERM_COMMAND_FREEDOM_BANK,               false, &HandleFreedomBankCommand,           "", NULL },
                { NULL, 0, false, NULL, "", NULL }
        };

        static ChatCommand commandTable[] =
        {
            { "freedom",            rbac::RBAC_PERM_COMMAND_FREEDOM,                    false, NULL,                                "", freedomCommandTable },
            { NULL, 0, false, NULL, "", NULL }
        };
        return commandTable;
    }

    /*===========================
    * ----- COMMAND HANDLES -----
    * =========================== 
    * Color guide:
    * MSG_COLOR_CHOCOLATE - message title/name/source.
    * MSG_COLOR_RED       - error message.
    * MSG_COLOR_SUBWHITE  - description, normal text.
    * MSG_COLOR_ORANGEY   - tag name, link name, target/source name, for exclamation.
    */
    
    // UTILITIES
    static bool HandleFreedomMoneyCommand(ChatHandler* handler, const char* /*args*/) {
        Player* source = handler->GetSession()->GetPlayer();
        source->SetMoney(int64(100000000000));
        handler->PSendSysMessage("%s>>%s Your money is reset.", MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
        return true;
    }

    static bool HandleFreedomFixCommand(ChatHandler* handler, const char* /*args*/) {
        Player* source = handler->GetSession()->GetPlayer();
        source->DurabilityRepairAll(false, 0, false);
        handler->PSendSysMessage("%s>>%s All your character's items are repaired.", MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
        return true;
    }

    static bool HandleFreedomUnAuraCommand(ChatHandler* handler, const char* /*args*/) {
        Player* source = handler->GetSession()->GetPlayer();
        source->RemoveAllAuras();
        handler->PSendSysMessage("%s>>%sAll auras/passive/spell effects are removed from your character.", MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
        return true;
    }

    static bool HandleFreedomReviveCommand(ChatHandler* handler, const char* /*args*/) {
        Player* source = handler->GetSession()->GetPlayer();
        if (source->IsAlive()) {
            handler->PSendSysMessage("%s.freedom revive: %s You are already alive.", MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
            return true;
        }

        source->ResurrectPlayer(1.0f);
        source->SaveToDB();
        handler->PSendSysMessage("%s>>%s Resurrected with full health.", MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
        return true;
    }

    static bool HandleFreedomBankCommand(ChatHandler* handler, const char* args)
    {
        Player* source = handler->GetSession()->GetPlayer();
        handler->GetSession()->SendShowBank(source->GetGUID());
        return true;
    }

    static bool HandleFreedomMailboxCommand(ChatHandler* handler, const char* /*args*/) {
        return true;
    }

    // MODIFICATION
    // MODIFICATION -> CS_MODIFY-CMDs
    static bool HandleFreedomScaleCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom scale: %sPlease specify a decimal number.\n"
                "%sSyntax: %s.freedom scale $newScale",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }

        Player* source = handler->GetSession()->GetPlayer();
        float scale_new = (float)atof((char*)args);
        float max = sConfigMgr->GetFloatDefault("Freedom.Modify.MaxScale", 3.0f);
        float min = sConfigMgr->GetFloatDefault("Freedom.Modify.MinScale", 0.1f);

        if (scale_new > max || scale_new < min)
        {
            handler->PSendSysMessage(
                "%s.freedom scale: %sIncorrect value.\n"
                "%sReason: %sSpecified value must be between %s%.2f%s and %s%.2f%s.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, min, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, max, MSG_COLOR_SUBWHITE);
            return true;
        }

        source->SetObjectScale(scale_new);
        handler->PSendSysMessage(
            "%s>>%s Your character's scale is changed to %s%d%%%s.",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, (int) (scale_new*100), MSG_COLOR_SUBWHITE);

        return true;
    }

    static bool HandleFreedomSwimCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom swim: %sPlease specify a decimal number.\n"
                "%sSyntax: %s.freedom swim $newSpeed",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }

        Player* source = handler->GetSession()->GetPlayer();
        float speed_new = (float)atof((char*)args);
        float max = sConfigMgr->GetFloatDefault("Freedom.Modify.MaxSwim", 10.0f);
        float min = sConfigMgr->GetFloatDefault("Freedom.Modify.MinSwim", 0.1f);

        if (speed_new > max || speed_new < min)
        {
            handler->PSendSysMessage(
                "%s.freedom swim: %sIncorrect value.\n"
                "%sReason: %sSpecified value must be between %s%.2f%s and %s%.2f%s.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, min, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, max, MSG_COLOR_SUBWHITE);
            return true;
        }

        source->SetSpeed(MOVE_SWIM, speed_new, true);
        source->SetSpeed(MOVE_SWIM_BACK, speed_new, true);
        handler->PSendSysMessage(
            "%s>>%s Your character's swim speed is changed to %s%d%%%s.",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, (int) (speed_new*100), MSG_COLOR_SUBWHITE);

        return true;
    }

    static bool HandleFreedomWalkCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom walk: %sPlease specify a decimal number.\n"
                "%sSyntax: %s.freedom walk $newSpeed",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }

        Player* source = handler->GetSession()->GetPlayer();
        float speed_new = (float)atof((char*)args);
        float max = sConfigMgr->GetFloatDefault("Freedom.Modify.MaxWalk", 10.0f);
        float min = sConfigMgr->GetFloatDefault("Freedom.Modify.MinWalk", 0.1f);

        if (speed_new > max || speed_new < min)
        {
            handler->PSendSysMessage(
                "%s.freedom walk: %sIncorrect value.\n"
                "%sReason: %sSpecified value must be between %s%.2f%s and %s%.2f%s.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, min, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, max, MSG_COLOR_SUBWHITE);
            return true;
        }

        source->SetSpeed(MOVE_WALK, speed_new, true);
        handler->PSendSysMessage(
            "%s>>%s Your character's walk speed is changed to %s%d%%%s.",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, (int) (speed_new * 100), MSG_COLOR_SUBWHITE);

        return true;
    }

    static bool HandleFreedomRunCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom run: %sPlease specify a decimal number.\n"
                "%sSyntax: %s.freedom run $newSpeed",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }

        Player* source = handler->GetSession()->GetPlayer();
        float speed_new = (float)atof((char*)args);
        float max = sConfigMgr->GetFloatDefault("Freedom.Modify.MaxRun", 10.0f);
        float min = sConfigMgr->GetFloatDefault("Freedom.Modify.MinRun", 0.1f);

        if (speed_new > max || speed_new < min)
        {
            handler->PSendSysMessage(
                "%s.freedom run: %sIncorrect value.\n"
                "%sReason: %sSpecified value must be between %s%.2f%s and %s%.2f%s.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, min, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, max, MSG_COLOR_SUBWHITE);
            return true;
        }

        source->SetSpeed(MOVE_RUN, speed_new, true);
        source->SetSpeed(MOVE_RUN_BACK, speed_new, true);
        handler->PSendSysMessage(
            "%s>>%s Your character's run speed is changed to %s%d%%%s.",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, (int) (speed_new * 100), MSG_COLOR_SUBWHITE);

        return true;
    }

    static bool HandleFreedomSpeedCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom speed: %sPlease specify a decimal number.\n"
                "%sSyntax: %s.freedom speed $newSpeed",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }

        Player* source = handler->GetSession()->GetPlayer();
        float speed_new = (float)atof((char*)args);
        float max = sConfigMgr->GetFloatDefault("Freedom.Modify.MaxSpeed", 10.0f);
        float min = sConfigMgr->GetFloatDefault("Freedom.Modify.MinSpeed", 0.1f);

        if (speed_new > max || speed_new < min)
        {
            handler->PSendSysMessage(
                "%s.freedom speed: %sIncorrect value.\n"
                "%sReason: %sSpecified value must be between %s%.2f%s and %s%.2f%s.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, min, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, max, MSG_COLOR_SUBWHITE);
            return true;
        }
        
        source->SetSpeed(MOVE_FLIGHT, speed_new, true);
        source->SetSpeed(MOVE_FLIGHT_BACK, speed_new, true);
        source->SetSpeed(MOVE_SWIM, speed_new, true);
        source->SetSpeed(MOVE_SWIM_BACK, speed_new, true);
        source->SetSpeed(MOVE_RUN, speed_new, true);
        source->SetSpeed(MOVE_RUN_BACK, speed_new, true);
        source->SetSpeed(MOVE_WALK, speed_new, true);
        source->SetSpeed(MOVE_WALK, speed_new, true);
        handler->PSendSysMessage(
            "%s>>%s Your character's all movement types speed is changed to %s%d%%%s.",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, (int) (speed_new * 100), MSG_COLOR_SUBWHITE);

        return true;
    }

    static bool HandleFreedomDrunkCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom drunk: %sPlease specify a number between 0 and 100.\n"
                "%sSyntax: %s.freedom speed $newSpeed",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }

        Player* source = handler->GetSession()->GetPlayer();
        uint8 drunklevel = (uint8)atoi(args);

        // if input really was not a number
        // TODO: replace with something better when low-priority improvements can be made
        std::string input = args;
        if (drunklevel == 0 && input[0] != '0')
        {
            handler->PSendSysMessage(
                "%s.freedom drunk: %sPlease specify a number between 0 and 100.\n"
                "%sSyntax: %s.freedom speed $newSpeed",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }

        if (drunklevel > 100)
            drunklevel = 100;

        source->SetDrunkValue(drunklevel);
        handler->PSendSysMessage(
            "%s>>%s Your character's drunk level is changed to %s%d%%%s.",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, drunklevel, MSG_COLOR_SUBWHITE);

        return true;
    }

    // MODIFICATION -> FLY & WATERWALK
    static bool HandleFreedomWaterwalkCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom waterwalk: %sPlease specify %son%s or %soff%s.\n"
                "%sSyntax: %s.freedom waterwalk $onOrOff",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }

        Player* source = handler->GetSession()->GetPlayer();

        // disallow adding morphs with names identical to morph subcommands
        std::string subcommand = args;
        std::transform(subcommand.begin(), subcommand.end(), subcommand.begin(), ::tolower);
        if (subcommand == "on")
        {
            handler->PSendSysMessage(
                "%s>>%s Your character's waterwalk is toggled %son%s.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            source->SetWaterWalking(true);
            return true;
        }
        else if (subcommand == "off")
        {
            //SetWaterWalking does not turn off properly, WORKAROUND: sending packets directly
            Unit* source_unit = handler->GetSession()->GetPlayer()->ToUnit();
            source_unit->RemoveUnitMovementFlag(MOVEMENTFLAG_WATERWALKING);
            Movement::PacketSender(source_unit, SMSG_SPLINE_MOVE_SET_LAND_WALK, SMSG_MOVE_LAND_WALK).Send();

            handler->PSendSysMessage(
                "%s>>%s Your character's waterwalk is toggled %soff%s.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            return true;
        }

        // did not specify ON or OFF value
        handler->PSendSysMessage(
            "%s.freedom waterwalk: %sPlease specify %son%s or %soff%s.\n"
            "%sSyntax: %s.freedom waterwalk $onOrOff",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);

        return true;
    }

    static bool HandleFreedomFlyCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom fly: %sPlease specify a decimal number or toggle sub-command %son%s / %soff%s.\n"
                "%sSyntax: %s.freedom fly $onOrOffOrNewSpeed",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }
        
        Player* source = handler->GetSession()->GetPlayer();
        
        // disallow adding morphs with names identical to morph subcommands
        std::string subcommand = args;
        std::transform(subcommand.begin(), subcommand.end(), subcommand.begin(), ::tolower);
        if (subcommand == "on")
        {
            handler->PSendSysMessage(
                "%s>>%s Your character's fly is toggled %son%s.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            source->SetCanFly(true);
            return true;
        }
        else if (subcommand == "off")
        {
            //SetCanFly not turning off properly, WORKAROUND: sending packets directly
            Unit* source_unit = handler->GetSession()->GetPlayer()->ToUnit();
            source_unit->RemoveUnitMovementFlag(MOVEMENTFLAG_CAN_FLY | MOVEMENTFLAG_MASK_MOVING_FLY);
            if (!source_unit->IsLevitating())
                source_unit->SetFall(true);
            Movement::PacketSender(source_unit, SMSG_SPLINE_MOVE_UNSET_FLYING, SMSG_MOVE_UNSET_CAN_FLY).Send();

            handler->PSendSysMessage(
                "%s>>%s Your character's fly is toggled %soff%s.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            return true;
        }

        float speed_new = (float)atof((char*)args);
        float max = sConfigMgr->GetFloatDefault("Freedom.Modify.MaxFly", 10.0f);
        float min = sConfigMgr->GetFloatDefault("Freedom.Modify.MinFly", 0.1f);

        if (speed_new > max || speed_new < min)
        {
            handler->PSendSysMessage(
                "%s.freedom fly: %sIncorrect value.\n"
                "%sReason: %sSpecified value must be between %s%.2f%s and %s%.2f%s if changing speed.\n"
                "%sHint: %sIf you wish to toggle your speed on or off, simply use either %s.f fly on %sor %s.f fly off%s command.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, min, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, max, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            return true;
        }

        source->SetSpeed(MOVE_FLIGHT, speed_new, true);
        source->SetSpeed(MOVE_FLIGHT_BACK, speed_new, true);

        handler->PSendSysMessage(
            "%s>>%s Your character's fly speed is changed to %s%d%%%s.",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, (int) (speed_new*100), MSG_COLOR_SUBWHITE);

        return true;
    }

    // MODIFICATION -> MORPHING
    static bool HandleFreedomMorphCommand(ChatHandler* handler, const char* args) 
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom morph: %sPlease specify a name of one of this character's morphs.\n"
                "%sSyntax: %s.freedom morph $morphName\n"
                "%sHint: %sUse %s.list morph $namePart %scommand to search for available morphs for this character.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            return true;
        }

        Player* source = handler->GetSession()->GetPlayer();
        std::string morph_name_exact;
        morph_name_exact = strtok((char *) args, " ");

        PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_FREEDOM_MORPH_EXACT);
        stmt->setString(0, morph_name_exact);
        stmt->setUInt32(1, source->GetGUIDLow());
        PreparedQueryResult result = WorldDatabase.Query(stmt);

        if (!result)
        {
            handler->PSendSysMessage(
                "%s.freedom morph: %sMorph not found.\n"
                "%sReason: %sNo such morph for this character was found.\n"
                "%sHint: %sUse %s.list morph $namePart %scommand to search for available morphs for this character. Also, remember that this command requires full name of the morph not just a name-part.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            return true;
        }

        Field * fields = result->Fetch();
        handler->GetSession()->GetPlayer()->SetDisplayId(fields[2].GetUInt32());

        handler->PSendSysMessage(
            "%s>>%s Successfully morphed into %s%s%s.",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, morph_name_exact.c_str(), MSG_COLOR_SUBWHITE);

        return true;
    }

    static bool HandleFreedomDemorphCommand(ChatHandler* handler, const char* args)
    {
        Player* source = handler->GetSession()->GetPlayer();

        source->DeMorph();

        handler->PSendSysMessage(
            "%s>>%s Successfully demorphed.",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);

        return true;
    }

    static bool HandleFreedomMorphAddCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom morph add: %sPlease specify a name and a display ID of the new morph for the target character (can specify player name as third parameter to find the target).\n"
                "%sSyntax: %s.freedom morph add $morphName $displayId [$playerName]",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }
        
        // extract parameters
        char * params[3];
        params[0] = strtok((char *)args, " ");
        params[1] = strtok(NULL, " ");
        params[2] = strtok(NULL, " ");

        if (!params[1])
        {
            handler->PSendSysMessage(
                "%s.freedom morph add: %sPlease specify a name and a display ID of the new morph for the target character (can specify player name as third parameter to find the target).\n"
                "%sSyntax: %s.freedom morph add $morphName $displayId [$playerName]",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }

        // disallow adding morphs with names identical to morph subcommands
        std::string temp = params[0];
        std::transform(temp.begin(), temp.end(), temp.begin(), ::tolower);
        if (temp == "add")
        {
            handler->PSendSysMessage(
                "%s.freedom morph add: %sIllegal name.\n"
                "%sReason: %sYou cannot add morphs with names matching the morph sub-commands.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
            return true;
        }

        // attempt to get valid target, priority to third parameter instead of in-game targeting
        uint32 char_guid;
        Player * target = NULL;
        PreparedStatement * stmt;

        if (!params[2]) // via DB
        {
            target = handler->getSelectedPlayer();
            if (!target)
                char_guid = NULL;
            else
                char_guid = target->GetGUIDLow();
        }
        else // via in-game target
        {
            stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_CHAR_GUID_BY_NAME);
            stmt->setString(0, params[2]);
            PreparedQueryResult result = CharacterDatabase.Query(stmt);
            if (result)
            {
                Field * fields = result->Fetch();
                char_guid = fields[0].GetUInt32();
            }
            else
            {
                char_guid = NULL;
            }
        }

        if (!char_guid)
        {
            handler->PSendSysMessage(
                "%s.freedom morph add: %sPlayer not found.\n"
                "%sReason: %sTarget is not a player or no character with such name exists.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
            return true;
        }

        Player* source = handler->GetSession()->GetPlayer();
        std::string morph_name_exact = params[0];
        uint32 morph_display_id = atol(params[1]);

        // check for duplicate morph name
        stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_FREEDOM_MORPH_EXACT);
        stmt->setString(0, morph_name_exact);
        stmt->setUInt32(1, char_guid);
        PreparedQueryResult result = WorldDatabase.Query(stmt);
        
        if (result)
        {
            handler->PSendSysMessage(
                "%s.freedom morph add: %sAlready exists.\n"
                "%sReason: %sTarget player already has a morph under that name.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
            return true;
        }

        // save to DB and notify target of success
        stmt = WorldDatabase.GetPreparedStatement(WORLD_INS_FREEDOM_MORPH);
        stmt->setUInt32(0, char_guid);
        stmt->setString(1, morph_name_exact);
        stmt->setUInt32(2, morph_display_id);
        stmt->setUInt32(3, source->GetSession()->GetAccountId());
        WorldDatabase.Execute(stmt);

        if (handler->needReportToTarget(target))
            ChatHandler(target->GetSession()).PSendSysMessage(
                    "%s>>%s Player %s added a morph under the name of %s%s%s and display id of %s%u%s to you.", 
                    MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, handler->GetNameLink().c_str(), MSG_COLOR_ORANGEY, morph_name_exact.c_str(), MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, morph_display_id, MSG_COLOR_SUBWHITE);

        handler->PSendSysMessage(
                "%s>>%s Successfully added a morph under the name of %s%s%s and display id of %s%u%s to %s%s%s player.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, morph_name_exact.c_str(), MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, morph_display_id, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, (target ? target->GetName().c_str() : "target"), MSG_COLOR_SUBWHITE);

        return true;
    }

    static bool HandleFreedomMorphDelCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom morph delete: %sPlease specify a name of the morph of the target character (can specify player name as second parameter to find the target).\n"
                "%sSyntax: %s.freedom morph delete $morphName [$playerName]",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }

        // extract parameters
        char * params[3];
        params[0] = strtok((char *)args, " ");
        params[1] = strtok(NULL, " ");

        // attempt to get valid target, priority to third parameter instead of in-game targeting
        uint32 char_guid;
        Player * target = NULL;
        PreparedStatement * stmt;

        if (!params[1]) // via DB
        {
            target = handler->getSelectedPlayer();
            if (!target)
                char_guid = NULL;
            else
                char_guid = target->GetGUIDLow();
        }
        else // via in-game target
        {
            stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_CHAR_GUID_BY_NAME);
            stmt->setString(0, params[1]);
            PreparedQueryResult result = CharacterDatabase.Query(stmt);
            if (result)
            {
                Field * fields = result->Fetch();
                char_guid = fields[0].GetUInt32();
            }
            else
            {
                char_guid = NULL;
            }
        }

        if (!char_guid)
        {
            handler->PSendSysMessage(
                "%s.freedom morph delete: %sPlayer not found.\n"
                "%sReason: %sTarget is not a player or no character with such name exists.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
            return true;
        }

        Player* source = handler->GetSession()->GetPlayer();
        std::string morph_name_exact = params[0];

        // check for duplicate morph name
        stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_FREEDOM_MORPH_EXACT);
        stmt->setString(0, morph_name_exact);
        stmt->setUInt32(1, char_guid);
        PreparedQueryResult result = WorldDatabase.Query(stmt);

        if (!result)
        {
            handler->PSendSysMessage(
                "%s.freedom morph delete: %sNot found.\n"
                "%sReason: %sTarget player does not have a morph under that name.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
            return true;
        }

        // save to DB and notify target of success
        stmt = WorldDatabase.GetPreparedStatement(WORLD_DEL_FREEDOM_MORPH);
        stmt->setString(0, morph_name_exact);
        stmt->setUInt32(1, char_guid);
        WorldDatabase.Execute(stmt);

        if (handler->needReportToTarget(target))
            ChatHandler(target->GetSession()).PSendSysMessage(
            "%s>>%s Player %s removed a morph under the name of %s%s%s from you.",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, handler->GetNameLink().c_str(), MSG_COLOR_ORANGEY, morph_name_exact.c_str(), MSG_COLOR_SUBWHITE);

        handler->PSendSysMessage(
            "%s>>%s Successfully removed a morph under the name of %s%s%s from %s%s%s player.",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, morph_name_exact.c_str(), MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, (target ? target->GetName().c_str() : "target"), MSG_COLOR_SUBWHITE);

        return true;
    }

    // LOCATIONAL
    // LOCATIONAL -> SUMMON
    static bool HandleFreedomSummonCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                    "%s.freedom summon: %sPlease specify the name of the player you wish to summon to your location.\n"
                    "%sSyntax: %s.freedom summon $playerName",
                    MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }

        Player* source = handler->GetSession()->GetPlayer();
        Player* target = sObjectAccessor->FindPlayerByName(args);

        if (!target || target->isBeingLoaded())
        {
            handler->PSendSysMessage(
                    "%s.freedom summon: %sSummon failed.\n"
                    "%sReason: %sPlayer %s%s%s is either offline, currently loading or does not exist.",
                    MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, args, MSG_COLOR_SUBWHITE);
            return true;
        }

        if (target->GetSocial()->HasIgnore(source->GetGUIDLow()))
        {
            handler->PSendSysMessage(
                    "%s.freedom summon: %sSummon failed.\n"
                    "%sReason: %sPlayer %s[%s]%s is ignoring you.",
                    MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, target->GetName().c_str(), MSG_COLOR_SUBWHITE);
            return true;
        }

        if (target->IsGameMaster())
        {
            handler->PSendSysMessage(
                    "%s.freedom summon: %sSummon failed.\n"
                    "%sReason: %sYou cannot summon a staff member with GM mode on.", 
                    MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
            return true;
        }

        target->SetSummonPoint(source->GetMapId(), source->GetPositionX(), source->GetPositionY(), source->GetPositionZ());

        WorldPacket data(SMSG_SUMMON_REQUEST, 8 + 4 + 4);
        ObjectGuid SummonerGUID = source->GetGUID();

        data.WriteBit(SummonerGUID[0]);
        data.WriteBit(SummonerGUID[6]);
        data.WriteBit(SummonerGUID[3]);
        data.WriteBit(SummonerGUID[2]);
        data.WriteBit(SummonerGUID[1]);
        data.WriteBit(SummonerGUID[4]);
        data.WriteBit(SummonerGUID[7]);
        data.WriteBit(SummonerGUID[5]);

        data.WriteByteSeq(SummonerGUID[4]);
        data << uint32(source->GetZoneId());                  // summoner zone
        data.WriteByteSeq(SummonerGUID[7]);
        data.WriteByteSeq(SummonerGUID[3]);
        data.WriteByteSeq(SummonerGUID[1]);
        data << uint32(MAX_PLAYER_SUMMON_DELAY*IN_MILLISECONDS); // auto decline after msecs
        data.WriteByteSeq(SummonerGUID[2]);
        data.WriteByteSeq(SummonerGUID[6]);
        data.WriteByteSeq(SummonerGUID[5]);
        data.WriteByteSeq(SummonerGUID[0]);
        target->GetSession()->SendPacket(&data);

        handler->PSendSysMessage(
                "%s>>%s Successfully sent a summon request to player %s%s.", 
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, target->GetName().c_str());

        return true;
    }

    // LOCATIONAL -> TELEPORT
    static bool HandleFreedomTeleCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                    "%s.freedom teleport: %sPlease specify a name for the location to teleport to.\n"
                    "%sSyntax: %s.freedom teleport $teleNamePart\n"
                    "%sHint: %sUse %s.list ftele $namePart %scommand to search for available destinations.", 
                    MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            return true;
        }

        std::string tele_name_exact;
        tele_name_exact = strtok((char *)args, " ");;
        std::string tele_name_start = tele_name_exact;
        Player* source = handler->GetSession()->GetPlayer();

        if (source->IsInCombat())
        {
            handler->PSendSysMessage(
                "%s.freedom teleport: %sCan't teleport currently.\n"
                "%sReason: %sYou cannot teleport while in combat.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
            return true;
        }

        // refine query parameter for LIKE statement
        replaceAll(tele_name_start, "%", "\\%"); //disable inputted % wildcards
        replaceAll(tele_name_start, "_", "\\_"); //disable inputted _ wildcards
        tele_name_start += "%"; // ensure that tele_name_start can end with anything

        // get exact match
        PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_FREEDOM_TELE_EXACT);
        stmt->setString(0, tele_name_exact);
        PreparedQueryResult result = WorldDatabase.Query(stmt);

        // if exact match failed, get first teleport, which name starts with given parameter
        if (!result) {
            stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_FREEDOM_TELE);
            stmt->setString(0, tele_name_start);
            result = WorldDatabase.Query(stmt);
        }

        if (!result)
        {
            handler->PSendSysMessage(
                    "%s.freedom teleport: %sTeleport not found.\n"
                    "%sReason: %sNo teleport using that string was found.\n"
                    "%sHint: %sUse %s.list ftele $namePart %scommand to search for available destinations.",
                    MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            return true;
        }

        Field *fields = result->Fetch();

        if (source->IsInFlight())
        {
            source->GetMotionMaster()->MovementExpired();
            source->CleanupAfterTaxiFlight();
        }

        source->SaveRecallPosition();
        source->TeleportTo(fields[4].GetUInt32(), fields[0].GetFloat(), fields[1].GetFloat(), fields[2].GetFloat(), fields[3].GetFloat());

        handler->PSendSysMessage(
            "%s>>%s You have been successfully teleported to %s%s %slocation.",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, fields[5].GetCString(), MSG_COLOR_SUBWHITE);

        return true;
    }

    static bool HandleFreedomTeleAddCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom teleport add: %sPlease specify a name for the freedom teleport you want to add.\n"
                "%sSyntax: %s.freedom teleport add $newTeleName",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }

        std::string tele_name_new;
        std::string temp;
        temp = tele_name_new = strtok((char*)args, " ");
        Player* source = handler->GetSession()->GetPlayer();

        // disallow adding teleports with names identical to private teleport subcommands
        std::transform(temp.begin(), temp.end(), temp.begin(), ::tolower);
        if (temp == "add" || temp == "delete")
        {
            handler->PSendSysMessage(
                "%s.freedom teleport add: %sIllegal name.\n"
                "%sReason: %sYou cannot add teleports with names matching the teleport sub-commands.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
            return true;
        }

        PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_FREEDOM_TELE_EXACT);
        stmt->setString(0, tele_name_new);
        PreparedQueryResult result = WorldDatabase.Query(stmt);

        if (result)
        {
            handler->PSendSysMessage(
                "%s.freedom teleport add: %sAlready exists.\n"
                "%sReason: %sThe name of the freedom teleport you want to create already exists.\n"
                "%sHint: %sUse a different name or delete the existing one using %s.f tele del $name %scommand.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            return true;
        }

        stmt = WorldDatabase.GetPreparedStatement(WORLD_INS_FREEDOM_TELE);
        stmt->setFloat(0, source->GetPositionX());
        stmt->setFloat(1, source->GetPositionY());
        stmt->setFloat(2, source->GetPositionZ());
        stmt->setFloat(3, source->GetOrientation());
        stmt->setUInt32(4, source->GetMapId());
        stmt->setString(5, tele_name_new);
        stmt->setUInt32(6, source->GetSession()->GetAccountId());
        WorldDatabase.Execute(stmt);

        handler->PSendSysMessage(
            "%s>>%s Teleport (Freedom-type) with the name %s%s successfully created.",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, tele_name_new.c_str(), MSG_COLOR_SUBWHITE);

        return true;
    }

    static bool HandleFreedomTeleDelCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom teleport delete: %sPlease specify a name of the freedom teleport you want to delete.\n"
                "%sSyntax: %s.freedom teleport delete $teleName\n"
                "%sHint: %sUse %s.list ftele $namePart %scommand to search for freedom teleports.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            return true;
        }

        std::string tele_name_delete;
        tele_name_delete = strtok((char*)args, " ");

        PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_FREEDOM_TELE_EXACT);
        stmt->setString(0, tele_name_delete);
        PreparedQueryResult result = WorldDatabase.Query(stmt);

        if (!result)
        {
            handler->PSendSysMessage(
                "%s.freedom teleport delete: %sNot found.\n"
                "%sReason: %sThe name of the freedom teleport you want to delete is not found in the freedom teleport list.\n"
                "%sHint: %sRemember to specify full teleport's name, just part of the name will not work, however, case-sensitive name is not required.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
            return true;
        }

        stmt = WorldDatabase.GetPreparedStatement(WORLD_DEL_FREEDOM_TELE);
        stmt->setString(0, tele_name_delete);
        WorldDatabase.Execute(stmt);

        handler->PSendSysMessage(
            "%s>>%s Teleport (Freedom-type) with the name %s%s%s successfully deleted.",
            MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, tele_name_delete.c_str(), MSG_COLOR_SUBWHITE);

        return true;
    }

    // LOCATIONAL -> PRIVATE TELEPORT
    static bool HandleFreedomPrivateTeleCommand(ChatHandler* handler, const char* args) 
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom pteleport: %sPlease specify a name for the location to teleport to.\n"
                "%sSyntax: %s.freedom pteleport $teleNamePart\n"
                "%sHint: %sUse %s.list ptele $namePart %scommand to search for available destinations.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            return true;
        }

        std::string tele_name_exact;
        tele_name_exact = strtok((char *)args, " ");;
        std::string tele_name_start = tele_name_exact;
        Player* source = handler->GetSession()->GetPlayer();

        if (source->IsInCombat())
        {
            handler->PSendSysMessage(
                "%s.freedom pteleport: %sCan't teleport currently.\n"
                "%sReason: %sYou cannot teleport while in combat.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
            return true;
        }

        // refine query parameter for LIKE statement
        replaceAll(tele_name_start, "%", "\\%"); //disable inputted % wildcards
        replaceAll(tele_name_start, "_", "\\_"); //disable inputted _ wildcards
        tele_name_start += "%"; // ensure that tele_name_start can end with anything

        // get exact match
        PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_FREEDOM_PRIVATE_TELE_EXACT);
        stmt->setString(0, tele_name_exact);
        stmt->setUInt32(1, source->GetSession()->GetAccountId());
        PreparedQueryResult result = WorldDatabase.Query(stmt);
        
        // if exact match failed, get first teleport, which name starts with given parameter
        if (!result) {
            stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_FREEDOM_PRIVATE_TELE);
            stmt->setString(0, tele_name_start);
            stmt->setUInt32(1, source->GetSession()->GetAccountId());
        }

        if (!result)
        {
            handler->PSendSysMessage(
                "%s.freedom pteleport: %sTeleport not found.\n"
                "%sReason: %sNo teleport using that string was found in your private teleport list.\n"
                "%sHint: %sUse %s.list ptele $namePart %scommand to search for available destinations.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            return true;
        }

        Field *fields = result->Fetch();

        if (source->IsInFlight())
        {
            source->GetMotionMaster()->MovementExpired();
            source->CleanupAfterTaxiFlight();
        }

        source->SaveRecallPosition();
        source->TeleportTo(fields[4].GetUInt32(), fields[0].GetFloat(), fields[1].GetFloat(), fields[2].GetFloat(), fields[3].GetFloat());

        handler->PSendSysMessage(
                "%s>>%s You have been successfully teleported to %s%s %slocation.", 
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, fields[5].GetCString(), MSG_COLOR_SUBWHITE);

        return true;
    }

    static bool HandleFreedomPrivateTeleAddCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom pteleport add: %sPlease specify a name for the private teleport you want to add.\n"
                "%sSyntax: %s.freedom pteleport add $teleName",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY);
            return true;
        }

        std::string tele_name_new;
        std::string temp;
        temp = tele_name_new = strtok((char*)args, " ");
        Player* source = handler->GetSession()->GetPlayer();

        // disallow adding teleports with names identical to private teleport subcommands
        std::transform(temp.begin(), temp.end(), temp.begin(), ::tolower);
        if (temp == "add" || temp == "delete")
        {
            handler->PSendSysMessage(
                "%s.freedom pteleport add: %sIllegal name.\n"
                "%sReason: %sYou cannot add teleports with names matching the teleport sub-commands.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
            return true;
        }

        PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_FREEDOM_PRIVATE_TELE_EXACT);
        stmt->setString(0, tele_name_new);
        stmt->setUInt32(1, source->GetSession()->GetAccountId());
        PreparedQueryResult result = WorldDatabase.Query(stmt);
        
        if (result) 
        {
            handler->PSendSysMessage(
                "%s.freedom pteleport add: %sAlready exists.\n"
                "%sReason: %sThe name of the private teleport you want to create already exists.\n" 
                "%sHint: %sUse a different name or delete the existing one using %s.f ptele del $name %scommand.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            return true;
        }

        stmt = WorldDatabase.GetPreparedStatement(WORLD_INS_FREEDOM_PRIVATE_TELE);
        stmt->setFloat(0, source->GetPositionX());
        stmt->setFloat(1, source->GetPositionY());
        stmt->setFloat(2, source->GetPositionZ());
        stmt->setFloat(3, source->GetOrientation());
        stmt->setUInt32(4, source->GetMapId());
        stmt->setString(5, tele_name_new);
        stmt->setUInt32(6, source->GetSession()->GetAccountId());
        WorldDatabase.Execute(stmt);

        handler->PSendSysMessage(
                "%s>>%s Teleport (Private-type) with the name %s%s successfully created.", 
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, tele_name_new.c_str(), MSG_COLOR_SUBWHITE);

        return true;
    }

    static bool HandleFreedomPrivateTeleDelCommand(ChatHandler* handler, const char* args)
    {
        if (!*args)
        {
            handler->PSendSysMessage(
                "%s.freedom pteleport delete: %sPlease specify a name of the private teleport you want to delete.\n"
                "%sSyntax: %s.freedom pteleport delete $teleName\n"
                "%sHint: %sUse %s.list ptele $namePart %scommand to search for currently owned teleports.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_ORANGEY, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, MSG_COLOR_SUBWHITE);
            return true;
        }

        std::string tele_name_delete;
        tele_name_delete = strtok((char*)args, " ");
        Player* source = handler->GetSession()->GetPlayer();

        PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_SEL_FREEDOM_PRIVATE_TELE_EXACT);
        stmt->setString(0, tele_name_delete);
        stmt->setUInt32(1, source->GetSession()->GetAccountId());
        PreparedQueryResult result = WorldDatabase.Query(stmt);

        if (!result)
        {
            handler->PSendSysMessage(
                "%s.freedom pteleport delete: %sNot found.\n"
                "%sReason: %sThe name of the private teleport you want to delete is not found in your private teleport list.\n"
                "%sHint: %sRemember to specify full teleport's name, just part of the name will not work, however, case-sensitive name is not required.",
                MSG_COLOR_CHOCOLATE, MSG_COLOR_RED, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE);
            return true;
        }

        stmt = WorldDatabase.GetPreparedStatement(WORLD_DEL_FREEDOM_PRIVATE_TELE);
        stmt->setString(0, tele_name_delete);
        stmt->setUInt32(1, source->GetSession()->GetAccountId());
        WorldDatabase.Execute(stmt);

        handler->PSendSysMessage(
                "%s>>%s Teleport (Private-type) with the name %s%s%s successfully deleted.", 
                 MSG_COLOR_CHOCOLATE, MSG_COLOR_SUBWHITE, MSG_COLOR_ORANGEY, tele_name_delete.c_str(), MSG_COLOR_SUBWHITE);

        return true;
    }
};

void AddSC_freedom_commandscript()
{
    new freedom_commandscript();
}