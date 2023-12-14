-- main game loop
require("samurai.samurai")

function getDefaultImage()
  if nil == defaultImage then
    local canvas = love.graphics.newCanvas(100, 100)
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
  return defaultImage
end

function love.load()
  math.randomseed(os.time())

  -- love.window.setMode(640, 480, {resizable=true})
  love.window.setFullscreen(true, "desktop")
  backgroundDirectory = 'assets/background/'
  backgroundItems = love.filesystem.getDirectoryItems( backgroundDirectory )
  backgrounds = {}
  for _,background in pairs(backgroundItems) do
    local info = love.filesystem.getInfo(backgroundDirectory..background, 'file')
    if nil ~= info then
      table.insert(backgrounds, background)
    end
  end
  if(0 < #backgrounds) then
    local i = math.random(#backgrounds)
    background = love.graphics.newImage(
      backgroundDirectory..backgrounds[i]
    )
  else
    background = getDefaultImage()
  end
  if background == nil then
    print('Failed to setup background')
    love.event.quit()
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
		love.graphics.draw(newImage("assets/fruit/Fruit_explosion.png"), samuri.x - 10, fruit_blocks.y - 10)
		fruit_blast_sounds:play()
	end
	
	love.graphics.draw(newImage("assets/cannon/Fruit_cannon_1.png"), 575 + fruit_cannon.x, 45 + fruit_cannon.y)
	love.graphics.draw(newImage("assets/cannon/Fruit_cannon_1.png"), -575 + fruit_cannon.x, 45 + fruit_cannon.y, 0, -1, 1)
	love.graphics.draw(newImage("assets/fruit/Dragon_Fruit_image.png"), fruit_blocks.x, fruit_blocks.y)
	if math.floor(os.clock()) % 3 == 0 then
		cannon_blast_sound:play()
		love.graphics.draw(newImage("assets/cannon/Fruit_cannon_2.png"), 575 + fruit_cannon.x, 45 + fruit_cannon.y)
		love.graphics.draw(newImage("assets/cannon/Fire_blast.png"), 575 + cannon_blast.x, cannon_blast.y)
	elseif math.floor(os.clock()) % 5 == 0 then
		cannon_blast_sound:play()
		love.graphics.draw(newImage("assets/cannon/Fruit_cannon_2.png"), -575 + fruit_cannon.x, 45 + fruit_cannon.y, 0, -1, 1)
		love.graphics.draw(newImage("assets/cannon/Fire_blast.png"), -575 + cannon_blast.x, cannon_blast.y, 0, -1, 1)
	end
	display_controls()
  visual_shapes()
end

function visual_shapes()
	love.graphics.setColor(1,1,1,.01) -- visual collision shapes
	love.graphics.setLineWidth(3)
	love.graphics.circle("line",fruit_blocks.x, fruit_blocks.y, 50)
	love.graphics.circle("line",samuri.x, samuri.y, 50)
end

function display_controls()
	controls = tostring(string.format("Controls: Move Left(A) Move Right (D) Jump (Spacebar)"))
	color = {red, green, blue}
	colored_text = {color,controls}
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

function newImage(filename)
  local info = love.filesystem.getInfo(filename, 'file')
  if nil == info then
    print('Failed to load image: ' .. filename)
    return love.audio.newSource(getDefaultImage())
  end
  return love.graphics.newImage(filename)
end