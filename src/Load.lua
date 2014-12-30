function love.load()
   debug=false
   
   
   --all globals listed here
   
   infiniteMass=1e10
   oneOverSqrt2=0.70710678
   
   gfxDir="gfx/"
   
   width = 800
   height = 500
   centerX = 400
   centerY = 250
   
   desktopWidth=0 -- fullscreen size, will be populated later
   desktopHeight=0 -- fullscreen size, will be populated later
   fullscreenWidth=0
   fullscreenHeight=0
   vSyncEnabled=false -- vsync limits the fps, can do more timesteps then
   borderX = 0 -- black border in fullscreen mode
   borderY = 0 -- black border in fullscreen mode
   fullscreen = false -- whether we are in fullscreen mode
   graphicsScaleFactor = 1.0 -- whether we are scaling the gfx in fullscreen
   
   showFPS = false -- display FPS?
     
   shadowOffsetX=8
   shadowOffsetY=8
   numPlayers=1
   
 	gameIsPaused = false
   gameWasPaused = true
   waitingForClick = true
   gameWon = false
   timeSinceUnpausing=0
   timeToWaitAfterPause=0.025
   timeSinceLastFrame=0
	--timeSinceLastDraw=0
   numTimeStepsPerFrame = 1
   
   maxVelocity = 1000
	minVelocity = 1/60
   mouseScaleX = 200
	mouseScaleY = 200
   numLevels=4
   numBalls=0
   currentLevel=0
   objects={}
   resurrectingObjects={}
   animations={}
   backgrounds={}
   screens={} -- title and win screens
  
   objectTypes = {
      "ball",
      "player",
      "brick",
      "hole",
      "forceField"
   }
   objectSubTypes = {
      "mediumBatPlayer",
      "mediumDiscPlayer",
      "mediumBatPlayer2",
      "mediumDiscPlayer2",
      "smallBall",
      "mediumBall",
      "largeBall",
      "rect1Hit1Brick",
      "rect1Hit2Brick",
      "square1Hit1Brick",
      "circ1Hit1Brick",
      "circ1Hit2Brick",
      "circ1Hit3Brick",
      "mediumHole",
      "smallHole",
      "oneOverRSquaredForceField",
      "constantForceField"
   }
   brickSubTypes = {
      "rect1Hit1Brick",
      "rect1Hit2Brick",
      "square1Hit1Brick",
      "circ1Hit1Brick",
      "circ1Hit2Brick",
      "circ1Hit3Brick"
   }
   animationTypes = {
      "none",
      "idle",
      "bumped",
      "destroyed"
   }
   
   -- initialize GFX mode
   love.graphics.setMode( 0, 0, false, false, 0 )
   desktopWidth,desktopHeight,fullscreen,vsyncEnabled,fsaa=love.graphics.getMode()
   --initializeWindowedMode()
   love.graphics.setDefaultImageFilter("linear","linear")
   initializeFullscreenMode()
   unpauseGame()
      
   -- check pixelShader support and define shaders for dithered shadows
   if love.graphics.isSupported("pixeleffect") then
      drawShadows=true
      shadowDitherShader = love.graphics.newPixelEffect([[
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
        {
            vec4 pixelColor=vec4(0.0, 0.0, 0.0, Texel(texture, texture_coords).a);
            if ((mod(floor(screen_coords.x),2) == 0 ) != (mod(floor(screen_coords.y),2) == 1)) 
               discard;
            return pixelColor;
        }
      ]])
      shadowDitherShaderNoTexture = love.graphics.newPixelEffect([[
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
        {
            vec4 pixelColor=vec4(0.0, 0.0, 0.0, 1.0);
            if ((mod(floor(screen_coords.x),2) == 0 ) != (mod(floor(screen_coords.y),2) == 1)) 
               discard;
            return pixelColor;
        }
      ]])
   else
      drawShadows=false
   end
   
   -- load all graphics
   --loadAnimationFrames()
   loadAnimationsFromTileMaps()
   loadBackgroundImages()
   loadScreens()
   
   -- set screenfont and color
	--local f = love.graphics.newFont(8)
   --love.graphics.setFont(f)
   local fontImg=love.graphics.newImage(gfxDir.."fonts/Verdana12.png")
   fontImg:setFilter("linear","linear")
   bigFont = love.graphics.newImageFont(fontImg,
      " !#$%&'()*+,-.0123456789:;<=>?"..
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ"..
      "[/]abcdefghijklmnopqrstuvwxyz")   
   
   love.graphics.setFont(bigFont)
   love.graphics.setBackgroundColor(255,255,255)
   
   --pauseGame()
   currentLevel=1
   titleScreen()
end

function loadBackgroundImages()
   local dir=gfxDir.."backgrounds/"
   local backgrounds=backgrounds
   
   for i=1,numLevels do
      backgrounds[i]=love.graphics.newImage(dir.."BG_"..i..".png")
   end
end

function loadScreens()
   local dir=gfxDir
   screens[1]=love.graphics.newImage(dir.."titleScreen.png")
   screens[2]=love.graphics.newImage(dir.."winScreen.png")
   screens[3]=love.graphics.newImage(dir.."gameOverScreen.png")
end