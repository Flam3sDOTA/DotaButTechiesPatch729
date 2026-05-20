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
    var opening = panel.style.visibility !== "visible";
    panel.style.visibility = opening ? "visible" : "collapse";
    Game.EmitSound(opening ? "ui.profile_open" : "ui.profile_close");
}

var mineLBServerTime  = 0;
var mineLBLocalSnap   = 0;
var mineLBLastRefs    = [];

function FormatClock(sec) {
    if (sec === undefined || sec === null || sec === 0) return "—";
    if (sec < 0) return "Pre-horn";
    var m = Math.floor(sec / 60);
    var s = Math.floor(sec % 60);
    return m + ":" + (s < 10 ? "0" : "") + s;
}

function FormatRelative(sec) {
    if (!sec || sec < 0) return "—";
    if (sec < 60) return Math.floor(sec) + "s ago";
    var m = Math.floor(sec / 60);
    var s = Math.floor(sec % 60);
    return m + ":" + (s < 10 ? "0" : "") + s + " ago";
}

function EffectiveServerTime() {
    var elapsedSinceSnap = (Date.now() / 1000) - mineLBLocalSnap;
    return mineLBServerTime + elapsedSinceSnap;
}

function UpdateLastAgo(label, lastAt) {
    if (!lastAt || lastAt <= 0) {
        label.text = "—";
        return;
    }
    label.text = FormatRelative(EffectiveServerTime() - lastAt);
}

function OnUpdateMineLeaderboard(data) {
    var list = $("#MineLBList");
    if (!list) return;
    list.RemoveAndDeleteChildren();
    mineLBLastRefs = [];

    mineLBServerTime = data.server_time || 0;
    mineLBLocalSnap  = Date.now() / 1000;

    var board = [];
    for (var k in data.board) board.push(data.board[k]);
    board.sort(function(a, b) {
        if (b.deaths !== a.deaths) return b.deaths - a.deaths;
        return a.pid - b.pid;
    });

    for (var i = 0; i < board.length; i++) {
        var entry = board[i];
        var row = $.CreatePanel("Panel", list, "");
        row.AddClass("MineLBRow");
        if (i === 0) row.AddClass("MineLBRow1");
        else if (i % 2 === 1) row.AddClass("MineLBRowAlt");

        var rank = $.CreatePanel("Label", row, "");
        rank.AddClass(i < 3 ? "MineLBRankTop3" : "MineLBRank");
        if (i === 0) {
            rank.AddClass("MineLBRank1");
            rank.text = "";
        } else {
            rank.text = (i + 1);
            if (i === 1) rank.AddClass("MineLBRank2");
            else if (i === 2) rank.AddClass("MineLBRank3");
        }

        var portrait = $.CreatePanel("DOTAHeroImage", row, "");
        portrait.AddClass("MineLBPortrait");
        portrait.heroname = entry.name;
        portrait.heroimagestyle = "icon";

        var name = $.CreatePanel("Label", row, "");
        name.AddClass("MineLBName");
        name.text = Players.GetPlayerName(entry.pid);

        var deaths = $.CreatePanel("Label", row, "");
        deaths.AddClass("MineLBDeaths");
        deaths.text = entry.deaths;

        var land = $.CreatePanel("Label", row, "");
        land.AddClass("MineLBLand");
        land.text = (entry.land || 0);

        var remote = $.CreatePanel("Label", row, "");
        remote.AddClass("MineLBRemote");
        remote.text = (entry.remote || 0);

        var suicide = $.CreatePanel("Label", row, "");
        suicide.AddClass("MineLBSuicide");
        suicide.text = (entry.suicide || 0);

        var multi = $.CreatePanel("Label", row, "");
        multi.AddClass("MineLBMulti");
        multi.text = "x" + (entry.multi || 0);

        var first = $.CreatePanel("Label", row, "");
        first.AddClass("MineLBFirst");
        first.text = FormatClock(entry.first_at);

        var last = $.CreatePanel("Label", row, "");
        last.AddClass("MineLBLast");
        UpdateLastAgo(last, entry.last_at);
        mineLBLastRefs.push({ label: last, last_at: entry.last_at });
    }
}

function TickMineLBRefresh() {
    for (var i = 0; i < mineLBLastRefs.length; i++) {
        var ref = mineLBLastRefs[i];
        if (ref.label && ref.label.IsValid && ref.label.IsValid()) {
            UpdateLastAgo(ref.label, ref.last_at);
        }
    }
    $.Schedule(1, TickMineLBRefresh);
}

var MINE_RING_OWN  = "particles/mineringindicator.vpcf";
var MINE_RING_ALLY = "particles/mineringindicator_ally.vpcf";

var trackedMines = {};
var activeRings  = {};
var lastAltDown  = false;

function ShowRingForMine(entindex) {
    if (activeRings[entindex]) return;
    var mine = trackedMines[entindex];
    if (!mine) return;
    var localPid = Players.GetLocalPlayer();
    if (Players.GetTeam(localPid) !== mine.team) return;
    var particle = (mine.owner_pid === localPid) ? MINE_RING_OWN : MINE_RING_ALLY;
    var pIdx = Particles.CreateParticle(particle, ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, parseInt(entindex));
    Particles.SetParticleControl(pIdx, 1, [mine.min_dist, 0, 0]);
    activeRings[entindex] = pIdx;
}

function HideRingForMine(entindex) {
    var pIdx = activeRings[entindex];
    if (pIdx !== undefined) {
        Particles.DestroyParticleEffect(pIdx, true);
        Particles.ReleaseParticleIndex(pIdx);
        delete activeRings[entindex];
    }
}

function ShowAllRings() {
    for (var entindex in trackedMines) {
        ShowRingForMine(entindex);
    }
}

function HideAllRings() {
    for (var entindex in activeRings) {
        var pIdx = activeRings[entindex];
        Particles.DestroyParticleEffect(pIdx, true);
        Particles.ReleaseParticleIndex(pIdx);
    }
    activeRings = {};
}

function OnMinePlanted(data) {
    trackedMines[data.entindex] = {
        owner_pid: data.owner_pid,
        team: data.team,
        min_dist: data.min_dist
    };
    if (lastAltDown) ShowRingForMine(data.entindex);
}

function OnMineRemoved(data) {
    delete trackedMines[data.entindex];
    HideRingForMine(data.entindex);
}

function TickAlt() {
    var altDown = GameUI.IsAltDown();
    if (altDown && !lastAltDown) {
        ShowAllRings();
    } else if (!altDown && lastAltDown) {
        HideAllRings();
    }
    lastAltDown = altDown;
    $.Schedule(0.05, TickAlt);
}

(function() {
    GameEvents.Subscribe("request_detonate_selected", OnRequestDetonateSelected);
    GameEvents.Subscribe("update_mine_leaderboard", OnUpdateMineLeaderboard);
    GameEvents.Subscribe("mine_planted", OnMinePlanted);
    GameEvents.Subscribe("mine_removed", OnMineRemoved);
    TickAlt();
    TickMineLBRefresh();
})();
