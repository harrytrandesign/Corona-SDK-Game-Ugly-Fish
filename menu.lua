-----------------------------------------------------------------------------------------
-- ABSTRACT - UGLY FISH VS TINY FINS
-- CREATED BY PICKION GAMES
-- HTTP://PICKLEANDONIONS.COM/

-- VERSION - 1.0
-- 
-- COPYRIGHT (C) 2014 PICKLE & ONIONS. ALL RIGHTS RESERVED.
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local gameNetwork = require("gameNetwork")

-----------------------------------------------
--*** Set up our variables and group ***
-----------------------------------------------

--	CONSTANT VARIABLES
local _W = display.contentWidth
local _H = display.contentHeight
local screenLeft = display.screenOriginX
local screenWidth = display.contentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.contentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local mSin = math.sin
local mAtan2 = math.atan2
local mPi = math.pi 
local mRand = math.random
local mCeil = math.ceil
local mSqrt = math.sqrt
local mPow = math.pow

local menuSpeed = 2;
local isButtonClickable = true

--	COLOR PALETTE
local colorFontUIText =			{R = 238/255,	G = 253/255,	B = 210/255,	A = 255/255}
local colorBlueSky =			{R = 168/255,	G = 200/255,	B = 238/255,	A = 255/255}
local colorLightGreen =			{R = 148/255,	G = 203/255,	B = 122/255,	A = 255/255}
local colorDarkGreen =			{R = 93/255,	G = 164/255,	B = 124/255,	A = 255/255}
local colorSandBeach =			{R = 232/255,	G = 206/255,	B = 169/255,	A = 255/255}
local colorBlueWater =			{R = 21/255,	G = 43/255,		B = 64/255,		A = 255/255}
local colorDeepSeaBed =			{R = 12/255,	G = 22/255,		B = 32/255,		A = 255/255}
local colorBubbleBlue = {}
		colorBubbleBlue[1] =	{R = 11/255,	G = 72/255,		B = 107/255,	A = 255/255}
		colorBubbleBlue[2] =	{R = 59/255,	G = 134/255,	B = 134/255,	A = 255/255}
		colorBubbleBlue[3] =	{R = 121/255,	G = 189/255,	B = 154/255,	A = 255/255}
		colorBubbleBlue[4] =	{R = 168/255,	G = 219/255,	B = 168/255,	A = 255/255}		

-- Sprite Sheet Images
local fishSequenceData = {name = "fishSwim", start = 1, count = 2, time = 500}

-- Display Groups
local menuGroup
local leftFishGroup
local rightFishGroup
local uiButtonGroup

local menuDecorFish = {}

-- Functions
local createMenu
local removeAllListeners
local switchScenes
local goToCreditsPage
local fishPurchase
local showLeaderBoardGC
local likeFacebook
local followTwitter
local waterBubblesMenu
local spawnFish
local destroyFish
local gameLoopMenu

