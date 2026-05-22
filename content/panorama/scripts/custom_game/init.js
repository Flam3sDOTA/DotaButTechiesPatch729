// Credits: DarkoniusXNG — https://github.com/DarkoniusXNG/barebones/blob/source2/content/dota_addons/barebones/panorama/scripts/custom_game/init.js#L1
function HidePickScreen() {
	const dotaHud = $.GetContextPanel().GetParent().GetParent();
	if (Game.GameStateIsBefore(DOTA_GameState.DOTA_GAMERULES_STATE_HERO_SELECTION)) {
		dotaHud.FindChild("PreGame").visible = false;
	}
	else if (Game.GameStateIs(DOTA_GameState.DOTA_GAMERULES_STATE_HERO_SELECTION)) {
		dotaHud.FindChild("PreGame").visible = true;
	}
	else if (Game.GameStateIs(DOTA_GameState.DOTA_GAMERULES_STATE_PRE_GAME)) {
		dotaHud.FindChild("PreGame").visible = false;
	}
}

(function()
{
	GameEvents.Subscribe( "game_rules_state_change", HidePickScreen );
})();
