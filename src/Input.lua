function getInputPlayer(playerNumber)
   local xInput,yInput=0,0

-- mouse/touch
   if playerNumber==1 then
      local mouseX, mouseY = love.mouse.getPosition()
      if touching then
         mouseX, mouseY = love.touch.getPosition( touchId )
         xInput=200*(mouseX-mouseXOld)
         yInput=200*(mouseY-mouseYOld)
         mouseXOld=mouseX
         mouseYOld=mouseY
      else
         love.mouse.setPosition(centerX,centerY)
         xInput=mouseScaleX*(mouseX-centerX)
         yInput=mouseScaleY*(mouseY-centerY)
      end
   end

-- keyboard
   if playerNumber==1 then
      if love.keyboard.isDown("a") then
         xInput = -500     
      end
      if love.keyboard.isDown("d") then
         xInput = 500
      end
      if love.keyboard.isDown("a") and love.keyboard.isDown("d") then
         xInput = 0
      end
      if love.keyboard.isDown("w") then
         yInput = -500    
      end
      if love.keyboard.isDown("s") then
         yInput = 500
      end
      if love.keyboard.isDown("w") and love.keyboard.isDown("s") then
         yInput = 0
      end
      if love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl") then
         xInput = xInput * 2
         yInput = yInput * 2
      end      
   elseif playerNumber==2 then
      if love.keyboard.isDown("left") then
         xInput = -500     
      end
      if love.keyboard.isDown("right") then
         xInput = 500
      end
      if love.keyboard.isDown("right") and love.keyboard.isDown("left") then
         xInput = 0
      end
      if love.keyboard.isDown("up") then
         yInput = -500    
      end
      if love.keyboard.isDown("down") then
         yInput = 500
      end
      if love.keyboard.isDown("up") and love.keyboard.isDown("down") then
         yInput = 0
      end
      if love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift") then
         xInput = xInput * 2
         yInput = yInput * 2
      end
   end

-- joystick/gamepad
   local joyXInput,joyYInput = 0,0
   local buttonInput = false
   local joystick
   if numJoysticks>=playerNumber then
      joystick = joysticks[playerNumber]
      if joystick:isGamepad() then
         joyXInput = joystick:getGamepadAxis("leftx")
         joyYInput = joystick:getGamepadAxis("lefty")
         joyXInput,joyYInput=joyXInput * 500,joyYInput * 500
         if joystick:isGamepadDown("dpup") then
            joyYInput = -500
         elseif joystick:isGamepadDown("dpdown") then
            joyYInput = 500
         end
         if joystick:isGamepadDown("dpleft") then
            joyXInput = -500
         elseif joystick:isGamepadDown("dpright") then
            joyXInput = 500
         end
         if joystick:isGamepadDown("a", "b", "x", "y") then
            buttonInput = true
         end
         if joystick:isGamepadDown("back") then
            love.keypressed("q")
         end
      else
         local numButtons = joystick:getButtonCount()
         if joystick:getAxisCount()>=1 then
            joyXInput,joyYInput = joystick:getAxes()
            joyXInput,joyYInput=joyXInput * 500,joyYInput * 500
         end
         if joystick:getHatCount()>=1 then
            local hatDirection = joystick:getHat(1)
            if hatDirection == 'u' then
               joyYInput = -500
            elseif hatDirection == 'd' then
               joyYInput = 500
            elseif hatDirection == 'l' then
               joyXInput = -500
            elseif hatDirection == 'r' then
               joyXInput = 500
            elseif hatDirection == 'ld' then
               joyXInput = -500
               joyYInput = 500
            elseif hatDirection == 'lu' then
               joyXInput = -500
               joyYInput = -500
            elseif hatDirection == 'rd' then
               joyXInput = 500
               joyYInput = 500
            elseif hatDirection == 'ru' then
               joyXInput = 500
               joyYInput = -500
            end
            if anyButtonPressed(joystick,numButtons) then
               buttonInput = true;
            end
         end
      end
      if norm(joyXInput,joyYInput) >= 0.15 * 500 then
         if buttonInput then
            joyXInput,joyYInput=2 * joyXInput, 2 * joyYInput
         end
         if math.abs(joyXInput)>math.abs(xInput) then
            xInput=joyXInput
         end
         if math.abs(joyYInput)>math.abs(yInput) then
            yInput=joyYInput
         end
      end
   end
   return xInput,yInput
