#include "ChatCommandManager.as"
#include "PickingCommands.as"

//command register order is not important
//actual order in help command is based on the order of commands in ChatCommands.cfg
void RegisterGruhshaChatCommands(ChatCommandManager@ manager)
{
	//gruhsha commands
	manager.RegisterCommand(BindingsMenu());
}
