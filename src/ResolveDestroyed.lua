function resolveDestroyedBalls()
   local objects=objects
   
   --for i,obj in ipairs(objects) do
   for i=#objects,1,-1 do
      local obj=objects[i]
      if obj.type=="ball" and obj.isDestroyed==true then
         if obj.animType~="destroyed" then
            obj.animType="destroyed"
            obj.animFrameNr=1
            obj.animIsLoop=false
            obj.vX=0
            obj.vY=0
            obj.canCollideWith=createSet({})
            obj.canScatterFrom=createSet({})
         elseif obj.animFrameNr==animations[obj.subType][obj.animType].numFrames then
            table.remove(objects,i)
            numBalls=numBalls-1
         end
      end
   end
end
            
function resolveDestroyedBricks()
   --for i,obj in ipairs(objects) do
   local objects=objects
   
   for i=#objects,1,-1 do
      local obj=objects[i]
      if obj.type=="brick" and obj.hitPoints<=0 then
         if obj.isDestroyed==false then
            obj.animType="destroyed"
            obj.animFrameNr=1
            obj.animIsLoop=false
            obj.isDestroyed=true
            obj.canCollideWith=createSet({})
            obj.canScatterFrom=createSet({})
         elseif obj.isDestroyed and obj.animFrameNr==animations[obj.subType][obj.animType].numFrames then
            score=score+obj.score
            table.remove(objects,i)
            bricksLeftToDestroy=bricksLeftToDestroy-1
         end
      end
   end
end
