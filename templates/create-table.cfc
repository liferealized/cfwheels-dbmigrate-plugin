component extends="[extends]" hint="[description]" {

  public void function up() {
    createTable(name='tableName')
      .timestamps()
      .create();
  }

  public void function down() {
    dropTable('tableName');
  }
}
