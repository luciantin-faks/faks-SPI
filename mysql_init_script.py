
# Init Root with new passwd
from db_setup import DbHandler

db_handler = DbHandler.DbHandler(dbtype="mysql", hostname="localhost", port="3308")


root_engine = db_handler.create_engine(username="root", password="4321")

script_file = open("./sql_script/alter_root.sql", "rt")
db_handler.run_script(engine=root_engine, script_file=script_file)

root_engine = db_handler.create_engine(username="root", password="1234")


# Create user "data" && tables

script_file = open("./sql_script/create_user_data.sql", "rt")
db_handler.run_script(engine=root_engine, script_file=script_file)


data_engine = db_handler.create_engine(username="data", password="1234")

script_file = open("./sql_script/tables_dim.sql", "rt")
results = db_handler.run_script(engine=data_engine, script_file=script_file)
print(results)


script_file = open("./sql_script/tables_init.sql", "rt")
results = db_handler.run_script(engine=data_engine, script_file=script_file)
print(results)


from db_setup import DataHandler

dataset_handler = DataHandler.Dataset(path=f'./data/DataCoSupplyChainDataset.csv', delimiter=',', encoding='ISO-8859-1')
# dataset_handler.print_pandas_tables()

tables, table_dtypes, table_insertion_order = dataset_handler.get_tables()


# Fill tables

# print(table_dtypes)

for table_name in table_insertion_order:
    print(table_name)
    print(tables[table_name][:10])
    dtype = dict(zip([tables[table_name].index.name] + tables[table_name].columns.tolist(), table_dtypes[table_name]))
    db_handler.fill_table(df=tables[table_name], table_name=table_name[6:], engine=data_engine,
                          schema="data_co_schema", dtypes=dtype);
