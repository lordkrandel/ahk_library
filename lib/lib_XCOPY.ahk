;; Xcopy wrapper class, helps with parameters 
class Xcopy {
    copy(source, dest, settings = "" ){ 
        if (!settings)
            settings := new XcopySettings()
        l_run := "xcopy  ""%s"" ""%s\*.*"" %s".fmt(source, dest, settings.get())
        RunWait, % l_run,, HIDE
    }
}

;; Xcopy parameters class, autogenerates some default argument and compiles the runstring
class XcopySettings {

    overWrite := 1
    onlyArchiveAttrib := 0
    disableArchiveAttrib := 0
    onlyAfterDate := ""
    ignoreErrors := 1
    subfolders := 1
    archiveFiles := 1
    hiddenFiles := 1
    readOnlyFiles := 1    
    createDirIfNotExists := 1
    quiet := 1

    get(){
        l_params := " " 
        if (this.quiet)
            l_params .= " /q "
        if (this.createDirIfNotExists)
            l_params .= " /i "
        if (this.overWrite)
            l_params .= " /y "
        if (this.onlyArchiveAttrib){
            if (this.disableArchiveAttrib)
                l_params .= " /m "
            else
                l_params .= " /a "
        }
        if (this.onlyAfterDate)
            l_params .= " /d:%s ".fmt(this.onlyAfterDate)
        if (this.subfolders)
            l_params .= " /s /e "
        if (this.ignoreErrors)
            l_params .= " /c "
        if (this.hiddenFiles)
            l_params .= " /h "
        if (this.readOnlyFiles)
            l_params .= " /r "
        return l_params
    }  
}

; Syntax
;     XCOPY source [destination] [options]
; Key
;     source      : Pathname for the file(s) to be copied.
;     destination : Pathname for the new file(s).
;     [options] can be any combination of the following:
; Source Options
;    /A           Copy files with the archive attribute set (default=Y)
;    /M           Copy files with the archive attribute set and turn off the archive attribute, 
;                 use this option when making regular Backups (default=Y)
;    /H           Copy hidden and system files and folders (default=N)
;    /D:mm-dd-yyyy
;                 Copy files changed on or after the specified date.
;                 If no date is given, copy only files whose
;                 source date/time is newer than the destination time.
;    /U           Copy only files that already exist in destination.
;    /S           Copy folders and subfolders
;    /E           Copy folders and subfolders, including Empty folders. May be used to modify /T.
;    /EXCLUDE:file1[+file2][+file3]...
;                The files can each contain one or more full or partial pathnames to be excluded.
;                When any of these match any part of the absolute path of a SOURCE file, then 
;                that file will be excluded.
;                For example, specifying a string like \obj\ or .obj will excludeall files 
;                underneath the directory obj or all files with the .obj extension respectively.
; Copy Options
;    /W           Prompt you to press a key before starting to copy.
;    /P           Prompt before creating each file.
;    /Y           Suppress prompt to confirm overwriting a file.
;                 may be preset in the COPYCMD env variable.
;    /-Y          Prompt to confirm overwriting a file.
;    /V           Verify that the new files were written correctly.
;    /C           Continue copying even if an error occurs.
;    /I           If in doubt always assume the destination is a folder
;                 e.g. when the destination does not exist.   
;    /Z           Copy files in restartable mode. If the copy is interrupted part
;                 way through, it will restart if possible. (use on slow networks)
;    /Q           Do not display file names while copying.
;    /F           Display full source and destination file names while copying.
;    /L           List only - Display files that would be copied.
; Destination Options
;    /R           Overwrite read-only files.
;    /T           Create folder structure, but do not copy files. Do not
;                 include empty folders or subfolders. 
;                 /T /E will include empty folders and subfolders.
;    /K           Copy attributes. XCOPY will otherwise reset read-only attributes.
;    /N           If at all possible, use only a short filename (8.3) when creating a destination file. 
;                 This may be necessary when copying between disks
;                 that are formatted differently e.g NTFS and VFAT, or when archiving 
;                 data to an ISO9660 CDROM.
;    /O           Copy file Ownership and ACL information.
;    /X           Copy file audit settings (implies /O).
; XCOPY will accept UNC pathnames
