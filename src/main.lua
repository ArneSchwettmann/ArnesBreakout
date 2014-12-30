--[[
Arne's SpaceTaxi
All source code and graphics, as long as 
they are not part of LÖVE, copyright (c) 2013-2014 Arne Schwettmann
--]]

-- requires LOVE 0.8.0 to run

require("InitializeLevel")
require("CreationFunctions")
require("GameLoop")
require("Auxiliary")
require("Input")
require("Debug")
require("Draw")
require("BordersAndConstraints")
require("ResolveDestroyed")
require("Load")
require("GameLogic")
require("Normals")
require("Colliding")
require("Penetrating")
require("ScreenModes")
require("TileMaps")
 
function love.update(dt)
   --effect:send("time", t)
   
   if gameIsPaused or waitingForClick or gameWon or gameLost or displayingTitleScreen then
     return
   end
   
   if gameWasPaused==true then
      getInputPlayer(1)
      timeSinceUnpausing=timeSinceUnpausing+dt
      if timeSinceUnpausing>=timeToWaitAfterPause then
         gameWasPaused=false
         timeSinceUnpausing=0
      end
      return
   end
   
   inputX={0,0}
   inputY={0,0}
   for i=1,numPlayers do
      inputX[i],inputY[i]=getInputPlayer(i)
   end
    
   for i=1,numTimeStepsPerFrame do
      evolve(dt/numTimeStepsPerFrame)
   end
   
   resolveDestroyedBricks()
   resolveDestroyedBalls()
   
   timeSinceLastFrame=timeSinceLastFrame+dt
   if timeSinceLastFrame>=1/60 then
      updateAnimationFrames()
      timeSinceLastFrame=0
   end
   checkGoal()   
end

function evolve(dt)
   local objects=objects
   
   local playerNumber=1
   for i,obj in ipairs(objects) do
      if obj.type=="player" then
         obj.fAppliedX=inputX[playerNumber]
         obj.fAppliedY=inputY[playerNumber]
         playerNumber=playerNumber+1
      else
         obj.fAppliedX = 0
         obj.fAppliedY = 0
      end
      obj.fImpulseX = 0
      obj.fImpulseY = 0
   end
  
   -- trial step to check if there will be a collision
   for i,obj in ipairs(objects) do
      obj.oldVX=obj.vX
      obj.oldVY=obj.vY
      obj.oldX=obj.x
      obj.oldY=obj.y
      --obj.oldFX=obj.fX
      --obj.oldFY=obj.fY
   end
   takeTimeStep(dt)

   checkBorders()
   resolveCollisions(dt)
   
   for i,obj in ipairs(objects) do
      obj.vX=obj.oldVX
      obj.vY=obj.oldVY
      obj.x=obj.oldX
      obj.y=obj.oldY
      --obj.fX=obj.oldFX
      --obj.fY=obj.oldFY
   end
   
   takeTimeStep(dt)
   checkBorders()
   -- artificially change object's positions to prevent interpenetration
   resolveConstraints()
end

function resolveCollisions(dt)         
   local objects=objects
   
	local numObjects=table.getn(objects)
   for i=1,numObjects-1 do
		for j=i+1,numObjects do 
         local obj1=objects[i]         
         local obj2=objects[j]   
         if obj1.type~="brick" and 
            obj1.canCollideWith[obj2.type] and 
            obj2.canCollideWith[obj1.type]
         then 
            if colliding(obj1,obj2) then
               if obj1.canScatterFrom[obj2.type] and
               obj2.canScatterFrom[obj1.type] then
                  updateScatteringForces(obj1,obj2,dt)
               end
               if obj1.type=="forceField" and obj1.influences[obj2.type] then
                     resolveInfluences(obj1,obj2,dt)
               end
               resolveCollisionEffects(obj1,obj2)
            end
         end
      end
   end
end

function resolveInfluences(obj1,obj2,dt)
   if obj1.subType=="oneOverRSquaredForceField" then
      local r_x=obj2.x-obj1.x
      local r_y=obj2.y-obj1.y
      local absR=math.sqrt(r_x*r_x+r_y*r_y)
      if absR>2 then
         local forceOn2_x=obj1.fieldStrength*r_x/(absR*absR)
         local forceOn2_y=obj1.fieldStrength*r_y/(absR*absR)
         obj2.fAppliedX = obj2.fAppliedX+forceOn2_x-obj1.frictionCoeff*obj2.vX
         obj2.fAppliedY = obj2.fAppliedY+forceOn2_y-obj1.frictionCoeff*obj2.vY
      end
   elseif obj1.subType=="constantForceField" then
      local r_x=obj2.x-obj1.x
      local r_y=obj2.y-obj1.y
      local absR=math.sqrt(r_x*r_x+r_y*r_y)
      if absR>2 then
         local forceOn2_x=obj1.fieldStrength*r_x/(absR)
         local forceOn2_y=obj1.fieldStrength*r_y/(absR)
         obj2.fAppliedX = obj2.fAppliedX+forceOn2_x-obj1.frictionCoeff*obj2.vX
         obj2.fAppliedY = obj2.fAppliedY+forceOn2_y-obj1.frictionCoeff*obj2.vY
      end
   end
end 

