component extends="[extends]" hint="[description]" {

  public void function up() {
    changeColumn(table='tableName', columnType='', columnName='columnName', default='', null=true);
  }

  public void function down() {
    changeColumn(table='tableName',columnName='columnName');
  }
}
