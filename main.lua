--[[
Backlog
- timer background and make amazing looking font
- add initial variation to fruit path
- keep fruit in game bounds(have fruit dissolve when out of bounds)
- fruit leave cannon immidately
- NPC(hamsters) need to fit sliced fruit into shipping container
- launch sliced fruit back to mother ship via large cannon(EXPLOSIONS)
- ultimate move meter released with the Q key
- make fruit module for fruit specific assets and logic.
- make cannon module for cannon specific assets and logic.
- make project modular (Use folders for; sounds, physics, sword, cannon, menus, etc...)
- more fruit (load each fruit in fruit folder)
- more animated variation to fruit (slice in two)
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
- [multiplayer] synced sliced causes syncro slice X-strike(prompted)
- auto-format source code
]]

--[[
other player data
- position
- facing left or right
- y velocity for moving up or down
]]
require("samurai.samurai")

function love.load()
  math.randomseed(os.time())

  local canvas = love.graphics.newCanvas(100, 100)
  do -- create default image, a fallback when images fail to load.
    love.graphics.reset()
    love.graphics.setCanvas(canvas)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(12)
    love.graphics.line(1, 1, canvas:getWidth(), canvas:getHeight())
    love.graphics.line(canvas:getWidth(), 1, 1, canvas:getHeight())
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(8)
    love.graphics.line(1, 1, canvas:getWidth(), canvas:getHeight())
    love.graphics.line(canvas:getWidth(), 1, 1, canvas:getHeight())
    love.graphics.setCanvas()
    defaultImage = love.graphics.newImage(canvas:newImageData())
  end
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
  if(0 < #backgrounds) then
    background = love.graphics.newImage(
      backgroundDirectory..backgrounds[math.random(#backgrounds)]
    )
  else
    background = defaultImage
  end
  cannon_blast_sound = newSource("assets/environment/lazercannon.ogg")
  fruit_blast_sounds = newSource("assets/environment/fruit-blast.wav")
  music = newSource("assets/environment/DojoBattle.mp3")
  music:setLooping(true)
  love.audio.setVolume(.1)
  music:play()

  playableWidth = 1920
  playableHeight = 1080

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

  samuri.load()
end

function love.update(dt)
	samuri.update(dt)
	
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
	samuri.draw()
	
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
  visual_shapes()
end

function visual_shapes()
	love.graphics.setColor(1,1,1,.01) -- visual collision shapes
	love.graphics.setLineWidth(3)
	love.graphics.circle("line",fruit_blocks.x, fruit_blocks.y, 50)
	love.graphics.circle("line",samuri.x, samuri.y, 50)
end

function display_timer()
	timer = tostring(string.format("Slice time!\n \t%.1f", os.clock()))
	color = {red, green, blue}
	colored_text = {color,timer}
	love.graphics.print(colored_text, 100, 190, 0, 2.5, 2.5)
end

function newSource(filename)
  local info = love.filesystem.getInfo(filename, 'file')
  if nil == info then
    if nil == defaultSoundData then
      -- default sample rate is 44100 samples per second
      defaultSoundData = love.sound.newSoundData(44100)     -- 1 second clip
      for i=0,11024 do                                      -- for a quarter second:
        defaultSoundData:setSample(i, math.random(-.1, .1)) --   static at 10%
      end
    end
    print('Failed to load sound source: ' .. filename)
    return love.audio.newSource(defaultSoundData)
  end
  return love.audio.newSource(filename, 'stream')
end
