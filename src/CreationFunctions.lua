function createPlayer(x,y,subType)
	local player = {}
   player.type="player"
   player.subType=subType
   player.image = animations[player.subType]["none"].images[1]
   player.width = player.image:getWidth()
   player.height = player.image:getHeight()
   player.halfwidth = 0.5*player.width
   player.halfheight = 0.5*player.height
   player.hasShadow = true
   player.x = x
   player.y = y
   player.vX = 0
   player.vY = 0
   player.fAppliedX = 0
   player.fAppliedY = 0
   player.fImpulseX = 0
   player.fImpulseY = 0
   player.fX = 0
   player.fY = 0
   player.mass = 0.125
   player.frictionCoeff = 1.5
   player.gravityX = 0
   player.gravityY = 0
   player.oldX = x
   player.oldY = y
   player.oldVX = 0
   player.oldVY = 0
   player.oldFX = 0
   player.oldFY = 0
   if subType=="mediumDiscPlayer" or subType=="mediumDiscPlayer2" then
      player.shape="circle"
   else 
      player.shape="rectangle"
   end
	player.canScatterFrom=createSet({"player","ball","brick"})
   player.restitution={["player"]=0.1,["ball"]=0.99,["brick"]=0.1}
   player.canCollideWith=createSet({"player","ball","brick"})
   player.animType="none"
   player.animFrameNr=1
   player.animIsLoop=false
   player.isDestroyed=false
   return player
end
	
function createBall(x,y)
   local ball={}
   ball.type="ball"
   ball.subType="mediumBall"
   ball.image = animations[ball.subType]["none"].images[1]
   ball.width = ball.image:getWidth()
   ball.height = ball.image:getHeight()
   ball.halfwidth = 0.5*ball.width
   ball.halfheight = 0.5*ball.height
   ball.hasShadow = true
   ball.x = x
   ball.y = y
   ball.vX = 0
   ball.vY = 0
   ball.fAppliedX = 0
   ball.fAppliedY = 0
   ball.fImpulseX = 0
   ball.fImpulseY = 0
   ball.fX = 0
   ball.fY = 0
   ball.mass = 0.025
   ball.frictionCoeff = 0
   ball.gravityX = 0
   ball.gravityY = 1000
   ball.oldX = x
   ball.oldY = y
   ball.oldVX = 0
   ball.oldVY = 0   
   ball.oldFX = 0
   ball.oldFY = 0
   ball.shape = "circle"
   ball.canScatterFrom=createSet({"player","ball","brick"})
   ball.restitution={["player"]=0.99,["ball"]=1,["brick"]=1}
   ball.canCollideWith=createSet({"player","ball","brick","forceField","hole"})
   ball.animType="none"
   ball.animFrameNr=1
   ball.animIsLoop=true
   ball.isDestroyed=false
   return ball
end

function createBrick(x,y,subType)
   local brick={}
   brick.type="brick"
   brick.subType=subType
   brick.image = animations[brick.subType]["none"].images[1]
   brick.width = brick.image:getWidth()
   brick.height = brick.image:getHeight()
   brick.halfwidth = 0.5*brick.width
   brick.halfheight = 0.5*brick.height
   brick.hasShadow = true
   brick.x = x
   brick.y = y
   brick.vX = 0
   brick.vY = 0
   brick.fAppliedX = 0
   brick.fAppliedY = 0
   brick.fImpulseX = 0
   brick.fImpulseY = 0
   brick.fX = 0
   brick.fY = 0
   brick.mass = infiniteMass
   brick.frictionCoeff = 0
   brick.gravityX = 0
   brick.gravityY = 0
   brick.oldX = x
   brick.oldY = y
   brick.oldVX = 0
   brick.oldVY = 0   
   brick.oldFX = 0
   brick.oldFY = 0
   brick.isVisible = true   
   if subType=="rect1Hit1Brick" then
      brick.hitPoints=1
      brick.shape="rectangle"
   elseif subType=="rect1Hit2Brick" then
      brick.hitPoints=2
      brick.shape="rectangle"
   elseif subType=="square1Hit1Brick" then
      brick.hitPoints=1
      brick.shape="rectangle"
   elseif subType=="circ1Hit1Brick" then
      brick.hitPoints=1
      brick.shape="circle"
   elseif subType=="circ1Hit2Brick" then
      brick.hitPoints=2
      brick.shape="circle"
   elseif subType=="circ1Hit3Brick" then
      brick.hitPoints=3
      brick.shape="circle"
   else
      brick.hitPoints=1
      brick.shape="rectangle"
   end   
   brick.canScatterFrom=createSet({"player","ball"})
   brick.restitution={["player"]=0.1,["ball"]=1}
   brick.canCollideWith=createSet({"player","ball"})
   brick.animType="none"
   brick.animFrameNr=1
   brick.animIsLoop=false
   brick.isDestroyed=false
   brick.score=100
   return brick
