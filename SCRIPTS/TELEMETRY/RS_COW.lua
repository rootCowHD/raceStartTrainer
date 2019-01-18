-- Author: Stefan Werntges (@RootCowHD)
-- Target: openTX 2.2
-- Version: 1.0.0
-- Uses global Variables

-- used global Variables
-- Functions Variables
rootCowHD_RACESTART_override = false
rootCowHD_RACESTART_startSwitch = false
rootCowHD_RACESTART_runDone = false
rootCowHD_RACESTART_hldDone = false
rootCowHD_RACESTART_setWithin = 5
rootCowHD_RACESTART_setDelay = 4
rootCowHD_RACESTART_isRunning = false -- Determins if the Script actually is running
rootCowHD_RACESTART_selected = 0
rootCowHD_RACESTART_eleLock = false

-- used local variables
-- General Variables
local isReady = false 	-- Toggle when armed or on Switch
                        -- When Override then it is startSwitch
                        -- Else it is calculated by the Arm Bit
                        -- The Arm Bit needs Smart Port or F.Port Telemetry
local isStarted = false -- Toggle when Ready but not started
                        -- Activates the Time calculation
                        -- Voice Out "Countdown in"
local isDelayed = false -- Toggle when delay Coundown is over
                        -- Voice Out "Start within"
local isGone = false    -- Toggle when Timer is over
                        -- voice Out "Go"
                        -- When isReady is toggled to false
                        -- Voice Out "Cancelled" and reset
                        -- isStarted and isDelayed unless isGone is true
-- Telemetry Variables
local maxTimer = 20
local minTimer = 2
local maxDelay = 15
local minDelay = 0

-- random timer
local countdown = 0
local delayTime = 0

-- transmitter infos
local ver, radio, maj, minor, rev, view

-- check if the system is Ready
-- switch or Arm Bit
local function checkReady()
  if (rootCowHD_RACESTART_override) then isReady = rootCowHD_RACESTART_startSwitch
  else
    local v_Arm = getValue('Tmp1') % 10
    if(v_Arm > 3) then isReady = true
    else isReady = false end
  end
  return isReady
end

-- Set randomValue and isStarted
local function calcRandom()
  if(isReady and not isStarted and not isDelayed and not isGone) then
    isStarted = true
    local startTime = getTime()
    math.randomseed(startTime)

    if(rootCowHD_RACESTART_setDelay > 3) then
      playFile("/SCRIPTS/RACESTART/SOUNDS/COUNTI.wav")
      playNumber(rootCowHD_RACESTART_setDelay,0,0) -- 0 for no Unit
    end

    delayTime = startTime + (100 * rootCowHD_RACESTART_setDelay)
    countdown = delayTime + math.random(200,((rootCowHD_RACESTART_setWithin * 100) + 200))
    return false
  end
  return true
end

-- check for Delay countdown
local function checkDelay()
  if(isReady and isStarted and not isDelayed and not isGone) then
    if(getTime() > delayTime) then
      isDelayed = true
      playFile("/SCRIPTS/RACESTART/SOUNDS/WITHIN.wav")
      playNumber(rootCowHD_RACESTART_setWithin,0,0) -- 26 for longer Text
    end
    return false
  end
  return true
end

-- check for start Countdown
local function checkCountdown()
  if(isReady and isStarted and isDelayed and not isGone) then
    if(getTime() > countdown) then
      isGone = true
      playFile("/SCRIPTS/RACESTART/SOUNDS/GO.wav")
    end
    return false
  end
  return true
end

-- check if isReady
local function checkCancelled()
  if( not isReady ) then
    if (isStarted and not isGone or isDelayed and not isGone) then
      playFile("/SCRIPTS/RACESTART/SOUNDS/CANCEL.wav")
    end
    isStarted = false
    isDelayed = false
    isGone = false
    return true
  end
  return false
end

local function subCountdown()
  if(rootCowHD_RACESTART_setWithin > minTimer) then
    rootCowHD_RACESTART_setWithin = rootCowHD_RACESTART_setWithin - 1
  end
end

local function addCountdown()
  if(rootCowHD_RACESTART_setWithin < maxTimer) then
    rootCowHD_RACESTART_setWithin = rootCowHD_RACESTART_setWithin + 1
  end
end

local function subDelay()
  if (rootCowHD_RACESTART_setDelay > minDelay) then
    rootCowHD_RACESTART_setDelay = rootCowHD_RACESTART_setDelay - 1
  end
end

local function addDelay()
  if (rootCowHD_RACESTART_setDelay < maxDelay) then
    rootCowHD_RACESTART_setDelay = rootCowHD_RACESTART_setDelay + 1
  end
