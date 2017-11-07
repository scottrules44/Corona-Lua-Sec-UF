--assets from: raywenderlich.com
--variables
local scale0X= ((display.actualContentWidth- display.contentWidth)*.5)
local scale0Y= ((display.actualContentHeight- display.contentHeight)*.5)
local time = 0
local resetTime = 20
time = resetTime
local score = 0
local numberOfBalloons = 100
local timerForClock
local balloonGroup = display.newGroup( )
--UI
local bg = display.newImageRect( "assets/clouds.png", 570, 320 )
bg.x, bg.y = display.contentCenterX, display.contentCenterY

local title = display.newText( "Balloon Pop", display.contentCenterX, 40, native.systemFontBold, 30 )
title:setFillColor( 1,0,0 )

local playButton = display.newGroup( )
playButton.box = display.newRect( playButton, 0, 0, 70, 40 )
playButton.box:setFillColor( 1,0,0 )
playButton.label = display.newText(playButton, "Play", 0, 0, native.systemFont, 20 )
playButton.x, playButton.y= display.contentCenterX, display.contentCenterY

local scoreCounter = display.newText( score, -scale0X+20, -scale0Y+20, native.systemFontBold, 20 )
scoreCounter.alpha = 0

local timerCounter = display.newText( time, -scale0X+20, display.contentHeight-15, native.systemFontBold, 20 )
timerCounter.alpha = 0
--functions
local function endGame(  )
	score = 0
	timerForClock = nil
	time = resetTime
	playButton.alpha = 1
	title.alpha = 1
	timerCounter.alpha = 0
	scoreCounter.alpha = 0
	display.remove( balloonGroup )
	balloonGroup = display.newGroup( )
end
local function makeballoons( )
	for i=1,numberOfBalloons do
		--move balloons group to front
		balloonGroup:toFront( )
		-- create balloons
		local balloon = display.newImageRect( balloonGroup,"assets/balloon.png", 30, 30 )
		balloon.x = math.random(-scale0X+40, display.actualContentWidth-scale0X-40);
		balloon.y = math.random(-scale0Y+30, display.actualContentHeight-scale0Y+1200);
		--make balloons fly
		local myTimer
		local function flyballoons(  )
			if (balloon.y == nil) then
				timer.cancel(myTimer)
				return
			end
			if (scale0Y-20 >= balloon.y) then
				timer.cancel( myTimer )
				display.remove( balloon )
			else
				balloon.y = balloon.y -3
			end
		end
		myTimer = timer.performWithDelay( 33,flyballoons, 0 )
		--destroy balloons when tapped
		local function balloonsTapped( )
			display.remove( balloon )
			if (myTimer) then
				timer.cancel( myTimer )
			end
			score = score+1
			scoreCounter.text = score
		end
		balloon:addEventListener( "tap", balloonsTapped )
	end
end
local function startTimer(  )
	if (timerForClock == nil) then
		local function editTime( )
			time = time -1
			timerCounter.text = time
			if (time == 0) then
				timer.cancel(timerForClock)
				endGame()
			end
		end
		timerForClock = timer.performWithDelay( 1000, editTime,0 )
	end
end
local function startGame(  )
	timerCounter.text = time
	scoreCounter.text = score
	playButton.alpha = 0
	title.alpha = 0
	timerCounter.alpha = 1
	scoreCounter.alpha = 1
	makeballoons( )
	startTimer(  )
end
playButton:addEventListener( "tap", startGame )