-----------------------------------------------------------------------------------------
-- ABSTRACT - UGLY FISH VS TINY FINS
-- CREATED BY PICKION GAMES
-- HTTP://PICKLEANDONIONS.COM/

-- VERSION - 1.0
-- 
-- COPYRIGHT (C) 2014 PICKLE & ONIONS. ALL RIGHTS RESERVED.
-----------------------------------------------------------------------------------------
-- Initial Settings
display.setStatusBar( display.HiddenStatusBar ) --Hide status bar from the beginning

display.setDefault("background", 1, 1, 1, 1)

local storyboard = require( "storyboard" )
storyboard.purgeOnSceneChange = true --So storyboard automatically purges for us.

connection = require("testconnection")
system.activate("multitouch")
local gameNetwork = require("gameNetwork")
local loadsave = require("loadsave")

math.randomseed( os.time() )
math.random()
math.random()

_G.soundAllowed = true --Set this to true anywhere.
_G.musicAllowed = true --Set this to true anywhere.
_G.isAdsAllowed = true

--Our global play sound function.
local sounds = {}
sounds["music"] = audio.loadStream("sounds/deepEmerald.wav")
sounds["click"] = audio.loadSound("sounds/click.wav")
sounds["crash"] = audio.loadSound("sounds/sharkbite.wav")
sounds["score"] = audio.loadSound("sounds/scored.wav")
sounds["jump"] = audio.loadSound("sounds/jump.wav")
sounds["error"] = audio.loadSound("sounds/errorWrong.wav")
audio.setVolume(0.1, {channel = 1})
audio.setVolume(1, {channel = 2})
audio.setVolume(0.2, {channel = 3})
audio.setVolume(1, {channel = 4})
audio.setVolume(0.2, {channel = 5})
audio.setVolume(1, {channel = 6})
function playSound(name) --Just pass a name to it. e.g. "select"
	if name == "music" then
		audio.stop(1)
		audio.play(sounds["music"], {channel=1, loops=-1})
	elseif name == "click" then
		audio.stop(2)
		audio.play(sounds["click"], {channel=2})
	elseif name == "crash" then
		audio.stop(3)
		audio.play(sounds["crash"], {channel=3})
	elseif name == "score" then
		audio.stop(4)
		audio.play(sounds["score"], {channel=4})
	elseif name == "jump" then
		audio.stop(5)
		audio.play(sounds["jump"], {channel=5})
	elseif name == "error" then
		audio.stop(6)
		audio.play(sounds["error"], {channel=6})
	end
end

-- Set up global variables
customFont = "RoundsBlack" -- font name
if system.getInfo("platformName") == "Android" then
	customFont = "RoundsBlack"
end


local AdMob = require("ads")
local adMobListener = function(event) print("ADMOB AD - Event: " .. event.response) end
AdMob.init( "admob", adMobId, adMobListener )

function showAdMobbAd(position)
	if (connection.test()) then
		if isAdsAllowed then
			hideAdMobAd()
			AdMob.show( "banner", {x=0, y=position})
			print("showing banner ad")
		end
	end
end

-- put showAdMobbAdInter() in the location I want to have a pop up ad show.
function showAdMobbAdInter( event )
	if (connection.test()) then
		if isAdsAllowed then
			hideAdMobAd()
			AdMob.show( "interstitial", {testMode=false, appId=adMobIdInter} )
			print("showing popup ad")
		end
	end
end

function hideAdMobAd()
	AdMob.hide()
end

function requestCallback( event )
	if event.type == "setHighScore" then
		local function alertCompletion() gameNetwork.request( "loadScores", { leaderboard={ category="UglyFishHighestScore", playerScope="Global", timeScope="AllTime", range={1,25} }, listener=requestCallback } ); end
--			native.showAlert( "High Score Reported!", "", { "OK" }, alertCompletion )
	end
end

function initCallback( event )
	if event.type == "showSignIn" then
	elseif event.data then
		loggedIntoGC = true
--			native.showAlert( "Success!", "", { "OK" } )
	end
end

function offlineAlert() 
	native.showAlert( "GameCenter Offline", "Please check your internet connection.", { "OK" } )
end

function onSystemEvent(event)
	if ( event.type == "applicationStart" ) then
		gameNetwork.init( "gamecenter", { listener=initCallback } )
		print("App is Open. Game Center Initiated.")
		return true
	end
end

function checkIfDataExists()
	if gameData.gameHighScore == nil 	then gameData.gameHighScore = 0 	else print("Data Already Exists, No Table Created.") end
	if gameData.gameCoinWallet == nil 	then gameData.gameCoinWallet = 0 	else end
	if gameData.gameCount == nil		then gameData.gameCount = 0			else end
	if gameData.whichFish == nil 		then gameData.whichFish = 1 		else end
end

function checkIfFishDataExists()
	if fishDatabase[1] == nil 		then fishDatabase[1] = {name = "Original Yellow", cost = 0, image = "images/fish/bigFishOrange.png", unlocked = true} end
	if fishDatabase[2] == nil 		then fishDatabase[2] = {name = "Original Orange", cost = 5, image = "images/fish/bigFishGreen.png", unlocked = false} end
	if fishDatabase[3] == nil 		then fishDatabase[3] = {name = "Original Green", cost = 10, image = "images/fish/bigFishBlue.png", unlocked = false} end
	if fishDatabase[4] == nil 		then fishDatabase[4] = {name = "Original Blue", cost = 15, image = "images/fish/bigFishRed.png", unlocked = false} end
	if fishDatabase[5] == nil 		then fishDatabase[5] = {name = "Original Red", cost = 25, image = "images/fish/bigFishYellow.png", unlocked = false} end
end

gameData = loadsave.loadTable("dataFile01.json")
fishDatabase = loadsave.loadTable("dataFile02.json")

if gameData == nil then
	gameData = {}
	loadsave.saveTable(gameData, "dataFile01.json")
	print("Game Data Nil So Create Game Data.")
else
	print("Game Data Not Nil.")
end

if fishDatabase == nil then
	fishDatabase = {}
	loadsave.saveTable(fishDatabase, "dataFile02.json")
	print("Fish Database Nil so Create Fish Database")
else
	print("Fish Database Not Nil")
end

checkIfDataExists()
checkIfFishDataExists()

Runtime:addEventListener("system", onSystemEvent)

-- Now change scene to go to the menu.
storyboard.gotoScene( "menu", "crossFade", 500 )