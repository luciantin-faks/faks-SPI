import pandas as pd
from IPython.display import display, HTML
from sqlalchemy import types

dataset_db_col_names = [
    "type", "days_for_shipping_real", "days_for_shipping_scheduled", "benefit_per_order", "sales_per_customer", "delivery_status",
    "late_delivery_risk", "category_id", "category_name", "customer_city", "customer_country", "email", "fname", "customer_id", "lname",
    "passwd", "segment", "customer_state", "customer_street", "customer_zipcode", "department_id", "department_name", "latitude", "longitude", "market",
    "city", "country", "order_customer_id", "order_date", "order_id", "order_item_cardprod_id", "discount", "discount_rate", "order_item_id", "item_price", "profit_ratio", "quantity", "sales", "order_item_total", "order_profit_per_order",
    "region", "state", "status", "zipcode", "product_id", "product_category_id", "product_description", "image", "name", "product_price", "product_status", "shipping_date", "mode"]

table_schema = {
    "table_customer_geo": ["customer_id", "customer_city", "customer_country", "customer_state", "customer_street", "customer_zipcode"],
    "table_customer": ["customer_id", "fname", "lname", "email", "passwd", "segment"],
    "table_product": ["product_id", "name", "category_id", "image", "product_price", "product_status"],
    "table_shipping": ["order_id", "days_for_shipping_real", "days_for_shipping_scheduled", "shipping_date", "mode"],
    "table_product_category": ["category_id", "category_name"],
    "table_orders": ["order_id", "customer_id", "order_date", "type", "delivery_status", "late_delivery_risk", "order_profit_per_order", "benefit_per_order", "department_id"],
    "table_orders_geo": ["order_id", "city", "region", "state", "status"],
    "table_order_item": ["order_item_id", "order_id", "product_id", "discount", "discount_rate", "item_price", "profit_ratio", "quantity", "sales", "order_item_total"],
    "table_department": ["department_id", "department_name", "latitude", "longitude", "market"]
    # "table_department": ["department_id", "department_name", "market"]
}

table_dtypes = {
    "table_customer_geo": [types.Integer(), types.VARCHAR(length=45), types.VARCHAR(length=45), types.VARCHAR(length=45), types.VARCHAR(length=45), types.VARCHAR(length=45)],
    "table_customer": [types.Integer(), types.VARCHAR(length=45), types.VARCHAR(length=45), types.VARCHAR(length=45), types.VARCHAR(length=45), types.VARCHAR(length=45)],
    "table_product": [types.Integer(), types.VARCHAR(length=45), types.Integer(), types.VARCHAR(length=254), types.Float(), types.VARCHAR(length=45)],
    "table_shipping": [types.Integer(), types.Integer(), types.Integer(), types.DateTime(), types.VARCHAR(length=45)],
    "table_product_category": [types.Integer(), types.VARCHAR(length=45)],
    "table_orders": [types.Integer(), types.Integer(), types.DateTime(), types.VARCHAR(length=45), types.VARCHAR(length=45), types.Integer(), types.Float(), types.Float(), types.Integer()],
    "table_orders_geo": [types.Integer(), types.Unicode(length=45), types.Unicode(length=45), types.Unicode(length=45), types.VARCHAR(length=45)],
    "table_order_item": [types.Integer(), types.Integer(), types.Integer(), types.Float(), types.Float(), types.Float(), types.Float(), types.Float(), types.Float(), types.Float()],
    "table_department": [types.Integer(), types.VARCHAR(length=45), types.Float(precision='10,8'), types.Float(precision='10,8'), types.VARCHAR(length=45)]
    # "table_department": [types.Integer(), types.VARCHAR(length=45), types.VARCHAR(length=45)]
}

#     latitude FLOAT(12,12) NOT NULL ,
#     longitude FLOAT(12,12) NOT NULL ,

table_insertion_order = ["table_customer", "table_customer_geo", "table_product_category", "table_product", "table_department", "table_orders", "table_orders_geo", "table_order_item", "table_shipping"]


class Dataset:
    def __init__(self, path, delimiter, encoding):
        self.dataset = pd.read_csv(path, delimiter=delimiter, encoding=encoding)
        self.dataset.columns = dataset_db_col_names
        self.dataset = self.dataset.set_index('order_item_id', drop=False)

        self.dataset["shipping_date"] = self.change_date_format(self.dataset, "shipping_date")
        self.dataset["order_date"] = self.change_date_format(self.dataset, "order_date")

        self.tables = {}
        self.table_names = table_schema.keys()

        for table_name in self.table_names:
            self.tables[table_name] = self.dataset[table_schema[table_name]]

        self.tables["table_customer_geo"] = self.tables["table_customer_geo"].groupby("customer_id").first()
        self.tables["table_customer"] = self.tables["table_customer"].groupby("customer_id").first()
        self.tables["table_product"] = self.tables["table_product"].groupby("product_id").first()
        self.tables["table_department"] = self.tables["table_department"].groupby("department_id").first()
        self.tables["table_orders"] = self.tables["table_orders"].groupby("order_id").first()
        self.tables["table_orders_geo"] = self.tables["table_orders_geo"].groupby("order_id").first()

        self.tables["table_shipping"] = self.tables["table_shipping"].groupby("order_id").first()
        self.tables["table_product_category"] = self.tables["table_product_category"].drop_duplicates().set_index("category_id")
        self.tables["table_order_item"] = self.tables["table_order_item"].set_index("order_item_id")

    def get_tables(self):
        return self.tables, table_dtypes, table_insertion_order

    def print_pandas_tables(self):
        for table_name in self.table_names:
            display(HTML(self.tables[table_name][:3].to_html()))

    def DD_MM_YYYY_to_YYYY_MM_DD(self, strng):
        strng = strng.split(" ")
        time = strng[1]
        date = strng[0].split('/')
        return date[2] + '-' + date[0] + '-' + date[1] + ' ' + time

    def change_date_format(self, df, col):
        return df[col].apply(lambda date: self.DD_MM_YYYY_to_YYYY_MM_DD(date + ":00"))
