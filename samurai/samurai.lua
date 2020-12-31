samuri = {}
function samuri.load()
  sword_slash_sounds = newSource("sound-assets/swing-samurai-sword.wav")

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
  isAttacking = false
  samuri.ground = samuri.y
  samuri.y_velocity = 0
  samuri.jump_height = -500
  samuri.gravity = -800
  isJumping = false
end

function samuri.update(dt)
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
end

function samuri.draw()
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

function newImage(path)
  if nil == love.filesystem.getInfo(path, 'file') then
    return defaultImage
  else
    return love.graphics.newImage(path)
  end
end

function samuri_idle()
    samuri_animation_idle = {}
    table.insert(samuri_animation_index,5)
    for i=1,samuri_animation_index[1] do
      table.insert(samuri_animation_idle, newImage("samurai/5x/idle_" .. i .. ".png"))
   end
end

function samuri_run()
    samuri_animation_run = {}
    table.insert(samuri_animation_index,7)
    for i=1,samuri_animation_index[2] do
      table.insert(samuri_animation_run, newImage("samurai/5x/run_" .. i .. ".png"))
   end
    table.insert(samuri_animation_index,7)
    for i=1,samuri_animation_index[3] do
      table.insert(samuri_animation_run, newImage("samurai/5x/run_" .. i .. ".png"))
   end
end

function samuri_attack()
    samuri_animation_attack = {}
    table.insert(samuri_animation_index,9)
    for i=1,samuri_animation_index[4] do
      table.insert(samuri_animation_attack, newImage("samurai/5x/attack_" .. i .. ".png"))
   end
end

function samuri_jump()
    samuri_animation_jump = {}
    table.insert(samuri_animation_index,4)
    for i=1,samuri_animation_index[5] do
      table.insert(samuri_animation_jump, newImage("samurai/5x/jump_" .. i .. ".png"))
   end
end
