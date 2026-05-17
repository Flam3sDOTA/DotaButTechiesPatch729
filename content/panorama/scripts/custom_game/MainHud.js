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

(function() {
    GameEvents.Subscribe("request_detonate_selected", OnRequestDetonateSelected);
})();
