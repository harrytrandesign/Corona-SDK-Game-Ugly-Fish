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
local GGTwitter = require( "GGTwitter" )
local json = require( "json" )
local physics = require ("physics")	--Require physics
local loadsave = require("loadsave")
local gameNetwork = require("gameNetwork")

local gravityX = 0;
local gravityY = 30;

physics.start()
physics.setGravity(gravityX, gravityY)
physics.setScale(60)
physics.setDrawMode("normal") -- normal hybrid debug

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

local isGameActive = false -- unused in this game
local isGameOver = false -- unused in this game

--	VARIABLES FOR CONTROL
local gameScore = 0;
local gameSpeed = 14;
local seaBouce = 0;
local seaDensity = 0.5;
local seaFriction = 0.2;
local bigFishVelocity = 15;
local smallFishVelocity = 2;
local fishBounce = 0;
local bigFishDensity = 10;
local smallFishDensity = 5;
local fishFriction = 0.2;

--	COLOR PALETTE
local colorFontUIText =			{R = 238/255,	G = 253/255,	B = 210/255,	A = 255/255}
local colorBlueSky =			{R = 168/255,	G = 200/255,	B = 238/255,	A = 255/255}
local colorLightGreen =			{R = 148/255,	G = 203/255,	B = 122/255,	A = 255/255}
local colorDarkGreen =			{R = 93/255,	G = 164/255,	B = 124/255,	A = 255/255}
local colorBeach =				{R = 232/255,	G = 206/255,	B = 169/255,	A = 255/255}
local colorBlueWater =			{R = 21/255,	G = 43/255,		B = 64/255,		A = 255/255}
local colorDeepSeaBed =			{R = 12/255,	G = 22/255,		B = 32/255,		A = 255/255}
local colorBubbleBlue = {}
		colorBubbleBlue[1] =	{R = 11/255,	G = 72/255,		B = 107/255, 	A = 255/255}
		colorBubbleBlue[2] =	{R = 59/255,	G = 134/255,	B = 134/255,	A = 255/255}
		colorBubbleBlue[3] =	{R = 121/255,	G = 189/255,	B = 154/255,	A = 255/255}
		colorBubbleBlue[4] =	{R = 168/255,	G = 219/255,	B = 168/255,	A = 255/255}		
local colorDarkFrame =			{R = 20/255,	G = 20/255,		B = 20/255,		A = 255/255}
local colorLightDisplay =		{R = 235/255,	G = 243/255,	B = 235/255,	A = 255/255}
local colorGameOrange =			{R = 255/255,	G = 127/255,	B = 42/255,		A = 255/255}
local colorMiscStuff =			{R = 0/255,		G = 0/255,		B = 0/255,		A = 255/255}

-- Sprite Sheet Images
local fishSequenceData = {name = "fishSwim", start = 1, count = 2, time = 200}
local fishSpriteSheet = graphics.newImageSheet("images/fish/fish" .. gameData.whichFish .. ".png", {width = 100, height = 70, numFrames = 2, sheetContentWidth = 200, sheetContentHeight = 70})

--	DISPLAY GROUPS
local groupDecor
local groupFish
local groupUI
local groupEnd

local bigFish = {}
local smallFish = {}

--	FUNCTIONS LIST
local createStage
local createReady
local onSubmitScore
local updateScore
local saveGameData
local checkForNewHighScore
local waterBubbles
local spawnCall
local onCollision
local jumpBigFish
local jumpSmallFish
local gameOverButtonIndex
local gameOverEvent
local onSystemEvent

