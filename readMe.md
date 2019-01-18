<h1>Race Start Trainer</h1>
<h2>Idea</h2>
The Idea behind this Timer is simpel, getting used to a "with in" race start timer. 
This time can be different from Race to Race, so the Start in the Script must be variable, too.

<h2> Now at 0.9.5 </h2>
The Script works technically correct.
The inner layout needs to be fixed to save some calculation power
X9 Layout is just temporarly
all Layouts will get a make over when the technically part is done

<h2>How to use it:</h2>
Merge the Scripts Folder with the one on your Taranis. You can now add RS_COW to one of your Telemetry Screens.<br>
<b>If you have Betaflight Telemetry:</b> go to the Telemetry Screen, change the Time before the countdown and the countdown itself, press the stick once (The bottom Left Text will not longer be inverted) and done. By arming you will now start your countdown. To Disable the Script, just go to your Telemetry Screen again, press the stick again and you won't get any voicelines (nor will the Script use as much working Power)<br><br>
<b>Without Betaflight Telemetry:</b> you need to map the function Scripts RS_HLD and RS_RUN to a switch (best way is to use the arm switch) on arm add the RS_RUN Script on disarm add RS_HLD. For this go to your Model Settings and to the Special Function Screen. When done, you can use the script like you have Arming Control (just without that your RC don't need to be actually armed)

<h2>Sources and Rights</h2>
- OpenTX: https://www.open-tx.org/ <br>
- LUA: https://www.lua.org/ <br>
- TTS for voice Creation: http://tts.softgateon.net/ <br>
