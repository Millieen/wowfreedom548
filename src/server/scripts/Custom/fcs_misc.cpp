#include "ScriptMgr.h"
#include "ObjectMgr.h"
#include "Chat.h"
#include "AccountMgr.h"
#include "Language.h"
#include "World.h"
#include "Player.h"
#include "Opcodes.h"

class fmisc_commandscript : public CommandScript
{
public:
    fmisc_commandscript() : CommandScript("fmisc_commandscript") { }

    ChatCommand* GetCommands() const
    {
        static ChatCommand commandTable[] =
        {
            { NULL, 0, false, NULL, "", NULL }
        };
        return commandTable;
    }
};

void AddSC_fmisc_commandscript()
{
    new fmisc_commandscript();
}