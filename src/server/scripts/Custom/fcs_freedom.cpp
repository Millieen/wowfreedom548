#include "ScriptMgr.h"
#include "ObjectMgr.h"
#include "Chat.h"
#include "AccountMgr.h"
#include "Language.h"
#include "World.h"
#include "Player.h"
#include "Opcodes.h"

class freedom_commandscript : public CommandScript
{
public:
    freedom_commandscript() : CommandScript("freedom_commandscript") { }

    ChatCommand* GetCommands() const OVERRIDE
    {
        static ChatCommand freedomCommandTable[] =
        {
            { NULL, 0, false, NULL, "", NULL }
        };
        static ChatCommand commandTable[] =
        {
            { "freedom", rbac::RBAC_PERM_COMMAND_GM, false, NULL, "", freedomCommandTable },
            { NULL, 0, false, NULL, "", NULL }
        };
        return commandTable;
    }

};

void AddSC_freedom_commandscript()
{
    new freedom_commandscript();
}