#include %A_Scriptdir%
#include <lib_CORE>
Core.init()

#include ac\ac.ahk
#include ac\optionsDialog.ahk
#include ac\acController.ahk

:?*:dba.::
!Space::
    ; Exclude Powerbuilder_treeview
    ControlGetFocus, l_output, A
    if (instr(l_output, "PBTreeView32") == 1) {
        return
    }
    if !(ac) {
        ac := new AutoComplete()
    }
    ac.controller.lastHwnd := WinActive("A")
    ac.controller.setHotkey(A_thishotkey)
    ac.show()
return

:?*:dba,::
    Send dba.
return

