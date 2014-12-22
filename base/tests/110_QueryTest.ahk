;; Query test class
class QueryTest extends TestBase {

	; test a simple query
	run(){
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
	}

}