function love.draw()
   local objects=objects
   local floor=math.floor
   local shadowOffsetX,shadowOffsetY=shadowOffsetX,shadowOffsetY
   local centerX,centerY=centerX,centerY
   local width,height=width,height
   local borderX,borderY=borderX,borderY
   
   -- scale if needed
   if graphicsScaleFactor~=1.0 then
      love.graphics.scale(graphicsScaleFactor,graphicsScaleFactor)
   end

   love.graphics.setColor(0,0,0,1)
   love.graphics.rectangle('fill',0,0,width+2*borderX+1,height+2*borderY+1)
   
   love.graphics.translate(borderX,borderY)
   
 
   if displayingTitleScreen then
      drawTitleScreen()
      love.graphics.translate(-borderX,-borderY)
      if graphicsScaleFactor~=1.0 then
         love.graphics.scale(1.0/graphicsScaleFactor,1.0/graphicsScaleFactor)
      end
      return
   end

   love.graphics.setColor(1,1,1,1)
   love.graphics.draw(backgrounds[currentLevel],0,0)
   -- draw the shadows first
   if drawShadows==true then
   
      love.graphics.setShader(shadowDitherShader)
      for k,obj in ipairs(objects) do
         if obj.image~=nil and obj.hasShadow then
            love.graphics.draw(obj.image, floor(obj.x-obj.halfwidth+shadowOffsetX), floor(obj.y-obj.halfheight)+shadowOffsetY)
         end
      end
     
      love.graphics.setShader()
   end
   
   for k,obj in ipairs(objects) do
      if obj.image~=nil then
         love.graphics.draw(obj.image, floor(obj.x-obj.halfwidth), floor(obj.y-obj.halfheight))
      end
   end
   -- draw the live symbols
   if numLives>0 then
      for i=1,numLives do
         local scale=0.35
         local x=floor(645+(i-1)*(liveImage:getWidth()*scale+5))
         local y=floor(14-0.5*liveImage:getHeight()*scale)
         love.graphics.draw(liveImage,x,y,0,scale,scale,0,0)
      end
   end
   
   -- draw instruction on top left
   love.graphics.setColor(0,0,0,1)
   love.graphics.print("P1 mouse/joy1, P2 arrows+shift/joy2, q quit, p pause", 10, 7)
   love.graphics.print("Score: "..score, 400, 7)
   love.graphics.print("Level: "..currentLevel.." of "..numLevels,500,7)
   love.graphics.print("Lives: ",600,7)
   
   -- depending on state of game, we draw other messages
   love.graphics.setColor(0,0,0,1)
   if gameWon then
      drawWinScreen()
   end
   if gameLost then
      drawGameOverScreen()
   end
   if waitingForClick==true then
      love.graphics.printf("Get ready for level "..currentLevel.."! Click mouse to continue!", 0, centerY-25,width,"center")
   end
   if gameIsPaused==true then
      drawPauseScreen()      
   end

   if showFPS then
      love.graphics.print("FPS: "..tostring(love.timer.getFPS()),10,40)
   end
   
   --[[
   if gameWasPaused==true then
      love.graphics.print("Starting in: "..(timeToWaitAfterPause-timeSinceUnpausing).." s", centerX-50, centerY-5)
   end
   --]]
   
   love.graphics.translate(-borderX,-borderY)
   if graphicsScaleFactor~=1.0 then
      love.graphics.scale(1.0/graphicsScaleFactor,1.0/graphicsScaleFactor)
   end
end

