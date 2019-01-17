RootCowHD_Control_xlite = true

lcd.clear()
lcd.drawScreenTitle("Race Start Trainer", 1, 1)
lcd.drawText(1,11,"Start Time")
lcd.drawText(1,11,"Timer Delay")
lcd.drawText(70,11,"Max. Timer")
lcd.drawLine(1,22,128,22,SOLID,FORCE)
lcd.drawText(21,28,rootCowHD_RACESTART_setDelay,DBLSIZE)
lcd.drawText(86,28,rootCowHD_RACESTART_setWithin,DBLSIZE)
lcd.drawLine(1,48,128,48,SOLID,FORCE)
lcd.drawLine(64,11,64,64,SOLID,FORCE)
lcd.drawText(1,54,"Enter:",SMLSIZE)

if(rootCowHD_RACESTART_isRunning) then
  lcd.drawText(31,54,"Disable", SMLSIZE)
else
  lcd.drawText(31,54,"Enable",INVERS + SMLSIZE)
end

if(rootCowHD_RACESTART_override) then
  lcd.drawText(70,54,"swtich Go",SMLSIZE)
else
  lcd.drawText(70,54,"no Switch",INVERS + SMLSIZE)
end

lcd.drawLine(54,25,49,32,SOLID,FORCE)
lcd.drawLine(54,25,59,32,SOLID,FORCE)
lcd.drawLine(54,45,49,38,SOLID,FORCE)
lcd.drawLine(54,45,59,38,SOLID,FORCE)

lcd.drawLine(108,35,115,30,SOLID,FORCE)
lcd.drawLine(108,35,115,40,SOLID,FORCE)
lcd.drawLine(125,35,118,30,SOLID,FORCE)
lcd.drawLine(125,35,118,40,SOLID,FORCE)
