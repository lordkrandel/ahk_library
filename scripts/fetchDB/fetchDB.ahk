#include <LIB_CORE>
#include <LIB_FILE>
#include <LIB_G_SINGLESELECT>
#include <LIB_XCOPY>

global Settings

;Xcopy.copy("D:\home\tmp\20141121\source", "d:\home\tmp\20141121\dest")

; Recupero il parametro cliente
l_cliente = %1%
FetchDB := new FetchDB()
FetchDB.selectConfig()

; Il mio dialogo di selezione deve chiudere 
class configSelector extends selectDialog{
    title := "FetchDB - Seleziona il cliente"
    done(){
        FetchDB.start(this.returnValue)
        ExitApp
    }
    escape(){
        ExitApp
    }
}


class FetchDB {

    selectConfig(){
        l_files := "D:\home\github\ahk_library\scripts\fetchDB\config\*.json".getfiles()
        l_files := Obj.map(l_files, "FetchDB.cleanupName")
        (new configSelector(l_files)).show()
    }
    
    cleanupName( a_file){
        Msgbox, % "a_test " a_test " a_file " a_file
        return a_file.basename().noextension()
    }

    start(a_cliente){

        try{
            ; Setup dei parametri generali
            this.setup(a_cliente)
        
            ; Apro il file di log
            Log := new Log(Settings.logfile)
            Log.start()
            
            ; Se indicato, recupero l'ultimo DB
            if (Settings.fetch){
                this.fetch()
            }

            ; Avvio il DB
            this.run()

            ; Fermo il log
            Log.stop()        
      
        } catch e {

            if (Log.files){
                l_err := "%s()::%s | %s".fmt(e.what, e.line, e.message)
                Log.error(l_err)
            } else {
                Msgbox, % e.message
            }

        }
    }

