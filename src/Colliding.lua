function collidingForTwoRectangles(obj1,obj2)   
   local leftrightoverlap = math.min(obj2.y+obj2.halfheight,obj1.y+obj1.halfheight)-math.max(obj2.y-obj2.halfheight,obj1.y-obj1.halfheight)
   local bottomtopoverlap = math.min(obj2.x+obj2.halfwidth,obj1.x+obj1.halfwidth)-math.max(obj2.x-obj2.halfwidth,obj1.x-obj1.halfwidth)
      return leftrightoverlap>0 and bottomtopoverlap>0
end

function colliding(obj1,obj2)
   local collisionHappens=false
   if obj1.shape=="rectangle" and obj2.shape=="rectangle" then
      collisionHappens=collidingForTwoRectangles(obj1,obj2)
   elseif obj1.shape=="circle" and obj2.shape=="circle" then
      collisionHappens = norm(obj2.x-obj1.x,obj2.y-obj1.y) < obj1.halfwidth+obj2.halfwidth
   elseif obj1.shape=="circle" and obj2.shape=="rectangle" or
   obj1.shape=="rectangle" and obj2.shape=="circle" then
      -- quick check: if the bounding rectangles do not even overlap -> no collision, return
      local boundingBoxesCollide=collidingForTwoRectangles(obj1,obj2)
      if boundingBoxesCollide==false then
         collisionHappens=false
      -- if not, we have to do more checks
      else
         local circ,rect
         if obj1.shape=="circle" then
            circ,rect=obj1,obj2
         else
            circ,rect=obj2,obj1
         end
         -- do they really collide just like two rectangles?
         if (circ.x < rect.x+rect.halfwidth and circ.x > rect.x-rect.halfwidth) or 
         (circ.y < rect.y+rect.halfheight and circ.y > rect.y-rect.halfheight) then
            collisionHappens = boundingBoxesCollide
         -- if not, then find the closest corner and check whether the distance is smaller than the radius of the circle
         else
            local x_dist=math.min(math.abs(circ.x-(rect.x-rect.halfwidth)),math.abs(circ.x-(rect.x+rect.halfwidth)))
            local y_dist=math.min(math.abs(circ.y-(rect.y-rect.halfheight)),math.abs(circ.y-(rect.y+rect.halfheight)))
               collisionHappens = norm(x_dist,y_dist)<circ.halfwidth
         end
      end
   end
   return collisionHappens
end
