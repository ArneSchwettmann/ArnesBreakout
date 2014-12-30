-- On the borders, the ball bounces elastically, and the player stops
function checkBorders()
   local objects=objects
   for k,obj in pairs(objects) do
      if obj.type=="player" then
         local player=obj
         if player.x<player.halfwidth then
            player.x = player.halfwidth
            player.vX = 0
         end
         if player.x>width-player.halfwidth then
            player.x=width-player.halfwidth
            player.vX = 0
         end
         if player.y<player.halfheight then
            player.y = 0+player.halfheight
            player.vY = 0
         end
         if player.y>height-player.halfheight then
            player.y=height-player.halfheight
            player.vY = 0
         end
      elseif obj.type=="ball" then
         local ball=obj
         if ball.x<ball.halfwidth then
            ball.x = ball.halfwidth
            ball.vX = -1*ball.vX
         end
         if ball.x>width-ball.halfwidth then
            ball.x = width-ball.halfwidth
            ball.vX=-1*ball.vX
         end
         if ball.y<ball.halfwidth then
            ball.y = ball.halfwidth
            ball.vY = -1*ball.vY
         end
         if ball.y>height-ball.halfheight then
            ball.y = height-ball.halfheight
            ball.vY=-1*ball.vY
         end
      end
   end
end

-- This function ensures that anytime an object is inside of one another, it's position 
-- is reverted to the former one, to ensure this interprenetation never happens
-- this leads to better stacking behavior, but also creates nonlinearities (objects get stuck)
function resolveConstraints()
   local objects=objects
	local numObjects=table.getn(objects)
   for i=1,numObjects-1 do
		for j=i+1,numObjects do 
         local obj1=objects[i]         
         local obj2=objects[j]   
         if obj1.type~="brick" then
            if obj1.canScatterFrom[obj2.type] and
               obj2.canScatterFrom[obj1.type] then
               -- displace objects along the normal away from each other towards their former position
               if colliding(obj1,obj2) then
                  local orig_obj1_x,orig_obj1_y=obj1.x,obj1.y
						local orig_obj2_x,orig_obj2_y=obj2.x,obj2.y
						local normal_x,normal_y=findNormal(obj1,obj2)
                  local displacement_mag=(obj1.oldX-obj1.x)*normal_x+(obj1.oldY-obj1.y)*normal_y
                  obj1.x=obj1.x+displacement_mag*normal_x
                  obj1.y=obj1.y+displacement_mag*normal_y
                  displacement_mag=(obj2.oldX-obj2.x)*normal_x+(obj2.oldY-obj2.y)*normal_y
                  obj2.x=obj2.x+displacement_mag*normal_x
                  obj2.y=obj2.y+displacement_mag*normal_y
						-- if this didn't work, then displace objects by the full penetration distance
						---[[
                  if colliding(obj1,obj2) then
							obj1.x,obj1.y=orig_obj1_x,orig_obj1_y
							obj2.x,obj2.y=orig_obj2_x,orig_obj2_y
							local penetrationDistance=findPenetrationDistance(obj1,obj2,normal_x,normal_y)
							local massFactor=obj1.mass/(obj1.mass+obj2.mass)
							obj1.x=obj1.x-(1-massFactor)*penetrationDistance*normal_x
							obj1.y=obj1.y-(1-massFactor)*penetrationDistance*normal_y
							obj2.x=obj2.x+massFactor*penetrationDistance*normal_x
							obj2.y=obj2.y+massFactor*penetrationDistance*normal_y
						end
                  --]]
					end
            end
         end
      end
   end
end
