#include <lib_g>

class optionsDialog extends g {

    name  := "inputDialog"
    title := "ODBC config"
    geom  := { w: 420 , h: 150 }
    win   := { hotkeys   : { Enter   : "save"
                           , Esc     : "escape" }
             , controls  : { button2 : "close"
                           , button3 : "save"   } }

    save(){
        try {
            o := { uid : this.uidedit
                 , pwd : this.pwdedit
                 , dsn : this.defaultcheck }

            uid        := this.controlGet(this.uidedit)
            pwd        := this.controlGet(this.pwdedit)
            defaultDsn := this.controlGet(this.defaultcheck) ? this.dsn : "None"

            OdbcReg.saveDsn( new OdbcSettings(this.dsn, uid, pwd, "dba"), defaultDsn )
            base.close()
        } catch l_exc {
            Msgbox, % "Cannot save " this.dsn ", error: " l_exc.message
        }
    }

    show(){
        base.show()
        OdbcReg.load()
        data := OdbcReg.loadDsn(this.dsn)
        for k, v in { dsn : "dsnedit", uid: "uidedit", pwd: "pwdedit" } {
            this.controlSet( this[v], "", data[k] )
        }
        if (OdbcReg.defaultDsn == this.dsn) {
            Control, Check,,, % "ahk_id " this.defaultcheck
        }
        ControlFocus,, % "ahk_id " this.uidedit
    }

    __new( dsn ) {

        g := this.name
        this.dsn := dsn

        Gui, %g%: +hwndwinhwnd
        Gui, %g%: Font, s10, Verdana

        Gui, %g%: Add, text,     x20    y20        h20  section, dsn
        Gui, %g%: Add, text,     xp     yp+30      h20, uid
        Gui, %g%: Add, text,     xp     yp+30      h20, pwd
        Gui, %g%: Add, Checkbox, xp     yp+30      h20  hwnddefaultcheck, Default
        Gui, %g%: Add, edit,     xs+80  ys    w300 h20  readonly          hwnddsnedit
        Gui, %g%: Add, edit,     xp     yp+30 w300 h20                    hwnduidedit
        Gui, %g%: Add, edit,     xp     yp+30 w300 h20  section           hwndpwdedit
        Gui, %g%: Add, Button,   xs+150 ys+35 w70  h25  gEventDispatcher, &Cancel
        Gui, %g%: Add, Button,   xp+80  yp    w70  h25  gEventDispatcher, &Save

        this.hwnd         := winhwnd
        this.dsnedit      := dsnedit
        this.uidedit      := uidedit
        this.pwdedit      := pwdedit
        this.defaultcheck := defaultcheck

    }

}

