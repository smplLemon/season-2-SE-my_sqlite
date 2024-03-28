import pandas as pd

class MySqliteRequest:
    def __init__(self):
        self.require_type = ""
        self.table_name = ""
        self.col_name = []
        self.where_column = {}
        self.value = {}

    @classmethod
    def from_table(cls, table_name):
        instance = cls()
        instance.table_name = table_name
        return instance

    def from_(self, table_name):
        self.table_name = table_name
        return self

    def where(self, p1, p2):
        self.where_column[p1] = p2
        return self

    def select(self, *p1):
        self.col_name = p1
        self.require_type = "select"
        return self

    def update(self, p1):
        self.table_name = p1
        self.require_type = "update"
        return self

    def insert(self, table_name):
        self.table_name = table_name
        self.require_type = "insert"
        return self

    def delete(self):
        self.require_type = "delete"
        return self

    def values(self, p1):
        self.value = p1
        return self

    def run(self):
        df = pd.read_csv(self.table_name)
        if self.require_type == "select":
            if "*" in self.col_name:
                print(df)
            else:
                print(df[list(self.col_name)])
        elif self.require_type == "insert":
            new_row = pd.DataFrame(self.value, index=[0])
            df = pd.concat([df, new_row], ignore_index=True)
            df.to_csv(self.table_name, index=False)
        elif self.require_type == "update":
            for key, value in self.value.items():
                df.loc[df[self.where_column.keys()].isin(self.where_column.values()).any(axis=1), key] = value
            df.to_csv(self.table_name, index=False)
        elif self.require_type == "delete":
            df = df[~df[self.where_column.keys()].isin(self.where_column.values()).any(axis=1)]
            df.to_csv(self.table_name, index=False)