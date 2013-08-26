-- DAN JORQUERA PRESENTS: SUPPORTIVE SHARK!
-- 4 HOUR GAME JAM CORONABLITZ
-- 123 GO!
-- (usually this should be split into several different docs, but time is of the essence!)

display.setStatusBar( display.HiddenStatusBar )
local physics = require("physics")

--Variables
local speed = 3.5
local difficulty = 30

local goodTable = {
	[1] = "good",
	[2] = "awesome",
	[3] = "brave",
	[4] = "great",
	[5] = "strong",
	[6] = "smart",
	[7] = "beautiful",
	[8] = "kind",
	[9] = "amazing",
	[10] = "helpful",
	[11] = "cherished",
	[12] = "cool",
	[13] = "wonderful",
	[14] = "precious",
	[15] = "respectful",
	[16] = "admired",
	[17] = "valued",
	[18] = "sensible",
	[19] = "important",
	[20] = "superb",
	[21] = "clever",
	[22] = "worthy",
	[23] = "excellent",
	[24] = "exemplary",
	[25] = "skillful",
}

local badTable = {
	[1] = "bad",
	[2] = "bonkers",
	[3] = "icky",
	[4] = "odd",
	[5] = "noisy",
	[6] = "uncool",
	[7] = "bothersome",
	[8] = "awkward",
	[9] = "batty",
	[10] = "silly",
	[11] = "gross",
	[12] = "crazy",
	[13] = "smelly",
	[14] = "stinky",
	[15] = "tiny",
	[16] = "small",
	[17] = "bad",
	[18] = "scared",
	[19] = "ignoble",
	[20] = "immature",
	[21] = "frightful",
	[22] = "dopey",
	[23] = "ditzy",
	[24] = "strange",
	[25] = "nutty",
}

local game = {
	start,
	enterFrame,
	onCollision,
	onTouch,
	over, --GAME OVER MAN, GAME OVER
	reset,
}

--START SCREEN
local start_screen = display.newGroup()

--START BUTTON
local start_button = display.newRect(0, 0, display.contentWidth*2, 100)
start_button:setFillColor(100, 100, 255)
start_button.x = display.contentWidth/2
start_button.y = display.contentHeight/2
start_screen:insert(start_button)

local start_text = display.newText("START", 0, 0, "VAGRounded BT", 70)
start_text.x = start_button.x
start_text.y = start_button.y
start_screen:insert(start_text)

--TITLE
local title = display.newText("Supportive Shark", 0, 0, "VAGRounded BT", 45)
title.x = start_button.x
title.y = start_button.y - title.height*4
start_screen:insert(title)

--CREDITS
local credits = display.newText("a game by dan jorquera", 0, 0, "VAGRounded BT", 20)
credits.x = start_button.x
credits.y = title.y + title.height
start_screen:insert(credits)

--INSTRUCTIONS
local instruct = display.newText("Encourage a baby shark to traverse the terrifying great sea.", 0, 0, "VAGRounded BT", 25)
instruct.x = start_button.x
instruct.y = start_button.y + start_button.height
start_screen:insert(credits)

local instruct2 = display.newText("Collect your thoughts before you speak by swimming towards positive words.", 0, 0, "VAGRounded BT", 25)
instruct2.x = start_button.x
instruct2.y = start_button.y + start_button.height + instruct.height
start_screen:insert(credits)

