;; Query test class
class QueryTest extends TestBase {

	;; Constructor
	__new(a_dbfile="test.sqlite"){
		this.dbfile := a_dbfile
	}

	;; Delete the SQLite DB if already exists
	clear(){
		if fileexist(this.dbfile){
			filedelete, % this.dbfile
		}
	}

	;; test against Sqlite3 odbc driver
	run(){

		; Delete the test database if already exists
		this.clear()
		try {
			Odbc := new Odbc(new SqliteOdbcSettings(this.dbfile)).connect()
			l_ret := Odbc.statement("CREATE table T01_test(t01n_id integer, t01s_desc varchar(100));")
			l_ret := Odbc.statement("INSERT INTO T01_test VALUES (1, 'abba');")
			l_ret := Odbc.statement("INSERT INTO T01_test VALUES (2, 'ebba');")
			l_ret := Odbc.statement("INSERT INTO T01_test VALUES (3, 'boh');")
			l_ret := Odbc.statement("INSERT INTO T01_test VALUES (4, 'bih');")
			l_sql := "SELECT * FROM T01_test"
			
			; Do the query
			l_table := new Query(l_sql)    ; Declaration
				.execute()                 ; Execution
				.fetchAll()                ; Get all rows
				.map("this.toString", "|") ; Get key-values pairs as strings
				.join("`n")                ; Build a single string
			msgbox, % l_table
			
		} catch l_exc {
			; rethrow the exception
			throw l_exc
		} finally {
			; Close the connection
			Odbc := ""
			; Delete the test database
			this.clear()
		}
	}
}		
		;Odbc := new Odbc("GulliverAsaLan9", "dba", "sql").connect()
		
		; XXX: STUB, This should really be independent from my personal ODBC setup
		;; Declare the query text
		;l_sql = 
		;( 
		;	SELECT 
		;		1 as 'field_1',
		;		ID_Utente,
		;		Logon,
		;		Password,
		;		Cod_Ruolo,
		;		Abilitato,
		;		Cod_Lingua,
		;		Cod_Gruppo 
		;	FROM 
		;		smart.utente
		;	; 
		;)

		; Connect to database
		;Odbc := new Odbc("GulliverAsaLan9", "dba", "sql").connect()

		;; Do the query
		;l_table := new Query(l_sql)    ; Declaration
		;	.execute()                 ; Execution
		;	.fetchAll()                ; Get all rows
		;	.map("this.toString", "|") ; Get key-values pairs as strings
		;	.join("`n")                ; Build a single string
