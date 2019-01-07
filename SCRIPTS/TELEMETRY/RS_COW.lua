-- Author: Stefan Werntges (@RootCowHD)
-- Target: openTX 2.2
-- Global Functions: no
-- Global Variables: no
-- Version: 1.0.0

-- Used Variables:
local isRunning = false -- determs the running state of the script
local started = false -- checks if the machine was armed
local delayed = false -- determs that the delay is done
local gone = false -- used to confirm the Start
local armSwitch = false -- determs if the timer should start

local countdown = 0 -- the countdown Time (1 = 10ms)
local delayTime = 0 -- the delay Time (1 = 10ms)

local startWithIn = 5 -- between delay and this is the actual Time
local startDelay = 4 -- delay before timer starts

local maxTimer = 20 -- maximum timer
local maxDelay = 15 -- maximum delay
local minTimer = 2 -- minimum timer
local minDelay = 0 -- minimum delay

-- Init Function
local function init_func()
end

-- Background Function
local function bg_func()
  if(isRunning) then
    local v_Tmp1 = getValue('Tmp1')
    local v_Arm = v_Tmp1 % 10
    if( v_Arm > 3) then
      armSwitch = true
    else
      armSwitch = false
    end

    -- TimeOut to start delay
    if(armSwitch and not started and not gone and not delayed) then
      started = true

      if(startDelay > 3) then
        playFile("/SCRIPTS/RACESTART/SOUNDS/COUNTI.wav")
        playNumber(startDelay,0,0) -- 0 for no Unit
      end

      math.randomseed(getTime())
      local startTime = getTime()
      delayTime = startTime + (100 * startDelay)
      countdown = delayTime + math.random(200,((startWithIn * 100)+200))
    end

    -- TimeOut to start Within Timer
    if (armSwitch and started and not gone and not delayed) then
      if(getTime() > delayTime) then
        delayed = true
        playFile("/SCRIPTS/RACESTART/SOUNDS/WITHIN.wav")
        playNumber(startWithIn,0,0) -- 26 for longer Text
      end
    end

    -- TimeOut for GO
    if(armSwitch and started and not gone and delayed) then
      if( getTime() > countdown) then
        gone = true
        playFile("/SCRIPTS/RACESTART/SOUNDS/GO.wav")
      end
    end

    -- Cancel Switch
    if(not armSwitch) then
      if(delayed and not gone or started and not gone) then
        playFile("/SCRIPTS/RACESTART/SOUNDS/CANCEL.wav")
      end
      started = false
      gone = false
      delayed = false
    end
  end
end

-- Run Function
local function run_func(event)
  -- Start the System in Telemetry Screen
  if(event == EVT_ENTER_BREAK) then
    isRunning = not isRunning
  end

  if (event == 37 or event == 69) then
    if(startWithIn < maxTimer) then
      startWithIn = startWithIn + 1
    end
  end

  if (event == 38 or event == 70) then
    if(startWithIn > minTimer) then
      startWithIn = startWithIn - 1
      if ((startDelay + minTimer)  > startWithIn) then
        startDelay = startDelay - 1
      end
    end
  end

  if (event == 35 or event == 67) then
    if (startDelay > minDelay) then
      startDelay = startDelay - 1
    end
  end

  if (event == 36 or event == 68) then
    if (startDelay < (startWithIn - minTimer)) then
      startDelay = startDelay + 1
    end
  end

  -- Screen for Taranis xLite
  lcd.clear()
  lcd.drawScreenTitle("Race Start Trainer", 1, 1)
  lcd.drawText(1,11,"Start Time")
  lcd.drawText(1,11,"Timer Delay")
  lcd.drawText(70,11,"Max. Timer")
  lcd.drawLine(1,22,128,22,SOLID,FORCE)
  lcd.drawText(21,28,startDelay,DBLSIZE)
  lcd.drawText(86,28,startWithIn,DBLSIZE)
  lcd.drawLine(1,48,128,48,SOLID,FORCE)
  lcd.drawLine(64,11,64,64,SOLID,FORCE)
  lcd.drawText(1,54,"Enter:",SMLSIZE)

  if(isRunning) then
    lcd.drawText(31,54,"Disable", SMLSIZE)
  else
    lcd.drawText(31,54,"Enable",INVERS + SMLSIZE)
  end

  lcd.drawText(70,54,"nonGlobal",INVERS + SMLSIZE)

  lcd.drawLine(54,25,49,32,SOLID,FORCE)
  lcd.drawLine(54,25,59,32,SOLID,FORCE)
  lcd.drawLine(54,45,49,38,SOLID,FORCE)
  lcd.drawLine(54,45,59,38,SOLID,FORCE)

  lcd.drawLine(108,35,115,30,SOLID,FORCE)
  lcd.drawLine(108,35,115,40,SOLID,FORCE)
  lcd.drawLine(125,35,118,30,SOLID,FORCE)
  lcd.drawLine(125,35,118,40,SOLID,FORCE)
end

-- Export Functions
return { run=run_func, background=bg_func, init=init_func }
