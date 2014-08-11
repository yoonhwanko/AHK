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

URL :=	"http://twitter.com"
Run, C:\Program Files (x86)\Internet Explorer\iexplore.exe
while((pwb :=	IEGet())=="")
{} 
pwb.Navigate(URL)
IELoad(pwb)
;pwb.Visible :=	True

While(LoopTwitterSearch(pwb, ShoeName, ShoeSize) == 0)
{
	If stop = 1
		return
}

msgbox Add to Cart Success
return

LoopTwitterSearch(pwb, ShoeName, ShoeSize)
{
	IELoad(pwb)
	
	DebugMessage("StartTweetSearch" )
	twitts :=   pwb.document.getElementsByTagName("p")
	
	Loop %  twitts.length
	{
		if   (twitts[A_Index-1].className="js-tweet-text tweet-text")
		{
			twitt := twitts[A_Index-1]
			sText :=  twitt.innerText
			IfInString, sText, %ShoeName%
			{
				
				twittLink :=   twitt.getElementsByTagName("a")
				Loop %  twittLink.length
				{
					if(twittLink[A_Index-1].className = "twitter-timeline-link")
					{
						url := twittLink[A_Index-1].href
						
						DebugMessage("[" A_Index-1 "] " "URL : " url " ShoeName = " ShoeName ", ShoeSize = " ShoeSize )
						BuyNikeStoreItem(url, ShoeName,ShoeSize)
					}
				}
				
				pwb.quit
				ObjRelease(pwb)	
				Return 1
			}
		}
	}
	pwb.Refresh()
	sleep 1000
	Return 0
}

BuyNikeStoreItem(_URL, _ShoeName,_ShoeSize)
{
	;_URL :=	"http://store.nike.com/us/en_us/pd/air-zoom-pegasus-31-running-shoe/pid-1066809/pgid-1066805"

	Run, C:\Program Files (x86)\Internet Explorer\iexplore.exe
	while((pwb :=	IEGet())=="")
	{} 
	pwb.Navigate(_URL)
	IELoad(pwb)
	
	;pwb.Visible :=	True

	;Loop %	(links :=	pwb.document.links).length
		;DebugMessage("test link " links[A_Index-1].innerText " : " A_Index)
	;[color=#FF0000]	if	(links[A_Index-1].innerText="Buy")
		;pwb.Navigate[links[A_Index-1].href,0x1000,"_self"] ;[/color]	[color=#00BF00]; 0x1000 = navOpenInBackgroundTab[/color]
	
	
	;Size
	label := ""
	selects := pwb.document.getElementsByName("skuAndSize")
	Loop % selects.length
	{
		select := selects[A_Index-1]
		options := select.getElementsByTagName("option")
		Loop % options.length
		{
			option := options[A_Index-1]
			iText := option.innerText
			IfInString, iText, %_ShoeSize%
			{
				if(option.className=="exp-pdp-size-not-in-stock")
				{

					DebugMessage("SoldOut ShoeName = " _ShoeName " ShoeSize = " _ShoeSize)
					ObjRelease(pwb)
					return
				
				}Else
				{
					label := option.value
					DebugMessage("test success[ " A_Index " ] inner: " opt.innerText " Label : " label)
					Break
				}
			}
		}
	
	}
	
	if ( StrLen(label) <= 0 )
	{
		;msgbox Err NotFound ShoeName = %_ShoeName% ShoeSize = %_ShoeSize%
		
		DebugMessage("Err NotFound ShoeName = " _ShoeName " ShoeSize = " _ShoeSize )
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

IELoad(p){
	While p.readyState!=4 || p.document.readyState!="complete" || p.busy
		Sleep 100
}

IEGet( Name:="about:blank") ; return pwb with the exact tab title
{ 
	IfEqual, Name,, WinGetTitle, Name, ahk_class IEFrame
		Name := ( Name="빈 페이지 - Windows Internet Explorer" ) ? "about:blank"
		: RegExReplace( Name, " - (Windows|Microsoft) Internet Explorer" )
	For Pwb in ComObjCreate( "Shell.Application" ).Windows
	{
		
		localName := Pwb.LocationName
		;DebugMessage("find win name : " localName " key name : " Name)
		
		if (localName=Name)
		{
			full := Pwb.FullName
			;DebugMessage("full name : " Pwb.FullName )
			IfInString, full, iexplore.exe
			{
				Return Pwb
			}
		}
	}
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