import sqlite3

class SQLiteInfo:
    """
    """
    def __init__(self, path_to_sqlite_db):
        """

        """
        self.path_to_sqlite_db = path_to_sqlite_db
        self.conn = sqlite3.connect(self.path_to_sqlite_db)
        self.table_names = self.get_table_names()
        self.column_details_map = self.get_column_details_map()

    def get_table_names(self):
        sql = """
        SELECT 
            name
        FROM 
            sqlite_master 
        WHERE 
            type ='table' AND 
            name NOT LIKE 'sqlite_%'
        """
        curr = self.conn.cursor()
        curr.execute(sql)
        table_names = [row[0] for row in curr.fetchall()]
        curr.close()
        return table_names

    def get_column_details_for_table(self, table_name):
        """Use the SQLite pragma table_info to get details for all the columns in a given table.
        """
        sql = "PRAGMA table_info('%s')" % table_name
        if table_name not in self.table_names:
            return [(),]
        curr = self.conn.cursor()
        curr.execute(sql)
        column_details_for_table = curr.fetchall()
        return column_details_for_table

    def get_column_details_map(self):
        """Defines and returns a dictionary that maps descriptive names to the indexes of the tuples
        in the list returned by the table_info pragma used in self.get_column_details_for_table.
        """
        column_details_map = dict(column_index=0, column_name=1, data_type=2, not_null=3, default_value=4, part_of_primary_key=5)
        return column_details_map
    
    def get_column_names_for_table(self, table_name):
        """Return a list of column names for a given table.
        """
        idx = self.column_details_map['column_name']
        column_details_for_table = self.get_column_details_for_table(table_name)
        column_names = [column_detail[idx] for column_detail in column_details_for_table]
        return column_names

    def __del__(self):
        self.conn.close()

if __name__ == '__main__':
    db_info = SQLiteInfo('/Users/mfm45656/databases/sqlite/genes.db')
    print(db_info.get_table_names())
    print(db_info.get_column_names_for_table('hugo_genes'))
    #del sql_cli
    #import os
    #print(os.listdir('.'))