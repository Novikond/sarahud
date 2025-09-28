import backend.CoolUtil;
import backend.Rating;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxStringUtil;
import flixel.math.FlxMath;
import openfl.text.TextFormat;
import flixel.group.FlxTypedSpriteGroup;

// for my fellow p-slice users, it probably shows you oncreate error i have NO CLUE what that is, it doesn't affect the script at all it just does that i guess
function onCreatePost() {
    scoreTxt.destroy();

    hudTextGroup = new FlxTypedSpriteGroup();
    hudSpriteGroup = new FlxTypedSpriteGroup();
    boxGroup = new FlxTypedSpriteGroup();
    hudSpriteExtraGroup = new FlxTypedSpriteGroup();
    playerStrumBGGroup = new FlxTypedSpriteGroup();
    opponentStrumBGGroup = new FlxTypedSpriteGroup();

    if (getModSetting("strumBG") > 0) {
        for (i in 0 ... 4) {
            playerStrumBG = new FlxSprite(0, -100).makeGraphic(game.playerStrums.members[i].width + 3, FlxG.height + 200, FlxColor.BLACK);
            playerStrumBG.alpha = getModSetting("strumBG");
            insert(game.playerStrums.indexOf + 1, playerStrumBG);
            playerStrumBGGroup.camera = game.camHUD;
            playerStrumBGGroup.add(playerStrumBG);

            if (ClientPrefs.data.opponentStrums) {
                opponentStrumBG = new FlxSprite(0, -100).makeGraphic(game.opponentStrums.members[i].width + 3, FlxG.height + 200, FlxColor.BLACK);
                opponentStrumBG.alpha = getModSetting("strumBG");
                insert(game.opponentStrums.indexOf + 1, opponentStrumBG);
                opponentStrumBGGroup.camera = game.camHUD;
                opponentStrumBGGroup.add(opponentStrumBG);
            }
        }
    }

    switch(getModSetting("scoreType")) {
        case "Left", "Right":
            for (i in 0 ... 3) {
            hudSprite = new FlxSprite(getModSetting("scoreType") == "Left" ? 10 + (i * 5) : FlxG.width - 70 - (i * 5), ClientPrefs.data.downScroll ? 10 + (i * 42) : FlxG.height - 150 + (i * 42));
            switch(i) {
                case 0:
                    hudSprite.loadGraphic(Paths.image("hudIcons/miss"));
                case 1:
                    hudSprite.loadGraphic(Paths.image("hudIcons/score"));
                case 2:
                    hudSprite.loadGraphic(Paths.image("hudIcons/rating"));
            }
            hudSprite.scale.set(.6, .6);
            hudSprite.antialiasing = true;
            hudSprite.camera = game.camHUD;
            game.add(hudSprite);

            hudSpriteGroup.camera = camHUD;
            hudSpriteGroup.add(hudSprite);

            box = new FlxSprite(getModSetting("scoreType") == "Left" ? 70 + (i * 5) : FlxG.width - 170 - (i * 5), ClientPrefs.data.downScroll ? 28 + (i * 42) : FlxG.height - 133 + (i * 42));
            box.makeGraphic(100, 24, FlxColor.BLACK);
            box.alpha = getModSetting("scoreBG");
            box.antialiasing = true;
            box.camera = game.camHUD;
            game.add(box);

            boxGroup.camera = game.camHUD;
            boxGroup.add(box);
            }

            hudText = new FlxText(getModSetting("scoreType") == "Left" ? 75 : FlxG.width - 475, hudSprite.y - 65, 400, getModSetting("scoreType") == "Left" ? "0\n\n 0\n\n  ?" : "0\n\n0 \n\n?  ", 20);
            hudText.setFormat(Paths.font("PhantomMuff.ttf"), 18, FlxColor.WHITE, getModSetting("scoreType") == "Left" ? "left" : "right", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            hudText.antialiasing = true;
            hudText.camera = game.camHUD;
            game.add(hudText);

        case "Center", "Vanilla":
            for (i in 0 ... 3) {
            hudSprite = new FlxSprite((FlxG.width / 2 - 250) + (i * 165), game.healthBar.y + 20);
            switch(i) {
                case 0:
                    hudSprite.loadGraphic(Paths.image("hudIcons/miss"));
                case 1:
                    hudSprite.loadGraphic(Paths.image("hudIcons/rating"));
                case 2:
                    hudSprite.loadGraphic(Paths.image("hudIcons/score"));
            }
            hudSprite.scale.set(.6, .6);
            hudSprite.antialiasing = true;
            hudSprite.camera = game.camHUD;
            game.add(hudSprite);

            hudSpriteGroup.camera = camHUD;
            hudSpriteGroup.add(hudSprite);

            box = new FlxSprite((FlxG.width / 2 - 192) + (i * 165), game.healthBar.y + 37).makeGraphic(100, 24, FlxColor.BLACK);
            box.alpha = getModSetting("scoreBG");
            box.antialiasing = true;
            box.camera = game.camHUD;
            game.add(box);

            boxGroup.camera = camHUD;
            boxGroup.add(box);

            hudText = new FlxText((FlxG.width / 2 - 190) + (i * 165), box.y + 2, 0, "0", 20);
            hudText.setFormat(Paths.font("PhantomMuff.ttf"), 18, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            hudText.antialiasing = true;
            game.add(hudText);

            hudTextGroup.camera = camHUD;
            hudTextGroup.add(hudText);
            }

            hudTextGroup.members[1].text = "?";

            if (getModSetting("scoreType") == "Vanilla") {
                for (i in 0 ... 2) {
                    hudSpriteGroup.members[i].destroy();
                    boxGroup.members[i].destroy();
                    hudTextGroup.members[i].destroy();
                }
            }
    }

    if (getModSetting("extraScore") != "Disabled") {
        boxExtra = new FlxSprite(getModSetting("extraScore") == "Right" ? FlxG.width - 63 : 17, FlxG.height / 2 - 100).makeGraphic(45, 185, FlxColor.BLACK);
        boxExtra.alpha = getModSetting("scoreBG");
        boxExtra.antialiasing = true;
        boxExtra.camera = game.camHUD;
        game.add(boxExtra);
        
        for (i in 0 ... 4) {
            hudSpriteExtra = new FlxSprite(getModSetting("extraScore") == "Right" ? FlxG.width - 70 : 10, FlxG.height / 2 - 100 + (i * 42));
            switch(i) {
                case 0:
                    hudSpriteExtra.loadGraphic(Paths.image("hudIcons/sick"));
                case 1:
                    hudSpriteExtra.loadGraphic(Paths.image("hudIcons/good"));
                case 2:
                    hudSpriteExtra.loadGraphic(Paths.image("hudIcons/bad"));
                case 3:
                    hudSpriteExtra.loadGraphic(Paths.image("hudIcons/shit"));
            }
            hudSpriteExtra.scale.set(.6, .6);
            hudSpriteExtra.alpha = .8;
            hudSpriteExtra.antialiasing = true;
            hudSpriteExtra.camera = game.camHUD;
            game.add(hudSpriteExtra);
        }

        hudTextExtra = new FlxText(boxExtra.x - 77, FlxG.height / 2 - 80, 200, "0\n\n0\n\n0\n\n0", 20);
        hudTextExtra.setFormat(Paths.font("PhantomMuff.ttf"), 18, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        hudTextExtra.alpha = .9;
        hudTextExtra.antialiasing = true;
        hudTextExtra.camera = game.camHUD;
        game.add(hudTextExtra);
    }

    if (game.timeBarType != "Disabled" && getModSetting("stylizedElements")) {
        game.timeTxt.setFormat(Paths.font("PhantomMuff.ttf"), 22, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        game.timeTxt.antialiasing = true;
        game.timeTxt.x = game.timeBar.x + (game.timeBar.width / 2) - (game.timeTxt.width / 2);
        game.timeTxt.y += 4;
    }
}

function onUpdatePost() {
    if (getModSetting("strumBG") > 0) {
        for (i in 0 ... 4) {
            playerStrumBGGroup.members[i].x = game.playerStrums.members[i].x;

            if (ClientPrefs.data.opponentStrums) {
                opponentStrumBGGroup.members[i].x = game.opponentStrums.members[i].x;
            }
        }
    }
}

function goodNoteHit() {
    switch(getModSetting("scoreType")) {
        case "Left":
            hudText.text = misses + "\n\n " + FlxStringUtil.formatMoney(score, false) + "\n\n  " + CoolUtil.floorDecimal(rating * 100, 2) + "%";
        
        case "Right":
            hudText.text = misses + "\n\n" + FlxStringUtil.formatMoney(score, false) + " \n\n" + CoolUtil.floorDecimal(rating * 100, 2) + "%  ";

        case "Center":
            hudTextGroup.members[0].text = misses;
            hudTextGroup.members[1].text = CoolUtil.floorDecimal(rating * 100, 2) + "%";
            hudTextGroup.members[2].text = FlxStringUtil.formatMoney(score, false);

        case "Vanilla":
            hudText.text = FlxStringUtil.formatMoney(score, false);
    }

    if (getModSetting("extraScore") != "Disabled") {
        hudTextExtra.text = ratingsData[0].hits + "\n\n" + ratingsData[1].hits + "\n\n" + ratingsData[2].hits + "\n\n" + ratingsData[3].hits;
    }
}

function noteMiss() {
    switch(getModSetting("scoreType")) {
        case "Left":
            hudText.text = misses + "\n\n " + FlxStringUtil.formatMoney(score, false) + "\n\n  " + CoolUtil.floorDecimal(rating * 100, 2) + "%";

        case "Right":
            hudText.text = misses + "\n\n" + FlxStringUtil.formatMoney(score, false) + " \n\n" + CoolUtil.floorDecimal(rating * 100, 2) + "%  ";
        
        case "Center":
            hudTextGroup.members[0].text = misses;
            hudTextGroup.members[1].text = FlxStringUtil.formatMoney(score, false);
            hudTextGroup.members[2].text = CoolUtil.floorDecimal(rating * 100, 2) + "%";

        case "Vanilla":
            hudText.text = FlxStringUtil.formatMoney(score, false);
    }
}