-----------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------
-- Called when the scene's view does not exist:
-- Create all your display objects here.
function scene:createScene( event )
	local gameGroup = self.view

	groupDecor = display.newGroup();									gameGroup:insert(groupDecor)
	groupFish = display.newGroup();										gameGroup:insert(groupFish)
	groupUI = display.newGroup();										gameGroup:insert(groupUI)
	groupEnd = display.newGroup();										gameGroup:insert(groupEnd)

	function createStage()
		decorBlueSky = display.newRect(0, 0, screenWidth, screenHeight)
		decorBlueSky:setFillColor(colorBlueSky.R, colorBlueSky.G, colorBlueSky.B, colorBlueSky.A)
		decorBlueSky.anchorX = 0.5;											decorBlueSky.x = centerX;
		decorBlueSky.anchorY = 0.5;											decorBlueSky.y = centerY;

		decorLightGround = display.newRect(0, 0, screenWidth * 2, screenHeight * 0.8)
		decorLightGround:setFillColor(colorLightGreen.R, colorLightGreen.G, colorLightGreen.B, colorLightGreen.A)
		decorLightGround.anchorX = 0.5;										decorLightGround.x = centerX;
		decorLightGround.anchorY = 1;										decorLightGround.y = screenHeight;

		decorDarkGround = display.newRect(0, 0, screenWidth * 2, screenHeight * 0.78)
		decorDarkGround:setFillColor(colorDarkGreen.R, colorDarkGreen.G, colorDarkGreen.B, colorDarkGreen.A)
		decorDarkGround.anchorX = 0.5;										decorDarkGround.x = centerX;
		decorDarkGround.anchorY = 1;										decorDarkGround.y = screenHeight;

		decorSandBeach = display.newRect(0, 0, screenWidth * 2, screenHeight * 0.75)
		decorSandBeach:setFillColor(colorBeach.R, colorBeach.G, colorBeach.B, colorBeach.A)	
		decorSandBeach.anchorX = 0.5;										decorSandBeach.x = centerX;
		decorSandBeach.anchorY = 1;											decorSandBeach.y = screenHeight;

		decorUpperSea = display.newRect(0, 0, screenWidth * 2, screenHeight * 0.7)
		decorUpperSea:setFillColor(colorBlueWater.R, colorBlueWater.G, colorBlueWater.B, colorBlueWater.A)
		decorUpperSea.anchorX = 0.5;										decorUpperSea.x = centerX;
		decorUpperSea.anchorY = 1;											decorUpperSea.y = screenHeight;

		decorLowerSea = display.newRect(0, 0, screenWidth * 2, screenHeight * 0.4)
		decorLowerSea:setFillColor(colorDeepSeaBed.R, colorDeepSeaBed.G, colorDeepSeaBed.B, colorDeepSeaBed.A)
		decorLowerSea.anchorX = 0.5;										decorLowerSea.x = centerX;
		decorLowerSea.anchorY = 1;											decorLowerSea.y = screenHeight;
		physics.addBody(decorLowerSea, "static", {bounce = seaBouce, density = seaDensity, friction = seaFriction})

		decorTreesHills = display.newImageRect("images/graphics/mountainTree.png", 320, 100)
		decorTreesHills.anchorX = 0.5;										decorTreesHills.x = centerX;
		decorTreesHills.anchorY = 1;										decorTreesHills.y = screenHeight * 0.2;

		------------------------------------------------

		gameObjectGoalLine = display.newRect(0, 0, 20, screenHeight)
		gameObjectGoalLine:setFillColor(colorMiscStuff.R, colorMiscStuff.G, colorMiscStuff.B, colorMiscStuff.A)
		gameObjectGoalLine.anchorX = 0.5;									gameObjectGoalLine.x = -100;
		gameObjectGoalLine.anchorY = 0.5;									gameObjectGoalLine.y = centerY;
		gameObjectGoalLine.alpha = 0.01;
		gameObjectGoalLine.objName = "goalScore"
		physics.addBody(gameObjectGoalLine, "static", {isSensor = true})

		gameButtonBigJump = display.newRect(0, 0, screenWidth * 0.5, screenHeight)
		gameButtonBigJump:setFillColor(colorMiscStuff.R, colorMiscStuff.G, colorMiscStuff.B, colorMiscStuff.A)
		gameButtonBigJump.anchorX = 0.5;									gameButtonBigJump.x = screenWidth * 0.25;
		gameButtonBigJump.anchorY = 0.5;									gameButtonBigJump.y = centerY;
		gameButtonBigJump.alpha = 0.1;

		gameButtonSmallJump = display.newRect(0, 0, screenWidth * 0.5, screenHeight)
		gameButtonSmallJump:setFillColor(colorMiscStuff.R, colorMiscStuff.G, colorMiscStuff.B, colorMiscStuff.A)
		gameButtonSmallJump.anchorX = 0.5;									gameButtonSmallJump.x = screenWidth * 0.75;
		gameButtonSmallJump.anchorY = 0.5;									gameButtonSmallJump.y = centerY;
		gameButtonSmallJump.alpha = 0.1;

		gameDecorFish1 = display.newSprite(fishSpriteSheet, fishSequenceData)
		gameDecorFish1.xScale = 0.5;										gameDecorFish1.yScale = 0.5;
		gameDecorFish1.anchorX = 0.5;										gameDecorFish1.x = mRand(40, screenWidth - 40)
		gameDecorFish1.anchorY = 0.5;										gameDecorFish1.y = mRand(screenHeight * 0.7, screenHeight * 0.9);
		gameDecorFish1.alpha = 0.25;
		gameDecorFish1:setSequence("fishSwim")
		gameDecorFish1:play()

		gameDecorFish2 = display.newSprite(fishSpriteSheet, fishSequenceData)
		gameDecorFish2.xScale = -0.5;										gameDecorFish2.yScale = 0.5;
		gameDecorFish2.anchorX = 0.5;										gameDecorFish2.x = mRand(40, screenWidth - 40)
		gameDecorFish2.anchorY = 0.5;										gameDecorFish2.y = mRand(screenHeight * 0.7, screenHeight * 0.9);
		gameDecorFish2.alpha = 0.25;
		gameDecorFish2:setSequence("fishSwim")
		gameDecorFish2:play()

		------------------------------------------------

		uiTextScore = display.newText("" .. gameScore, 0, 0, customFont, 64 * 2)
		uiTextScore:setFillColor(colorBeach.R, colorBeach.G, colorBeach.B, colorBeach.A)	
		uiTextScore.xScale = 0.5;											uiTextScore.yScale = 0.5;
		uiTextScore.anchorX = 0.5;											uiTextScore.x = centerX;
		uiTextScore.anchorY = 0;											uiTextScore.y = screenHeight * 0.6;
		uiTextScore.isVisible = false;

		uiTextHighScore = display.newText("High Score: " .. gameData.gameHighScore, 0, 0, customFont, 12 * 2)
		uiTextHighScore:setFillColor(colorBeach.R, colorBeach.G, colorBeach.B, colorBeach.A)	
		uiTextHighScore.xScale = 0.5;										uiTextHighScore.yScale = 0.5;
		uiTextHighScore.anchorX = 0.5;										uiTextHighScore.x = centerX;
		uiTextHighScore.anchorY = 1;										uiTextHighScore.y = screenHeight - 2;
		uiTextHighScore.isVisible = false;

		------------------------------------------------

		groupDecor:insert(decorBlueSky)
		groupDecor:insert(decorLightGround)
		groupDecor:insert(decorDarkGround)
		groupDecor:insert(decorSandBeach)
		groupDecor:insert(decorUpperSea)
		groupDecor:insert(decorLowerSea)
		groupDecor:insert(decorTreesHills)
		groupDecor:insert(gameDecorFish1)
		groupDecor:insert(gameDecorFish2)

		groupDecor:insert(gameObjectGoalLine)

		groupDecor:insert(gameButtonBigJump)
		groupDecor:insert(gameButtonSmallJump)

		groupUI:insert(uiTextScore)
		groupUI:insert(uiTextHighScore)
	end

	function createReady()
		uiImageTabletFrame = display.newRect(0, 0, 224, 336)
		uiImageTabletFrame:setFillColor(colorDarkFrame.R, colorDarkFrame.G, colorDarkFrame.B, colorDarkFrame.A)
		uiImageTabletFrame.anchorX = 0.5;										uiImageTabletFrame.x = centerX;
		uiImageTabletFrame.anchorY = 0.5;										uiImageTabletFrame.y = centerY;
		uiImageTabletFrame.myLabel = "start"

		uiImageTabletDisplay = display.newRect(0, 0, 192, 264)
		uiImageTabletDisplay:setFillColor(colorLightDisplay.R, colorLightDisplay.G, colorLightDisplay.B, colorLightDisplay.A)
		uiImageTabletDisplay.anchorX = 0.5;										uiImageTabletDisplay.x = centerX;
		uiImageTabletDisplay.anchorY = 0.5;										uiImageTabletDisplay.y = centerY - 12;

		uiImageTabletButton = display.newCircle(0, 0, 15)
		uiImageTabletButton:setFillColor(colorLightDisplay.R, colorLightDisplay.G, colorLightDisplay.B, colorLightDisplay.A)
		uiImageTabletButton.anchorX = 0.5;										uiImageTabletButton.x = centerX;
		uiImageTabletButton.anchorY = 0.5;										uiImageTabletButton.y = centerY + 145;

		uiImageTabletShading = display.newRect(0, 0, 112, 336)
		uiImageTabletShading:setFillColor(colorMiscStuff.R, colorMiscStuff.G, colorMiscStuff.B, colorMiscStuff.A)
		uiImageTabletShading.anchorX = 1;										uiImageTabletShading.x = centerX;
		uiImageTabletShading.anchorY = 0.5;										uiImageTabletShading.y = centerY;
		uiImageTabletShading.alpha = 0.1;

		------------------------------------------------
		uiGameInstructions = display.newImageRect("images/graphics/instructionsFish.png", 100, 50)
		uiGameInstructions.anchorX = 0.5;										uiGameInstructions.x = centerX;
		uiGameInstructions.anchorY = 1;											uiGameInstructions.y = centerY;

		uiTextTapLeftScreen = display.newText("Tap", 0, 0, customFont, 14 * 2)
		uiTextTapLeftScreen:setFillColor(colorDarkFrame.R, colorDarkFrame.G, colorDarkFrame.B, colorDarkFrame.A)
		uiTextTapLeftScreen.xScale = 0.5;										uiTextTapLeftScreen.yScale = 0.5;
		uiTextTapLeftScreen.anchorX = 0.5;										uiTextTapLeftScreen.x = centerX - 50;
		uiTextTapLeftScreen.anchorY = 0.5;										uiTextTapLeftScreen.y = centerY + 50;

		uiTextTapRightScreen = display.newText("Tap", 0, 0, customFont, 14 * 2)
		uiTextTapRightScreen:setFillColor(colorDarkFrame.R, colorDarkFrame.G, colorDarkFrame.B, colorDarkFrame.A)
		uiTextTapRightScreen.xScale = 0.5;										uiTextTapRightScreen.yScale = 0.5;
		uiTextTapRightScreen.anchorX = 0.5;										uiTextTapRightScreen.x = centerX + 50;
		uiTextTapRightScreen.anchorY = 0.5;										uiTextTapRightScreen.y = centerY + 50;

		groupUI:insert(uiImageTabletFrame)
		groupUI:insert(uiImageTabletDisplay)
		groupUI:insert(uiImageTabletButton)
		groupUI:insert(uiImageTabletShading)

		groupUI:insert(uiGameInstructions)
		groupUI:insert(uiTextTapLeftScreen)
		groupUI:insert(uiTextTapRightScreen)
	end
