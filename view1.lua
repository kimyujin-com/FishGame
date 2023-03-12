-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	
	local background = display.newRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight)
	background:setFillColor(1)

	local pond = display.newCircle(display.contentWidth * 0.6, display.contentHeight/2, 350)
	pond:setFillColor(0.5, 0.8, 1)

	local fish = {}
	local fishGroup = display.newGroup()

	for i = 1, 5 do
			fish[i] = display.newImage(fishGroup, "image/fish.png")
			fish[i].x, fish[i].y = pond.x + math.random(-200, 200), pond.y +  math.random(-200, 200)
	end

	--fishGroup.x = fishGroup.x - 150
	--fishGroup.y = fishGroup.y - 150
	sceneGroup:insert(fishGroup)

	local cat = display.newImageRect("image/cat.png", 150*1.2, 200*1.2)
	cat.x, cat.y = display.contentWidth*0.4, display.contentHeight*0.8

	local score = 0
	local showScore = display.newText(score, display.contentWidth*0.2, display.contentHeight*0.2)
	showScore:setFillColor(0)
	showScore.size = 100

	--[[local function catch(event)
		display.remove(event.target)
		score = score + 1
		showScore.text = score

		if score == 5 then
			local options = 
			{
				effect = "zoomOutInFade",
				time = 200,
				params = "view1"
			}
			composer.gotoScene("view2", options)
		end
	end]]

	for i = 1, 5 do
		fish[i].id = i .."번 fish"
		end
	local function catch( event )
		if ( event.phase == "began" ) then
			print(event.target.id .. " 드래그!")
			display.getCurrentStage():setFocus( event.target )
			event.target.isFocus = true
		elseif ( event.phase == "moved" ) then

			if ( event.target.isFocus ) then
				event.target.x = event.xStart + event.xDelta
				event.target.y = event.yStart + event.yDelta
			end
		elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
			if ( event.target.isFocus ) then
				print("잭")

				if event.target.x < cat.x + 100 and event.target.x > cat.x - 100 
				and event.target.y < cat.y + 100 and event.target.y > cat.y - 100 then

					display.remove(event.target)
					score = score + 1
					showScore.text = score
					composer.setVariable("scoreText", score)

					if score == 5 then
						composer.setVariable("complete", true)
						composer.gotoScene("view2")
					end
				else
					event.target.x = event.xStart
					event.target.y = event.ystart
				end
				display.getCurrentStage():setFocus( nil )
				event.target.isFocus = false
			end
			display.getCurrentStage():setFocus( nil )
			event.target.isFocus = false
		end
	end
		for i=1,5 do
			fish[i]:addEventListener("touch",catch)
		end
	-- 시간 제한 --
	local limit = 10
	local showLimit = display.newText(limit, display.contentWidth*0.9, display.contentHeight*0.1)
	showLimit:setFillColor(0)
	showLimit.size = 80

	local function timeAttack( event )
		limit = limit - 1
		showLimit.text = limit

		if(limit == 0) then
			composer.setVariable("complete", false)
			composer.gotoScene("view2")
			end
	end
		timer.performWithDelay( 1000, timeAttack, 0 )--1초 뒤에 timeAttack이라는 함수를 ^무한번 ^반복해라
		
	--레이어 정리--
	sceneGroup:insert(background)
	sceneGroup:insert(pond)
	sceneGroup:insert(fishGroup)
	sceneGroup:insert(cat)
	sceneGroup:insert(showScore)
	sceneGroup:insert(showLimit)

	--fishGroup:toFront()
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
		composer.removeScene("view1")
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene