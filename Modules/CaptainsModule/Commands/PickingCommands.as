#include "ChatCommand.as"
#include "RulesCore.as"
#include "BindingsCommon.as"
#include "TranslationsSystem.as"

class BindingsMenu : ChatCommand
{
	BindingsMenu()
	{
		super("bindings", Descriptions::bindingscom);
	}

	bool canPlayerExecute(CPlayer@ player)
	{
		return (
			ChatCommand::canPlayerExecute(player) &&
			!ChatCommands::getManager().whitelistedClasses.empty()
		);
	}

	void Execute(string[] args, CPlayer@ player)
	{
		CRules@ rules = getRules();

		if (player.isMyPlayer())
		{
			rules.set_bool("bindings_open", !rules.get_bool("bindings_open"));

			ResetRuleBindings();
			LoadFileBindings();

			ResetRuleSettings();
			LoadFileSettings();
		}
	}
}