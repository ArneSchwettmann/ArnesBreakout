function startGame()
      currentLevel=1
      score=0
      gameWon=false
      gameLost=false
      numLives=3
      initializeLevel(currentLevel)
      --pauseGame()
      displayingTitleScreen = false
      unpauseGame()
      waitForClick()
end

function titleScreen()
      displayingTitleScreen=true
end

function continueGame()
      score=0
      gameWon=false
      gameLost=false
      numLives=3
      initializeLevel(currentLevel)
      unpauseGame()
end

function checkGoal()
   if bricksLeftToDestroy==0 and gameWon==false then
      currentLevel=currentLevel+1
      if currentLevel>numLevels then
         won()
         currentLevel=numLevels
      else
         initializeLevel(currentLevel)
         waitForClick()
      end
   elseif numBalls==0 then
      if numLives>0 then
         looseLive()
      else
         lost()
      end
   end
end

function lost()
   if gameLost==false then
      gameLost=true
   end
end

function won()
   if gameWon==false then
      gameWon=true
      --createFiftyBalls()
   end
end
     
function pauseGame()
   gameIsPaused = true
   love.mouse.setVisible(true)
   love.mouse.setGrabbed(false)
end

function waitForClick()
   waitingForClick = true
   gameWasPaused = true
end

function unpauseGame()
	gameIsPaused = false
   gameWasPaused = true
	love.mouse.setGrabbed(true)
	love.mouse.setVisible(false)
	love.mouse.setPosition(centerX,centerY)
end

function love.focus(f)
  if not f then
    -- lost focus
    pauseGame()
  else
    -- gained focus
    -- unpauseGame()
  end
end

function looseLive()
   numLives=numLives-1
   local insertionPoint=1
   for i=#objects,1,-1 do 
      if objects[i].type=="player" then
         table.remove(objects,i)
         insertionPoint=i
      end
   end
   for i,obj in ipairs(resurrectingObjects) do
      table.insert(objects,insertionPoint+i-1,deepCopy(obj))
      if obj.type=="ball" then
        numBalls=numBalls+1
      end
   end
   waitForClick()
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
