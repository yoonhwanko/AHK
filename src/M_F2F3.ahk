!F4::
{
Mousegetpos, xpos, ypos
WinGet, active_id, ID, BlueStacks App Player	;league lobby
PixelGetColor, OutputVar, xpos, ypos,rgb
msgbox %colour%, X%xpos%, Y%ypos%, %rgb%, %OutputVar%
}
return

!F2::stop:=!stop

!F3::
stop = 0
Loop
{
WinWait, BlueStacks App Player, 
IfWinNotActive, BlueStacks App Player, , WinActivate, BlueStacks App Player, 
WinWaitActive, BlueStacks App Player,
sleep 30
	If stop = 1
		break

	PixelGetColor, color, 157, 843
	
	;black screen
	if Check(176,1003,0x8C3A00) == 0 && Check(93,213,0x0000) && Check(537,213,0x000000) && Check(48,861,0x000000) && Check(506,840,0x7E0D69)
	{
	}else if Check(176,1003,0x8C3A00) || Check(176,1003,0x943D00) || Check(176,1003,0x933D00) || Check(176,1003,0x953E00)
	{
		DebugMessage("하단 중앙 파란색 버튼")
		Click(176,1003)
	}
	;메뉴 단.
	else if Check(266,120,0x7E0D69) && Check(259,60,0xFFFFFF) && Check(314,54,0xFFFFFF)
	{
		DebugMessage("시즌경기 메뉴")
		Click(383,512)
	}
	else if Check(266,120,0x7E0D69) && Check(67,967,0xCA642B) && Check(341,979,0xC96931) && Check(531,984,0xC75F27) 
	{
		;경기시작
		DebugMessage("메인메뉴")
		Click(67,967,0xCA642B, 2)
		;리그 경기
		Click(128,847)
	}else if  Check(261,88,0xFFFFFF) && Check(284,95,0xFFFFFF) && Check(334,90,0xFFFFFF)
	{
		DebugMessage("재계약")
		
		if Check(61,252,0x13110F,1) || Check(61,252,0xFFF6FB,1)
		{
			Click(61,252,0x13110F,1)
			Click(61,252,0xFFF6FB,1)
		}
		Click(332,964)
		
		sleep 3000
		
		Click(227,632)
	}else	; 리그 생성
	{
		
		if(MakeLeague())
		{
			DebugMessage("리그 생성 ")
		}
		else
		{
			DebugMessage("인 게임")
			Click(753,437)
		}
		
	}	
	color = 0
			
}
return


MakeLeague()
{
	ttt = 0
	if (Check(174,817,0xFDFDFD) && Check(455,845,0xFFFFFF))	;	리그생성
	{
		ttt = 1
		Click(195,980,0xB16128, 2)
	}else if (Check(216,888,0xDFDFDF) && Check(356,888,0xFFFFFF))
	{
		ttt = 1
		Click(195,980,0xB16128, 2)
	}else if (Check(144,839,0xFFFFFF) && Check(403,854,0xFFFFFF))
	{
		ttt = 1
		Click(195,980,0xB16128, 2)
	}else if Check(250,87,0xFFFFFF) && Check(287,80,0xFFFFFF) && Check(340,90,0xFFFFFF)
	{
		ttt = 1
		Click(195,980,0xB16128, 2)
	}else if Check(231,379,0xFFFFFF) && Check(312,380,0xFFFFFF) && Check(348,377,0xFFFFFF)
	{
		ttt = 1
		Click(195,980,0xB16128, 2)
	} 
	
	return ttt

}

Click(x, y, color = -1, delay = 1)
{
	if(color+0==-1)
	{
		MouseClick, left, x, y
    	sleep delay*1000
	}else
	{
		if(Check(x,y,color)==1)
		{
			MouseClick, left, x, y
    		sleep delay*1000
		}
    }
}

Check(x, y, color, debug = 0) { 
	PixelGetColor, c, x, y
	if c+0==color+0
  	{	
		return 1
	}
	else
	{
		;if (debug)
			DebugMessage("Real = " c ", Input = " color ", (" x "," y ")")
	}
	return 0
}    

DebugMessage(str)
{
return
 global h_stdout
 DebugConsoleInitialize()  ; start console window if not yet started
 ;str .= "\n" ; add line feed
 ;DllCall("WriteFile", "uint", h_Stdout, "uint", &str, "uint", StrLen(str)+1, "uint*", BytesWritten, "uint", NULL) ; write into the console
 FileAppend  %str%`n, CONOUT$
 WinSet, Bottom,, ahk_id %h_stout%  ; keep console on bottom
 str = ""
}

DebugConsoleInitialize()
{
   global h_Stdout     ; Handle for console
   static is_open = 0  ; toogle whether opened before
   if (is_open = 1)     ; yes, so don't open again
     return
	 
   is_open := 1	
   ; two calls to open, no error check (it's debug, so you know what you are doing)
   DllCall("AttachConsole", int, -1, int)
   DllCall("AllocConsole", int)

   dllcall("SetConsoleTitle", "str","Paddy Debug Console")    ; Set the name. Example. Probably could use a_scriptname here 
   h_Stdout := DllCall("GetStdHandle", "int", -11) ; get the handle
   WinSet, Bottom,, ahk_id %h_stout%      ; make sure it's on the bottom
   WinActivate,Lightroom   ; Application specific; I need to make sure this application is running in the foreground. YMMV
   return
}

printf(string, prms*)    ; uses variadics to handle variable number of inputs
{
    padchar := " "
    
    for each, prm in prms
    {
        RegExMatch(string,"`%(.*?)([s|f])",m)
        
        format := m1
        type := m2
        
        if (type = "f") {    ; format float using setformat command
            
            originalformat := A_FormatFloat
            SetFormat, Float, %format%
            prm += 0.0
            SetFormat, Float, %originalformat%
           
        } else if (type = "s") {   ; format string (pad string if necessary, negative number indicates right justify)
        
            if (format < 0)
                loop % -format-StrLen(prm)
                    prm := padchar prm
            else
                loop % format-StrLen(prm)
                    prm := prm padchar
                    
        } else {
            msgbox, unknown type = %type% specified in call to printf
        }
        
        StringReplace, string, string, % "`" m, % prm     ; "%" symbol must be escaped with backtick
        
    }
        
    return string
}