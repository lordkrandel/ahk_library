#include <lib_odbc>
#include %A_ScriptDir%\scripts\ac\levels.ahk

class acController {


    odbc         := new ODBC()
    firstRun     := 1
    currentLevel := 0
    setPrefix    := 0
    win          := 0
    levels       := { 0 : new dsnlevel(    this.odbc )
                    , 1 : new ownerlevel(  this.odbc )
                    , 2 : new tablelevel(  this.odbc )
                    , 3 : new columnlevel( this.odbc ) }
    hotkeys      := { owner  : ":?*:dba."
                    , normal : "!Space"  }

    __new(win){
        this.win := win
    }

    setHotkey(htk){

        norm  := this.hotkeys.normal
        own   := this.hotkeys.owner

        this.setPrefix := 0

        if ( htk == own ) {
            this.setPrefix := 1
            this.currentLevel := Math.min( this.currentLevel, 2)
        }

        this.hotkeys.current := htk

    }

    getCurrentLevel() {
        return this.levels[this.currentLevel]
    }

    start(){
        try {
            while ( d := this.getCurrentLevel().getDefault() ) {
                entries := this.changeLevel(1, d)
            }
        } catch e {
            this.currentLevel := 0
            entries := this.getEntries()
        }
        this.firstRun := 0
        return entries
    }

    getTitle(){
        return this.getCurrentLevel().name
    }

    changeLevel( n = 1, s = "") {
        if ( abs(n) <> 1 || ! Math.between( 0, this.currentLevel + n, this.levels.maxindex() ) ) {
            return
        }
        try {
            if (s){
                this.levels[this.currentLevel].value := s
            }
            this.currentLevel += n
            entries := this.getEntries(this.currentLevel)
        } catch e {
            throw e
        }
        return entries
    }

    getEntries( n = 0 ){
        val := ( n > 0 ? this.levels[n-1].value : "" )
        return this.levels[n].getEntries(val)
    }

    getPrefix(){
        return % this.levels[this.currentLevel - 1].value "."
    }

    build(s){

        multi := !! instr(s, "|")
        htk   := a_thishotkey
        lvl   := this.getCurrentLevel()

        ; Build the prefix
        sub := "`n"

        ; Add comma if required by "," "+,"
        if ( htk.in([",", "+,"])) {
            sub := "," sub
        }

        ; Add prefix if required by Shift
        if ( "+".in( htk ) ) {
            this.setPrefix := 1
        }

        prefix := this.getPrefix()

        ; Save last value
        if (! multi){
            lvl.value := s
        }

        if (  this.setPrefix ){
            sub := sub prefix
            s := regexreplace( s, "^", prefix )
        }

        ; Replace pipe character (|) with the prefix
        if ( multi ) {
            s := regexreplace( s, "\|",  sub )
        }

        return s

    }

}

