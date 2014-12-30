function cycleScreenModes()
   if fullscreen then
      pauseGame()
      initializeWindowedMode()
   else
      pauseGame()
      initializeFullscreenMode()
   end
end


function initializeWindowedMode()
   love.graphics.setMode( width, height, false, false, 0 )
   fullscreenWidth,fullscreenHeight,fullscreen,vSyncEnabled,fsaa=love.graphics.getMode()
   love.graphics.setCaption("Arne's Breakout")
   borderX=0
   borderY=0
   numTimeStepsPerFrame = 1
   screenMode="windowed"
   graphicsScaleFactor=1.0
end

function initializeFullscreenMode()
   love.graphics.setMode( desktopWidth, desktopHeight, true, true, 0 )
   fullscreenWidth,fullscreenHeight,fullscreen,vSyncEnabled,fsaa=love.graphics.getMode()
   if fullscreenWidth>width then
      borderX=math.floor((fullscreenWidth-width)/2)
   end
   if fullscreenHeight>height then
      borderY=math.floor((fullscreenHeight-height)/2)
   end
   if vSyncEnabled then
      numTimeStepsPerFrame = 2
   else
      numTimeStepsPerFrame = 1
   end
   screenMode="fullscreen"
   graphicsScaleFactor=1.0
end

function toggleScaling()
   if graphicsScaleFactor==1.0 then
      graphicsScaleFactor=math.min(fullscreenWidth/width,fullscreenHeight/height)
      if fullscreenWidth/width < fullscreenHeight/height then
         borderX=0
         borderY=math.floor(1/graphicsScaleFactor*(fullscreenHeight-graphicsScaleFactor*height)/2)
      else
         borderY=0
         borderX=math.floor(1/graphicsScaleFactor*(fullscreenWidth-graphicsScaleFactor*width)/2)
      end
   else
      graphicsScaleFactor=1.0
      if fullscreenWidth>width then
         borderX=math.floor((fullscreenWidth-width)/2)
      end
      if fullscreenHeight>height then
         borderY=math.floor((fullscreenHeight-height)/2)
      end
   end
end