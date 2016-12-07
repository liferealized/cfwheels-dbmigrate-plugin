<cfcomponent extends="Abstract">

	<cfset variables.sqlTypes = {}>
	<cfset variables.sqlTypes['binary'] = {name='BYTEA'}>
	<cfset variables.sqlTypes['boolean'] = {name='BOOLEAN'}>
	<cfset variables.sqlTypes['char'] = {name='CHARACTER',limit=64}>
	<cfset variables.sqlTypes['date'] = {name='DATE'}>
	<cfset variables.sqlTypes['datetime'] = {name='TIMESTAMP'}>
	<cfset variables.sqlTypes['decimal'] = {name='DECIMAL'}>
	<cfset variables.sqlTypes['float'] = {name='FLOAT'}>
	<cfset variables.sqlTypes['integer'] = {name='INTEGER'}>
	<cfset variables.sqlTypes['ipaddress'] = {name='INET'}>
	<cfset variables.sqlTypes['bigInteger'] = {name='BIGINT'}>
	<cfset variables.sqlTypes['string'] = {name='CHARACTER VARYING',limit=255}>
	<cfset variables.sqlTypes['text'] = {name='TEXT'}>
	<cfset variables.sqlTypes['time'] = {name='TIME'}>
	<cfset variables.sqlTypes['timestamp'] = {name='TIMESTAMP'}>

	<cffunction name="adapterName" returntype="string" access="public" hint="name of database adapter">
		<cfreturn "PostgreSQL">
	</cffunction>

	<cffunction name="addForeignKeyOptions" returntype="string" access="public">
		<cfargument name="sql" type="string" required="true" hint="column definition sql">
		<cfargument name="options" type="struct" required="false" default="#StructNew()#" hint="column options">
		<cfscript>
			arguments.sql = arguments.sql & " FOREIGN KEY (" & arguments.options.column & ")";
			if (StructKeyExists(arguments.options, "referenceTable")){
				if (StructKeyExists(arguments.options, "referenceColumn")){
					arguments.sql = arguments.sql & " REFERENCES ";
					arguments.sql = arguments.sql & arguments.options.referenceTable;
					arguments.sql = arguments.sql & " (" & arguments.options.referenceColumn & ")";
				}
			}
			for (loc.item in listToArray("onUpdate,onDelete"))
				{
					if (len(arguments.options[loc.item]))
					{
						switch (arguments.options[loc.item])
						{
							case "none":
								arguments.sql = arguments.sql & " " & uCase(humanize(loc.item)) & " NO ACTION";
								break;

							case "null":
								arguments.sql = arguments.sql & " " & uCase(humanize(loc.item)) & " SET NULL";
								break;

							default:
								arguments.sql = arguments.sql & " " & uCase(humanize(loc.item)) & " CASCADE";
								break;
						}
					}
				}

		</cfscript>
		<cfreturn arguments.sql>
	</cffunction>

	<cffunction name="addPrimaryKeyOptions" returntype="string" access="public">
		<cfargument name="sql" type="string" required="true" hint="column definition sql">
		<cfargument name="options" type="struct" required="false" default="#StructNew()#" hint="column options">
		<cfscript>
		if (StructKeyExists(arguments.options, "autoIncrement") && arguments.options.autoIncrement)
			arguments.sql = ReplaceNoCase(arguments.sql, "INTEGER", "SERIAL", "all");

		arguments.sql = arguments.sql & " PRIMARY KEY";
		</cfscript>
		<cfreturn arguments.sql>
	</cffunction>

	<!--- postgres does not quote table names --->
	<cffunction name="quoteTableName" returntype="string" access="public" hint="surrounds table or index names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfreturn "#Replace(arguments.name,".","`.`","ALL")#">
	</cffunction>

	<!--- postgres uses double quotes --->
	<cffunction name="quoteColumnName" returntype="string" access="public" hint="surrounds column names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfreturn '"#arguments.name#"'>
	</cffunction>

	<!--- createTable - use default --->

	<cffunction name="renameTable" returntype="string" access="public" hint="generates sql to rename a table">
		<cfargument name="oldName" type="string" required="true" hint="old table name">
		<cfargument name="newName" type="string" required="true" hint="new table name">
		<cfreturn "ALTER TABLE #quoteTableName(arguments.oldName)# RENAME TO #quoteTableName(arguments.newName)#">
	</cffunction>

	<!--- dropTable - use default --->

	<!--- NOTE FOR addColumnToTable & changeColumnInTable
		  Rails adaptor appears to be applying default/nulls in separate queries
		  Need to check if that is necessary --->
	<!--- addColumnToTable - ? --->
	<!--- changeColumnInTable - ? --->

	<!--- renameColumnInTable - use default --->

	<!--- dropColumnFromTable - use default --->

	<!--- addForeignKeyToTable - use default --->

	<cffunction name="dropForeignKeyFromTable" returntype="string" access="public" hint="generates sql to add a foreign key constraint to a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="keyName" type="any" required="true" hint="foreign key name">
		<cfreturn "ALTER TABLE #quoteTableName(LCase(arguments.name))# DROP CONSTRAINT #quoteTableName(arguments.keyname)#">
	</cffunction>

	<!--- foreignKeySQL - use default --->

	<!--- addIndex - use default --->

	<!--- removeIndex - use default --->

</cfcomponent>
