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

--	COLOR PALETTE
local colorFontUIText =			{R = 238/255,	G = 253/255,	B = 210/255,	A = 255/255}
local colorBlueSky =			{R = 168/255,	G = 200/255,	B = 238/255,	A = 255/255}
local colorLightGreen =			{R = 148/255,	G = 203/255,	B = 122/255,	A = 255/255}
local colorDarkGreen =			{R = 93/255,	G = 164/255,	B = 124/255,	A = 255/255}
local colorBlueWater =			{R = 21/255,	G = 43/255,		B = 64/255,		A = 255/255}
local colorSandBeach =			{R = 232/255,	G = 206/255,	B = 169/255,	A = 255/255}

-- Display Groups
local creditGroup

-- Functions
local createCreditScreen
local removeAllListeners
local creditButtonIndex

-----------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------
-- Called when the scene's view does not exist:
-- Create all your display objects here.
function scene:createScene( event )
	local creditScreenGroup = self.view

	creditGroup = display.newGroup();										creditScreenGroup:insert(creditGroup)

	function createCreditScreen()
		creditDecorBlueSky = display.newRect(0, 0, screenWidth, screenHeight)
		creditDecorBlueSky:setFillColor(colorBlueSky.R, colorBlueSky.G, colorBlueSky.B, colorBlueSky.A)
		creditDecorBlueSky.anchorX = 0.5;									creditDecorBlueSky.x = centerX;
		creditDecorBlueSky.anchorY = 1;										creditDecorBlueSky.y = screenHeight;

		creditDecorLightGround = display.newRect(0, 0, screenWidth, screenHeight * 0.8)
		creditDecorLightGround:setFillColor(colorLightGreen.R, colorLightGreen.G, colorLightGreen.B, colorLightGreen.A)
		creditDecorLightGround.anchorX = 0.5;								creditDecorLightGround.x = centerX;
		creditDecorLightGround.anchorY = 1;									creditDecorLightGround.y = screenHeight;

		creditDecorDarkGround = display.newRect(0, 0, screenWidth, screenHeight * 0.78)
		creditDecorDarkGround:setFillColor(colorDarkGreen.R, colorDarkGreen.G, colorDarkGreen.B, colorDarkGreen.A)
		creditDecorDarkGround.anchorX = 0.5;								creditDecorDarkGround.x = centerX;
		creditDecorDarkGround.anchorY = 1;									creditDecorDarkGround.y = screenHeight;

		creditDecorUpperSea = display.newRect(0, 0, screenWidth, screenHeight * 0.75)
		creditDecorUpperSea:setFillColor(colorBlueWater.R, colorBlueWater.G, colorBlueWater.B, colorBlueWater.A)
		creditDecorUpperSea.anchorX = 0.5;									creditDecorUpperSea.x = centerX;
		creditDecorUpperSea.anchorY = 1;									creditDecorUpperSea.y = screenHeight;

		creditDecorTreesHills = display.newImageRect("images/graphics/mountainTree.png", 320, 100)
		creditDecorTreesHills.anchorX = 0.5;								creditDecorTreesHills.x = centerX;
		creditDecorTreesHills.anchorY = 1;									creditDecorTreesHills.y = screenHeight * 0.2;

		creditTextHeaderTitle = display.newText("CREDITS", 0, 0, customFont, 28 * 2)
		creditTextHeaderTitle:setFillColor(colorSandBeach.R, colorSandBeach.G, colorSandBeach.B, colorSandBeach.A)
		creditTextHeaderTitle.xScale = 0.5;									creditTextHeaderTitle.yScale = 0.5;
		creditTextHeaderTitle.anchorX = 0.5;								creditTextHeaderTitle.x = centerX;
		creditTextHeaderTitle.anchorY = 0.5;								creditTextHeaderTitle.y = screenHeight * 0.25 + 20;

		creditTextCreator = display.newText("Game Design by Harry Tran", 0, 0, customFont, 14 * 2)
		creditTextCreator:setFillColor(colorSandBeach.R, colorSandBeach.G, colorSandBeach.B, colorSandBeach.A)
		creditTextCreator.xScale = 0.5;										creditTextCreator.yScale = 0.5;
		creditTextCreator.anchorX = 0.5;									creditTextCreator.x = centerX;
		creditTextCreator.anchorY = 0;										creditTextCreator.y = screenHeight * 0.25 + 40;

		creditTextProgrammer = display.newText("Programmed by Harry Tran", 0, 0, customFont, 14 * 2)
		creditTextProgrammer:setFillColor(colorSandBeach.R, colorSandBeach.G, colorSandBeach.B, colorSandBeach.A)
		creditTextProgrammer.xScale = 0.5;									creditTextProgrammer.yScale = 0.5;
		creditTextProgrammer.anchorX = 0.5;									creditTextProgrammer.x = centerX;
		creditTextProgrammer.anchorY = 0;									creditTextProgrammer.y = screenHeight * 0.25 + 60;

		creditTextArtist = display.newText("Artwork by Harry Tran", 0, 0, customFont, 14 * 2)
		creditTextArtist:setFillColor(colorSandBeach.R, colorSandBeach.G, colorSandBeach.B, colorSandBeach.A)
		creditTextArtist.xScale = 0.5;										creditTextArtist.yScale = 0.5;
		creditTextArtist.anchorX = 0.5;										creditTextArtist.x = centerX;
		creditTextArtist.anchorY = 0;										creditTextArtist.y = screenHeight * 0.25 + 80;

		creditTextFontDesign = display.newText("Rounds Black by Jovanny Lemonad", 0, 0, customFont, 14 * 2)
		creditTextFontDesign:setFillColor(colorSandBeach.R, colorSandBeach.G, colorSandBeach.B, colorSandBeach.A)
		creditTextFontDesign.xScale = 0.5;									creditTextFontDesign.yScale = 0.5;
		creditTextFontDesign.anchorX = 0.5;									creditTextFontDesign.x = centerX;
		creditTextFontDesign.anchorY = 0;									creditTextFontDesign.y = screenHeight * 0.25 + 100;

		creditTextMusicName = display.newText("Song Name Deep Emerald", 0, 0, customFont, 14 * 2)
		creditTextMusicName:setFillColor(colorSandBeach.R, colorSandBeach.G, colorSandBeach.B, colorSandBeach.A)
		creditTextMusicName.xScale = 0.5;									creditTextMusicName.yScale = 0.5;
		creditTextMusicName.anchorX = 0.5;									creditTextMusicName.x = centerX;
		creditTextMusicName.anchorY = 0;									creditTextMusicName.y = screenHeight * 0.25 + 120;

		creditTextMusicCreator = display.newText("Music Loop by PlayOnLoop", 0, 0, customFont, 14 * 2)
		creditTextMusicCreator:setFillColor(colorBlueSky.R, colorBlueSky.G, colorBlueSky.B, colorBlueSky.A)
		creditTextMusicCreator.xScale = 0.5;								creditTextMusicCreator.yScale = 0.5;
		creditTextMusicCreator.anchorX = 0.5;								creditTextMusicCreator.x = centerX;
		creditTextMusicCreator.anchorY = 0;									creditTextMusicCreator.y = screenHeight * 0.25 + 140;
		creditTextMusicCreator.myLabel = "musicSource"

		creditTextSoundCreator = display.newText("Sound Effects by NoiseForFun", 0, 0, customFont, 14 * 2)
		creditTextSoundCreator:setFillColor(colorBlueSky.R, colorBlueSky.G, colorBlueSky.B, colorBlueSky.A)
		creditTextSoundCreator.xScale = 0.5;								creditTextSoundCreator.yScale = 0.5;
		creditTextSoundCreator.anchorX = 0.5;								creditTextSoundCreator.x = centerX;
		creditTextSoundCreator.anchorY = 0;									creditTextSoundCreator.y = screenHeight * 0.25 + 160;
		creditTextSoundCreator.myLabel = "soundSource"

		creditTextPickionSite = display.newText("http://www.pickleandonions.com/", 0, 0, customFont, 14 * 2)
		creditTextPickionSite:setFillColor(colorBlueSky.R, colorBlueSky.G, colorBlueSky.B, colorBlueSky.A)
		creditTextPickionSite.xScale = 0.5;									creditTextPickionSite.yScale = 0.5;
		creditTextPickionSite.anchorX = 0.5;								creditTextPickionSite.x = centerX;
		creditTextPickionSite.anchorY = 0;									creditTextPickionSite.y = screenHeight - 130;
		creditTextPickionSite.myLabel = "ourWebpage"

		creditTextCopyrightLine = display.newText("© Copyright 2014 Pickion Games", 0, 0, customFont, 14 * 2)
		creditTextCopyrightLine:setFillColor(colorSandBeach.R, colorSandBeach.G, colorSandBeach.B, colorSandBeach.A)
		creditTextCopyrightLine.xScale = 0.5;								creditTextCopyrightLine.yScale = 0.5;
		creditTextCopyrightLine.anchorX = 0.5;								creditTextCopyrightLine.x = centerX;
		creditTextCopyrightLine.anchorY = 0;								creditTextCopyrightLine.y = screenHeight - 110;

		creditTextMiscLine = display.newText("All Rights Reserved.", 0, 0, customFont, 14 * 2)
		creditTextMiscLine:setFillColor(colorSandBeach.R, colorSandBeach.G, colorSandBeach.B, colorSandBeach.A)
		creditTextMiscLine.xScale = 0.5;									creditTextMiscLine.yScale = 0.5;
		creditTextMiscLine.anchorX = 0.5;									creditTextMiscLine.x = centerX;
		creditTextMiscLine.anchorY = 0;										creditTextMiscLine.y = screenHeight - 90;

		creditButtonMenu = display.newImageRect("images/buttons/orangeMenuButton.png", 80, 80)
		creditButtonMenu.xScale = 0.5;										creditButtonMenu.yScale = 0.5;
		creditButtonMenu.anchorX = 0;										creditButtonMenu.x = 10;
		creditButtonMenu.anchorY = 1;										creditButtonMenu.y = screenHeight - 30;
		creditButtonMenu.myLabel = "menu"

		creditGroup:insert(creditDecorBlueSky)
		creditGroup:insert(creditDecorLightGround)
		creditGroup:insert(creditDecorDarkGround)
		creditGroup:insert(creditDecorUpperSea)
		creditGroup:insert(creditDecorTreesHills)
		creditGroup:insert(creditTextHeaderTitle)
		creditGroup:insert(creditTextCreator)
		creditGroup:insert(creditTextProgrammer)
		creditGroup:insert(creditTextArtist)
		creditGroup:insert(creditTextFontDesign)
		creditGroup:insert(creditTextMusicName)
		creditGroup:insert(creditTextMusicCreator)
		creditGroup:insert(creditTextSoundCreator)
		creditGroup:insert(creditTextPickionSite)
		creditGroup:insert(creditTextCopyrightLine)
		creditGroup:insert(creditTextMiscLine)
		creditGroup:insert(creditButtonMenu)
	end

	createCreditScreen()
