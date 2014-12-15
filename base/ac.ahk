#include <lib_CORE>
#include ac\ac.ahk
#include ac\optionsDialog.ahk
#include ac\acController.ahk

Core.init()
Menu, Tray, Icon, img\kube.ico

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

#r::
    reload
return