end       

function anyButtonPressed(joystick,numButtons)
	local returnValue=false
	if numButtons>0 then 
		for i=1,numButtons do
			if joystick:isDown(i) then
				returnValue=true
			end
		end
	end
	return returnValue
end

function love.mousepressed(x, y, button, istouch)
   if gameIsPaused==false and waitingForClick and button == 1 then
      waitingForClick=false
   end
   if istouch then
      touching = true
      touchId = 1
   else
      touching = false
   end
   if displayingTitleScreen then 
      if button == 1 then
         numPlayers=1
         startGame()
      end
   elseif gameLost then
      if button == 1 then
         titleScreen()
      end
   end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
   if gameIsPaused==false and waitingForClick then
      waitingForClick=false
   end
   touching = true
   touchId = id
   mouseXOld=x
   mouseYOld=y

   if displayingTitleScreen then
         numPlayers=1
         startGame()
   elseif gameLost then
         titleScreen()
   end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
   touching = false
   touchId = nil
end

function love.gamepadpressed(joystick, button)
   if (button ~= "dpup"
    and button ~= "dpdown"
    and button ~= "dpleft"
    and button ~= "dpright") then
      if (button == "back") then
         love.keypressed('q')
      elseif (button == "start") then
         love.keypressed('p')
      elseif gameIsPaused==false and waitingForClick then
         waitingForClick=false
      elseif displayingTitleScreen then
         for i=1,#joysticks,1 do
            if joysticks[i]:getID()==joystick:getID() then
               if (i==1 or i==2) then
                  numPlayers=i
                  startGame()
               end
            end
         end
      elseif gameLost then
         if button=="a" then
            continueGame()
         elseif button=="x" then
            titleScreen()
         end
      end
   end
end

function love.keypressed(key, unicode)
   if displayingTitleScreen then 
      if key == 'q' or key == 'escape' then
         love.event.quit()
      elseif key == '2' then
         numPlayers=2
         startGame()
      elseif key == '1' then
         numPlayers=1
         startGame()
      end
   elseif key == 'q' or key == 'escape' then
      titleScreen()
   end
   if key == 'p' then
      if gameIsPaused == false then
         pauseGame()
      else
         unpauseGame()
      end
   elseif key == 'm' then
      bricksLeftToDestroy=0
   elseif key == 'n' then
      if currentLevel>1 then
         currentLevel=currentLevel-1
         initializeLevel(currentLevel)
      end
   elseif key == 'h' then
      if true then
         drawShadows=not drawShadows
      end
   elseif key == 'r' then
      titleScreen()
   elseif key == 'c' and gameLost==true then
      continueGame()
   elseif key == 'b' then
      local newBallIndex=1
      for i,obj in ipairs(objects) do
         if obj.type=="player" or obj.type=="ball" then
            newBallIndex=i+1
         end
      end
      local newBall=createBall(centerX,centerY)
      table.insert(objects,newBallIndex,newBall)
      numBalls=numBalls+1
   elseif key == 'v' then
      local lastBallIndex=0
      for i,obj in ipairs(objects) do
         if obj.type=="ball" then
            lastBallIndex=i
         end
      end
      if lastBallIndex~=0 then 
         table.remove(objects,lastBallIndex)
         numBalls=numBalls-1
      end
   elseif key == 'f' then
     cycleScreenModes()
   elseif key == 'g' then
     toggleScaling()
   elseif key == 'j' then
     cycleMouseSensitivity()
   elseif key == 'o' then
      showFPS= not showFPS
   end
end

function cycleMouseSensitivity()
   mouseScaleX = mouseScaleX + 50
   mouseScaleY = mouseScaleY + 50
   if mouseScaleX > 1000 then
      mouseScaleX = 50
      mouseScaleY = 50
   end
end
