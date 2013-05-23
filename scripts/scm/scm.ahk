#include <lib_CORE>
#include <lib_FILE>

class Folder {

    __new( path = "" ){
        this.app := ComObjCreate("Shell.Application")
        if (path){
            this.path := path
            this.items := this.app.NameSpace( path ).items
            if (!this.items){
                throw "Cannot create Folder for path %s".fmt( path )
            }
        }
     }

    __delete(){
        ComObjDestroy(this.app)
        ComObjDestroy(this.items)
    }

}

Log := new Log( ["*", "scm.log"] )

sourcePath   := "d:\progetti\repo\pbexport\__source"
destPath     := "d:\progetti\repo\pbexport\_dest"
exporter     := "d:\progetti\repo\pbexport\pbexport.exe"
svn          := "C:\Program Files\SlikSvn\bin\svn.exe".qq()
message      := ("autocommit " a_now).qq()
tempFile     := "D:\Progetti\repo\PBexport\tempfile.txt"

sourceFolder := new Folder(sourcePath)
destFolder   := new Folder(destPath)
sourcePath   := sourcePath.qq()
destPath     := destPath.qq()

Log.info("Pushing " destPath)

; delete old folders
for k, v in destFolder.items {
    path := k.path
    SplitPath, path , filename
    if (filename == ".svn") {
        continue
    }
    FileRemoveDir, % k.path, 1
    Log.info("rmdir " k.path )
}

; export pbl into new folders
for k, v in sourceFolder.items {

    path := k.path
    SplitPath, path , filename, , ext
    if ( ext != "pbl"){
        continue
    }

    RunWait, % exporter " " k.path.qq() " " destPath
    Log.info(k.path.qq() " --> " destPath)

}

; add files to repository
RunWait, % "%s add --force %s".fmt( svn, destPath ),, hide
if (errorlevel) {
    Log.error("errorlevel: " Errorlevel)
}
Log.info("svn add --force " )

; commit these adds
Log.info("svn ci --message " message)
RunWait, % "%s ci --message %s %s".fmt(svn, message, destPath),, hide
if (errorlevel) {
    Log.error("errorlevel: " Errorlevel)
}

; retrieve the deleted files list
Log.info("svn status > " tempfile)
RunWait, % "cmd /c ""%s status %s > %s""".fmt(svn, destPath, tempfile.qq()),, hide
if (errorlevel) {
    Log.error("errorlevel: " Errorlevel)
}

; for each deleted file
Loop, read, %tempfile%
{
    l := A_loopreadline
    if (l.left(1) != "!"){
        continue
    }
    l := l.slice(9).qq()

    ; remove it from the repository
    Log.info("svn delete " l)
    RunWait, % "%s delete %s".fmt(svn, l),, hide
    if (errorlevel) {
        Log.error("errorlevel: " Errorlevel)
    }
}

; update
Log.info("svn update ")
RunWait, % "%s update %s".fmt(svn, destPath),, hide
if (errorlevel) {
    Log.error("errorlevel: " Errorlevel)
}

; commit
Log.info("svn commit --message " message)
RunWait, % "%s commit --message %s %s".fmt(svn, message, destPath),, hide
if (errorlevel) {
    Log.error("errorlevel: " Errorlevel)
}

; delete tempfile
Log.info("del " tempfile )
FileDelete, % tempfile
if (errorlevel) {
    Log.error("errorlevel: " Errorlevel)
}

ExitApp



