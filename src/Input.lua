function getInputPlayer(playerNumber)
   local xInput,yInput=0,0
   if playerNumber==1 then
      local mouseX, mouseY = love.mouse.getPosition()
      love.mouse.setPosition(centerX,centerY)
      xInput=mouseScaleX*(mouseX-centerX)
      yInput=mouseScaleY*(mouseY-centerY)
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
		local joystickNum=-1
		local joyXInput,joyYInput = 0,0
		if love.joystick.isOpen(1) then
				joystickNum=1
		elseif love.joystick.isOpen(2) then
		 		joystickNum=2
		elseif love.joystick.isOpen(3) then
		 		joystickNum=3
		elseif love.joystick.isOpen(4) then
		 		joystickNum=4
		elseif love.joystick.isOpen(5) then
		 		joystickNum=5
		end
		if joystickNum~=-1 then
			local numButtons = love.joystick.getNumButtons( joystickNum )
			if love.joystick.getNumAxes(joystickNum)>=1 then
				joyXInput,joyYInput = love.joystick.getAxes(joystickNum)
				joyXInput,joyYInput=joyXInput * 500,joyYInput * 500
			end
			if love.joystick.getNumHats(joystickNum)>=1 then
				local hatDirection = love.joystick.getHat(joystickNum, 1)
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
			end
			if norm(joyXInput,joyYInput) >= 0.15 * 500 then
				if numButtons>0 then
					if anyButtonPressed(joystickNum, numButtons ) then
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
		end
	end
   return xInput,yInput
end       

function anyButtonPressed(joystickNum,numButtons)
	local returnValue=false
	if numButtons>0 then 
		for i=1,numButtons do
			if love.joystick.isDown( joystickNum, i ) then
				returnValue=true
			end
		end
	end
	return returnValue
end
		
		

function love.mousepressed(x, y, button)
   if gameIsPaused==false and waitingForClick and button == 'l' then
      waitingForClick=false
   end
end

function love.keypressed(key, unicode)
   if displayingTitleScreen then 
      if key == 'q' then
         love.event.quit()
      elseif key == '2' then
         numPlayers=2
         startGame()
      elseif key == '1' then
         numPlayers=1
         startGame()
      end
   elseif key == 'q' then
      titleScreen()
   end
   if key == 'p' then
      if gameIsPaused == false then
         pauseGame()
      else
         unpauseGame()
      end
   elseif key == 'w' then
      won()
   elseif key == 'm' then
      bricksLeftToDestroy=0
   elseif key == 'n' then
      if currentLevel>1 then
         currentLevel=currentLevel-1
         initializeLevel(currentLevel)
      end
   elseif key == 's' then
      for k,obj in pairs(objects) do
         if obj.type=="ball" then
            obj.vX=0
            obj.vY=0
         end
      end
   elseif key == 'h' then
      if love.graphics.isSupported("pixeleffect") then
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
   elseif key == 'd' then
     toggleScaling()
   elseif key == 'o' then
      showFPS= not showFPS
   end
end
