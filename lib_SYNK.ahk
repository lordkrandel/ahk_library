#EscapeChar \
#CommentFlag //

SYNK_filecompare(fsource, fdest){
//  Confronta due file per vedere se sono uguali                                //
//  E' possibile implementare una funzione personalizzata di compare, in modo   //
//  da includere o escludere dalla copia alcuni tipi di file. Basta ritornare   //
//  "1" se il file sorgente non è da copiare                                    //

    if (!(fileexist(fdest)))
       return 0

    FileGetSize, fsourcesize, %fsource%
    FileGetSize, fdestsize,   %fdest%
    if ( fsourcesize != fdestsize)
       return 0

    FileGetTime, fsourcetime, %fsource%
    FileGetTime, fdesttime,   %fdest%
    if ( fsourcetime != fdesttime)
       return 0

    return 1
}

SYNK_error(err, errText, byRef e){
// Semplifica la scrittura della gestione errori nelle funzioni                 //

    if (err)
        MsgBox, 0, Error, % errText

    return (e := err)
}

SYNK_countfilesizes(source){
// Determina la somma delle dimensioni dei file di una directory ricorsivamente //
    c := 0
    Loop, %source%\\*.*, 1, 1
    {
        FileGetSize, t, %A_Loopfilefullpath%
        c += t
    }
    return c
}

SYNK_dirsynk(source, dest, bak, move = 0, prog = 600, moveExceedings = 0, dateBak = 1, compare = "SYNK_filecompare"){
//  Sincronizza una directory sorgente con una destinazione salvando i file  //
//  vecchi in una cartella di backup                                         //
//  progress è la larghezza della progressbar, 0 la toglie                   //
//  moveExceedings muove in backup i file locali che non ci sono sul server  //
//  dateBak indica nella directory di backup va creata una sottocartella     //
//  con il backup attuale                                                    //

    SetBatchLines -1

    currentSize := e := 0
    if (dateBak){
        FormatTime, time,, yyyyMMdd_HHmmss
        bak .= "\\" time
    }

    // controllo se la directory sorgente esiste //
    if SYNK_error( (!fileExist(source)), "La directory sorgente \n" source "\n non esiste", e  )
        return e

    // Faccio la somma delle dimensioni dei file nella cartella   //
    // così posso tener conto di quanto ho progredito nella copia //
    totalSize   := SYNK_countfilesizes(source)

    // Creo la directory di backup //
    FileCreateDir, % bak
    if SYNK_error(ErrorLevel, "Impossibile creare la directory di backup\n" bak, e)
        return e

    if (prog)
        Progress, FM7 FS7 WM400 WS400 H90 w%prog%, _, _, SYNK

    // Se voglio muovere in backup i file locali che non ci sono sul server //
    if (moveExceeding){

        // Ciclo sui file della directory destinazione, ricorsivamente //
        // Se trovo file che non ci sono nella directory sorgente,     //
        // li sposto nella cartella di backup                          //
        Loop, %dest%\\*.*, 1,1
        {

            fdest := A_LoopFileFullPath

            // Creo i path di destinazione e di backup a partire dal file sorgente //
            StringReplace, fsource, fdest, %dest%, %source%
            StringReplace, fbak,    fdest, %dest%, %bak%

            if ( (fsource == fbak) || instr(fdest, bak, 0, 1) == 1 )
                continue

            if (! fileexist(fsource)){

                // Crea la sottodirectory, ignora l'errore se già esiste //
                SplitPath, fbak,, fbakdir
                filecreatedir, % fbakdir

                // Muovi il file / la directory //
                FileGetAttrib, attr, % fdest
                if ( inStr(attr, "D") )
                    FileMoveDir, %fdest%, %fbak%
                else
                    FileMove, %fdest%, %fbak%
                if SYNK_error(ErrorLevel, "Errore nello spostamento\nda: " fdest "\na: " fbak, e)
                    return e

            }
        }
    }

    // Ciclo sui file nella directory sorgente, ricorsivamente //
    Loop, %source%\\*.*, 1, 1
    {
        fsource := A_LoopFileFullPath

        // Creo i path di destinazione e di backup a partire dal file sorgente //
        StringReplace, fdest, fsource, %source%, %dest%
        StringReplace, fbak,  fsource, %source%, %bak%

        // Se sto cercando di copiare una directory //
        FileGetAttrib, attr, % fsource
        if ( inStr(attr, "D") ) {

            // Se non esiste nella destinazione, creala //
            if (! fileExist(fdest) ) {
                FileCreateDir, %fdest%
                if SYNK_error(ErrorLevel, A_LastError, e)
                    return e
            }

        // Se sto copiando un file //
        } else {

            if (! %compare%(fsource, fdest)){

                // Se esiste fai un backup //
                if (fileexist(fdest)){

                    // Crea la sottodirectory, ignora l'errore se già esiste //
                    SplitPath, fbak,, fbakdir
                    filecreatedir, % fbakdir

                    // Fai una copia //
                    FileCopy, %fdest%, %fbak%
                    if SYNK_error(ErrorLevel, "Errore nella copia di backup del file\nda: " fdest "\na: " fbak, e)
                        return e
                }

                // Copia/Sposta la sorgente sopra la destinazione //
                if (move)
                    FileMove, %fsource%, %fdest%, 1
                else
                    FileCopy, %fsource%, %fdest%, 1

                if SYNK_error(ErrorLevel, "Errore nella copia del file\nda: " fsource "\na: " fdest, e)
                    return e

            }

            fileGetSize, fsize, % fsource
            if SYNK_error(ErrorLevel, "Errore nel leggere le dimesioni di\n" fsource, e)
                return e
            currentSize += fsize

            if (prog){
                p := 100 * (currentSize / totalSize)
                Progress, %p%, %fsource%\n-> %fdest%, %currentsize% / %totalSize% bytes , SYNK
            }
        }

    }

    // Disabilito la progressbar se attiva //
    if (prog)
        Progress, off

    // Cancella la directory di backup se è vuota //
    FileRemoveDir, % bak

    SetBatchLines 10ms

    return e
}

//SYNK_stub(){

    if (%0% < 3) {
        Msgbox, 0, Error, % "Uso: synk.exe <sorgente> <destinazione> <backup> [move?, progressbarWidth]"
        exitApp
    }

    source = %1%
    dest   = %2%
    bak    = %3%
    move   := ( %4% ? %4% : 0 )
    prog   := ( %5% ? %5% : 600 )
    moveEx := ( %6% ? %6% : 0 )
    dateBak:= ( %7% ? %7% : 1 )

    SYNK_dirsynk( source, dest, bak, move, prog, moveEx, dateBak /*, "SYNK_filecompare"*/ )

//}
