;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

!F6::
{
Mousegetpos, xpos, ypos
WinGet, active_id, ID, FIFA
colour := PixelColor(771, 307, active_id)
PixelGetColor, OutputVar, 771, 307,rgb
msgbox %colour%, X%xpos%, Y%ypos%
}
return


!F5::
{
MouseGetPos, xpos, ypos 
PixelGetColor, color, %xpos%, %ypos%
MsgBox Colour:%color% at X%xpos%, Y%ypos%
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

!F1::
stop = 0
contractcount = 0
Loop
{
WinWait, FIFA, 
IfWinNotActive, FIFA, , WinActivate, FIFA, 
WinWaitActive, FIFA,
sleep 650

PixelGetColor, color2, 338, 671
if color2=0x362F26
{
contractcount:=contractcount+1

if contractcount = 38
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
   contractcount = 0
  }
}
else
PixelGetColor, color2, 338, 671
if color2=0x372F26
{
contractcount:=contractcount+1

if contractcount = 38
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
   contractcount = 0
  }
}
else
PixelGetColor, color2, 338, 671
if color2=0x382F26
{
contractcount:=contractcount+1

if contractcount = 38
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
   contractcount = 0
  }
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
if contractcount = 38
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
   contractcount = 0
  }
 }
If stop = 1
	break
}
return

!F2::stop:=!stop

