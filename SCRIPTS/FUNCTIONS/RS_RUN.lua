rootCowHD_RACESTART_override = false
rootCowHD_RACESTART_startSwitch = false
rootCowHD_RACESTART_runDone = false
rootCowHD_RACESTART_hldDone = false

local function init_func() end

local function run_func()
  if(not runDone) then
    rootCowHD_RACESTART_override = true
    rootCowHD_RACESTART_startSwitch = true
    rootCowHD_RACESTART_runDone = true
    rootCowHD_RACESTART_hldDone = false
  end
end

return { run=run_func, init=init_func }
