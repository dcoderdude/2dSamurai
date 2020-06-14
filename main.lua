--[[
* add dropping blocks of fruit
* add collsion detection to slice fruit
* add scene barrier
* add level progression
* add menu selection and option screen
]]--

love.window.setFullscreen(true, "desktop")
background = love.graphics.newImage("art-assets/background/airadventurelevel4.png")
sounds = love.audio.newSource("sound-assets/sword-02.wav", "stream")
music = love.audio.newSource("sound-assets/DojoBattle.mp3", "stream")
music:setLooping(true)
music:play()

function love.load()
   samuri = {}
	samuri_animation_index = {}
	samuri.x = 500
   samuri.y = 800
	samuri.speed = 1000
	samuri_idle()
	samuri_run()
	samuri_attack()
	samuri_jump()
	currentFrame = 1
	isAttacking = false
	samuri.ground = samuri.y
	samuri.y_velocity = 0
	samuri.jump_height = -300
	samuri.gravity = -500
	isJumping = false
end

function love.update(dt)
	currentIndex = 1
	if love.keyboard.isDown("a") and not isJumping then
		currentIndex = 3
		samuri.x = samuri.x - samuri.speed * dt
	elseif love.keyboard.isDown("d") and not isJumping then
		currentIndex = 2
		samuri.x = samuri.x + samuri.speed * dt
	elseif love.mouse.isDown(1) or isAttacking then
		if isAttacking == false then
			sounds:play()
		end
		isAttacking = true
		currentIndex = 4
	elseif love.keyboard.isDown("space") or isJumping then
		currentIndex = 5
		if samuri.y_velocity == 0 then
			isJumping = true
			samuri.y_velocity = samuri.jump_height
		end
		if samuri.y_velocity ~=0 then
			samuri.y = samuri.y + samuri.y_velocity * dt
			samuri.y_velocity = samuri.y_velocity - samuri.gravity * dt
		end
		if samuri.y > samuri.ground then
			isJumping = false
			samuri.y_velocity = 0
			samuri.y = samuri.ground
		end
	end
	
	currentFrame = currentFrame + samuri_animation_index[currentIndex] * dt
   if currentFrame >= samuri_animation_index[currentIndex] then
      currentFrame = 1
		isAttacking = false
   end
   if love.keyboard.isDown("escape") then love.event.quit() end
end

function love.draw()
	for i = 0, love.graphics.getWidth() / background:getWidth() do
		for j = 0, love.graphics.getHeight() / background:getHeight() do
			love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
		end
	end
	if currentIndex == 1 then love.graphics.draw(samuri_animation_idle[math.floor(currentFrame)], samuri.x, samuri.y) 
	elseif
		currentIndex == 2 then love.graphics.draw(samuri_animation_run[math.floor(currentFrame)], samuri.x, samuri.y)
	elseif
		currentIndex == 3 then love.graphics.draw(samuri_animation_run[math.floor(currentFrame)], samuri.x, samuri.y, 0, -1, 1)
	elseif
		currentIndex == 4 then love.graphics.draw(samuri_animation_attack[math.floor(currentFrame)], samuri.x, samuri.y)
	elseif
		currentIndex == 5 then love.graphics.draw(samuri_animation_jump[math.floor(currentFrame)], samuri.x, samuri.y)
	end
end

function samuri_idle()
	samuri_animation_idle = {}
	table.insert(samuri_animation_index,5)
	for i=1,samuri_animation_index[1] do
      table.insert(samuri_animation_idle, love.graphics.newImage("art-assets/Samurai/5x/idle_" .. i .. ".png"))
   end
end

function samuri_run()
	samuri_animation_run = {}
	table.insert(samuri_animation_index,7)
	for i=1,samuri_animation_index[2] do
      table.insert(samuri_animation_run, love.graphics.newImage("art-assets/Samurai/5x/run_" .. i .. ".png"))
   end
	table.insert(samuri_animation_index,7)
	for i=1,samuri_animation_index[3] do
      table.insert(samuri_animation_run, love.graphics.newImage("art-assets/Samurai/5x/run_" .. i .. ".png"))
   end
end

function samuri_attack()
	samuri_animation_attack = {}
	table.insert(samuri_animation_index,9)
	for i=1,samuri_animation_index[4] do
      table.insert(samuri_animation_attack, love.graphics.newImage("art-assets/Samurai/5x/attack_" .. i .. ".png"))
   end
end

function samuri_jump()
	samuri_animation_jump = {}
	table.insert(samuri_animation_index,4)
	for i=1,samuri_animation_index[5] do
      table.insert(samuri_animation_jump, love.graphics.newImage("art-assets/Samurai/5x/jump_" .. i .. ".png"))
   end
end