end

-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enterScene( event )
	storyboard.removeAll()

	function onSubmitScore( event )
		if loggedIntoGC then gameNetwork.request( "setHighScore", { localPlayerScore={ category="UglyFishHighestScore", value=gameData.gameHighScore }, listener=requestCallback } ); else offlineAlert(); end
	end

	function updateScore(amount)
		gameScore = gameScore + amount
		uiTextScore.text = "" .. gameScore
	end

	function saveGameData()
		loadsave.saveTable(gameData, "dataFile01.json")
		print("Data is saved. Highest Score is " .. gameData.gameHighScore)
		print("Data is saved. Coin Wallet is " .. gameData.gameCoinWallet)
	end

	function checkForNewHighScore()
		print(gameScore .. " is the score. The current high score is " .. gameData.gameHighScore)
		if gameScore > gameData.gameHighScore then
			gameData.gameHighScore = gameScore
			onSubmitScore()
			saveGameData()
			uiTextHighScore.text = "High Score: " .. gameData.gameHighScore
			print("The last high score was beat, the new high score is now " .. gameData.gameHighScore)
		end
	end

	function waterBubbles()
		local bubbles = {}

		for i = 1, 10 do
			local randomColor = mRand(1, 4)
			bubbles[i] = display.newCircle(0, 0, 5)
			bubbles[i].x = mRand(0, screenWidth)
			bubbles[i].y = screenHeight
			bubbles[i]:setFillColor(colorBubbleBlue[randomColor].R, colorBubbleBlue[randomColor].G, colorBubbleBlue[randomColor].B, colorBubbleBlue[randomColor].A)
			bubbles[i].alpha = mRand(0.1, 0.5)
			bubbles[i].trans = transition.to(bubbles[i], {time = mRand(1400, 2000), delay = 10, x = mRand(0, screenWidth), y = mRand(screenHeight * 0.3, screenHeight * 0.8), alpha = 0.05, onComplete = function() if bubbles[i] then bubbles[i]:removeSelf() end end})
		end

		return bubbles[i]
	end

	function spawnCall()
		local i
		local randomDiceRoll = mRand(1, 100)
		print("Dice Rolled is " .. randomDiceRoll)

		for i = 1, 1 do
			function onCollision(self, event)
				if event.phase == "began" then
					local id = event.other.objName
					if id == "goalScore" then
						if soundAllowed then playSound("score") end
						self:removeSelf()
						self = nil
						smallFish[i]:removeSelf()
						smallFish[i] = nil
						gameButtonBigJump:removeEventListener("touch", jumpBigFish)
						gameButtonSmallJump:removeEventListener("touch", jumpSmallFish)
						updateScore(1)
						spawnRoundTimer = timer.performWithDelay(250, spawnCall, 1)
						print("Got a point, update score.")
					elseif id == "enemyFish" then
						if soundAllowed then playSound("crash") end
						self:removeSelf()
						self = nil
						event.other:removeSelf()
						event.other = nil
						gameButtonBigJump:removeEventListener("touch", jumpBigFish)
						gameButtonSmallJump:removeEventListener("touch", jumpSmallFish)
						gameOverEvent()
						print("Big fish crashed into small fish.")
					end
				end
				return true
			end

			bigFish[i] = display.newSprite(fishSpriteSheet, fishSequenceData)
			bigFish[i].anchorX = 0.5;
			bigFish[i].anchorY = 0.5;										bigFish[i].y = screenHeight * 0.55;
			physics.addBody(bigFish[i], "dynamic", {bounce = fishBounce, density = bigFishDensity, friction = fishFriction, radius = 18, isSensor = false})
			bigFish[i].xScale = 0.5;										bigFish[i].yScale = 0.5;
			bigFish[i].objName = "hero"
			bigFish[i].isFixedRotation = true;
			bigFish[i].canJump = true;
			bigFish[i].collision = onCollision
			bigFish[i]:addEventListener("collision", bigFish[i])
			bigFish[i]:setSequence("fishSwim")
			bigFish[i]:play()

			smallFish[i] = display.newImageRect("images/fish/piranhaFish.png", 30, 21)
			smallFish[i].anchorX = 0.5;
			smallFish[i].anchorY = 1;									smallFish[i].y = screenHeight * 0.55;
			physics.addBody(smallFish[i], "dynamic", {bounce = fishBounce, density = smallFishDensity, friction = fishFriction, radius = 10})
			smallFish[i].xScale = 1;
			smallFish[i].objName = "enemyFish"
			smallFish[i].isFixedRotation = true;
			smallFish[i].canJump = true;

			function jumpBigFish(event)
				if event.phase == "began" and bigFish[i].canJump then
					local vx,vy = bigFish[i]:getLinearVelocity()
					bigFish[i].canJump = false;
					if soundAllowed then playSound("jump") end
					bigFish[i]:setLinearVelocity(vx, 0)
					bigFish[i]:applyLinearImpulse(0, -bigFishVelocity)
					gameButtonBigJump:removeEventListener("touch", jumpBigFish)
				end
			end

			function jumpSmallFish(event)
				if event.phase == "began" and smallFish[i].canJump then
					local vx,vy = smallFish[i]:getLinearVelocity()
					smallFish[i].canJump = false;
					if soundAllowed then playSound("jump") end
					smallFish[i]:setLinearVelocity(vx, 0)
					smallFish[i]:applyLinearImpulse(0, -smallFishVelocity)
					gameButtonSmallJump:removeEventListener("touch", jumpSmallFish)
				end
			end

			gameButtonBigJump:addEventListener("touch", jumpBigFish)
			gameButtonSmallJump:addEventListener("touch", jumpSmallFish)

			-- Big Fish will be on the left. Small Fish on the right.
			if randomDiceRoll <= 50 then
				bigFish[i].x = -30;
				bigFish[i].xScale = 0.5;
				gameButtonBigJump.x = screenWidth * 0.25;
				smallFish[i].x = screenWidth + 30;
				smallFish[i].xScale = -1;
				gameButtonSmallJump.x = screenWidth * 0.75;
				gameObjectGoalLine.x = screenWidth - 10;
				bigFish[i]:applyForce(700, 0)
				smallFish[i]:applyForce(-120, 0)
				groupFish:insert(bigFish[i])
				groupFish:insert(smallFish[i])

			-- Big Fish will be on the right. Small Fish on the left.
			elseif randomDiceRoll >= 51 then
				bigFish[i].x = screenWidth + 30;
				bigFish[i].xScale = -0.5;
				gameButtonBigJump.x = screenWidth * 0.75;
				smallFish[i].x = -30;
				smallFish[i].xScale = 1;
				gameButtonSmallJump.x = screenWidth * 0.25;
				gameObjectGoalLine.x = 10;
				bigFish[i]:applyForce(-700, 0)
				smallFish[i]:applyForce(120, 0)
				groupFish:insert(smallFish[i])
				groupFish:insert(bigFish[i])
			end
		end

		return bigFish[i], smallFish[i]
	end

	function gameOverButtonIndex(event)
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
					if t.myLabel == "start" then
						if soundAllowed then playSound("click") end

						uiTextScore.isVisible = true;
						uiTextHighScore.isVisible = true;

						-- Dump all the instructions displayed
						if uiImageTabletFrame then uiImageTabletFrame:removeSelf(); uiImageTabletFrame = nil end
						if uiImageTabletDisplay then uiImageTabletDisplay:removeSelf(); uiImageTabletDisplay = nil end
						if uiImageTabletButton then uiImageTabletButton:removeSelf(); uiImageTabletButton = nil end
						if uiImageTabletShading then uiImageTabletShading:removeSelf(); uiImageTabletShading = nil end
						if uiGameInstructions then uiGameInstructions:removeSelf(); uiGameInstructions = nil end
						if uiTextTapLeftScreen then uiTextTapLeftScreen:removeSelf(); uiTextTapLeftScreen = nil end
						if uiTextTapRightScreen then uiTextTapRightScreen:removeSelf(); uiTextTapRightScreen = nil end

						-- Increase the game count played
						gameData.gameCount = gameData.gameCount + 1
						saveGameData()

						-- Call the timers
						firstSpawnTimer = timer.performWithDelay(150, spawnCall, 1)
						bubbleSpawnTimer = timer.performWithDelay(50, waterBubbles, -1)

					elseif t.myLabel == "menu" then
						hideAdMobAd()
						if soundAllowed then playSound("click") end
						storyboard.gotoScene("menu", "crossFade", 500)

					elseif t.myLabel == "leaderboard" then
						function onShowBoards( event )
							if loggedIntoGC then gameNetwork.show( "leaderboards", { leaderboard={ category="UglyFishHighestScore", timeScope="Week" } } ); else offlineAlert(); end
						end

						if soundAllowed then playSound("click") end
						onShowBoards()

					elseif t.myLabel == "twitter" then
						function tw_listener( event )
							if event.phase == "authorised" then
								twitter:post( "Just played Ugly Fish vs Tiny Fins, my coin collection is " .. gameData.gameCoinWallet .. " #UglyFish #TinyFins #iOS #iPhone #AppStore #FreeApp https://itunes.apple.com/us/app/id918696665?mt=8" )
							elseif event.phase == "posted" then
								native.showAlert("Twitter", "Thanks for Sharing Your Score.", {"ok"})
							elseif event.phase == "deauthorised" then
								twitter:destroy()
								twitter = nil
							end
						end

						if soundAllowed then playSound("click") end
						twitter = GGTwitter:new( "svH0R4NZ4K1ELWk2uKqCKukT6", "MRs8hquBum32HAK85jrQVxSxvDhwpW0WlVod70LJ6cnIyhPvOt", tw_listener )
						twitter:authorise()

					elseif t.myLabel == "retry" then
						hideAdMobAd()
						if soundAllowed then playSound("click") end

						if gameOverOuterFrame then gameOverOuterFrame:removeSelf() gameOverOuterFrame = nil end
						if gameOverOuterBox then gameOverOuterBox:removeSelf() gameOverOuterBox = nil end
						if gameOverInnerFrame then gameOverInnerFrame:removeSelf() gameOverInnerFrame = nil end
						if gameOverInnerBox then gameOverInnerBox:removeSelf() gameOverInnerBox = nil end
						if gameOverHeaderTitle then gameOverHeaderTitle:removeSelf() gameOverHeaderTitle = nil end
						if gameOverGameScore then gameOverGameScore:removeSelf() gameOverGameScore = nil end
						if gameOverHighScore then gameOverHighScore:removeSelf() gameOverHighScore = nil end
						if gameOverCoinImage then gameOverCoinImage:removeSelf() gameOverCoinImage = nil end
						if gameOverCoinCount then gameOverCoinCount:removeSelf() gameOverCoinCount = nil end
						if gameOverButtonMenu then gameOverButtonMenu:removeSelf() gameOverButtonMenu = nil end
						if gameOverButtonReplay then gameOverButtonReplay:removeSelf() gameOverButtonReplay = nil end
						if gameOverButtonLeader then gameOverButtonLeader:removeSelf() gameOverButtonLeader = nil end
						if gameOverButtonTwitter then gameOverButtonTwitter:removeSelf() gameOverButtonTwitter = nil end
						if gameOverButtonSound then gameOverButtonSound:removeSelf() gameOverButtonSound = nil end
						if gameOverButtonMusic then gameOverButtonMusic:removeSelf() gameOverButtonMusic = nil end

						gameScore = 0
						uiTextScore.text = "" .. gameScore
						uiTextScore.isVisible = false;
						uiTextHighScore.isVisible = false;

						createReady()

						uiImageTabletFrame:addEventListener("touch", gameOverButtonIndex)
					end
					print(t.myLabel, " has been pressed")
				end
			end
		end
		return true
	end

	function gameOverEvent()
		print("Game Over")
		local function delay() display.getCurrentStage():setFocus(nil) end
		timer.performWithDelay(100, delay, 1)

		showAdMobbAd(0)

		-- Convert Score to Coins at a 5:1 Ratio
		coinConversion = math.floor(gameScore * 0.2)
		print("Coin Converted " .. coinConversion)
		gameData.gameCoinWallet = gameData.gameCoinWallet + coinConversion

		checkForNewHighScore()
		print("highest score is " .. gameData.gameHighScore)
		-- Game Data has been saved with Check High Score Function

		timer.cancel(bubbleSpawnTimer)

		gameOverOuterFrame = display.newRect(0, 0, 288, 432)
		gameOverOuterFrame:setFillColor(colorGameOrange.R, colorGameOrange.G, colorGameOrange.B, colorGameOrange.A)
		gameOverOuterFrame.anchorX = 0.5;										gameOverOuterFrame.x = centerX;
		gameOverOuterFrame.anchorY = 0.5;										gameOverOuterFrame.y = centerY;

		gameOverOuterBox = display.newRect(0, 0, 278, 422)
		gameOverOuterBox:setFillColor(colorLightDisplay.R, colorLightDisplay.G, colorLightDisplay.B, colorLightDisplay.A)
		gameOverOuterBox.anchorX = 0.5;											gameOverOuterBox.x = centerX;
		gameOverOuterBox.anchorY = 0.5;											gameOverOuterBox.y = centerY;

		gameOverInnerFrame = display.newRect(0, 0, 248, 392)
		gameOverInnerFrame:setFillColor(colorGameOrange.R, colorGameOrange.G, colorGameOrange.B, colorGameOrange.A)
		gameOverInnerFrame.anchorX = 0.5;										gameOverInnerFrame.x = centerX;
		gameOverInnerFrame.anchorY = 0.5;										gameOverInnerFrame.y = centerY;

		gameOverInnerBox = display.newRect(0, 0, 244, 388)
		gameOverInnerBox:setFillColor(colorBeach.R, colorBeach.G, colorBeach.B, colorBeach.A)	
		gameOverInnerBox.anchorX = 0.5;											gameOverInnerBox.x = centerX;
		gameOverInnerBox.anchorY = 0.5;											gameOverInnerBox.y = centerY;

		gameOverHeaderTitle = display.newText("GAME OVER", 0, 0, customFont, 36 * 2)
		gameOverHeaderTitle:setFillColor(colorMiscStuff.R, colorMiscStuff.G, colorMiscStuff.B, colorMiscStuff.A)
		gameOverHeaderTitle.xScale = 0.5;										gameOverHeaderTitle.yScale = 0.5;
		gameOverHeaderTitle.anchorX = 0.5;										gameOverHeaderTitle.x = centerX;
		gameOverHeaderTitle.anchorY = 0.5;										gameOverHeaderTitle.y = centerY - 140;

		gameOverGameScore = display.newText("Score " .. gameScore, 0, 0, customFont, 24 * 2)
		gameOverGameScore:setFillColor(colorMiscStuff.R, colorMiscStuff.G, colorMiscStuff.B, colorMiscStuff.A)
		gameOverGameScore.xScale = 0.5;											gameOverGameScore.yScale = 0.5;
		gameOverGameScore.anchorX = 0.5;										gameOverGameScore.x = centerX;
		gameOverGameScore.anchorY = 0.5;										gameOverGameScore.y = centerY - 85;

		gameOverHighScore = display.newText("High Score: " .. gameData.gameHighScore, 0, 0, customFont, 14 * 2)
		gameOverHighScore:setFillColor(colorMiscStuff.R, colorMiscStuff.G, colorMiscStuff.B, colorMiscStuff.A)
		gameOverHighScore.xScale = 0.5;											gameOverHighScore.yScale = 0.5;
		gameOverHighScore.anchorX = 0.5;										gameOverHighScore.x = centerX;
		gameOverHighScore.anchorY = 0.5;										gameOverHighScore.y = centerY - 50;

		gameOverCoinImage = display.newImageRect("images/graphics/fishCoinsFlat.png", 80, 80)
		gameOverCoinImage.xScale = 0.6;											gameOverCoinImage.yScale = 0.6;
		gameOverCoinImage.anchorX = 0.5;										gameOverCoinImage.x = centerX - 80;
		gameOverCoinImage.anchorY = 0.5;										gameOverCoinImage.y = centerY;

		gameOverCoinCount = display.newText("+" .. coinConversion, 0, 0, customFont, 36 * 2)
		gameOverCoinCount:setFillColor(colorMiscStuff.R, colorMiscStuff.G, colorMiscStuff.B, colorMiscStuff.A)
		gameOverCoinCount.xScale = 0.5;											gameOverCoinCount.yScale = 0.5;
		gameOverCoinCount.anchorX = 0;											gameOverCoinCount.x = centerX - 50;
		gameOverCoinCount.anchorY = 0;											gameOverCoinCount.y = centerY - 28;

		if coinConversion >= 1 then
			gameOverCoinCount.isVisible = true
		else
			gameOverCoinImage.isVisible = false
			gameOverCoinCount.isVisible = false
		end

		gameOverButtonMenu = display.newImageRect("images/buttons/orangeMenuButton.png", 80, 80)
		gameOverButtonMenu.xScale = 0.6;										gameOverButtonMenu.yScale = 0.6;
		gameOverButtonMenu.anchorX = 0.5;										gameOverButtonMenu.x = centerX;
		gameOverButtonMenu.anchorY = 0;											gameOverButtonMenu.y = centerY + 60;
		gameOverButtonMenu.myLabel = "menu"

		gameOverButtonReplay = display.newImageRect("images/buttons/orangeReplayButton.png", 80, 80)
		gameOverButtonReplay.xScale = 0.6;										gameOverButtonReplay.yScale = 0.6;
		gameOverButtonReplay.anchorX = 0.5;										gameOverButtonReplay.x = centerX + 68;
		gameOverButtonReplay.anchorY = 0;										gameOverButtonReplay.y = centerY + 60;
		gameOverButtonReplay.myLabel = "retry"

		gameOverButtonLeader = display.newImageRect("images/buttons/orangeLeaderboardButton.png", 80, 80)
		gameOverButtonLeader.xScale = 0.6;										gameOverButtonLeader.yScale = 0.6;
		gameOverButtonLeader.anchorX = 0.5;										gameOverButtonLeader.x = centerX - 68;
		gameOverButtonLeader.anchorY = 0;										gameOverButtonLeader.y = centerY + 60;
		gameOverButtonLeader.myLabel = "leaderboard"

		gameOverButtonTwitter = display.newImageRect("images/buttons/flatDesignTwitterButton.png", 80, 80)
		gameOverButtonTwitter.xScale = 0.6;										gameOverButtonTwitter.yScale = 0.6;
		gameOverButtonTwitter.anchorX = 0.5;									gameOverButtonTwitter.x = centerX;
		gameOverButtonTwitter.anchorY = 0;										gameOverButtonTwitter.y = centerY + 128;
		gameOverButtonTwitter.myLabel = "twitter"

		function gameOverSoundToggle(event)
			if soundAllowed then
				gameOverButtonSound:removeSelf()
				gameOverButtonSound = nil
				soundAllowed = false
				gameOverButtonSound = display.newImageRect("images/buttons/orangeVolumeOffButton.png", 80, 80)
				gameOverButtonSound.xScale = 0.6;								gameOverButtonSound.yScale = 0.6;
				gameOverButtonSound.anchorX = 0.5;								gameOverButtonSound.x = centerX + 68;
				gameOverButtonSound.anchorY = 0;								gameOverButtonSound.y = centerY + 128;
				gameOverButtonSound:addEventListener("tap", gameOverSoundToggle)
				groupEnd:insert(gameOverButtonSound)
			else
				gameOverButtonSound:removeSelf()
				gameOverButtonSound = nil
				soundAllowed = true
				gameOverButtonSound = display.newImageRect("images/buttons/orangeVolumeOnButton.png", 80, 80)
				gameOverButtonSound.xScale = 0.6;								gameOverButtonSound.yScale = 0.6;
				gameOverButtonSound.anchorX = 0.5;								gameOverButtonSound.x = centerX + 68;
				gameOverButtonSound.anchorY = 0;								gameOverButtonSound.y = centerY + 128;
				gameOverButtonSound:addEventListener("tap", gameOverSoundToggle)
				groupEnd:insert(gameOverButtonSound)
			end
			return true
		end

		if soundAllowed then
			gameOverButtonSound = display.newImageRect("images/buttons/orangeVolumeOnButton.png", 80, 80)
		else
			gameOverButtonSound = display.newImageRect("images/buttons/orangeVolumeOffButton.png", 80, 80)
		end
		gameOverButtonSound.xScale = 0.6;										gameOverButtonSound.yScale = 0.6;
		gameOverButtonSound.anchorX = 0.5;										gameOverButtonSound.x = centerX + 68;
		gameOverButtonSound.anchorY = 0;										gameOverButtonSound.y = centerY + 128;
		gameOverButtonSound:addEventListener("tap", gameOverSoundToggle)

		function gameOverMusicToggle(event)
			if musicAllowed then
				gameOverButtonMusic:removeSelf()
				gameOverButtonMusic = nil
				musicAllowed = false
				audio.stop(1)
				gameOverButtonMusic = display.newImageRect("images/buttons/orangeMusicOffButton.png", 80, 80)
				gameOverButtonMusic.xScale = 0.6;								gameOverButtonMusic.yScale = 0.6;
				gameOverButtonMusic.anchorX = 0.5;								gameOverButtonMusic.x = centerX - 68;
				gameOverButtonMusic.anchorY = 0;								gameOverButtonMusic.y = centerY + 128;
				gameOverButtonMusic:addEventListener("tap", gameOverMusicToggle)
				groupEnd:insert(gameOverButtonMusic)
			else
				gameOverButtonMusic:removeSelf()
				gameOverButtonMusic = nil
				musicAllowed = true
				if musicAllowed then playSound("music") end
				gameOverButtonMusic = display.newImageRect("images/buttons/orangeMusicOnButton.png", 80, 80)
				gameOverButtonMusic.xScale = 0.6;								gameOverButtonMusic.yScale = 0.6;
				gameOverButtonMusic.anchorX = 0.5;								gameOverButtonMusic.x = centerX - 68;
				gameOverButtonMusic.anchorY = 0;								gameOverButtonMusic.y = centerY + 128;
				gameOverButtonMusic:addEventListener("tap", gameOverMusicToggle)
				groupEnd:insert(gameOverButtonMusic)
			end
			return true
		end

		if musicAllowed then
			gameOverButtonMusic = display.newImageRect("images/buttons/orangeMusicOnButton.png", 80, 80)
		else
			gameOverButtonMusic = display.newImageRect("images/buttons/orangeMusicOffButton.png", 80, 80)
		end
		gameOverButtonMusic.xScale = 0.6;										gameOverButtonMusic.yScale = 0.6;
		gameOverButtonMusic.anchorX = 0.5;										gameOverButtonMusic.x = centerX - 68;
		gameOverButtonMusic.anchorY = 0;										gameOverButtonMusic.y = centerY + 128;
		gameOverButtonMusic:addEventListener("tap", gameOverMusicToggle)

		groupEnd:insert(gameOverOuterFrame)
		groupEnd:insert(gameOverOuterBox)
		groupEnd:insert(gameOverInnerFrame)
		groupEnd:insert(gameOverInnerBox)
		groupEnd:insert(gameOverHeaderTitle)
		groupEnd:insert(gameOverGameScore)
		groupEnd:insert(gameOverHighScore)
		groupEnd:insert(gameOverCoinImage)
		groupEnd:insert(gameOverCoinCount)
		groupEnd:insert(gameOverButtonMenu)
		groupEnd:insert(gameOverButtonReplay)
		groupEnd:insert(gameOverButtonLeader)
		groupEnd:insert(gameOverButtonTwitter)
		groupEnd:insert(gameOverButtonSound)
		groupEnd:insert(gameOverButtonMusic)

		gameOverButtonMenu:addEventListener("touch", gameOverButtonIndex)
		gameOverButtonReplay:addEventListener("touch", gameOverButtonIndex)
		gameOverButtonLeader:addEventListener("touch", gameOverButtonIndex)
		gameOverButtonTwitter:addEventListener("touch", gameOverButtonIndex)
	end

showAdMobbAdInter()
createStage()
createReady()

uiImageTabletFrame:addEventListener("touch", gameOverButtonIndex)

function onSystemEvent(event)
	if ( event.type == "applicationOpen" ) then
		checkIfDataExists()
		checkIfFishDataExists()
		print("Application has been opened.")
	elseif ( event.type == "applicationSuspend" ) then
		saveGameData()
		print("Application has been paused.")
	elseif ( event.type == "applicationExit" ) then
		saveGameData()
		print("Application is exiting closed.")
	end
end
Runtime:addEventListener("system", onSystemEvent)
end

-- Called when scene is about to move offscreen:
-- Cancel Timers/Transitions and Runtime Listeners etc.
function scene:exitScene( event )
	if firstSpawnTimer ~= nil then timer.cancel(firstSpawnTimer) end
	if bubbleSpawnTimer ~= nil then timer.cancel(bubbleSpawnTimer) end
	if spawnRoundTimer ~= nil then timer.cancel(spawnRoundTimer) end
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