end

function createHole(x, y, subType)
   local hole={}
   hole.type="hole"
   hole.subType=subType
   hole.image = animations[hole.subType]["none"].images[1]
   hole.width = hole.image:getWidth()
   hole.height = hole.image:getHeight()
   hole.halfwidth = 0.5*hole.width
   hole.halfheight = 0.5*hole.height
   hole.hasShadow = false
   hole.x = x
   hole.y = y
   hole.vX = 0
   hole.vY = 0
   hole.fAppliedX = 0
   hole.fAppliedY = 0
   hole.fImpulseX = 0
   hole.fImpulseY = 0
   hole.fX = 0
   hole.fY = 0
   hole.mass = infiniteMass
   hole.frictionCoeff = 0
   hole.gravityX = 0
   hole.gravityY = 0
   hole.oldX = x
   hole.oldY = y
   hole.oldVX = 0
   hole.oldVY = 0   
   hole.oldFX = 0
   hole.oldFY = 0
   hole.isVisible = true
   hole.shape="circle"
   hole.canScatterFrom=createSet({})
   hole.restitution={}
   hole.canCollideWith=createSet({"ball"})
   hole.animType="none"
   hole.animFrameNr=1
   hole.animIsLoop=false
   hole.isDestroyed=false
   hole.score=-1000
   return hole
end

function createForceField(x, y, subType, radius)
   local forceField={}
   forceField.type="forceField"
   forceField.subType=subType
   forceField.image = nil
   forceField.width = 2*radius
   forceField.height = 2*radius
   forceField.halfwidth = 1*radius
   forceField.halfheight = 1*radius
   forceField.hasShadow = false
   forceField.x = x
   forceField.y = y
   forceField.vX = 0
   forceField.vY = 0
   forceField.fAppliedX = 0
   forceField.fAppliedY = 0
   forceField.fImpulseX = 0
   forceField.fImpulseY = 0
   forceField.fX = 0
   forceField.fY = 0
   forceField.mass = infiniteMass
   forceField.frictionCoeff = 0.1
   forceField.gravityX = 0
   forceField.gravityY = 0
   forceField.oldX = x
   forceField.oldY = y
   forceField.oldVX = 0
   forceField.oldVY = 0   
   forceField.oldFX = 0
   forceField.oldFY = 0
   forceField.isVisible = true
   forceField.shape="circle"
   forceField.canScatterFrom=createSet({})
   forceField.restitution=0
   forceField.canCollideWith=createSet({"ball"})
   forceField.influences=createSet({"ball"})
   forceField.animType="none"
   forceField.animFrameNr=1
   forceField.animIsLoop=false
   forceField.fieldStrength=-100
   return forceField
end

--[[
function createFiftyBalls()
   local newBallIndex=1
   for j,obj in ipairs(objects) do
      if obj.type=="player" or obj.type=="ball" then
         newBallIndex=j+1
      end
   end
   for i=-25,25 do
      local newBall=createBall(centerX+(width-25)*i/50,centerY-(height-25)*(1/2-math.abs(i)/50))
      table.insert(objects,newBallIndex,newBall)
      numBalls=numBalls+1
      newBallIndex=newBallIndex+1
   end
end
--]]
