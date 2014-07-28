!F4::
stop = 0
Loop
{
WinGet, active_id, ID, FIFA
if 1
{
ControlClick, x1059 y702, FIFA
    sleep 9300
ControlClick, x462 y332, FIFA
    sleep 1200
ControlClick, x746 y678, FIFA
    sleep 1200
ControlClick, x610 y670, FIFA
    sleep 1200
ControlClick, x642 y444, FIFA
    sleep 100
}

If stop = 1
	break

PostMessage, 0X100, 0x1B , 3866625,, ahk_class FIFANG
sleep,100
PostMessage, 0X101, 0x1B , 3866625,, ahk_class FIFANG

ControlClick, x1059 y702, FIFA
 sleep 650

WinGet, active_id, ID, FIFA
if 1
{
ControlClick, x1059 y702, FIFA
    sleep 9300
ControlClick, x462 y332, FIFA
    sleep 1200
ControlClick, x746 y678, FIFA
    sleep 1200
ControlClick, x610 y670, FIFA
    sleep 1200
ControlClick, x642 y444, FIFA
    sleep 100
}

}
return

!F3::
stop = 0
Loop
{
WinWait, FIFA, 
IfWinNotActive, FIFA, , WinActivate, FIFA, 
WinWaitActive, FIFA,
sleep 650

PixelGetColor, color2, 338, 671
if color2=0x362F26
  {
   MouseClick, left, 1059, 707
    sleep 9300
   MouseClick, left, 462, 332
    sleep 1200
   MouseClick, left, 746, 678
    sleep 1200
   MouseClick, left, 610, 670
    sleep 1200
   MouseClick, left, 642, 444
    sleep 100
  }
else
PixelGetColor, color2, 338, 671
if color2=0x372F26
  {
   MouseClick, left, 1059, 707
    sleep 9300
   MouseClick, left, 462, 332
    sleep 1200
   MouseClick, left, 746, 678
    sleep 1200
   MouseClick, left, 610, 670
    sleep 1200
   MouseClick, left, 642, 444
    sleep 100
  }
else
PixelGetColor, color2, 338, 671
if color2=0x382F26
  {
   MouseClick, left, 1059, 707
    sleep 9300
   MouseClick, left, 462, 332
    sleep 1200
   MouseClick, left, 746, 678
    sleep 1200
   MouseClick, left, 610, 670
    sleep 1200
   MouseClick, left, 642, 444
    sleep 100
  }
If stop = 1
	break
send {Escape down}
sleep 30
send {Escape up}
sleep 100
MouseClick, left, 1059, 707

PixelGetColor, color2, 338, 671
if color2=0x362F26
  {
   MouseClick, left, 1059, 707
    sleep 9300
   MouseClick, left, 462, 332
    sleep 1200
   MouseClick, left, 746, 678
    sleep 1200
   MouseClick, left, 610, 670
    sleep 1200
   MouseClick, left, 642, 444
    sleep 100
  }
else
PixelGetColor, color2, 338, 671
if color2=0x372F26
  {
   MouseClick, left, 1059, 707
    sleep 9300
   MouseClick, left, 462, 332
    sleep 1200
   MouseClick, left, 746, 678
    sleep 1200
   MouseClick, left, 610, 670
    sleep 1200
   MouseClick, left, 642, 444
    sleep 100
  }
else
PixelGetColor, color2, 338, 671
if color2=0x382F26
  {
   MouseClick, left, 1059, 707
    sleep 9300
   MouseClick, left, 462, 332
    sleep 1200
   MouseClick, left, 746, 678
    sleep 1200
   MouseClick, left, 610, 670
    sleep 1200
   MouseClick, left, 642, 444
    sleep 100
  }
}
return

!F2::stop:=!stop
