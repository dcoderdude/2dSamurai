love.window.setFullscreen(true, "desktop")
background = love.graphics.newImage("art-assets/background_land/PNG/layer5.png")

function love.load()
   samuri = {}
	samuri_animation_index = {}
	samuri.x = 500
   samuri.y = 650
	samuri.speed = 1000
	samuri_idle()
	samuri_run()
	samuri_attack()
	samurai_slash = love.audio.newSource("sound-assets/samurai-slash.mp3", "stream")
	currentFrame = 1
end

function love.update(dt)
   if love.keyboard.isDown("escape") then love.event.quit() end
	currentIndex = 1

	if love.keyboard.isDown("a") then
		currentIndex = 3
		samuri.x = samuri.x - samuri.speed * dt
	elseif love.keyboard.isDown("d") then
		currentIndex = 2
		samuri.x = samuri.x + samuri.speed * dt
	elseif love.mouse.isDown(1) then
		currentIndex = 4
		samurai_slash:play()
	end
	
	currentFrame = currentFrame + samuri_animation_index[currentIndex] * dt
   if currentFrame >= samuri_animation_index[currentIndex] then
      currentFrame = 1
   end
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
	end
end

function samuri_idle()
	samuri_animation_idle = {}
	table.insert(samuri_animation_index,3)
	for i=0,samuri_animation_index[1] do
      table.insert(samuri_animation_idle, love.graphics.newImage("art-assets/Samurai/5x/idle_" .. i .. ".png"))
   end
end

function samuri_run()
	samuri_animation_run = {}
	table.insert(samuri_animation_index,3)
	for i=0,samuri_animation_index[2] do
      table.insert(samuri_animation_run, love.graphics.newImage("art-assets/Samurai/5x/run_" .. i .. ".png"))
   end
	table.insert(samuri_animation_index,3)
	for i=0,samuri_animation_index[3] do
      table.insert(samuri_animation_run, love.graphics.newImage("art-assets/Samurai/5x/run_" .. i .. ".png"))
   end
end

function samuri_attack()
	samuri_animation_attack = {}
	table.insert(samuri_animation_index,7)
	for i=0,samuri_animation_index[4] do
      table.insert(samuri_animation_attack, love.graphics.newImage("art-assets/Samurai/5x/attack_" .. i .. ".png"))
   end
end