var selectedLength = "";
var difficultyModes = ["Short","Med","Long"];
var difficultyCounts = [22, 22, 22];
var difficultyOffsets = [13, 13, 13];
var timer = $("#Countdown");
var voted = false

function HoverDifficulty(name) {
    if (voted) return;
    var panel = $("#"+name)

    if (name != selectedLength || selectedLength != "")
        panel.AddClass('Hover')
}

function MouseOverDiff(name) {
    var panel = $("#"+name)

    if (name != selectedLength)
        panel.RemoveClass('Hover')

}

function SelectDifficulty(name) {
    if (voted) return;
    var panel = $("#"+name)
    selectedLength = name

    for (var i in difficultyModes)
    {
        var diffPanel = $("#"+difficultyModes[i])
        if (difficultyModes[i] != selectedLength)
        {
            diffPanel.RemoveClass('Hover')
            diffPanel.RemoveClass('Selected')
        }
    }

    panel.AddClass('Hover')
    panel.AddClass('Selected')
    
    Game.EmitSound("ui_generic_button_click");
}

function ConfirmVote() {
    Game.EmitSound("ui_generic_button_click");
    $("#VoteBtn").enabled = false;
    voted = true;

    var idName = GetLengthID(selectedLength);
    var countHolder = $("#"+difficultyModes[idName]+"Count");
    difficultyCounts[idName] += difficultyOffsets[idName];
    difficultyOffsets[idName] *= 0.9;

    var miranaFace = $.CreatePanel("Panel", countHolder, "countPanel");
    miranaFace.style.position = difficultyCounts[idName]+"px 0 0 0";

    var data = {};
    data['length'] = selectedLength
    GameEvents.SendCustomGameEventToServer( "vote_cast", { "data" : data } );
}

function GetLengthID(name) {
    if (selectedLength == difficultyModes[0]) {
        return 0;
    } else if (selectedLength == difficultyModes[1]) {
        return 1;
    } else {
        return 2;
    }
}

function UpdateVoteTimer( data )
{
    timer.text = data.time;
}

function WinnerFound ( data ) 
{
    $.Msg("winner was " + data.winner);
    $("#Short").AddClass("Fade");
    $("#Med").AddClass("Fade");
    $("#Long").AddClass("Fade");
    $("#"+data.winner).RemoveClass("Fade");
    $("#Voting").DeleteAsync(1.5);
}

GameEvents.Subscribe( "update_vote_timer", UpdateVoteTimer);
GameEvents.Subscribe( "voting_done", WinnerFound);

