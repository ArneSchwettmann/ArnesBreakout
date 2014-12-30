function loadAnimationsFromTileMaps()
   local animations=animations
 
   local tileMaps={
      "player",
      "ballAndHoles",
      "brickSet1",
   }
   -- animations I have so far with numFrames. For "destroyed" anims, the last frame should be duplicated to ensure
   -- it is shown
   -- the table contains type, subtype and numFrames
   local tileMapContents={}
   
   tileMapContents["player"] = {  
      {"mediumBatPlayer","none",1},
      {"mediumBatPlayer","bumped",4},
      {"mediumBatPlayer2","none",1},
      {"mediumBatPlayer2","bumped",4},
      {"mediumDiscPlayer","none",1},
      {"mediumDiscPlayer","bumped",4},
      {"mediumDiscPlayer2","none",1},
      {"mediumDiscPlayer2","bumped",4},
--]]      
   }
   
   tileMapContents["ballAndHoles"] = {
      {"mediumBall","none",1},
      {"mediumBall","destroyed",6},
      {"mediumHole","none",1},
      {"smallHole","none",1}
   }
  
   tileMapContents["brickSet1"] = {
      {"rect1Hit1Brick","none",1},
      {"rect1Hit1Brick","destroyed",6},
      {"rect1Hit2Brick","none",1},
      {"rect1Hit2Brick","destroyed",6},
      {"rect1Hit2Brick","bumped",4},
      {"square1Hit1Brick","none",1},      
      {"square1Hit1Brick","destroyed",6},
      {"circ1Hit1Brick","none",1},
      {"circ1Hit1Brick","destroyed",6},
      {"circ1Hit2Brick","none",1}, 
      {"circ1Hit2Brick","destroyed",6},
      {"circ1Hit2Brick","bumped",4},
      {"circ1Hit3Brick","none",1},      
      {"circ1Hit3Brick","destroyed",6},
      {"circ1Hit3Brick","bumped",4},   
   }      
   for _,tileMapName in pairs(tileMaps) do
      loadFramesFromTileMap(tileMapName,tileMapContents[tileMapName],animations,gfxDir)
   end
end

function loadFramesFromTileMap(tileMapName,animationList,animations,dir)
   local tileMap=love.image.newImageData(gfxDir..tileMapName..".png")
   local xMin,xMax,yMin,yMax=0,0,0,0
   local x,y=0,0
   local rowHeight=0
   local gridR,gridG,gridB,gridA=tileMap:getPixel(x,y)
   local animNr=1
   local frameNr=1
   local v=animationList[animNr][1]
   local v2=animationList[animNr][2]
   animations[v]={}
   animations[v][v2]={}
   local anim=animations[v][v2]
   anim.numFrames=0
   anim.images={}
            
   while animNr<=#animationList do
      y=y+1
      x=x+1
      if x>tileMap:getWidth()-1 then
         y=y+rowHeight+1
         x=1
         xMin=1
         rowHeight=0
      end
      
      r,g,b,a=tileMap:getPixel(x,y)
      --end of an animation is marked by a four pixel vertical gridline
      if r==gridR and g==gridG and b==gridB and a==gridA then
         if animNr==#animationList then
               return
         else   
            animNr=animNr+1
            v=animationList[animNr][1]
            v2=animationList[animNr][2]
            if animations[v]==nil then
               animations[v]={}
            end
            animations[v][v2]={}
            anim=animations[v][v2]
            anim.numFrames=0
            anim.images={}
            frameNr=1
            x=x+3
         end
      end
      xMin=x
      r=nil
      while not (r==gridR and g==gridG and b==gridB and a==gridA) do
         x=x+1
         if x>tileMap:getWidth()-1 then
               y=y+rowHeight+1
               x=1
               xMin=1
               rowHeight=0
         else
            r,g,b,a=tileMap:getPixel(x,y)
         end
      end
      xMax=x-1
      x=xMax
      yMin=y
      r,g,b,a=tileMap:getPixel(x,y)
      a=nil
      while not (r==gridR and g==gridG and b==gridB and a==gridA) do
         y=y+1
         r,g,b,a=tileMap:getPixel(x,y)
      end
      yMax=y-1
      if yMax-yMin+1>rowHeight then
         rowHeight=yMax-yMin+1
      end
      local imageData=love.image.newImageData(xMax-xMin+1,yMax-yMin+1)
      imageData:paste(tileMap,0,0,xMin,yMin,xMax-xMin+1,yMax-yMin+1)
      
      anim.images[frameNr] = love.graphics.newImage(imageData)
      anim.numFrames=anim.numFrames+1

      frameNr=frameNr+1
      x=xMax+1
      y=yMin-1
   end   
end