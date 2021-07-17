samuri = {}
function samuri.load()
  sword_slash_sounds = newSource("assets/samurai/swing-samurai-sword.wav")
  sleeping_hamster_sounds = newSource("assets/samurai/Idol_Hamster_1.wav")
  swing_hamster_sword_sounds = newSource("assets/samurai/Hamster_Squeak_3.wav")
  samuri_animation_index = {}
  samuri.x = playableWidth / 2
  samuri.y = 250 + playableHeight / 2
  samuri.speed = 800
  samuri_idle()
  samuri_run()
  samuri_attack()
  samuri_jump()
  currentIndex = 1
  currentFrame = 1
  samuri.ground = samuri.y
  samuri.y_velocity = 0
  samuri.jump_height = -500
  samuri.gravity = -800
  isAttacking = false
  isJumping = false
  isIdle = false
  state = ""
end

function samuri.update(dt)
  local newState = "idle"
  currentIndex = 1
  -- keyboard interactions
  if love.keyboard.isDown("a") and not isJumping then
    newState = "isMoving"
    currentIndex = 3
    if samuri.x > 150 then
      samuri.x = samuri.x - (samuri.speed * dt)
    end
  elseif love.keyboard.isDown("d") and not isJumping then
    newState = "isMoving"
    currentIndex = 2
    if samuri.x < (playableWidth - samuri_animation_run[math.floor(currentFrame)]:getWidth()) then
      samuri.x = samuri.x + (samuri.speed * dt)
    end
  elseif love.mouse.isDown(1) or isAttacking then
    newState = "isMoving"
    if isAttacking == false then
      sword_slash_sounds:play()
      swing_hamster_sword_sounds:play()
    end
    isAttacking = true
    currentIndex = 4
  elseif love.keyboard.isDown("space") or isJumping then
    newState = "isMoving"
    currentIndex = 5
    if samuri.y_velocity == 0 then
      newState = "isMoving"
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
  -- exit game event
  if love.keyboard.isDown("escape") then love.event.quit() end

  -- reset samurai animation
  if currentFrame >= samuri_animation_index[currentIndex] then
    currentFrame = 1
      isAttacking = false
  end
  -- idle samurai
  currentFrame = currentFrame + samuri_animation_index[currentIndex] * dt
  -- state change for samurai sounds
  if state ~= newState then
     -- stop playing sound of prior state      
     if state == "idle" then
      sleeping_hamster_sounds:stop()
     end
     -- start playing sounds of new state
     if newState == "idle" then
      sleeping_hamster_sounds:setLooping(true)
      sleeping_hamster_sounds:play()
     end
     state = newState
  end
end

function samuri.draw()
  local states = {'idle', 'runRight', 'runLeft', 'attack', 'jump'}
  local animations = {}
  animations.idle = { frames = samuri_animation_idle, flipped = false }
  animations.runRight = { frames = samuri_animation_run, flipped = false }
  animations.runLeft = { frames = samuri_animation_run, flipped = true }
  animations.attack = { frames = samuri_animation_attack, flipped = false }
  animations.jump = { frames = samuri_animation_jump, flipped = false }
  local state = states[currentIndex]
  local animation = animations[state]
  local frame = animation.frames[math.floor(currentFrame)]
  if(animation.flipped) then
    love.graphics.draw(frame, samuri.x, samuri.y, 0, -1, 1)
  else
    love.graphics.draw(frame, samuri.x, samuri.y)
  end
end

function newImage(path)
  if nil == love.filesystem.getInfo(path, 'file') then
    print('Failed to load image: ' .. path)
    return defaultImage
  else
    return love.graphics.newImage(path)
  end
end

function samuri_idle()
  samuri_animation_idle = {}
  table.insert(samuri_animation_index,2)
  for i=1,samuri_animation_index[1] do
    table.insert(samuri_animation_idle, newImage("assets/samurai/idle_" .. i .. ".png"))
  end
end

function samuri_run()
    samuri_animation_run = {}
    table.insert(samuri_animation_index,5)
    for i=1,samuri_animation_index[2] do
      table.insert(samuri_animation_run, newImage("assets/samurai/run_" .. i .. ".png"))
   end
    table.insert(samuri_animation_index,5)
    for i=1,samuri_animation_index[3] do
      table.insert(samuri_animation_run, newImage("assets/samurai/run_" .. i .. ".png"))
   end
end

function samuri_attack()
    samuri_animation_attack = {}
    table.insert(samuri_animation_index,7)
    for i=1,samuri_animation_index[4] do
      table.insert(samuri_animation_attack, newImage("assets/samurai/attack_" .. i .. ".png"))
   end
end

function samuri_jump()
    samuri_animation_jump = {}
    table.insert(samuri_animation_index,3)
    for i=1,samuri_animation_index[5] do
      table.insert(samuri_animation_jump, newImage("assets/samurai/jump_" .. i .. ".png"))
   end
end
