# Corona/Lua Tutorial
In this tutorial, we going to get introduced to Corona and Lua and make a simple game.

## Prerequisites
* [Create a corona developer account](https://developer.coronalabs.com/user/login)
* [Install the latest public build for Corona](https://developer.coronalabs.com/downloads/corona-sdk)
* Have a text editor installed such as [Atom](https://atom.io/)
* I heavily recommend adding autocomplete to atom. (see below)


## How to install Autocomplete with Atom

1.In the menu bar go to Packages>Setting View>Install Packages and Themes

2.Then in the search box type in __corona sdk__

3.Click install on __autocomplete-corona__

## Introduction to Corona and Lua

Lua is a programing language. It is very similar to javascript. It is probably one of the easiest languages to learn.

Lua has been used in many games and application like Angry Birds and League of Legends.

Corona, on the other hand, is the engine. It allows you to develop apps and 2d games for free. It uses open GL to run on MacOS, Android, Windows, and iOS.

## Setting values

Corona is scoped based programing language. This means that code is read from top to bottom. So we need to predeclare 

```
local scale0X= ((display.actualContentWidth- display.contentWidth)*.5)
local scale0Y= ((display.actualContentHeight- display.contentHeight)*.5)
local time = 0
local resetTime = 20
time = resetTime
local score = 0
local numberOfBalloons = 100
local timerForClock
local balloonGroup = display.newGroup( )
```

## Create UI

```
local bg = display.newImageRect( "assets/clouds.png", 570, 320 )
bg.x, bg.y = display.contentCenterX, display.contentCenterY

local title = display.newText( "Balloon", display.contentCenterX, 40, native.systemFontBold, 30 )
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
```

## add play button

We are going to add a start game function, which will start the game on play button tap
```
local function startGame(  )
    timerCounter.text = time
    scoreCounter.text = score
    playButton.alpha = 0
    title.alpha = 0
    timerCounter.alpha = 1
    scoreCounter.alpha = 1
end
playButton:addEventListener( "tap", startGame )
```

## start timer
(Note this function should be above startGame function)

Next we need to -1 every second and update timerCounter text

```
local function startTimer(  )
    if (timerForClock == nil) then
        local function editTime( )
            time = time -1
            timerCounter.text = time
            if (time == 0) then
                timer.cancel(timerForClock)
                --endGame()  uncomment when end game function is added
            end
        end
        timerForClock = timer.performWithDelay( 1000, editTime,0 )
    end
end
```

## Make the balloons
(Note this function should be above startTimer function)
 
Next, we to generate balloons randomly and make them go upwards

Also, we need to add a point every to a ballon is tapped

```
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
```
## Start game up

lets call makeballoons() and startTimer() in our start game function

 ```
 --Updated startGame function
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
 ```

## End game
(Note this function should be above make balloons function)

Now we need to create a endGame function which will reset the UI and Game after time is up
```
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
```

## Uncomment endGame function in timer

Finally, we need to Uncomment the endGame function in startTimer

```
--Updated
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
```
## Challenge Time!
This tutorial was very basic there is still lots you can do with this project
Examples
* Add end game screen
* Add settings or credits section
* Make a hard mode which speeds up balls
* Add high score section
* Better artwork

## Helpful links, tips, and sources

Have to give credit to Ray Wenderlich for his ballon pop assets

If you have question problems with Corona, you can always ask in the [forums](https://forums.coronalabs.com/forum/532-newbie-questions/). There are usually engineers or other corona members that can help.

Corona has alot of tuturials and examples in the [documentation](https://docs.coronalabs.com).

## Thanks for following along!
My name is Scott and my email is scottrules44@gmail.com if you have any questions or comments