end

local function toggleRunning()
  rootCowHD_RACESTART_isRunning = not rootCowHD_RACESTART_isRunning
  return rootCowHD_RACESTART_isRunning
end

local function selectTransmitter(rad)
  local err
  view, err = loadScript("/SCRIPTS/RACESTART/TRANSMITTERS/"..rad..".lua")
  if(view ~= nil) then
  else
    print(err)
  end
end

local function init_func()
  ver, radio, maj, minor, rev = getVersion()
  if(radio == "xlite" or radio == "xlite_simu") then
    RootCowHD_Control_SCHEME = "xLite"
    selectTransmitter("xLite")
  end

  if(radio == "x7" or radio == "x7_simu") then
    RootCowHD_Control_SCHEME = "X7"
    selectTransmitter("x7")
  end

  if( radio == "x9d" or radio == "x9d_simu" or
      radio == "x9d+" or radio == "x9d+_simu" or
      radio == "x9e" or radio == "x9e_simu") then
    RootCowHD_Control_SCHEME = "X9"
    selectTransmitter("x9")
  end
end

local function bg_func()
  if(rootCowHD_RACESTART_isRunning) then
    checkReady()
    calcRandom()
    checkDelay()
    checkCountdown()
    checkCancelled()
  end
end

local function run_func(event)
  if(RootCowHD_Control_SCHEME == "xLite") then
    if(event == EVT_ENTER_BREAK) then
      toggleRunning()
    end
    if (event == 37 or event == 69) then
      addCountdown()
    end
    if (event == 38 or event == 70) then
      subCountdown()
    end
    if (event == 35 or event == 67) then
      subDelay()
    end
    if (event == 36 or event == 68) then
      addDelay()
    end
  end

  if(RootCowHD_Control_SCHEME == "X7") then
    if(event == EVT_ROT_LEFT) then
      if(rootCowHD_RACESTART_eleLock == false) then
        if(rootCowHD_RACESTART_selected == 0) then
          rootCowHD_RACESTART_selected = 1
        else
          rootCowHD_RACESTART_selected = rootCowHD_RACESTART_selected -1
        end
      else
        if(rootCowHD_RACESTART_selected == 0) then subDelay() end
        if(rootCowHD_RACESTART_selected == 1) then subCountdown() end
      end
    end

    if(event == EVT_ROT_RIGHT) then
      if(rootCowHD_RACESTART_eleLock == false) then
        if(rootCowHD_RACESTART_selected == 1) then
          rootCowHD_RACESTART_selected = 0
        else
          rootCowHD_RACESTART_selected = rootCowHD_RACESTART_selected +1
        end
      else
        if(rootCowHD_RACESTART_selected == 0) then addDelay() end
        if(rootCowHD_RACESTART_selected == 1) then addCountdown() end
      end
    end

    if(event == EVT_ENTER_BREAK) then
      rootCowHD_RACESTART_eleLock = not rootCowHD_RACESTART_eleLock
    end

    if(event == EVT_MENU_BREAK) then toggleRunning() end
  end

  if(RootCowHD_Control_SCHEME == "X9") then
    if(event == EVT_MINUS_BREAK or event == EVT_MINUS_REPT) then
      if(rootCowHD_RACESTART_eleLock == false) then
        if(rootCowHD_RACESTART_selected == 0) then
          rootCowHD_RACESTART_selected = 1
        else
          rootCowHD_RACESTART_selected = rootCowHD_RACESTART_selected -1
        end
      else
        if(rootCowHD_RACESTART_selected == 0) then subDelay() end
        if(rootCowHD_RACESTART_selected == 1) then subCountdown() end
      end
    end

    if(event == EVT_PLUS_BREAK or event == EVT_PLUS_REPT) then
      if(rootCowHD_RACESTART_eleLock == false) then
        if(rootCowHD_RACESTART_selected == 1) then
          rootCowHD_RACESTART_selected = 0
        else
          rootCowHD_RACESTART_selected = rootCowHD_RACESTART_selected +1
        end
      else
        if(rootCowHD_RACESTART_selected == 0) then addDelay() end
        if(rootCowHD_RACESTART_selected == 1) then addCountdown() end
      end
    end

    if(event == EVT_ENTER_BREAK) then
      rootCowHD_RACESTART_eleLock = not rootCowHD_RACESTART_eleLock
    end

    if(event == EVT_MENU_BREAK) then toggleRunning() end
  end

  view()
end

return { run=run_func, background=bg_func, init=init_func }