!F9::
stop = 0
Loop
{
WinGet, active_id, ID, FIFA
colour := PixelColor(312, 669, active_id)
PixelGetColor, OutputVar, 312, 669,rgb
if colour=0xff262f36
{
ControlClick, x1059 y707, FIFA
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

ControlClick, x1059 y707, FIFA
 sleep 650

WinGet, active_id, ID, FIFA
colour := PixelColor(312, 669, active_id)
PixelGetColor, OutputVar, 312, 669,rgb
if colour=0xff262f36
{
ControlClick, x1059 y707, FIFA
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

!F8::
stop = 0
contractcount:=0
Loop
{
WinGet, active_id, ID, FIFA
colour := PixelColor(312, 669, active_id)
PixelGetColor, OutputVar, 312, 669,rgb
if colour=0xff262f36
{
contractcount:=contractcount+1

if contractcount = 38
  {
   ControlClick, x1059 y707, FIFA
    sleep 9300
   ControlClick, x462 y332, FIFA
    sleep 1200
   ControlClick, x746 y678, FIFA
    sleep 1200
   ControlClick, x610 y670, FIFA
    sleep 1200
   ControlClick, x642 y444, FIFA
    sleep 100
   contractcount = 0
  }
}

If stop = 1
	break

ControlClick, x1059 y707, FIFA
 sleep 650

WinGet, active_id, ID, FIFA               ;level up reward
colour3 := PixelColor(802, 595, active_id)
PixelGetColor, OutputVar, 802, 595,,rgb
if colour3=0xff1e1f1e
 {
  ControlClick, x644 y603, FIFA          ;level up ok button
   sleep 500
 }

WinGet, active_id, ID, FIFA
colour := PixelColor(312, 669, active_id)
PixelGetColor, OutputVar, 312, 669,rgb
if colour=0xff262f36
 {
if contractcount = 38
  {
ControlClick, x1059 y707, FIFA
    sleep 9300
ControlClick, x462 y332, FIFA
    sleep 1200
ControlClick, x746 y678, FIFA
    sleep 1200
ControlClick, x610 y670, FIFA
    sleep 1200
ControlClick, x642 y444, FIFA
    sleep 100
contractcount = 0
  }
 }

}
return

!F10::
stop = 0
SetControlDelay -1
Loop
{
WinWait, FIFA, 
IfWinNotActive, FIFA, , WinActivate, FIFA, 
WinWaitActive, FIFA,
sleep 600
PixelGetColor, color1, 468, 682         ;contract popup
if color1=0x1E1F1E
  {
   MouseClick, left, 611, 671        ;contract button
    sleep 850
   MouseClick, left, 643, 441        ;contract ok button
    sleep 600
  }
sleep 350


PixelGetColor, color5, 649, 286        ;league lobby
if color5=0x1E1A19
  {
   MouseClick, left, 1017, 710         ;green button
    sleep 300
  }
else
PixelGetColor, color2, 539, 300        ;league lobby
if color2=0x161716
  {
   MouseClick, left, 1017, 710         ;green button
    sleep 300
  }
else
PixelGetColor, color2, 550, 312        ;league lobby
if color2=0x171717
  {
   MouseClick, left, 1017, 710         ;green button
    sleep 300
  }
else
PixelGetColor, color3, 1019, 714        ;league lobby
if color3=0x21AD31
  {
   MouseClick, left, 1017, 710         ;green button
    sleep 300
  }
else
PixelGetColor, color4, 489, 592           ;level up reward
if color4=0x1E1F1E
 {
   MouseClick, left, 644, 603             ;level up ok button
   sleep 300
 }
else
   MouseClick, left, 1063, 710           ;blue button
  sleep 650

if stop = 1
    break
}
return

!F11::
stop = 0
SetControlDelay -1
Loop
{
sleep 600
WinGet, active_id, ID, FIFA               ;contract popup
colour1 := PixelColor(401, 465, active_id)
PixelGetColor, OutputVar, 401, 465,rgb
if colour1=0xff1e1f1e
  {
   ControlClick, x611 y671, FIFA         ;contract button
    sleep 850
   ControlClick, x643 y441, FIFA         ;contract ok button
    sleep 600
  }
sleep 200

WinGet, active_id, ID, FIFA               ;league lobby
colour2 := PixelColor(771, 307, active_id)
PixelGetColor, OutputVar, 771, 307,rgb
if colour2=0xbd15171b
  {
   ControlClick, x1017 y710, FIFA         ;green button
    sleep 300
  }
else
WinGet, active_id, ID, FIFA               ;league lobby
colour4 := PixelColor(771, 307, active_id)
PixelGetColor, OutputVar, 771, 307,rgb
if colour4=0xbd15171a
  {
   ControlClick, x1017 y710, FIFA         ;green button
    sleep 300
  }
else
WinGet, active_id, ID, FIFA               ;league lobby
colour5 := PixelColor(771, 307, active_id)
PixelGetColor, OutputVar, 771, 307,rgb
if colour5=0xbd15171c
  {
   ControlClick, x1017 y710, FIFA         ;green button
    sleep 300
  }
else
WinGet, active_id, ID, FIFA               ;league lobby
colour5 := PixelColor(771, 307, active_id)
PixelGetColor, OutputVar, 771, 307,rgb
if colour6=0xbd16181c
  {
   ControlClick, x1017 y710, FIFA         ;green button
    sleep 300
  }
else
WinGet, active_id, ID, FIFA               ;league lobby
colour5 := PixelColor(1017, 713, active_id)
PixelGetColor, OutputVar, 1017, 713,rgb
if colour6=0xff37ae21
  {
   ControlClick, x1017 y710, FIFA         ;green button
    sleep 300
  }

WinGet, active_id, ID, FIFA               ;level up reward
colour3 := PixelColor(802, 595, active_id)
PixelGetColor, OutputVar, 802, 595,,rgb
if colour3=0xff1e1f1e
 {
  ControlClick, x644 y603, FIFA          ;level up ok button
   sleep 500
 }

ControlClick, x1063 y710, FIFA            ;blue button
  sleep 950

if stop = 1
    break
}
return

PixelColor(pc_x, pc_y, pc_wID) 
{ 
  If pc_wID 
  { 
      pc_hDC := DllCall("GetDC", "UInt", pc_wID) 
      WinGetPos, , , pc_w, pc_h, ahk_id %pc_wID% 
      pc_hCDC := CreateCompatibleDC(pc_hDC) 
      pc_hBmp := CreateCompatibleBitmap(pc_hDC, pc_w, pc_h) 
      pc_hObj := SelectObject(pc_hCDC, pc_hBmp) 
      
      pc_hmCDC := CreateCompatibleDC(pc_hDC) 
      pc_hmBmp := CreateCompatibleBitmap(pc_hDC, 1, 1) 
      pc_hmObj := SelectObject(pc_hmCDC, pc_hmBmp) 

      #DllCall("PrintWindow", "UInt", pc_wID, "UInt", pc_hCDC, "UInt", 0) 
      DllCall("BitBlt" , "UInt", pc_hCDC, "Int", 0, "Int", 0, "Int", 1, "Int", 1, "UInt", pc_hDC, "Int", pc_x, "Int", pc_y, "UInt", 0xCC0020) 
      DllCall("BitBlt" , "UInt", pc_hmCDC, "Int", 0, "Int", 0, "Int", 1, "Int", 1, "UInt", pc_hCDC, "Int", pc_x, "Int", pc_y, "UInt", 0xCC0020) 
      pc_fmtI := A_FormatInteger 
      SetFormat, Integer, Hex 
      DllCall("GetBitmapBits", "UInt", pc_hmBmp, "UInt", VarSetCapacity(pc_bits, 4, 0), "UInt", &pc_bits) 

      pc_c := NumGet(pc_bits, 0) 
      SetFormat, Integer, %pc_fmtI% 

      DeleteObject(pc_hBmp), DeleteObject(pc_hmBmp) 
      DeleteDC(pc_hCDC), DeleteDC(pc_hmCDC) 
      DllCall("ReleaseDC", "UInt", pc_wID, "UInt", pc_hDC) 
      Return pc_c 
  } 
} 


CreateCompatibleDC(hdc=0) { 
  return DllCall("CreateCompatibleDC", "UInt", hdc) 
}    

CreateCompatibleBitmap(hdc, w, h) { 
  return DllCall("CreateCompatibleBitmap", UInt, hdc, Int, w, Int, w) 
} 

SelectObject(hdc, hgdiobj) { 
  return DllCall("SelectObject", "UInt", hdc, "UInt", hgdiobj) 
} 

DeleteObject(hObject) { 
  Return, DllCall("DeleteObject", "UInt", hObject) 
} 

DeleteDC(hdc) { 
  Return, DllCall("DeleteDC", "UInt", hdc) 
}
