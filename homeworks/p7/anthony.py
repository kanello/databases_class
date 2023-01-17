
from bottle import route, run, template, post, get, request, json_dumps
import sqlite3

from matplotlib.pyplot import table

con = sqlite3.connect('greenhouse.db')
cur = con.cursor()


@route('/')
def home():

    # return "hello world"
    return template('greenhouse_system.html')


@route('/data-search')
def home():

    return template('data_search.html')

@route('/listall')
def hello():
    html = "<h2> all tables</h2> <br /> <table>"
    for row in cur.execute("select name from sqlite_master where type='table'"):
        html += "<tr>"
        for cell in row:
            html += "<td>" + str(cell) + "</td>"
        html += "<td><a href=\"/show/" + row[0] + "\">show metadata</a> </td>  </tr>"
    html += "</table>"
    html += "<br /><br /><br /><br /><br />"
    
    return html

@route('/show/<table_name>')
def show_table(table_name):
    table_name
    html = f"<h2> You are looking at 5 rows of table: {table_name}</h2> <br /> <table>"
    
    query = cur.execute(f"select * from {table_name} limit 5")

    column_names = list(map(lambda x: x[0], cur.description))
    html+="<h3>"
    for name in column_names:
        html += f"{name} "
    html+="</h3>"
    for row in query:
        html += "<tr>"
        for cell in row:
            html += "<td>" + str(cell) + "</td>"
        html += "</tr>"
    html += "</table>"
    html += "<br /><br /><br /><br /><br />"

    return html
    



if __name__ == '__main__':
    run(host='localhost', port=8080, debug = True)