--GAME START
function game:start()
	local backgroundMusic = audio.loadStream("sharks.MP3")
	local backgroundMusicChannel = audio.play( backgroundMusic, {loops=-1}  )
	physics.start()
	
	local bg = display.newRect(0, 0, display.contentWidth*2, display.contentHeight*2)
	bg.x = display.contentWidth/2
	bg.y = display.contentHeight/2
	bg:setFillColor(0, 25, 50)
	game.bg = bg
	
	local mama = display.newImage("art/mama.png")
	mama:setFillColor(150, 150, 150)
	mama.x = display.contentWidth/2
	mama.y = display.contentHeight/2
	mama.xScale = 0.5
	mama.yScale = 0.5
	mama.rotation = 0
	game.mama = mama
	
	local baby = display.newImage("art/baby.png")
	baby.x = 50
	baby.y = 50
	baby.xScale = 0.5
	baby.yScale = 0.5
	baby:setFillColor(175, 175, 175)
	game.baby = baby
	
	local bottom = display.newImage("art/waves.png")
	bottom.x = display.contentWidth/2
	bottom.y = display.contentHeight - bottom.height/2 + display.screenOriginY
	game.bottom = bottom
	
	local good_words = display.newGroup()
	local good_words_text = display.newText("good", 0, 0, "VAGRounded BT", 33)
	good_words.x = display.contentWidth*2
	good_words.y = 0
	good_words:insert(good_words_text)
	game.good_words = good_words
	game.good_words_text = good_words_text
	game.good_words.text = "good"
	
	local bad_words = display.newGroup()
	local bad_words_text = display.newText("bad", 0, 0, "VAGRounded BT", 33)
	bad_words.x = display.contentWidth*2
	bad_words.y = 100
	bad_words:insert(bad_words_text)
	game.bad_words = bad_words
	game.bad_words_text = bad_words_text
	game.bad_words.text = "bad"
	
	game.good_timer = 0
	game.bad_timer = 0
	game.good_timer_max = 200
	game.bad_timer_max = 200
	
	--POINTS
	local points = 0
	local points_text = display.newText(points, 15, 0, "VAGRounded BT", 40)
	--points_text:setTextColor(0, 0, 0)
	game.points = points
	game.points_text = points_text
	
	--TOP TEXT
	local top_text = display.newText("You are ", 0, 0, "VAGRounded BT", 25)
	top_text.x = display.contentWidth/2
	top_text.y = top_text.height
	game.top_text = top_text
	
	local top_field = display.newText("", 0, 0, "VAGRounded BT", 25)
	top_field.x = display.contentWidth/2
	top_field.y = top_text.y + top_field.height
	game.top_field = top_field
	
	points_text.y = top_text.y
	
	--Set up physics
	physics.setGravity(0, 0)
	
	physics.addBody(game.mama, { density=0, friction=0.5, bounce=0.3, isSensor=true} )
	--game.mama.gravityScale = 0
	physics.addBody(game.good_words, { density=3.0, friction=0.5, bounce=0.3 } )
	physics.addBody(game.bad_words, { density=3.0, friction=0.5, bounce=0.3 } )
	
	game.mama.collision = game.onCollision
	game.mama:addEventListener("collision", game.mama)
	
	Runtime:addEventListener("touch", game.onTouch)
	
	--Hide start screen
	start_screen.isVisible = false
	
	Runtime:addEventListener("enterFrame", game.enterFrame)
end

