#include <lib_odbc>

class level {
    odbc := ""
    __new(odbc){

        this.odbc := odbc
    }
    getDefault(){
        return 0
    }
}

class dsnlevel extends level{
    name := "DSN"

    getEntries( val = ""){
        return % "|" "|".join( OdbcReg.dsnList )
    }

    getDefault(){
        return OdbcReg.default.dsn
    }

}

class ownerlevel extends level{
    name := "Owner"
    getDefault(){
        return OdbcReg.default.owner
    }

    getEntries( val ){

        try {

            this.odbc.settings := OdbcReg.loadDsn(val)
            this.odbc.connect()

        } catch e {
            throw e
        }

        q =
        (
            select distinct
               creator
            from
               sys.syscatalog
            order by
               creator
            ;
        )
        query := new Query( this.odbc.conn, q )
        s := ""
        loop {
            s := s "|" query.rs.fields.item("creator").value
            query.rs.movenext()
        } until (query.rs.EOF)
        return s
    }
}

class tablelevel extends level{ 

    name := "Tables"

    getEntries(val){

        val := val.toUpper()
        q =
        (
            select
               creator,
               tname
            from
               sys.syscatalog
            where
               upper(creator) = '%val%'
            order by
               creator,
               tname
            ;
        )
        this.odbc.connect()
        query := new Query(this.odbc.conn, q )
        s := ""
        loop {
            s := s "|" query.rs.fields.item("tname").value
            query.rs.movenext()
        } until (query.rs.EOF)
        return s

    }
}

class columnlevel extends level{
    name := "Columns"

    getEntries( val ){
        q =
        (
            select
                column_name
            from
                 sys.syscolumn
                    join sys.systable
            where
                table_name = '%val%'
            order by
                column_id
            ;
        )
        this.odbc.connect()
        query := new Query(this.odbc.conn, q )
        s := ""
        loop {
            s := s "|" query.rs.fields.item("column_name").value
            query.rs.movenext()
        } until (query.rs.EOF)
        return s
    }
}