-----------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------
-- Called when the scene's view does not exist:
-- Create all your display objects here.
function scene:createScene( event )
	local mainMenuGroup = self.view

	menuGroup = display.newGroup();										mainMenuGroup:insert(menuGroup)
	leftFishGroup = display.newGroup();									mainMenuGroup:insert(leftFishGroup)
	rightFishGroup = display.newGroup();								mainMenuGroup:insert(rightFishGroup)
	uiButtonGroup = display.newGroup();									mainMenuGroup:insert(uiButtonGroup)

	function createMenu()
		menuDecorBlueSky = display.newRect(0, 0, screenWidth, screenHeight)
		menuDecorBlueSky:setFillColor(colorBlueSky.R, colorBlueSky.G, colorBlueSky.B, colorBlueSky.A)
		menuDecorBlueSky.anchorX = 0.5;										menuDecorBlueSky.x = centerX;
		menuDecorBlueSky.anchorY = 1;										menuDecorBlueSky.y = screenHeight;

		menuDecorLightGround = display.newRect(0, 0, screenWidth, screenHeight)
		menuDecorLightGround:setFillColor(colorLightGreen.R, colorLightGreen.G, colorLightGreen.B, colorLightGreen.A)
		menuDecorLightGround.anchorX = 0.5;									menuDecorLightGround.x = centerX;
		menuDecorLightGround.anchorY = 1;									menuDecorLightGround.y = screenHeight;

		menuDecorDarkGround = display.newRect(0, 0, screenWidth, screenHeight)
		menuDecorDarkGround:setFillColor(colorDarkGreen.R, colorDarkGreen.G, colorDarkGreen.B, colorDarkGreen.A)
		menuDecorDarkGround.anchorX = 0.5;									menuDecorDarkGround.x = centerX;
		menuDecorDarkGround.anchorY = 1;									menuDecorDarkGround.y = screenHeight;

		menuDecorSandBeach = display.newRect(0, 0, screenWidth, screenHeight)
		menuDecorSandBeach:setFillColor(colorSandBeach.R, colorSandBeach.G, colorSandBeach.B, colorSandBeach.A)
		menuDecorSandBeach.anchorX = 0.5;									menuDecorSandBeach.x = centerX;
		menuDecorSandBeach.anchorY = 1;										menuDecorSandBeach.y = screenHeight;

		menuDecorUpperSea = display.newRect(0, 0, screenWidth, screenHeight)
		menuDecorUpperSea:setFillColor(colorBlueWater.R, colorBlueWater.G, colorBlueWater.B, colorBlueWater.A)
		menuDecorUpperSea.anchorX = 0.5;									menuDecorUpperSea.x = centerX;
		menuDecorUpperSea.anchorY = 1;										menuDecorUpperSea.y = screenHeight;

		menuDecorDeeperSea = display.newRect(0, 0, screenWidth, screenHeight)
		menuDecorDeeperSea:setFillColor(colorDeepSeaBed.R, colorDeepSeaBed.G, colorDeepSeaBed.B, colorDeepSeaBed.A)
		menuDecorDeeperSea.anchorX = 0.5;									menuDecorDeeperSea.x = centerX;
		menuDecorDeeperSea.anchorY = 1;										menuDecorDeeperSea.y = screenHeight;

		menuDecorTreesAndHills = display.newImageRect("images/graphics/mountainTree.png", 320, 100)
		menuDecorTreesAndHills.anchorX = 0.5;								menuDecorTreesAndHills.x = centerX;
		menuDecorTreesAndHills.anchorY = 1;									menuDecorTreesAndHills.y = -screenHeight;

		-- Set up buttons and icons and logos
		menuGameLogo = display.newImageRect("images/graphics/logoGame.png", 240, 140)
		menuGameLogo.anchorX = 0.5;											menuGameLogo.x = centerX;
		menuGameLogo.anchorY = 0.5;											menuGameLogo.y = centerY - 100;

		menuButtonPlay = display.newImageRect("images/buttons/orangePlayButton.png", 160, 160)
		menuButtonPlay.xScale = 0.5;										menuButtonPlay.yScale = 0.5;
		menuButtonPlay.anchorX = 0.5;										menuButtonPlay.x = centerX;
		menuButtonPlay.anchorY = 0;											menuButtonPlay.y = centerY + 40;

		menuButtonAchievement = display.newImageRect("images/buttons/orangeAchievementButton.png", 80, 80)
		menuButtonAchievement.xScale = 0.5;									menuButtonAchievement.yScale = 0.5;
		menuButtonAchievement.anchorX = 0;									menuButtonAchievement.x = 10;
		menuButtonAchievement.anchorY = 1;									menuButtonAchievement.y = screenHeight - 130;

		menuButtonTwitterFollow = display.newImageRect("images/buttons/flatDesignTwitterButton.png", 80, 80)
		menuButtonTwitterFollow.xScale = 0.5;								menuButtonTwitterFollow.yScale = 0.5;
		menuButtonTwitterFollow.anchorX = 0;								menuButtonTwitterFollow.x = 10;
		menuButtonTwitterFollow.anchorY = 1;								menuButtonTwitterFollow.y = screenHeight - 80;

		menuButtonFacebookLike = display.newImageRect("images/buttons/flatDesignFacebookButton.png", 80, 80)
		menuButtonFacebookLike.xScale = 0.5;								menuButtonFacebookLike.yScale = 0.5;
		menuButtonFacebookLike.anchorX = 0;									menuButtonFacebookLike.x = 10;
		menuButtonFacebookLike.anchorY = 1;									menuButtonFacebookLike.y = screenHeight - 30;

		function menuSoundToggle(event)
			if soundAllowed then
				menuButtonSoundAdjust:removeSelf()
				menuButtonSoundAdjust = nil
				soundAllowed = false
				menuButtonSoundAdjust = display.newImageRect("images/buttons/orangeVolumeOffButton.png", 80, 80)
				menuButtonSoundAdjust.xScale = 0.5;								menuButtonSoundAdjust.yScale = 0.5;
				menuButtonSoundAdjust.anchorX = 1;								menuButtonSoundAdjust.x = screenWidth - 10;
				menuButtonSoundAdjust.anchorY = 1;								menuButtonSoundAdjust.y = screenHeight - 80;
				menuButtonSoundAdjust:addEventListener("tap", menuSoundToggle)
				uiButtonGroup:insert(menuButtonSoundAdjust)
			else
				menuButtonSoundAdjust:removeSelf()
				menuButtonSoundAdjust = nil
				soundAllowed = true
				menuButtonSoundAdjust = display.newImageRect("images/buttons/orangeVolumeOnButton.png", 80, 80)
				menuButtonSoundAdjust.xScale = 0.5;								menuButtonSoundAdjust.yScale = 0.5;
				menuButtonSoundAdjust.anchorX = 1;								menuButtonSoundAdjust.x = screenWidth - 10;
				menuButtonSoundAdjust.anchorY = 1;								menuButtonSoundAdjust.y = screenHeight - 80;
				menuButtonSoundAdjust:addEventListener("tap", menuSoundToggle)
				uiButtonGroup:insert(menuButtonSoundAdjust)
			end
			return true
		end

		if soundAllowed then
			menuButtonSoundAdjust = display.newImageRect("images/buttons/orangeVolumeOnButton.png", 80, 80)
		else
			menuButtonSoundAdjust = display.newImageRect("images/buttons/orangeVolumeOffButton.png", 80, 80)
		end
		menuButtonSoundAdjust.xScale = 0.5;										menuButtonSoundAdjust.yScale = 0.5;
		menuButtonSoundAdjust.anchorX = 1;										menuButtonSoundAdjust.x = screenWidth - 10;
		menuButtonSoundAdjust.anchorY = 1;										menuButtonSoundAdjust.y = screenHeight - 80;
		menuButtonSoundAdjust:addEventListener("tap", menuSoundToggle)

		function menuMusicToggle(event)
			if musicAllowed then
				menuButtonMusicAdjust:removeSelf()
				menuButtonMusicAdjust = nil
				musicAllowed = false
				audio.stop(1)
				menuButtonMusicAdjust = display.newImageRect("images/buttons/orangeMusicOffButton.png", 80, 80)
				menuButtonMusicAdjust.xScale = 0.5;								menuButtonMusicAdjust.yScale = 0.5;
				menuButtonMusicAdjust.anchorX = 1;								menuButtonMusicAdjust.x = screenWidth - 10;
				menuButtonMusicAdjust.anchorY = 1;								menuButtonMusicAdjust.y = screenHeight - 130;
				menuButtonMusicAdjust:addEventListener("tap", menuMusicToggle)
				uiButtonGroup:insert(menuButtonMusicAdjust)
			else
				menuButtonMusicAdjust:removeSelf()
				menuButtonMusicAdjust = nil
				musicAllowed = true
				if musicAllowed then playSound("music") end
				menuButtonMusicAdjust = display.newImageRect("images/buttons/orangeMusicOnButton.png", 80, 80)
				menuButtonMusicAdjust.xScale = 0.5;								menuButtonMusicAdjust.yScale = 0.5;
				menuButtonMusicAdjust.anchorX = 1;								menuButtonMusicAdjust.x = screenWidth - 10;
				menuButtonMusicAdjust.anchorY = 1;								menuButtonMusicAdjust.y = screenHeight - 130;
				menuButtonMusicAdjust:addEventListener("tap", menuMusicToggle)
				uiButtonGroup:insert(menuButtonMusicAdjust)
			end
			return true
		end

		if musicAllowed then
			menuButtonMusicAdjust = display.newImageRect("images/buttons/orangeMusicOnButton.png", 80, 80)
		else
			menuButtonMusicAdjust = display.newImageRect("images/buttons/orangeMusicOffButton.png", 80, 80)
		end
		menuButtonMusicAdjust.xScale = 0.5;										menuButtonMusicAdjust.yScale = 0.5;
		menuButtonMusicAdjust.anchorX = 1;										menuButtonMusicAdjust.x = screenWidth - 10;
		menuButtonMusicAdjust.anchorY = 1;										menuButtonMusicAdjust.y = screenHeight - 130;
		menuButtonMusicAdjust:addEventListener("tap", menuMusicToggle)

		menuImageCoin = display.newImageRect("images/graphics/fishCoinsFlat.png", 80, 80)
		menuImageCoin.xScale = 0.5;												menuImageCoin.yScale = 0.5;
		menuImageCoin.anchorX = 1;												menuImageCoin.x = screenWidth - 10;
		menuImageCoin.anchorY = 1;												menuImageCoin.y = screenHeight - 30;

		menuTextCoinNumber = display.newText("" .. gameData.gameCoinWallet, 0, 0, customFont, 24 * 2)
		menuTextCoinNumber:setFillColor(colorFontUIText.R, colorFontUIText.G, colorFontUIText.B, colorFontUIText.A)
		menuTextCoinNumber.xScale = 0.5;										menuTextCoinNumber.yScale = 0.5;
		menuTextCoinNumber.anchorX = 1;											menuTextCoinNumber.x = screenWidth - 55;
		menuTextCoinNumber.anchorY = 1;											menuTextCoinNumber.y = screenHeight - 35;

		menuButtonBuyFish = display.newImageRect("images/buttons/orangeDollarSignButton.png", 80, 80)
		menuButtonBuyFish.xScale = 0.5;											menuButtonBuyFish.yScale = 0.5;
		menuButtonBuyFish.anchorX = 1;											menuButtonBuyFish.x = screenWidth - 10;
		menuButtonBuyFish.anchorY = 1;											menuButtonBuyFish.y = screenHeight - 180;

		menuTextTimesPlayedCount = display.newText("Total Games Played: " .. gameData.gameCount, 0, 0, customFont, 12 * 2)
		menuTextTimesPlayedCount:setFillColor(colorFontUIText.R, colorFontUIText.G, colorFontUIText.B, colorFontUIText.A)
		menuTextTimesPlayedCount.xScale = 0.5;									menuTextTimesPlayedCount.yScale = 0.5;
		menuTextTimesPlayedCount.anchorX = 0.5;									menuTextTimesPlayedCount.x = centerX;
		menuTextTimesPlayedCount.anchorY = 1;									menuTextTimesPlayedCount.y = screenHeight - 2;

		menuButtonRemoveAds = display.newImageRect("images/buttons/orangeNoAdsButton.png", 80, 80)
		menuButtonRemoveAds.xScale = 0.5;										menuButtonRemoveAds.yScale = 0.5;
		menuButtonRemoveAds.anchorX = 0;										menuButtonRemoveAds.x = 10;
		menuButtonRemoveAds.anchorY = 0;										menuButtonRemoveAds.y = 10;
		menuButtonRemoveAds.isVisible = false;

		menuButtonShowCredits = display.newImageRect("images/buttons/orangeInfoButton.png", 80, 80)
		menuButtonShowCredits.xScale = 0.5;										menuButtonShowCredits.yScale = 0.5;
		menuButtonShowCredits.anchorX = 1;										menuButtonShowCredits.x = screenWidth - 10;
		menuButtonShowCredits.anchorY = 0;										menuButtonShowCredits.y = 10;

		menuGroup:insert(menuDecorBlueSky)
		menuGroup:insert(menuDecorLightGround)
		menuGroup:insert(menuDecorDarkGround)
		menuGroup:insert(menuDecorSandBeach)
		menuGroup:insert(menuDecorUpperSea)
		menuGroup:insert(menuDecorDeeperSea)
		menuGroup:insert(menuDecorTreesAndHills)

		uiButtonGroup:insert(menuGameLogo)
		uiButtonGroup:insert(menuButtonPlay)
		uiButtonGroup:insert(menuButtonAchievement)
		uiButtonGroup:insert(menuButtonTwitterFollow)
		uiButtonGroup:insert(menuButtonFacebookLike)
		uiButtonGroup:insert(menuButtonSoundAdjust)
		uiButtonGroup:insert(menuButtonMusicAdjust)
		uiButtonGroup:insert(menuImageCoin)
		uiButtonGroup:insert(menuTextCoinNumber)
		uiButtonGroup:insert(menuButtonBuyFish) -- Send it to another Storyboard screen.
		uiButtonGroup:insert(menuButtonShowCredits)
		uiButtonGroup:insert(menuTextTimesPlayedCount)
		uiButtonGroup:insert(menuButtonRemoveAds)
	end

	createMenu()
