#include %A_ScriptDir%\ac\levels.ahk

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
            this.currentLevel := [this.currentLevel, 2].min()
        }
        this.hotkeys.current := htk
    }

    getCurrentLevel() {
        return this.levels[this.currentLevel]
    }

    start(){
        l_default := this.getCurrentLevel().getDefault()
        if ( l_default ) {
            entries := this.changeLevel(1, l_default)
        } else {
            this.currentLevel := 0
            entries := this.getEntries()
        }
        this.firstRun := 0
        return entries
    }

    getTitle(){
        return this.getCurrentLevel().name
    }

    
    nextLevel(a_value){
        return this.changeLevel(1, a_value)
    }
    prevLevel(){
        return this.changeLevel(-1)
    }
    changeLevel( a_offset = 1, a_value = "") {

        l_next_level := this.currentLevel + a_offset

        if ( abs(a_offset) <> 1 )
            return
        if !l_next_level.between(0, this.levels.maxindex())
            return

        try {
            this.levels[this.currentLevel].value := a_value
            l_entries := this.getEntries(l_next_level)
            this.currentLevel := l_next_level
            return l_entries
        } catch l_exc {
            msgbox, % l_exc.message
        }
        
    }

    getEntries(n=0){
        val := (n > 0 ? this.levels[n-1].value : "")
        l_entries := this.levels[n].getEntries(val)
        return l_entries
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