function game:enterFrame(event)
	game.points_text.text = game.points
	
	--Fake gravity!
	game.mama.y = game.mama.y + 0.2
	game.good_words.y = game.good_words.y + 5
	game.bad_words.y = game.bad_words.y + 5
	
	game.good_timer = game.good_timer + 1
	if(game.good_timer >= game.good_timer_max) then --RESET WORDS
		game.good_timer = 0
		game.good_timer_max = math.random(60, 300) --timer randomization
		game.good_words.x = display.contentWidth + 50
		game.good_words.y = math.random(-300, 200)
		
		local new_word = math.random(1, #goodTable)
		game.good_words_text.text = goodTable[new_word]
		game.good_words.text = goodTable[new_word]
	end
	
	game.bad_timer = game.bad_timer + 1
	if(game.bad_timer >= game.bad_timer_max) then --RESET WORDS
		game.bad_timer = 0
		game.bad_timer_max = math.random(60, 300) --timer randomization
		game.bad_words.x = display.contentWidth + 50
		game.bad_words.y = math.random(-300, 200)
		
		local new_word = math.random(1, #badTable)
		game.bad_words_text.text = badTable[new_word]
		game.bad_words.text = badTable[new_word]
	end
	
	--Move words from right to left
	
	if(game.good_words.x) then
		game.good_words.x = game.good_words.x - 8
	end
	if(game.bad_words.x) then
		game.bad_words.x = game.bad_words.x - 8
	end
	
	--Baby's always falling
	game.baby.y = game.baby.y + 0.2
	
	--Game over check
	if(game.baby.y > game.bottom.y or game.mama.y > game.bottom.y) then
		game.over()
	end
end

--Collision Detection
function game.onCollision(self, event)
	if(event.other == game.good_words) then
		timer.performWithDelay(1, game.resetGoodWords)
	elseif(event.other == game.bad_words) then
		timer.performWithDelay(1, game.resetBadWords)
	end
	
	game.top_field.text = event.other.text
end

--HIDE WORDS WHEN  HIT.
function game.resetGoodWords()
	if(game.good_words) then
		game.good_words.x = 1000000
	
		if(game.baby.y > 30) then
			game.baby.y = game.baby.y - difficulty
			game.points = game.points + 5
		end
	end
end

function game.resetBadWords()
	if(game.bad_words) then
		game.bad_words.x = 1000000
		game.baby.y = game.baby.y + difficulty * 2
	
		if(game.points > 10) then
			game.points = game.points - 10
		end
	end
end

local angleB = 0

function angleBetween ( srcObj, dstObj )
		--This function find the angle in between 2 objects
        local xDist = dstObj.x-srcObj.x ; local yDist = dstObj.y-srcObj.y
        angleB = math.deg( math.atan( yDist/xDist ) )
        if ( srcObj.x < dstObj.x ) then angleB = angleB+90 else angleB = angleB-90 end
        return angleB
end

local getAngle = 0

--Movement controls
function game.onTouch(event)

	--MOVE TOWARDS POINTS TOUCHED
	if event.phase == "moved" then
		if(game.mama.x < event.x) then
			game.mama.x = game.mama.x + speed
		elseif(game.mama.x > event.x) then
			game.mama.x = game.mama.x - speed
		end
	
		if(game.mama.y < event.y) then
			game.mama.y = game.mama.y + speed
		elseif(game.mama.y > event.y) then
			game.mama.y = game.mama.y - speed
		end
	end
	
	--ADJUST ROTATION
	getAngle = angleBetween(game.mama, event)
	game.mama.rotation = getAngle - 90
end
--[[
function game.cleanUp()
	Runtime:removeEventListener("touch", game.onTouch)
	Runtime:removeEventListener("enterFrame", game.enterFrame)

	if(game.mama) then
		game.mama:removeSelf()
		game.mama = nil
	end
	
	if(game.baby) then
		game.baby:removeSelf()
		game.baby = nil
	end
	
	if(game.good_words) then
		game.good_words:removeSelf()
		game.good_words = nil
	end
	
	if(game.bad_words) then
		game.bad_words:removeSelf()
		game.bad_words = nil
	end
	
	if(game.top_text) then
		game.top_text:removeSelf()
		game.top_text = nil
	end
	
	if(game.top_field) then
		game.top_field:removeSelf()
		game.top_field = nil
	end
	
	if(game.good_timer) then
		game.good_timer = nil
	end
	
	if(game.bad_timer) then
		game.bad_timer = nil	
	end
	
	if(game.points_text) then
		game.points_text:removeSelf()
		game.points_text = nil
	end
end
--]]
function game.over()
	Runtime:removeEventListener("enterFrame", game.enterFrame)
	--game.cleanUp()
	
	local game_over = display.newText("game over", 0, 0, "VAGRounded BT", 35)
	game_over.x = display.contentWidth/2
	game_over.y = display.contentHeight/2
	game.game_over = game_over
	
	local points_textGO = display.newText(game.points .. " points", 0, 0, "VAGRounded BT", 20)
	points_textGO.x = display.contentWidth/2
	points_textGO.y = game_over.y + points_textGO.height
	game.points_textGO = points_textGO
	
	local try_again_btn = display.newRect(0, 0, 200, 50)
	try_again_btn:setFillColor(0, 0, 0)
	try_again_btn.x = display.contentWidth/2
	try_again_btn.y = points_textGO.y + try_again_btn.height
	game.try_again_btn = try_again_btn
	
	local try_again_text = display.newText("Play again?", 0, 0, "VAGRounded BT", 20)
	try_again_text.x = try_again_btn.x
	try_again_text.y = try_again_btn.y
	game.try_again_text = try_again_text
	
	game.mama.isVisible = false
	game.baby.isVisible = false
	game.good_words.isVisible = false
	game.bad_words.isVisible = false
	
	game.game_over.isVisible = true
	game.points_textGO.isVisible = true
	game.try_again_btn.isVisible = true
	game.try_again_text.isVisible = true
	
	try_again_btn:addEventListener( "touch", game.reset)
end

function game.reset(event)
	Runtime:addEventListener("enterFrame", game.enterFrame)
	game.game_over.isVisible = false
	game.points_textGO.isVisible = false
	game.try_again_btn.isVisible = false
	game.try_again_text.isVisible = false
	
	game.points = 0
	game.mama.x = display.contentWidth/2
	game.mama.y = display.contentHeight/2
	game.baby.x = 50
	game.baby.y = 50
	game.mama.isVisible = true
	game.baby.isVisible = true
	game.good_words.isVisible = true
	game.bad_words.isVisible = true
end

start_button:addEventListener( "touch", game.start)

-- (C) 2013 Dan Jorquera