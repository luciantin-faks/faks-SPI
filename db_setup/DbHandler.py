import sqlalchemy as sqla
from sqlalchemy import text
import pandas as pd
from string import Template

import pymysql
pymysql.install_as_MySQLdb()

class DbHandler:
    def __init__(self, dbtype, hostname, port):
        self.URL_TEMPLATE = Template("${dbtype}://${username}:${password}@${hostname}:${port}/?charset=utf8mb4")
        self.dbtype = dbtype
        self.hostname = hostname
        self.port = port

    def run_script(self, engine, script_file):
        script = script_file.read()
        script = script.split(';')
        script = list(filter(lambda line: len(line) > 2 and line[0] != '-', script))
        script = list(map((lambda x: x.replace('\n', '')), script))
        script = list(filter(lambda line: len(line) > 2 and line[0] != '-', script))  # ??

        results = []
        for cmd in script:
            results.append(engine.execute(text(cmd).execution_options(autocommit=True)))

        return results

    def create_engine(self, username, password):
        url = self.URL_TEMPLATE.substitute(port=self.port, dbtype=self.dbtype, username=username, hostname=self.hostname, password=password)
        return sqla.create_engine(url)

    def fill_table(self, df, table_name, engine, schema, dtypes):
        # engine.execute(text(f"USE ${str(schema)};").execution_options(autocommit=True))
        response = df.to_sql(name=table_name, con=engine, schema=schema, if_exists='append', index=True, chunksize=100, dtype=dtypes, method='multi')
        return response

# import sqlalchemy as sqla
# from sqlalchemy import text
# url = "mysql://root:4321@localhost:3308"
# url = "mysql://root:4321@/db?host=/run/mysqld"
# eng = sqla.create_engine(url)
# eng.execute(text("show tables"))

