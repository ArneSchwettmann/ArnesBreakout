-- Object order: hole/forceField,player,ball,brick
function initializeLevel(levelNr)
	if levelNr==1 then
		objects={}
      
      for i=1,1 do
         for j=1,1 do
            local hole
            local field
            hole=createHole(0.1*width,0.9*height,"mediumHole")
            hole.x=hole.x+(i-1)*2*hole.width
            hole.y=hole.y+(j-1)*2*hole.height
            field=createForceField(hole.x,hole.y,"constantForceField",30)
            table.insert(objects,hole)
            table.insert(objects,field)
            hole=createHole(0.9*width,0.9*height,"mediumHole")
            hole.x=hole.x-(i-1)*2*hole.width
            hole.y=hole.y+(j-1)*2*hole.height
            field=createForceField(hole.x,hole.y,"constantForceField",30)
            table.insert(objects,hole)
            table.insert(objects,field)
         end
      end
      
      if numPlayers==1 then
         local player=createPlayer(0.5*width,0.8*height,"mediumBatPlayer")
         table.insert(objects,player)  
      elseif numPlayers==2 then
         local player=createPlayer(0.4*width,0.8*height,"mediumBatPlayer")
         table.insert(objects,player)  
      
         local player2=createPlayer(0.6*width,0.8*height,"mediumBatPlayer2")
         table.insert(objects,player2)  
      end

		local firstBall=createBall(0.5*width,0.6*height)
      table.insert(objects,firstBall)
      
		for i=1,3 do
			for j=1,3 do
				local brick=createBrick(70*i+50,30*j+50,"rect1Hit1Brick")
				table.insert(objects,brick)      
			end
		end

 		for i=1,3 do
			for j=1,3 do
				local brick=createBrick(70*i+470,30*j+50,"rect1Hit1Brick")
				table.insert(objects,brick)      
			end
		end
		bricksLeftToDestroy=18
		numBalls=1
      
   elseif levelNr==2 then
		objects={}
      
      for i=1,8 do
         for j=1,2 do
            local hole
            local field
            if i==8 and j==2 then break else
            hole=createHole(0.1*width,0.9*height,"mediumHole")
            hole.x=hole.x+(j-2)*2*hole.width+(i-1)*4*hole.width
            hole.y=hole.y+(j-2)*3*hole.height
            field=createForceField(hole.x,hole.y,"constantForceField",50)
            table.insert(objects,hole)
            table.insert(objects,field)
            end
         end
      end
      
      if numPlayers==1 then
         local player=createPlayer(0.5*width,0.95*height,"mediumBatPlayer")
         table.insert(objects,player)  
      elseif numPlayers==2 then
         local player=createPlayer(0.4*width,0.95*height,"mediumBatPlayer")
         table.insert(objects,player)  
      
         local player2=createPlayer(0.6*width,0.95*height,"mediumBatPlayer2")
         table.insert(objects,player2)  
      end

 
		local firstBall=createBall(0.4*width,0.8*height-0.25*height)
      firstBall.gravityY=0
      firstBall.gravityX=0
      table.insert(objects,firstBall)   

      local secondBall=createBall(0.6*width,0.8*height-0.25*height)
      secondBall.gravityY=0
      secondBall.gravityX=0
      table.insert(objects,secondBall)   
      
      for i=1,6 do
			for j=1,4 do
            local brick={}
            if j<2 then
               brick=createBrick(75*i+137.5,40*j+50,"rect1Hit2Brick")
               brick.hitPoints=2
            else
               brick=createBrick(75*i+137.5,40*j+50,"rect1Hit1Brick")
               brick.hitPoints=1
            end
            brick.score=100*(4-j)
				table.insert(objects,brick)      
			end
		end
		bricksLeftToDestroy=24
		numBalls=2
   
	elseif levelNr==3 then
      objects={}
      
      for i=1,8 do
         for j=1,1 do
            local hole
            local field
            --if i==8 and j==3 then break else
            hole=createHole(0.1*width,0.9*height,"smallHole")
            hole.x=hole.x+(i-1)*5*hole.width
            hole.y=hole.y
            field=createForceField(hole.x,hole.y,"constantForceField",30)
            field.fieldStrength=-80
            table.insert(objects,hole)
            table.insert(objects,field)
         end
      end
      
      if numPlayers==1 then
         local player=createPlayer(0.5*width,0.8*height,"mediumBatPlayer")
         table.insert(objects,player)  
      elseif numPlayers==2 then
         local player=createPlayer(0.4*width,0.8*height,"mediumBatPlayer")
         table.insert(objects,player)
         
         local player2=createPlayer(0.6*width,0.8*height,"mediumBatPlayer2")
         table.insert(objects,player2)  
      end

      
		local firstBall=createBall(0.5*width,0.8*height-0.15*height)
      table.insert(objects,firstBall)   
      
		for i=1,2 do
			for j=1,2 do
            local brick={}
            if j==1 then 
               brick=createBrick(75*i+0,75*j+30,"circ1Hit3Brick")
               brick.hitPoints=3
               brick.score=500
            else 
               brick=createBrick(75*i+0,75*j+30,"circ1Hit1Brick")
               brick.hitPoints=1
               brick.score=100
            end
            table.insert(objects,brick)      
			end
		end

  		for i=1,2 do
			for j=1,2 do
            local brick={}
            if j==1 then 
               brick=createBrick(75*i+575,75*j+30,"circ1Hit3Brick")
               brick.hitPoints=3
               brick.score=300
            else 
               brick=createBrick(75*i+575,75*j+30,"circ1Hit1Brick")
               brick.hitPoints=1
               brick.score=100
            end
				table.insert(objects,brick)      
			end
		end

  		for i=1,5 do
			for j=1,2 do
            local brick={}
            brick=createBrick(75*i+170,20*j+40,"rect1Hit2Brick")
            brick.hitPoints=2
            brick.score=500
				table.insert(objects,brick)      
			end
		end

  		for i=1,5 do
			for j=1,2 do
            local brick={}
            brick=createBrick(75*i+170,20*j+80,"rect1Hit1Brick")
            brick.hitPoints=1
            brick.score=250
				table.insert(objects,brick)      
			end
		end
      
  		for i=1,5 do
			for j=1,2 do
            local brick={}
            brick=createBrick(75*i+170,75*j+90,"square1Hit1Brick")
            brick.hitPoints=1
            brick.score=100
				table.insert(objects,brick)      
			end
		end
		bricksLeftToDestroy=38
		numBalls=1
   
   elseif levelNr==4 then
		objects={}
		
      for i=1,12,2 do
         local x=centerX+150*math.sin(2*math.pi*i/12)
         local y=centerY+150*math.cos(2*math.pi*i/12)
         local hole
         local field
         hole=createHole(x,y,"smallHole")
         field=createForceField(hole.x,hole.y,"constantForceField",30)
         field.fieldStrength=-50
         table.insert(objects,hole)
         table.insert(objects,field)
      end
		for i=1,10,1 do
		   local x=centerX+225*math.sin(2*math.pi*(i+0.5)/10)
         local y=centerY+225*math.cos(2*math.pi*(i+0.5)/10)
         local hole
         local field
         hole=createHole(x,y,"smallHole")
         field=createForceField(hole.x,hole.y,"constantForceField",30)
         field.fieldStrength=-50
         table.insert(objects,hole)
         table.insert(objects,field)
      end
     
      if numPlayers==1 then
         local player=createPlayer(centerX,centerY,"mediumDiscPlayer")
         table.insert(objects,player)  
      elseif numPlayers==2 then
         local player=createPlayer(centerX,centerY,"mediumDiscPlayer")
         player.x=player.x-1.5*player.halfwidth
         table.insert(objects,player)
         
         local player2=createPlayer(centerX,centerY,"mediumDiscPlayer2")
         player2.x=player2.x+1.5*player2.halfwidth
         table.insert(objects,player2)  
      end

      
      local ball=createBall(centerX,centerY-75)
      ball.gravityY=0
      ball.gravityX=0
      ball.frictionCoeff=0.05
      table.insert(objects,ball)
   
		for i=1,12 do
		   local brick
         local x=centerX+150*math.sin(2*math.pi*i/12)
         local y=centerY+150*math.cos(2*math.pi*i/12)
         brick=createBrick(x,y,"circ1Hit1Brick")
         brick.hitPoints=1
         brick.score=100
         table.insert(objects,brick)      
      end
		for i=1,10 do
		   local brick
         local x=centerX+225*math.sin(2*math.pi*(i+0.5)/10)
         local y=centerY+225*math.cos(2*math.pi*(i+0.5)/10)
         brick=createBrick(x,y,"circ1Hit2Brick")
         brick.hitPoints=2
         brick.score=200
         table.insert(objects,brick)      
      end

		bricksLeftToDestroy=22
		numBalls=1
   end
   
   resurrectingObjects={}
   liveImage={1}
   for i,obj in ipairs(objects) do
      if obj.type=="player" then
         table.insert(resurrectingObjects,deepCopy(obj))
         if liveImage[1]==1 then
            liveImage=obj.image 
         end
      elseif obj.type=="ball" then
         table.insert(resurrectingObjects,deepCopy(obj))
      end
   end
end	
