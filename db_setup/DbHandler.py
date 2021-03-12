import sqlalchemy as sqla
from sqlalchemy import text
import pandas as pd
from string import Template


class DbHandler:
    def __init__(self, dbtype, hostname, port):
        # engine_root = sqla.create_engine("mysql://root:4321@localhost:3308/")
        self.URL_TEMPLATE = Template("${dbtype}://${username}:${password}@${hostname}:${port}/")

    def run_script(self, engine, script_src):
        script_file = open(script_src, "rt")
        script = script_file.read()
        script = script.split(';')
        script = list(filter(lambda line: len(line) > 2 and line[0] != '-', script))
        script = list(map((lambda x: x.replace('\n', '')), script))
        script = list(filter(lambda line: len(line) > 2 and line[0] != '-', script))

        for cmd in script:
            result = engine.execute(text(cmd).execution_options(autocommit=True))

    def fill_table(self, df, table_name, engine):
        response = df.to_sql()
        return response

    def DD_MM_YYYY_to_YYYY_MM_DD(self, strng):
        strng = strng.split(" ")
        time = strng[1]
        date = strng[0].split('-')
        return date[2] + '-' + date[0] + '-' + date[1] + ' ' + time

    def change_date_format(self, df, col):
        return df[col].apply(lambda date: self.DD_MM_YYYY_to_YYYY_MM_DD(date.replace('/', '-') + ":00"))
