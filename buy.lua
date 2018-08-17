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
local loadsave = require("loadsave")

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

local isButtonClickable = true

--	COLOR PALETTE
local colorFontUIText =			{R = 238/255,	G = 253/255,	B = 210/255,	A = 255/255}
local colorBlueSky =			{R = 168/255,	G = 200/255,	B = 238/255,	A = 255/255}
local colorSandBeach =			{R = 232/255,	G = 206/255,	B = 169/255,	A = 255/255}
local colorBlueWater =			{R = 21/255,	G = 43/255,		B = 64/255,		A = 255/255}
local colorDeepSeaBed =			{R = 12/255,	G = 22/255,		B = 32/255,		A = 255/255}
local coloriPhoneFrame =		{R = 20/255,	G = 20/255,		B = 20/255,		A = 255/255}

-- Display Groups
local buyGroup
local uiBuyGroup

-- Functions
local createOverlay
local createPurchaseButtons
local selectThisFish
local buttonPressingFunction
local saveBuyGameData
local returnToMenu

-----------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------
-- Called when the scene's view does not exist:
-- Create all your display objects here.
function scene:createScene( event )
	local mainMenuGroup = self.view

	buyGroup = display.newGroup();												mainMenuGroup:insert(buyGroup)
	uiBuyGroup = display.newGroup();											mainMenuGroup:insert(uiBuyGroup)

	function createOverlay()
		purchaseDecorBlueSky = display.newRect(0, 0, screenWidth, screenHeight)
		purchaseDecorBlueSky:setFillColor(colorBlueSky.R, colorBlueSky.G, colorBlueSky.B, colorBlueSky.A)
		purchaseDecorBlueSky.anchorX = 0.5;										purchaseDecorBlueSky.x = centerX;
		purchaseDecorBlueSky.anchorY = 1;										purchaseDecorBlueSky.y = screenHeight;

		purchaseTextHeader = display.newText("Buy Fish", 0, 0, customFont, 36 * 2)
		purchaseTextHeader:setFillColor(coloriPhoneFrame.R, coloriPhoneFrame.G, coloriPhoneFrame.B, coloriPhoneFrame.A)
		purchaseTextHeader.xScale = 0.5;										purchaseTextHeader.yScale = 0.5;
		purchaseTextHeader.anchorX = 0.5;										purchaseTextHeader.x = centerX;
		purchaseTextHeader.anchorY = 0;											purchaseTextHeader.y = 55;

		purchaseImageCoin = display.newImageRect("images/graphics/fishCoinsFlat.png", 80, 80)
		purchaseImageCoin.xScale = 0.5;											purchaseImageCoin.yScale = 0.5;
		purchaseImageCoin.anchorX = 0.5;										purchaseImageCoin.x = centerX;
		purchaseImageCoin.anchorY = 1;											purchaseImageCoin.y = screenHeight - 5;

		purchaseTextCoinCount = display.newText("" .. gameData.gameCoinWallet, 0, 0, customFont, 24 * 2)
		purchaseTextCoinCount:setFillColor(coloriPhoneFrame.R, coloriPhoneFrame.G, coloriPhoneFrame.B, coloriPhoneFrame.A)
		purchaseTextCoinCount.xScale = 0.5;										purchaseTextCoinCount.yScale = 0.5;
		purchaseTextCoinCount.anchorX = 0;										purchaseTextCoinCount.x = centerX + 25;
		purchaseTextCoinCount.anchorY = 1;										purchaseTextCoinCount.y = screenHeight - 10;

		purchaseButtonMenu = display.newImageRect("images/buttons/orangeMenuButton.png", 80, 80)
		purchaseButtonMenu.xScale = 0.5;										purchaseButtonMenu.yScale = 0.5;
		purchaseButtonMenu.anchorX = 0;											purchaseButtonMenu.x = 10;
		purchaseButtonMenu.anchorY = 1;											purchaseButtonMenu.y = screenHeight - 5;

		purchaseDecorTopNav = display.newRect(0, 0, screenWidth, 50)
		purchaseDecorTopNav:setFillColor(colorBlueSky.R, colorBlueSky.G, colorBlueSky.B, colorBlueSky.A)
		purchaseDecorTopNav.anchorX = 0.5;										purchaseDecorTopNav.x = centerX;
		purchaseDecorTopNav.anchorY = 0;										purchaseDecorTopNav.y = 0;

		purchaseDecorBottomNav = display.newRect(0, 0, screenWidth, 50)
		purchaseDecorBottomNav:setFillColor(colorBlueSky.R, colorBlueSky.G, colorBlueSky.B, colorBlueSky.A)
		purchaseDecorBottomNav.anchorX = 0.5;									purchaseDecorBottomNav.x = centerX;
		purchaseDecorBottomNav.anchorY = 1;										purchaseDecorBottomNav.y = screenHeight;

		buyGroup:insert(purchaseDecorBlueSky)
		buyGroup:insert(purchaseTextHeader)
		buyGroup:insert(purchaseDecorTopNav)
		buyGroup:insert(purchaseDecorBottomNav)
		buyGroup:insert(purchaseImageCoin)
		buyGroup:insert(purchaseTextCoinCount)
		buyGroup:insert(purchaseButtonMenu)
	end

	function createPurchaseButtons()
		local i
		local purchaseButton = {}
		local coinForPrice = {}
		local costForFish = {}

		function selectThisFish(event)
			local t = event.target
			local c = t.value

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

							gameData.whichFish = c;
							saveBuyGameData()
							print("Selecting This Fish " .. gameData.whichFish)
						end
					end
				end
			end
			return true
		end

		function buttonPressingFunction(event)
			local t = event.target
			local c = t.value

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
							if t.unlocked then
								print("Already Unlocked")
							elseif gameData.gameCoinWallet < t.cost then
								if soundAllowed then playSound("error") end
								print("Not enough coins")
							elseif gameData.gameCoinWallet >= t.cost and not t.unlocked then
								if soundAllowed then playSound("click") end

								gameData.gameCoinWallet = gameData.gameCoinWallet - t.cost
								fishDatabase[c].unlocked = true
								saveBuyGameData()

								print("Coins Left " .. gameData.gameCoinWallet)
								print("The Current Fish is " .. gameData.whichFish)

								t:removeEventListener("touch", buttonPressingFunction)
								t:setFillColor(colorSandBeach.R, colorSandBeach.G, colorSandBeach.B, colorSandBeach.A)
								t:addEventListener("touch", selectThisFish)

								coinForPrice[c]:removeSelf();
								coinForPrice[c] = nil;
								coinForPrice[c] = display.newImageRect("images/buy/fish" .. c .. ".png", 100, 70)
								coinForPrice[c].xScale = 0.5;								coinForPrice[c].yScale = 0.5;
								coinForPrice[c].anchorX = 1;								coinForPrice[c].x = centerX - 40;
								coinForPrice[c].anchorY = 0.5;								coinForPrice[c].y = 125 + ((c - 1) * 60);
								uiBuyGroup:insert(coinForPrice[c])

								costForFish[c]:setFillColor(coloriPhoneFrame.R, coloriPhoneFrame.G,coloriPhoneFrame.B, coloriPhoneFrame.A)
								costForFish[c].text = "Select";

								purchaseTextCoinCount.text = "" .. gameData.gameCoinWallet
							end
						end
					end
				end
			end
			return true
		end

		for i = 1, #fishDatabase do
			purchaseButton[i] = display.newRect(0, 0, 200, 50)
			purchaseButton[i]:setStrokeColor(colorDeepSeaBed.R, colorDeepSeaBed.G, colorDeepSeaBed.B, colorDeepSeaBed.A)
			purchaseButton[i].strokeWidth = 5;
			purchaseButton[i].anchorX = 0.5;							purchaseButton[i].x = centerX;
			purchaseButton[i].anchorY = 0;								purchaseButton[i].y = 100 + ((i - 1) * 60);
			purchaseButton[i].value = i
			purchaseButton[i].unlocked = fishDatabase[i].unlocked
			purchaseButton[i].cost = fishDatabase[i].cost
			uiBuyGroup:insert(purchaseButton[i])

			coinForPrice[i] = display.newImageRect("images/graphics/fishCoinsFlat.png", 80, 80)
			coinForPrice[i].xScale = 0.5;								coinForPrice[i].yScale = 0.5;
			coinForPrice[i].anchorX = 1;								coinForPrice[i].x = centerX - 40;
			coinForPrice[i].anchorY = 0.5;								coinForPrice[i].y = 125 + ((i - 1) * 60);
			uiBuyGroup:insert(coinForPrice[i])

			costForFish[i] = display.newText("" .. fishDatabase[i].cost, 0, 0, customFont, 24 * 2)
			costForFish[i]:setFillColor(colorFontUIText.R, colorFontUIText.G, colorFontUIText.B, colorFontUIText.A)
			costForFish[i].xScale = 0.5;								costForFish.yScale = 0.5;
			costForFish[i].anchorX = 0;									costForFish[i].x = centerX - 10;
			costForFish[i].anchorY = 0.5;								costForFish[i].y = 125 + ((i - 1) * 60)
			uiBuyGroup:insert(costForFish[i])

			if fishDatabase[i].unlocked then
				purchaseButton[i]:setFillColor(colorSandBeach.R, colorSandBeach.G, colorSandBeach.B, colorSandBeach.A)
				coinForPrice[i]:removeSelf();
				coinForPrice[i] = display.newImageRect("images/buy/fish" .. i .. ".png", 100, 70)
				coinForPrice[i].xScale = 0.5;								coinForPrice[i].yScale = 0.5;
				coinForPrice[i].anchorX = 1;								coinForPrice[i].x = centerX - 40;
				coinForPrice[i].anchorY = 0.5;								coinForPrice[i].y = 125 + ((i - 1) * 60);
				uiBuyGroup:insert(coinForPrice[i])
				costForFish[i]:setFillColor(coloriPhoneFrame.R, coloriPhoneFrame.G,coloriPhoneFrame.B, coloriPhoneFrame.A)
				costForFish[i].text = "Select";
				purchaseButton[i]:addEventListener("touch", selectThisFish)
			else
				purchaseButton[i]:setFillColor(colorBlueWater.R, colorBlueWater.G, colorBlueWater.B, colorBlueWater.A)
				coinForPrice[i].isVisible = true;
			end

			purchaseButton[i]:addEventListener("touch", buttonPressingFunction)
			print("fishDatabase" .. i)
		end
	end

	createOverlay()
	createPurchaseButtons()
end

-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enterScene( event )
	-- Completely remove the previous scene/all scenes.
	-- Handy in this case where we want to keep everything simple.
	storyboard.removeAll()

	function saveBuyGameData()
		loadsave.saveTable(gameData, "dataFile01.json")
		loadsave.saveTable(fishDatabase, "dataFile02.json")
	end

	function returnToMenu(event)
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
						-- Go the the game
						hideAdMobAd()
						timer.performWithDelay(500, function()
							storyboard.gotoScene( "menu", "crossFade", 500 )
						end, 1)
					end
				end
			end
		end
		return true
	end

-- Timers and Transitions
showAdMobbAd(0)
purchaseButtonMenu:addEventListener("touch", returnToMenu)
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