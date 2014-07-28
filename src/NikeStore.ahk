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
;Loop
{
	DebugMessage("test start")
	
	InputBox, ShoeName, "ShoeName", "Please enter a ShoeName.", , 200, 100
	
	while(StrLen(ShoeName) <= 0)
	{
		InputBox, ShoeName, "ShoeName", "Please enter a ShoeName.", , 200, 100
	}
	
	InputBox, ShoeSize, "ShoeSize", "Please enter a ShoeSize.", , 200, 100
	
	while(StrLen(ShoeSize) <= 0)
	{
		InputBox, ShoeSize, "ShoeSize", "Please enter a ShoeSize.", , 200, 100
	}
	
	msgbox ShoeName = %ShoeName% ShoeSize = %ShoeSize%
	DebugMessage("ShoeName = " ShoeName ", ShoeSize = " ShoeSize )
	
	URL :=	"http://store.nike.com/us/en_us/pd/air-jordan-xx8-se-basketball-shoe/pid-1465170/pgid-782607"

	pwb :=	ComObjCreate("InternetExplorer.Application"), pwb.Navigate(URL)

	While	pwb.Busy
		Sleep, 50

	pwb.Visible :=	True

	;Loop %	(links :=	pwb.document.links).length
		;DebugMessage("test link " links[A_Index-1].innerText " : " A_Index)
	;[color=#FF0000]	if	(links[A_Index-1].innerText="Buy")
		;pwb.Navigate[links[A_Index-1].href,0x1000,"_self"] ;[/color]	[color=#00BF00]; 0x1000 = navOpenInBackgroundTab[/color]
	
	
	;Size
	label := ""
	Loop %   (option := pwb.document.all.tags["option"]).length
		{
			opt := pwb.document.getElementsByName("skuId")[A_Index-1]
			if   (opt.className="exp-pdp-size-not-in-stock" && opt.innerText+0=ShoeSize)
			{
				msgbox SoldOut ShoeName = %ShoeName% ShoeSize = %ShoeSize%
				ObjRelease(pwb)
				return
			}Else if(opt.innerText+0=ShoeSize)
			{
				label := opt.value
				DebugMessage("test success[ " A_Index " ] inner: " opt.innerText " Label : " label)
				
				Break
			}
		}
	
	if ( StrLen(label) <= 0 )
	{
		msgbox Err NotFound ShoeName = %ShoeName% ShoeSize = %ShoeSize%
		ObjRelease(pwb)
		return
	}
	
	pwb.document.all.skuAndSize.value := label
		
	;Add to Cart
	Loop %   (button :=   pwb.document.all.tags["button"]).length
		if   (button[A_Index-1].className="add-to-cart nsg-button--nike-orange")
		{
			DebugMessage("test success[ " A_Index " ] classname: " button[A_Index-1].className " inner: " button[A_Index-1].innerText+0)
			button[A_Index-1].click()
		}
		
	ObjRelease(pwb)
	return
	
	Loop %   (div :=   pwb.document.all.tags["div"]).length
		if   (div[A_Index-1].className="newPrice")
		{
		  Bookdiv := pwb.document.getElementsByTagName("div")[A_Index-1]
		  divLinks := Bookdiv.getElementsByTagName("a")
		  DebugMessage("test " divLinks[0])
		;   send, {ctrl down}
		;  divLinks[0].click()
		;  send, {ctrl up}
		;  MsgBox, Click 'OK' to continue to the next book.
		}Else
		{
			;DebugMessage("test err[ " A_Index " ] classname: " div[A_Index-1].className)
		}

}
return

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