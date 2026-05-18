var voteOptionNames = [];

function VoteOptionClicked(opt) {
    if (opt === "force_techies" && $("#force_techies").checked) {
        $("#random_techies").checked = false;
        GameEvents.SendCustomGameEventToServer("vote_option_clicked", {
            option: "random_techies",
            playerID: Players.GetLocalPlayer(),
            value: false
        });
    }
    if (opt === "random_techies" && $("#random_techies").checked) {
        $("#force_techies").checked = false;
        GameEvents.SendCustomGameEventToServer("vote_option_clicked", {
            option: "force_techies",
            playerID: Players.GetLocalPlayer(),
            value: false
        });
    }
    if (opt === "turbo_mode" && $("#turbo_mode").checked) {
        $("#turbo_mode_full").checked = false;
        GameEvents.SendCustomGameEventToServer("vote_option_clicked", {
            option: "turbo_mode_full",
            playerID: Players.GetLocalPlayer(),
            value: false
        });
    }
    if (opt === "turbo_mode_full" && $("#turbo_mode_full").checked) {
        $("#turbo_mode").checked = false;
        GameEvents.SendCustomGameEventToServer("vote_option_clicked", {
            option: "turbo_mode",
            playerID: Players.GetLocalPlayer(),
            value: false
        });
    }

    var data = {
        option: opt,
        playerID: Players.GetLocalPlayer(),
        value: $("#" + opt).checked
    };
    GameEvents.SendCustomGameEventToServer("vote_option_clicked", data);
}

function UpdateVoteLabel(data) {
    if (voteOptionNames[data.option] == null) {
        voteOptionNames[data.option] = $("#" + data.option).text;
    }
    var playerCount = data.playerCount;
    $("#" + data.option).text = voteOptionNames[data.option] + " " + data.votes + "/" + playerCount;
}

(function () {
    GameEvents.Subscribe("update_vote_label", UpdateVoteLabel);
})();