end

-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enterScene( event )
	-- Completely remove the previous scene/all scenes.
	-- Handy in this case where we want to keep everything simple.
	storyboard.removeAll()

	local function removeAllListeners()
		creditButtonMenu:removeEventListener("touch", creditButtonIndex)
		creditTextSoundCreator:removeEventListener("touch", creditButtonIndex)
		creditTextMusicCreator:removeEventListener("touch", creditButtonIndex)
		creditTextPickionSite:removeEventListener("touch", creditButtonIndex)
	end

	function creditButtonIndex(event)
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
					if t.myLabel == "menu" then
						removeAllListeners()
						if soundAllowed then playSound("click") end
						storyboard.gotoScene( "menu", "crossFade", 500 )

					elseif t.myLabel == "musicSource" then
						if soundAllowed then playSound("click") end
						system.openURL( "http://www.playonloop.com/" )

					elseif t.myLabel == "soundSource" then
						if soundAllowed then playSound("click") end
						system.openURL( "http://www.noiseforfun.com/" )

					elseif t.myLabel == "ourWebpage" then
						if soundAllowed then playSound("click") end
						system.openURL( "http://www.pickion.com/" )

					end
					print(t.myLabel, " has been pressed")
				end
			end
		end
		return true
	end

-- Timers and Transitions
creditButtonMenu:addEventListener("touch", creditButtonIndex)
creditTextSoundCreator:addEventListener("touch", creditButtonIndex)
creditTextMusicCreator:addEventListener("touch", creditButtonIndex)
creditTextPickionSite:addEventListener("touch", creditButtonIndex)
end

-- Called when scene is about to move offscreen:
-- Cancel Timers/Transitions and Runtime Listeners etc.
function scene:exitScene( event )

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