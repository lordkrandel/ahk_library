#include <lib_STRING>
#include <lib_FILE>

Win32  := new Win32()
stdin  := new StdIn()

source   := "d:\Progetti\repo\Pbexport\__source\"
dest     := "d:\Progetti\repo\Pbexport\_dest\"
exporter := "d:\progetti\repo\pbexport\pbexport.exe"
svn      := "C:\Program Files\SlikSvn\bin\svn.exe"
proc     := "C:\Program Files (x86)\TortoiseSVN\bin\TortoiseProc.exe"

nl := "`r`n"
r := ""
FormatTime, now,, dd/MM/yyyy
default_message := "PG " + now + nl

s := stdin.read()
t := s.split(nl)
f := {}

for k, v in t {

    x := trim(v.left(2))
    y := trim(v.lefttrim(4))

    if (y.right(4).toLower() != ".pbl" || "D".in(FileExist(y)) ){
        continue
    }

    SplitPath, y, z

    if ( x.in("MA?") ){
        f.insert(y)
        if (x == "?"){
            runwait, % "%s add ""%s"" --force".fmt(svn, y),, hide
        } else {
            FileSetAttrib, -R, % dest z "\*.*"
            filedelete, % dest z "\*.*"
        }
        Runwait, % "%s ""%s"" %s".fmt(exporter, y, dest)
        Runwait, % "%s add ""%s"" --force".fmt(svn, dest "*" ),, hide
        Runwait, % "%s /command:commit /path:""%s"" /logmsg:""%s"" /closeonend:0".fmt(proc, dest, default_message)
    }

}


ExitApp



