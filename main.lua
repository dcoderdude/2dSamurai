love.window.setFullscreen(true, "desktop")
background = love.graphics.newImage("art-assets/background_land/PNG/layer5.png")

function love.load()
   samuri = {}
	samuri_anima_index = {}
	samuri.x = 500
   samuri.y = 650
	samuri.speed = 500
	samuri_idle()
	samuri_run()
	currentFrame = 1
end

function love.update(dt)
	-- samuri movement
	currentIndex = 1

	if love.keyboard.isDown("a") then
		currentIndex = 3
		samuri.x = samuri.x - samuri.speed * dt
	elseif love.keyboard.isDown("d") then
		currentIndex = 2
		samuri.x = samuri.x + samuri.speed * dt
	end
	if love.mouse.isDown(1) then  samuri.image = love.graphics.newImage("art-assets/Samurai/5x/attack_" .. math.random(0,7) .. ".png") end
   if love.keyboard.isDown("escape") then love.event.quit() end
	
	currentFrame = currentFrame + samuri_anima_index[currentIndex] * dt
   if currentFrame >= samuri_anima_index[currentIndex] then
      currentFrame = 1
   end
end

function love.draw()
	for i = 0, love.graphics.getWidth() / background:getWidth() do
		for j = 0, love.graphics.getHeight() / background:getHeight() do
			love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
		end
	end
	if currentIndex == 1 then love.graphics.draw(samuri_anima_idle[math.floor(currentFrame)], samuri.x, samuri.y) 
	elseif
		currentIndex == 2 then love.graphics.draw(samuri_anima_run[math.floor(currentFrame)], samuri.x, samuri.y)
	elseif
		currentIndex == 3 then love.graphics.draw(samuri_anima_run[math.floor(currentFrame)], samuri.x, samuri.y, 0, -1, 1)
	end
end

function samuri_idle()
	samuri_anima_idle = {}
	table.insert(samuri_anima_index,3)
	for i=0,samuri_anima_index[1] do
      table.insert(samuri_anima_idle, love.graphics.newImage("art-assets/Samurai/5x/idle_" .. i .. ".png"))
   end
end

function samuri_run()
	samuri_anima_run = {}
	table.insert(samuri_anima_index,3)
	for i=0,samuri_anima_index[2] do
      table.insert(samuri_anima_run, love.graphics.newImage("art-assets/Samurai/5x/run_" .. i .. ".png"))
   end
	table.insert(samuri_anima_index,3)
	for i=0,samuri_anima_index[3] do
      table.insert(samuri_anima_run, love.graphics.newImage("art-assets/Samurai/5x/run_" .. i .. ".png"))
   end
end