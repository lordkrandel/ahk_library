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
               table_owner
           from
               dbo.sp_tables()
           order by
               table_owner
           ;
        )
        query := new Query( this.odbc.conn, q )
        s := ""
        loop {
            s := s "|" query.rs.fields.item("table_owner").value
            query.rs.movenext()
        } until (query.rs.EOF)
        return s
    }
}

class tablelevel extends level{ 

    name := "Tables"

    getEntries(val){
        q =
        (
            select
               table_name
            from
              dbo.sp_tables()
            where
               upper(table_owner) = '%val%'
            order by
               table_owner,
               table_name
            ;
        )
        this.odbc.connect()
        query := new Query(this.odbc.conn, q )
        s := ""
        loop {
            s := s "|" query.rs.fields.item("table_name").value
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



