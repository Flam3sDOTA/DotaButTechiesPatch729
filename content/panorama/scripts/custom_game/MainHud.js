"use strict";

var NoDashboardButton = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("MenuButtons");
var NoScoreboardButton = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("MenuButtons");
var NoSettingsButton = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("MenuButtons");

NoDashboardButton.FindChildTraverse("DashboardButton").style.visibility = "collapse";
NoScoreboardButton.FindChildTraverse("ToggleScoreboardButton").style.visibility = "collapse";
NoSettingsButton.FindChildTraverse("SettingsRebornButton").style.visibility = "collapse";

function OnRequestDetonateSelected(data) {
    if (data.target_pid !== Players.GetLocalPlayer()) return;
    
    var selection = Players.GetSelectedEntities(Players.GetLocalPlayer());
    
    if (!selection || selection.length === 0) {
        selection = [data.caster_entindex];
    }
    GameEvents.SendCustomGameEventToServer("detonate_selected_mines", {
        entities: selection
    });
}

function ToggleSlarkCrawl() {
    var panel = $("#SlarkCrawlPanel");
    if (!panel) return;
    if (panel.style.visibility === "visible") {
        panel.style.visibility = "collapse";
        panel.RemoveClass("crawl_active");
    } else {
        panel.RemoveClass("crawl_active");
        panel.style.visibility = "visible";
        $.Schedule(0.1, function() {
            panel.AddClass("crawl_active");
        });
    }
}

var customBtn1 = $("#CustomButton1");
if (customBtn1) {
    customBtn1.SetPanelEvent("onactivate", ToggleSlarkCrawl);
}

function ToggleMineLeaderboard() {
    var panel = $("#MineLeaderboardPanel");
    if (!panel) return;
    panel.style.visibility = (panel.style.visibility === "visible") ? "collapse" : "visible";
}

function OnUpdateMineLeaderboard(data) {
    var list = $("#MineLBList");
    if (!list) return;
    list.RemoveAndDeleteChildren();

    var board = [];
    for (var k in data.board) board.push(data.board[k]);
    board.sort(function(a, b) { return b.deaths - a.deaths; });

    for (var i = 0; i < board.length; i++) {
        var row = $.CreatePanel("Panel", list, "");
        row.AddClass("MineLBRow");
        if (i % 2 === 1) row.AddClass("MineLBRowAlt");

        var rank = $.CreatePanel("Label", row, "");
        rank.AddClass(i < 3 ? "MineLBRankTop3" : "MineLBRank");
        rank.text = (i + 1);

        var portrait = $.CreatePanel("DOTAHeroImage", row, "");
        portrait.AddClass("MineLBPortrait");
        portrait.heroname = board[i].name;
        portrait.heroimagestyle = "icon";

        var name = $.CreatePanel("Label", row, "");
        name.AddClass("MineLBName");
        name.text = Players.GetPlayerName(board[i].pid);

        var deaths = $.CreatePanel("Label", row, "");
        deaths.AddClass("MineLBDeaths");
        deaths.text = board[i].deaths;
    }
}

(function() {
    GameEvents.Subscribe("request_detonate_selected", OnRequestDetonateSelected);
    GameEvents.Subscribe("update_mine_leaderboard", OnUpdateMineLeaderboard);
})();
