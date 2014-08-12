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

HashFromAddr(pData, len, algid, key=0)
{
  hProv := size := hHash := hash := ""
  ptr := (A_PtrSize) ? "ptr" : "uint"
  aw := (A_IsUnicode) ? "W" : "A"
  if (DllCall("advapi32\CryptAcquireContext" aw, ptr "*", hProv, ptr, 0, ptr, 0, "uint", 1, "uint", 0xF0000000))
  {
    if (DllCall("advapi32\CryptCreateHash", ptr, hProv, "uint", algid, "uint", key, "uint", 0, ptr "*", hHash))
    {
      if (DllCall("advapi32\CryptHashData", ptr, hHash, ptr, pData, "uint", len, "uint", 0))
      {
        if (DllCall("advapi32\CryptGetHashParam", ptr, hHash, "uint", 2, ptr, 0, "uint*", size, "uint", 0))
        {
          VarSetCapacity(bhash, size, 0)
          DllCall("advapi32\CryptGetHashParam", ptr, hHash, "uint", 2, ptr, &bhash, "uint*", size, "uint", 0)
        }
      }
      DllCall("advapi32\CryptDestroyHash", ptr, hHash)
    }
    DllCall("advapi32\CryptReleaseContext", ptr, hProv, "uint", 0)
  }
  int := A_FormatInteger
  SetFormat, Integer, h
  Loop, % size
  {
    v := substr(NumGet(bhash, A_Index-1, "uchar") "", 3)
    while (strlen(v)<2)
      v := "0" v
    hash .= v
  }
  SetFormat, Integer, % int
  return hash
}
 
 
HashFromString(string, algid, key=0)
{
  len := strlen(string)
  if (A_IsUnicode)
  {
    VarSetCapacity(data, len)
    StrPut := "StrPut"
    %StrPut%(string, &data, len, "cp0")
    return HashFromAddr(&data, len, algid, key)
  }
  data := string
  return HashFromAddr(&data, len, algid, key)
}
 
MD5(string)
{
  return HashFromString(string, 0x8003)
}