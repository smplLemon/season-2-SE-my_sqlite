import csv
from my_sqlite_request import MySqliteRequest

def main_func(p1):
    request = MySqliteRequest()
    if "VALUES" in p1:
        string_value = p1.split('VALUES')[1].strip()
    tokens = p1.split()
    data_name = ""
    i = 0
    while i < len(tokens):
        if tokens[i] == "SELECT":
            tmp = tokens[i+1].split(",") if "," in tokens[i+1] else tokens[i+1]
            request = request.select(tmp)
        elif tokens[i] == "FROM":
            request = request.from_(tokens[i+1])
        elif tokens[i] == "WHERE":
            tmp = " ".join(tokens).split("WHERE")[-1].split("=")
            tmp = [item.strip() for item in tmp]
            request = request.where(tmp[0], tmp[1].strip("'"))
        elif tokens[i] == "INSERT" and tokens[i + 1] == "INTO":
            i += 2
            data_name = tokens[i]
            request = request.insert(tokens[i])
        elif tokens[i] == "UPDATE":
            request = request.update(tokens[i + 1])