function updateScatteringForces(obj1,obj2,dt,restitution)         
   local normal_x,normal_y=findNormal(obj1,obj2)
   
   --- friction force by player on ball due to rubbing with player, perpendicular to surface normal
   if (obj1.type=="player" and obj2.type=="ball") then
      forceOn2_x=obj2.mass*0.5*(obj1.vX-obj2.vX)/dt
      forceOn2_y=obj2.mass*0.5*(obj1.vY-obj2.vY)/dt
      forceOn2_mag=(forceOn2_x*normal_y+forceOn2_y*normal_x)
      forceOn2_x=forceOn2_mag*normal_y
      forceOn2_y=forceOn2_mag*normal_x
      obj2.fImpulseX = obj2.fImpulseX+forceOn2_x
      obj2.fImpulseY = obj2.fImpulseY+forceOn2_y 
      obj1.fImpulseX = obj1.fImpulseX-forceOn2_x
      obj1.fImpulseY = obj1.fImpulseY-forceOn2_y
   end
   
   -- Elastic Collision force, projected on the normal
   -- Eqns from http://farside.ph.utexas.edu/teaching/301/lectures/node76.html inelastic 1D collision
   -- extension for elastic: replace a factor of 2.00 with 1+cR, where restitution is the coefficient of restitution
   -- bettween the two objects, which goes from 1 (elastic) to 0 (inelastic)
   --factor=obj2.mass*2.00*obj1.mass/(obj2.mass+obj1.mass)/dt
   
   local cR=obj1.restitution[obj2.type]
   local factor=obj2.mass*(1.0+cR)*obj1.mass/(obj2.mass+obj1.mass)/dt
   
   local forceOn2_x=factor*(obj1.vX-obj2.vX)
   local forceOn2_y=factor*(obj1.vY-obj2.vY)
   local forceOn2_mag=(forceOn2_x*normal_x+forceOn2_y*normal_y)
   if forceOn2_mag>0 then 
      forceOn2_x=forceOn2_mag*normal_x
      forceOn2_y=forceOn2_mag*normal_y
      if obj2.mass < infiniteMass then
         obj2.fImpulseX = obj2.fImpulseX+forceOn2_x
         obj2.fImpulseY = obj2.fImpulseY+forceOn2_y 
         obj2.vX = obj2.vX+(forceOn2_x*dt)/obj2.mass
         obj2.vY = obj2.vY+(forceOn2_y*dt)/obj2.mass 
      end
      if obj1.mass < infiniteMass then
         obj1.fImpulseX = obj1.fImpulseX-forceOn2_x
         obj1.fImpulseY = obj1.fImpulseY-forceOn2_y
         obj1.vX = obj1.vX-(forceOn2_x*dt)/obj1.mass
         obj1.vY = obj1.vY-(forceOn2_y*dt)/obj1.mass 
      end
   end
end

function resolveCollisionEffects(obj1,obj2)
   if (obj1.type=="ball" and obj2.type=="brick") then
      obj2.hitPoints=obj2.hitPoints-1
      if obj2.subType=="rect1Hit2Brick" or obj2.subType=="circ1Hit3Brick" or obj2.subType=="circ1Hit2Brick" then
         obj2.animType="bumped"
         obj2.animFrameNr=1
         obj2.animIsLoop=false
      end
   elseif (obj1.type=="player" and obj2.type=="brick") then
   elseif (obj1.type=="player" and obj2.type=="ball") then
      local player = obj1
      player.animType="bumped"
      player.animFrameNr=1
      player.animIsLoop=false
   elseif (obj1.type=="hole" and obj2.type=="ball") then
      local hole=obj1
      local ball=obj2
      if hole.width>=ball.width then
         local distance=norm(ball.x-hole.x,ball.y-hole.y)
         --local velocity=norm(ball.vY,ball.vX)
         if distance+0.5*ball.halfwidth<hole.halfwidth and ball.isDestroyed==false then
           ball.isDestroyed=true
           score=score+hole.score
         end
      end
   end
end

function takeTimeStep(dt)
   local objects=objects
   local norm=norm
   local minVelocity=minVelocity
   local maxVelocity=maxVelocity
   
   for i=1,table.getn(objects) do
      local obj=objects[i]
      
      if obj.mass>=infiniteMass then
         obj.fX=0
         obj.fY=0
      else
         obj.fX = obj.fAppliedX + obj.fImpulseX - 
            obj.frictionCoeff * obj.vX + 
            obj.mass * obj.gravityX

         obj.vX = obj.vX + 1/obj.mass * obj.fX * dt

         obj.fX = obj.fX - obj.fImpulseX
         
         obj.fY = obj.fAppliedY + obj.fImpulseY - 
            obj.frictionCoeff * obj.vY + 
            obj.mass * obj.gravityY
            
         obj.vY = obj.vY + 1/obj.mass * obj.fY * dt

         obj.fY = obj.fY - obj.fImpulseY
         
         local velocity=norm(obj.vX,obj.vY)
         if velocity>maxVelocity then
            obj.vY=obj.vY/velocity*maxVelocity
            obj.vX=obj.vX/velocity*maxVelocity
         elseif velocity<minVelocity then
            --obj.vX=0
            --obj.vY=0
         end
      end

      obj.x = obj.x + obj.vX * dt
      obj.y = obj.y + obj.vY * dt 
   end
end

function updateAnimationFrames()
   local objects=objects
   local animations=animations
   
   for i,obj in ipairs(objects) do
      if obj.animType~="none" then
         local numFrames=animations[obj.subType][obj.animType].numFrames
         if numFrames==0 then 
            return 
         else
            obj.animFrameNr=obj.animFrameNr+1
         end
         if obj.animFrameNr>numFrames then
            obj.animFrameNr=1
            if obj.animIsLoop==false then                              
               obj.animType="none"
            end
         end 
         obj.image=animations[obj.subType][obj.animType].images[obj.animFrameNr]
      end            
   end
end