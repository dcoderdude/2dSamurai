--[[
* add blocks of fruit
* add collsion detection
* add level progression
* add menu selection and option screen
]]--

love.window.setFullscreen(true, "desktop")
background = love.graphics.newImage("art-assets/background/airadventurelevel1.png")
sounds = love.audio.newSource("sound-assets/swing-samurai-sword.wav", "stream")
music = love.audio.newSource("sound-assets/DojoBattle.mp3", "stream")
music:setLooping(true)
music:play()

function love.load()
   samuri = {}
	samuri.img = love.graphics.newImage("art-assets/Samurai/5x/idle_1.png")
	samuri_animation_index = {}
	samuri.x = love.graphics.getWidth() / 2
   samuri.y = 250 + love.graphics.getHeight() / 2
	samuri.speed = 800
	samuri_idle()
	samuri_run()
	samuri_attack()
	samuri_jump()
	currentFrame = 1
	isAttacking = false
	samuri.ground = samuri.y
	samuri.y_velocity = 0
	samuri.jump_height = -500
	samuri.gravity = -800
	isJumping = false
	
	fruit_cannon = {}
	fruit_cannon.img = love.graphics.newImage("art-assets/blocks/Fruit_cannon.png")
	fruit_cannon.x = 575 + love.graphics.getWidth() / 2
	fruit_cannon.y = 45 + love.graphics.getHeight() / 2
	
	fruit_cannon2 = {}
	fruit_cannon2.img = love.graphics.newImage("art-assets/blocks/Fruit_cannon2.png")
	fruit_cannon2.x = -575 + love.graphics.getWidth() / 2
	fruit_cannon2.y = 45 + love.graphics.getHeight() / 2
end

function love.update(dt)
	currentIndex = 1
	if love.keyboard.isDown("a") and not isJumping then
		currentIndex = 3
		if samuri.x > 150 then 
			samuri.x = samuri.x - (samuri.speed * dt)
		end
	elseif love.keyboard.isDown("d") and not isJumping then
		currentIndex = 2
		if samuri.x < (love.graphics.getWidth() - samuri.img:getWidth()) then
			samuri.x = samuri.x + (samuri.speed * dt)
		end
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
	
	love.graphics.draw(fruit_cannon.img, fruit_cannon.x, fruit_cannon.y)
	love.graphics.draw(fruit_cannon2.img, fruit_cannon2.x, fruit_cannon2.y, 0, -1, 1)
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