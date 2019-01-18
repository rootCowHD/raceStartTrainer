lcd.clear()
lcd.drawScreenTitle("Race Start Trainer", 1, 1)
lcd.drawText(1,11,"Start Time")
lcd.drawText(1,11,"Timer Delay")
lcd.drawText(70,11,"Max. Timer")
lcd.drawLine(1,22,128,22,SOLID,FORCE)

if(rootCowHD_RACESTART_selected == 0) then
  if(not rootCowHD_RACESTART_eleLock) then
    lcd.drawText(21,28,rootCowHD_RACESTART_setDelay,DBLSIZE + INVERS)
  else
    lcd.drawText(21,28,rootCowHD_RACESTART_setDelay,DBLSIZE + BLINK)
  end
else
  lcd.drawText(21,28,rootCowHD_RACESTART_setDelay,DBLSIZE)
end

if(rootCowHD_RACESTART_selected == 1) then
  if(not rootCowHD_RACESTART_eleLock) then
    lcd.drawText(21,28,rootCowHD_RACESTART_setWithin,DBLSIZE + INVERS)
  else
    lcd.drawText(21,28,rootCowHD_RACESTART_setWithin,DBLSIZE + BLINK)
  end
else
lcd.drawText(86,28,rootCowHD_RACESTART_setWithin,DBLSIZE)
end

lcd.drawLine(1,48,128,48,SOLID,FORCE)
lcd.drawLine(64,11,64,64,SOLID,FORCE)
lcd.drawText(1,54,"Menu:",SMLSIZE)

if(rootCowHD_RACESTART_isRunning) then
  lcd.drawText(26,54,"ENABLED", SMLSIZE)
else
  lcd.drawText(25,54,"DISABLED",INVERS + SMLSIZE)
end

if(not rootCowHD_RACESTART_override) then
  lcd.drawText(70,54,"no switch",SMLSIZE)
else
  lcd.drawText(70,54,"SWITCHED",INVERS + SMLSIZE)
end