function drawTitleScreen()
      local floor=math.floor

      love.graphics.setColor(1,1,1,1)
      love.graphics.draw(backgrounds[currentLevel],0,0)
      if drawShadows==true then
         love.graphics.setShader(shadowDitherShader)
         love.graphics.draw(screens[1],0+shadowOffsetX,0+shadowOffsetY)
         love.graphics.setShader()
      end
      love.graphics.setColor(1,1,1,1)
      love.graphics.draw(screens[1],0,0)
      if drawShadows==true then
         love.graphics.setShader(shadowDitherShaderNoTexture)
         love.graphics.setColor(0,0,0,1)
         love.graphics.rectangle("fill", floor(centerX-200+shadowOffsetX), floor(centerY-5-75+150+shadowOffsetY), 400, 160 )
         love.graphics.setShader()
      end   
      love.graphics.setColor(1,1,1,1)
      love.graphics.rectangle("fill", floor(centerX-200), floor(centerY-5-75+150), 400, 160 )
      love.graphics.setColor(0,0,0,1)
      verticalSpacing = 25
      love.graphics.printf("Fire(1) or 1 or Click or Touch - Start 1 player game", 0, centerY-10-2.5*verticalSpacing+150,width,"center")
      love.graphics.printf("Fire(2) or 2 - Start 2 player game", 0, centerY-10-1.5*verticalSpacing+150,width,"center")
      love.graphics.printf("s - Mouse Sensitivity: " ..mouseScaleX / 100, 0, centerY-10-0.5*verticalSpacing+150,width,"center")
      love.graphics.printf("f - Toggle fullscreen", 0, centerY-10+0.5*verticalSpacing+150,width,"center")
      love.graphics.printf("d - Toggle scaling (fullscreen only)", 0, centerY-10+1.5*verticalSpacing+150,width,"center")
      love.graphics.printf("q or Select - Quit", 0, centerY-10+2.5*verticalSpacing+150,width,"center")
end

function drawPauseScreen()
   local floor=math.floor
   
   if drawShadows==true then
      love.graphics.setShader(shadowDitherShaderNoTexture)
      love.graphics.setColor(0,0,0,1)
      love.graphics.rectangle("fill", floor(centerX-200+shadowOffsetX), floor(centerY-5-75+shadowOffsetY), 400, 160 )
      love.graphics.setShader()
   end   
   love.graphics.setColor(1,1,1,1)
   love.graphics.rectangle("fill", floor(centerX-200), floor(centerY-5-75), 400, 160 )
   love.graphics.setColor(0,0,0,1)
   love.graphics.printf("Paused! Press p to continue", 0, centerY-5,width,"center")
end

function drawWinScreen()
   local floor=math.floor
   
   love.graphics.setColor(1,1,1,1)
   if drawShadows==true then
      love.graphics.setShader(shadowDitherShader)
      love.graphics.draw(screens[2],0+shadowOffsetX,0+shadowOffsetY)
      love.graphics.setShader()
   end
   love.graphics.draw(screens[2],0,0)
   
   if drawShadows==true then
      love.graphics.setShader(shadowDitherShaderNoTexture)
      love.graphics.setColor(0,0,0,1)
      love.graphics.rectangle("fill", floor(centerX-150+shadowOffsetX), floor(centerY+125-40+shadowOffsetY), 300, 80 )
      love.graphics.setShader()
   end   
   love.graphics.setColor(1,1,1,1)
   love.graphics.rectangle("fill", floor(centerX-150), floor(centerY+125-40), 300, 80 )
   love.graphics.setColor(0,0,0,1)
   love.graphics.printf("Congratulations, you won!", 0, centerY-5+125-15,width,"center")   
   love.graphics.printf("Press r to restart!", 0, centerY-5+125+15,width,"center")   
end

function drawGameOverScreen()
   local floor=math.floor

   love.graphics.setColor(1,1,1,1)
   if drawShadows==true then
      love.graphics.setShader(shadowDitherShader)
      love.graphics.draw(screens[3],0+shadowOffsetX,0+shadowOffsetY)
      love.graphics.setShader()
   end
   love.graphics.draw(screens[3],0,0)
   
   if drawShadows==true then
      love.graphics.setShader(shadowDitherShaderNoTexture)
      love.graphics.setColor(0,0,0,1)
      love.graphics.rectangle("fill", floor(centerX-300+shadowOffsetX), floor(centerY+75-40+shadowOffsetY), 600, 80 )
      love.graphics.setShader()
   end   
   love.graphics.setColor(1,1,1,1)
   love.graphics.rectangle("fill", floor(centerX-300), floor(centerY+75-40), 600, 80 )
   love.graphics.setColor(0,0,0,1)
   love.graphics.printf("Press r to restart or c to continue", 0, centerY-5+75,width,"center")
end