    setup(a_cliente){
    
        ; Creo il path JSON
        JSON := new JsonParser(A_Scriptdir "\" "json.js")

        ; Recupero le impostazioni 
        l_settings := JSON.load(A_Scriptdir "\" "fetchdb.json")

        ; Inizializzo i settings cliente
        l_settings_cliente := A_Scriptdir "\" l_settings.config.fmt(a_cliente)
        l_settings := Core.merge(l_settings, JSON.load(l_settings_cliente))

        ; In base alla versione ASA, recupero le configurazioni aggiuntive per il Database
        l_settings_db := A_Scriptdir "\" l_settings.settings_asa.fmt(l_settings.db_versione)
        l_settings := Core.merge(l_settings, JSON.load(l_settings_db))

        ; Unisco tutte le configurazioni
        Settings := l_settings
        
    }

    ; Callback per filtrare da una lista di file per estensione
    filterByExtensions(a_path, a_extensions) {
        return a_path.extension().in(a_extensions)
    }

    run(){
        ; Lancio il database
        l_dest_com := Settings.dest "\" Settings.source_com.basename()
        l_dest_sem := Settings.dest "\" Settings.source_sem.basename()

        Log.debug("Lancio il database")
        l_run := Settings.db_runstring.fmt( "" 
               . Settings.db_exe
               , Settings.db_parms
               , Settings.db_servername
               , Settings.dest "\gulliver.db"
               , l_dest_com
               , l_dest_sem)
        Log.debug(l_run)
        Run, % l_run,, HIDE
    }

    
    fetch() {

        ; Recupero l'ultimo db dalla cartella del cliente
        l_dbarchive := ""
        {
            Log.debug("Recupero l'ultimo DB dalla cartella " Settings.source)
            l_files  := ( Settings.source "\*.*").getfiles()

            l_files  := Obj.filter(l_files, "FetchDB.filterByExtensions", Settings.archive_ext)

            ; Trovo il file più nuovo nella cartella DB
            for k, v in l_files {
                l_current := v.mtime()
                if (l_current > l_max) {
                    l_max  := l_current
                    l_name := v
                }
            }
            if (!l_name){
                throw Exception("Ultimo DB " Settings.cliente " non trovato")
            }
            l_dbarchive := l_name                
            Log.debug("Trovato " l_dbarchive ", data " l_dbarchive.mtime() )
        }

        ; Creo una copia di backup, rinominando la vecchia cartella
        {
            l_backup := Settings.dest "_" A_Now
            Log.debug("Backup della vecchia cartella " Settings.dest " -> " l_backup)
            If FileExist(Settings.dest) {
                try {
                    FileMoveDir, % Settings.dest, % l_backup, R
                } catch le {
                    throw Exception("Impossibile fare il backup della cartella " Settings.dest)
                }
            }
        }
        ; Creo una nuova cartella destinazione
        {
            Log.debug("Creo una nuova directory di destinazione " Settings.dest)
            FileCreateDir, % Settings.dest
        }
        
        ; Recupero il nome del file che avrà quando verrà copiato
        ; Copio il database compresso, overwrite
        {
            l_dbarchive_dest := Settings.dest "\" l_dbarchive.basename()
            Log.debug("Copio il database da %s a %s".fmt(l_dbarchive, l_dbarchive_dest))
            FileCopy, % l_dbarchive, % l_dbarchive_dest, 1
            l_dbarchive := l_dbarchive_dest
            Log.debug("Il nuovo file archivio è ora " l_dbarchive)
        }

        ; Scompatto il file all'interno della cartella
        {
            Log.debug("Scompatto il database in " l_dbarchive)
            l_run := "%s e -y %s".fmt(Settings.7zip.qq(), l_dbarchive.qq())
            Log.debug(l_run)
            RunWait, %l_run%, % Settings.dest, Hide
        }

        ; Creo la directory Cestino 
        {
            l_cestino := "%s\%s".fmt(Settings.dest, Settings.cestino)
            Log.debug("Creo la directory cestino " l_cestino)
            FileCreateDir, % l_cestino
        }

        ; Elimino tutti i file inutili, o rinomino facendo la lower 
        {
            Log.debug("Elimino i file inutili, o rinomino facendo la lower ")
            Loop, % Settings.dest "\*.*"
            {

                l_current := a_LoopFileFullPath.basename()
                l_source  := Settings.dest "\" l_current

                ; Se non è un file del db, spostalo nel cestino
                if (! l_current.extension().in(Settings.db_ext) ) {
                    Log.debug("%-60s -> %s\%s".fmt(l_current, Settings.cestino, l_current))
                    l_dest := "%s\%s\%s".fmt(Settings.dest, Settings.cestino, l_current)
                    FileMove, % l_source, % l_dest, R

                ; Se ha un nome con maiuscole, ne faccio la lower
                } else if (regexmatch(l_current, "[A-Z]+")){
                    Log.debug("%-60s -> %s ".fmt(l_current, l_current.toLower()))
                    l_dest := Settings.dest "\" l_current.toLower()
                    FileMove, % l_source, % l_dest, R
                }
            }
        }

        ; Tolgo attributi inutili a file e cartelle
        {
            Log.debug("Tolgo attributi inutili a file e cartelle")
            FileSetAttrib, -RASHT, % Settings.dest, 1
        }
        
        ; Controllo se esistono le comunicazioni, altrimenti le copio
        {            
            if ( !(Settings.dest "\" Settings.source_com.basename()).hasfiles() ) {
                Log.debug("DB Comunicazioni non trovato")
                Log.debug("%-60s -> %s".fmt(Settings.source_com, Settings.dest))
                FileCopy, % Settings.source_com, % Settings.dest
            }
        }

        ; Controllo se esiste il semaforo, altrimenti lo copio
        {            
            if ( !(Settings.dest "\" Settings.source_sem.basename() ).hasfiles() ) {
                Log.debug("DB Semaforo non trovato")
                l_source := l_asa["source_sem"]
                Log.debug("%-60s -> %s".fmt(l_source, Settings.dest))
                FileCopy, % l_source, % Settings.dest
            }
        }
    }
}