end

-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enterScene( event )
	-- Completely remove the previous scene/all scenes.
	-- Handy in this case where we want to keep everything simple.
	storyboard.removeAll()

	local function removeAllListeners()
		menuButtonPlay:removeEventListener("touch", switchScenes)
		menuButtonBuyFish:removeEventListener("touch", fishPurchase)
		menuButtonShowCredits:removeEventListener("touch", goToCreditsPage)
		menuButtonAchievement:removeEventListener("touch", showLeaderBoardGC)
		menuButtonTwitterFollow:removeEventListener("touch", followTwitter)
		menuButtonFacebookLike:removeEventListener("touch", likeFacebook)
		Runtime:removeEventListener("enterFrame", gameLoopMenu)
	end

	function switchScenes(event)
		local t = event.target

		if isButtonClickable then
			if event.phase == "began" then 
				display.getCurrentStage():setFocus( t )
				t.isFocus = true
				t.alpha = 0.7
			elseif t.isFocus then 
				if event.phase == "ended"  then 
					display.getCurrentStage():setFocus( nil )
					t.isFocus = false
					t.alpha = 1

					--Check bounds. If we are in it then click!
					local b = t.contentBounds
					if event.x >= b.xMin and event.x <= b.xMax and event.y >= b.yMin and event.y <= b.yMax then 

						-- Hide Ad
						hideAdMobAd()
						timer.cancel(menuBubbleSpawnTimer)
						timer.cancel(menuFishSpawnTimer)
						removeAllListeners()
						destroyFish()

						menuDeepSeaTrans			= transition.to(menuDecorDeeperSea,		{time = 550, yScale = 0.4})
						menuUpperSeaTrans			= transition.to(menuDecorUpperSea,		{time = 550, yScale = 0.7})
						menuSandMoveTrans			= transition.to(menuDecorSandBeach,		{time = 550, yScale = 0.75})
						menuDarkGroundTrans			= transition.to(menuDecorDarkGround,		{time = 550, yScale = 0.78})
						menuLightGroundTrans		= transition.to(menuDecorLightGround,	{time = 550, yScale = 0.8})
						menuTreeHillTrans			= transition.to(menuDecorTreesAndHills,	{delay = 450, time = 100, y = screenHeight * 0.2})

						if soundAllowed then playSound("click") end
						-- Go the the game
						timer.performWithDelay(600, function()
							storyboard.gotoScene( "game", "crossFade", 500 )
						end, 1)
					end
				end
			end
		end
		return true
	end

	function goToCreditsPage(event)
		local t = event.target

		if isButtonClickable then
			if event.phase == "began" then 
				display.getCurrentStage():setFocus( t )
				t.isFocus = true
				t.alpha = 0.7
			elseif t.isFocus then 
				if event.phase == "ended"  then 
					display.getCurrentStage():setFocus( nil )
					t.isFocus = false
					t.alpha = 1

					--Check bounds. If we are in it then click!
					local b = t.contentBounds
					if event.x >= b.xMin and event.x <= b.xMax and event.y >= b.yMin and event.y <= b.yMax then 

						-- Hide Ad
						hideAdMobAd()
						timer.cancel(menuBubbleSpawnTimer)
						timer.cancel(menuFishSpawnTimer)
						removeAllListeners()
						destroyFish()

						if soundAllowed then playSound("click") end
						-- Go the the game
						timer.performWithDelay(500, function()
							storyboard.gotoScene( "infoCredit", "crossFade", 500 )
						end, 1)
					end
				end
			end
		end
		return true
	end

	function fishPurchase(event)
		local t = event.target

		if isButtonClickable then
			if event.phase == "began" then 
				display.getCurrentStage():setFocus( t )
				t.isFocus = true
				t.alpha = 0.7
			elseif t.isFocus then 
				if event.phase == "ended"  then 
					display.getCurrentStage():setFocus( nil )
					t.isFocus = false
					t.alpha = 1

					--Check bounds. If we are in it then click!
					local b = t.contentBounds
					if event.x >= b.xMin and event.x <= b.xMax and event.y >= b.yMin and event.y <= b.yMax then 

						-- Hide Ad
						hideAdMobAd()
						timer.cancel(menuBubbleSpawnTimer)
						timer.cancel(menuFishSpawnTimer)
						removeAllListeners()
						destroyFish()

						if soundAllowed then playSound("click") end
						-- Go the the game
						timer.performWithDelay(500, function()
							storyboard.gotoScene( "buy", "crossFade", 500 )
						end, 1)
					end
				end
			end
		end
		return true
	end

	function onShowBoards( event )
		if loggedIntoGC then gameNetwork.show( "leaderboards", { leaderboard={ category="UglyFishHighestScore", timeScope="Week" } } ); else offlineAlert(); end
	end

	function showLeaderBoardGC(event)
		local t = event.target

		if event.phase == "began" then 
			display.getCurrentStage():setFocus( t )
			t.isFocus = true
			t.alpha = 0.7
		elseif t.isFocus then 
			if event.phase == "ended"  then 
				display.getCurrentStage():setFocus( nil )
				t.isFocus = false
				t.alpha = 1

				--Check bounds. If we are in it then click!
				local b = t.contentBounds

				if event.x >= b.xMin and event.x <= b.xMax and event.y >= b.yMin and event.y <= b.yMax then
					if soundAllowed then playSound("click") end
					onShowBoards()
				end
			end
		end
		return true
	end

	function likeFacebook(event)
		local t = event.target

		if isButtonClickable then
			if event.phase == "began" then 
				display.getCurrentStage():setFocus( t )
				t.isFocus = true
				t.alpha = 0.7
			elseif t.isFocus then 
				if event.phase == "ended"  then 
					display.getCurrentStage():setFocus( nil )
					t.isFocus = false
					t.alpha = 1

					--Check bounds. If we are in it then click!
					local b = t.contentBounds
					if event.x >= b.xMin and event.x <= b.xMax and event.y >= b.yMin and event.y <= b.yMax then
						if soundAllowed then playSound("click") end
						-- Hide the ad
						system.openURL( "https://www.facebook.com/pages/Pickion-Games/497675963658121" )
					end
				end
			end
		end
		return true
	end

	function followTwitter(event)
		local t = event.target

		if isButtonClickable then
			if event.phase == "began" then 
				display.getCurrentStage():setFocus( t )
				t.isFocus = true
				t.alpha = 0.7
			elseif t.isFocus then 
				if event.phase == "ended"  then 
					display.getCurrentStage():setFocus( nil )
					t.isFocus = false
					t.alpha = 1

					--Check bounds. If we are in it then click!
					local b = t.contentBounds
					if event.x >= b.xMin and event.x <= b.xMax and event.y >= b.yMin and event.y <= b.yMax then
						if soundAllowed then playSound("click") end
						-- Hide the ad
						system.openURL( "https://twitter.com/pickiongames" )
					end
				end
			end
		end
		return true
	end

	function waterBubblesMenu()
		local menuDecorBubbles = {}

		for i = 1, 10 do
			local randomColor = mRand(1, 4)
			menuDecorBubbles[i] = display.newCircle(0, 0, 5)
			menuDecorBubbles[i].x = mRand(0, screenWidth)
			menuDecorBubbles[i].y = screenHeight
			menuDecorBubbles[i]:setFillColor(colorBubbleBlue[randomColor].R, colorBubbleBlue[randomColor].G, colorBubbleBlue[randomColor].B, colorBubbleBlue[randomColor].A)
			menuDecorBubbles[i].alpha = mRand(0.1, 0.5)
			menuDecorBubbles[i].trans = transition.to(menuDecorBubbles[i], {time = mRand(1400, 2000), delay = 10, x = mRand(0, screenWidth), y = mRand(screenHeight * 0.05, screenHeight * 0.8), alpha = 0.05, onComplete = function() if menuDecorBubbles[i] then menuDecorBubbles[i]:removeSelf() end end})
		end

		return menuDecorBubbles[i]
	end

	function spawnFish()
		local i
		local randomNumberRoll = mRand(1, 100)
		local fishNumber = mRand(1, 5)
		local fishSpriteSheet = graphics.newImageSheet("images/fish/fish" .. fishNumber .. ".png", {width = 100, height = 70, numFrames = 2, sheetContentWidth = 200, sheetContentHeight = 70})

		for i = 1, 1 do
			menuDecorFish[i] = display.newSprite(fishSpriteSheet, fishSequenceData)
			menuDecorFish[i].xScale = 0.5;									menuDecorFish[i].yScale = 0.5;
			menuDecorFish[i].anchorX = 0.5;
			menuDecorFish[i].y = mRand(screenHeight * 0.4, screenHeight * 0.95)
			menuDecorFish[i]:setSequence("fishSwim")
			menuDecorFish[i]:play()

			if randomNumberRoll <= 50 then
				menuDecorFish[i].x = -50
				menuDecorFish[i].xScale = 0.5;
				leftFishGroup:insert(menuDecorFish[i])
			elseif randomNumberRoll >= 51 then
				menuDecorFish[i].x = screenWidth + 50;
				menuDecorFish[i].xScale = -0.5;
				rightFishGroup:insert(menuDecorFish[i])
			end
		end
	end

	function destroyFish()
		for i = leftFishGroup.numChildren, 1, -1 do
			local leftSide = leftFishGroup[i]
			if leftSide ~= nil and leftSide.x ~= nil then
				leftSide:removeSelf()
				leftSide = nil
			end
		end

		for i = rightFishGroup.numChildren, 1, -1 do
			local rightSide = rightFishGroup[i]
			if rightSide ~= nil and rightSide.x ~= nil then
				rightSide:removeSelf()
				rightSide = nil
			end
		end
	end

	function gameLoopMenu()
		for i = leftFishGroup.numChildren, 1, -1 do
			local leftSide = leftFishGroup[i]
			if leftSide ~= nil and leftSide.x ~= nil and leftSide.x <= screenWidth then
				leftSide:translate(menuSpeed, 0)
			else
				leftSide:removeSelf()
				leftSide = nil
			end
		end

		for i = rightFishGroup.numChildren, 1, -1 do
			local rightSide = rightFishGroup[i]
			if rightSide ~= nil and rightSide.x ~= nil and rightSide.x >= 0 then
				rightSide:translate(-menuSpeed, 0)
			else
				rightSide:removeSelf()
				rightSide = nil
			end
		end
	end

