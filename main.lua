--[[
Backlog
- make project modular (Use folders. Perhaps one for fruit, the samurai, etc.)
- more fruit
- align asset flipping (center images on x, y)
- horizontal movement while jumping
- support swinging sword towards mouse cursor (starbound)
- improve sword and fruit collision, only on swing
- platforms
- suface interaction (slide on slick surface, slide downhill)
- menu selection and option screen
- volume control (from options)
- end of round state
- new area progression
- score board (fruit sliced count in limited time, or how quickly did you slice enough fruit)
- [multiplayer] connect, other player simply visible per update.
- [multiplayer] dead reckoning (have other player continue to move while waiting for next update)
- [multiplayer] co-op
- [multiplayer] vs
- [multiplayer] collide with other player
- auto-format source code
]]

--[[
other player data
- position
- facing left or right
- y velocity for moving up or down
]]

function love.load()
  -- love.window.setMode(640, 480, {resizable=true})
  love.window.setFullscreen(true, "desktop")
  backgroundDirectory = 'art-assets/background/'
  backgroundItems = love.filesystem.getDirectoryItems( backgroundDirectory )
  backgrounds = {}
  for _,background in pairs(backgroundItems) do
    local info = love.filesystem.getInfo(backgroundDirectory..background, 'file')
    if nil ~= info then
      table.insert(backgrounds, background)
    end
  end
  if(#backgrounds < 1) then
    error('No background files found in '..backgroundDirectory)
  end
  local osTime = os.time()
  math.randomseed(osTime)
  background = love.graphics.newImage(
    backgroundDirectory..backgrounds[math.random(#backgrounds)]
  )
  cannon_blast_sound = love.audio.newSource("sound-assets/8-bit-cannon.wav","stream")
  sword_slash_sounds = love.audio.newSource("sound-assets/swing-samurai-sword.wav", "stream")
  fruit_blast_sounds = love.audio.newSource("sound-assets/fruit-blast.wav", "stream")
  music = love.audio.newSource("sound-assets/DojoBattle.mp3", "stream")
  music:setLooping(true)
  music:play()

  playableWidth = 1920
  playableHeight = 1080
	samuri = {}
	samuri_animation_index = {}
	samuri.x = playableWidth / 2
	samuri.y = 250 + playableHeight / 2
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
	fruit_cannon.x = playableWidth / 2
	fruit_cannon.y = playableHeight / 2

	cannon_blast = {}
	cannon_blast.x = playableWidth / 2
	cannon_blast.y = playableHeight / 2

	fruit_blocks = {}
	fruit_blocks.x = playableWidth / 2
	fruit_blocks.y = 250 + playableHeight / 2
	fruit_blocks.ground = fruit_blocks.y
	fruit_blocks.x_velocity = 0
	fruit_blocks.y_velocity = 0
	fruit_blocks_height = -1500
	fruit_blocks.gravity = -1800
	fruit_blocks.angle = 0
	fruit_blocks.speed = 300

	red = 0/255
	green = 0/255
	blue = 0/255
  love.audio.setVolume(.1)
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
		if samuri.x < (playableWidth - samuri_animation_run[math.floor(currentFrame)]:getWidth()) then
			samuri.x = samuri.x + (samuri.speed * dt)
		end
	elseif love.mouse.isDown(1) or isAttacking then
		if isAttacking == false then
			sword_slash_sounds:play()
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
   if love.keyboard.isDown("escape") then love.event.quit() end
	currentFrame = currentFrame + samuri_animation_index[currentIndex] * dt
   if currentFrame >= samuri_animation_index[currentIndex] then
      currentFrame = 1
		isAttacking = false
   end
	
	fruit_blocks.y_velocity = fruit_blocks.y_velocity - fruit_blocks.gravity * dt
	if fruit_blocks.y > fruit_blocks.ground then
		fruit_blocks.y_velocity = -fruit_blocks.y_velocity
		fruit_blocks.y = fruit_blocks.ground
	end
	
	if math.floor(os.clock()) % 3 == 0 then
		fruit_blocks.x, fruit_blocks.y = 575 + cannon_blast.x, cannon_blast.y
		fruit_blocks.x_velocity, fruit_blocks.y_velocity = -1000, 0
	elseif math.floor(os.clock()) % 5 == 0 then
		fruit_blocks.x, fruit_blocks.y = -575 + cannon_blast.x, cannon_blast.y
		fruit_blocks.x_velocity, fruit_blocks.y_velocity = 1000, 0
	end
	fruit_blocks.x = fruit_blocks.x + fruit_blocks.x_velocity * dt
	fruit_blocks.y = fruit_blocks.y + fruit_blocks.y_velocity * dt
end

function love.draw()
  love.graphics.reset()
  local graphicsWidth, graphicsHeight = love.graphics.getDimensions()
  love.graphics.translate(graphicsWidth / 2, graphicsHeight / 2)
	love.graphics.scale(
    math.min(graphicsWidth / playableWidth, graphicsHeight / playableHeight)
  )
  love.graphics.translate(-playableWidth / 2, -playableHeight / 2)
	love.graphics.draw(
    background,
    0,
    0,
    0,
    playableWidth / background:getWidth(),
    playableHeight / background:getHeight()
  )
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
	
	if (math.sqrt(math.pow(samuri.x - fruit_blocks.x, 2) + math.pow(samuri.y - fruit_blocks.y, 2)) < 100) then
		love.graphics.draw(love.graphics.newImage("art-assets/blocks/Fruit_explosion.png"), samuri.x - 10, fruit_blocks.y - 10)
		fruit_blast_sounds:play()
	end
	
	love.graphics.draw(love.graphics.newImage("art-assets/blocks/Fruit_cannon_1.png"), 575 + fruit_cannon.x, 45 + fruit_cannon.y)
	love.graphics.draw(love.graphics.newImage("art-assets/blocks/Fruit_cannon_1.png"), -575 + fruit_cannon.x, 45 + fruit_cannon.y, 0, -1, 1)
	love.graphics.draw(love.graphics.newImage("art-assets/blocks/Dragon_Fruit_image.png"), fruit_blocks.x, fruit_blocks.y)
	if math.floor(os.clock()) % 3 == 0 then
		cannon_blast_sound:play()
		love.graphics.draw(love.graphics.newImage("art-assets/blocks/Fruit_cannon_2.png"), 575 + fruit_cannon.x, 45 + fruit_cannon.y)
		love.graphics.draw(love.graphics.newImage("art-assets/blocks/Fire_blast.png"), 575 + cannon_blast.x, cannon_blast.y)
	elseif math.floor(os.clock()) % 5 == 0 then
		cannon_blast_sound:play()
		love.graphics.draw(love.graphics.newImage("art-assets/blocks/Fruit_cannon_2.png"), -575 + fruit_cannon.x, 45 + fruit_cannon.y, 0, -1, 1)
		love.graphics.draw(love.graphics.newImage("art-assets/blocks/Fire_blast.png"), -575 + cannon_blast.x, cannon_blast.y, 0, -1, 1)
	end
	display_timer()
	love.graphics.setColor(1,1,1,.01) -- visual collision shapes
	love.graphics.setLineWidth(3)
	love.graphics.circle("line",fruit_blocks.x, fruit_blocks.y, 50)
	love.graphics.circle("line",samuri.x, samuri.y, 50)
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

function display_timer()
	timer = tostring(string.format("Slice time!\n \t%.1f", os.clock()))
	color = {red, green, blue}
	colored_text = {color,timer}
	love.graphics.print(colored_text, 100, 190, 0, 2.5, 2.5)
end