-- Timers and Transitions
print("Coin Wallet = " .. gameData.gameCoinWallet)
print("Which Fish is " .. gameData.whichFish)
showAdMobbAdInter()
if musicAllowed then playSound("music") end
menuBubbleSpawnTimer = timer.performWithDelay(50, waterBubblesMenu, -1)
menuFishSpawnTimer = timer.performWithDelay(1000, spawnFish, -1)
menuButtonPlay:addEventListener("touch", switchScenes)
menuButtonBuyFish:addEventListener("touch", fishPurchase)
menuButtonShowCredits:addEventListener("touch", goToCreditsPage)
menuButtonAchievement:addEventListener("touch", showLeaderBoardGC)
menuButtonTwitterFollow:addEventListener("touch", followTwitter)
menuButtonFacebookLike:addEventListener("touch", likeFacebook)
Runtime:addEventListener("enterFrame", gameLoopMenu)
end

-- Called when scene is about to move offscreen:
-- Cancel Timers/Transitions and Runtime Listeners etc.
function scene:exitScene( event )
	if menuBubbleSpawnTimer ~= nil then timer.cancel(menuBubbleSpawnTimer) end
	if menuFishSpawnTimer ~= nil then timer.cancel(menuFishSpawnTimer) end
end

--Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end

-----------------------------------------------
-- Add the story board event listeners
-----------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene