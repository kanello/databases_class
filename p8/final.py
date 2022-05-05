from datetime import datetime
from bottle import route, run, template, post, get, request, json_dumps, redirect
import sqlite3

#establish connections
con = sqlite3.connect('greenhouse.db')
cur = con.cursor()

    
@route('/')
def home():

    #render homepage
    return template('greenhouse_system.html')
    
@get('/main')
def show_main():
    """redirects to the search route. Have to pass some dummy data as no search has yet been completed, so want to show the user no table yet, tough my .tpl file expects some data
    """


    #we want to return the fk as a dropdown to the user
    query = cur.execute(f"select distinct row_id from plants_active")
    greenhouse_rows=[]
    for row in query.fetchall():
        greenhouse_rows.append(row[0])

    
    return template('view/search', cases=0, rows=[], row_ids='None', crop_variety='None', requested='None', results='None', g_rows=greenhouse_rows)

@post('/search')
def search():
    """The user searched for something in the search page. Data comes via form
    Returns results found for the search parameters passed through
    """
    
    #we pass these into the query later on
    #we feed these back to the user so they know what they searched for, since the data won't persist in the form
    row_id=request.forms.get('row_id')
    crop_variety=request.forms.get('crop_variety')
    limit=request.forms.get('limit')

    #in case the user hasn't specified how many entries they want
    if len(limit)==0:
        limit=20
    
    #separate queries for (COND1), (COND2), (COND1) AND (COND2), (NO CONDITIONS)
    #COND1) AND (COND2)
    if len(row_id)!=0 and len(crop_variety)!=0:
        query = cur.execute(f"select plant_id from plants_active where row_id='{row_id}' and crop_variety like '%{crop_variety}%' order by plant_id asc limit {limit}")

    #(NO CONDITIONS)
    elif len(row_id)+len(crop_variety)==0:
        query = cur.execute(f"select plant_id from plants_active order by plant_id asc limit {limit}")

    #(COND1) row_id
    elif len(crop_variety)==0:
        query = cur.execute(f"select plant_id from plants_active where row_id='{row_id}' order by plant_id asc limit {limit}")
    
    #(COND2) crop_variety
    else:
        query = cur.execute(f"select plant_id from plants_active where crop_variety like '%{crop_variety}%' order by plant_id asc limit {limit}")
        
    count = 0 #we pass this count to the user
    
    data = []
    for row in query.fetchall():
        new_tuple=str(row[0])
        data.append(new_tuple)
        count+=1
    
    #we want to return the fk as a dropdown to the user
    query = cur.execute(f"select distinct row_id from plants_active")
    greenhouse_rows=[]
    for row in query.fetchall():
        greenhouse_rows.append(row[0])

    return template('view/search', rows=data, cases=len(data), row_ids=request.forms.get('row_id'), crop_variety=request.forms.get('crop_variety'), results=count, requested=limit, g_rows=greenhouse_rows)

@get('/view/<id>')
def view(id):
    """View a specific tuple given. Pass the data through to the .tpl template
    """

    #return all columns restricted on the id
    query = cur.execute(f"select * from plants_active where plant_id='{id}'")

    for row in query.fetchall():
        new_tuple={"plant_id":row[0], "row_id":row[1], "crop_variety":row[2], "date_planted":row[3]}
    
    #we want to return the fk as a dropdown to the user
    query = cur.execute(f"select distinct row_id from plants_active")
    g_rows=[]
    for row in query.fetchall():
        g_rows.append(row[0])

    return template('view/view_record', plant_id=new_tuple["plant_id"], row_id=new_tuple["row_id"], crop_variety=new_tuple["crop_variety"], date_planted=new_tuple["date_planted"],g_rows=g_rows)
    
@post('/view/<id>')
def update(id):
    """When the user updated data from the tuple we showed them. When update complete, send them back to the search page
    """
    
    #for the query
    row_id=request.forms.get('row_id')
    print(f"row id: {row_id}")
    crop_variety=request.forms.get('crop_variety')
    date_planted=request.forms.get('date_planted')

    cur.execute(f"""
        update plants_active 
        set  
        row_id = '{row_id}', 
        crop_variety = '{crop_variety}', 
        date_planted = '{date_planted}' 
        where plant_id='{id}'""")

    #data doesn't persist if you close the server unless you commit
    con.commit()
    
    redirect(f'/view/{id}')
    
@get('/delete/<id>')
def delete (id):
    """Deletes records that the user selected. Also finds related tuples in relY table and deletes those too. Notifies user of records deleted
    """

    #we'll let the user know how many records in relY had an fk on the relX record we deleted
    #we're also going to delete those with fk on relX's pk
    query = cur.execute("select count(*) from trusses_status where plant_id='{id}'")
    count=0
    for rows in query:
        print(rows)
        count+=1


    #delete query
    cur.execute(f"delete from plants_active where plant_id='{id}'")
    cur.execute(f"delete from trusses_status where plant_id='{id}'")

    con.commit()
    return f"""
        <script>
        window.alert('Successfully deleted plant: [{id}]. {count} trusses were also deleted from the trusses table. Click OK to be redirected to search page');
        window.location.href="/main"
        </script>"""

@get('/relY/<id>')
def get_data(id):
    """Returns the records from relY where relX.id=relY.id
    """

    query = cur.execute(f"select * from trusses_status where plant_id='{id}'")
    
    data = []
    
    for row in query.fetchall():
        new_row={"truss_id":str(row[0]), "colour":row[2], "last_observation":row[3], "weight_estimate":row[8]}
        
        data.append(new_row)

    return template('view/rely', dicti=data, loop=len(data), plant_id=id)

@post('/relY/add/<id>')
def add_data(id):
    """Add a tuple in relationY, which is related to pk in relationX. When done, return the search result
    Does a check on the pk and alerts the user if they entered a pk which is already used
    """

    #get data from the form
    truss_id=request.forms.get("truss_id")
    colour=request.forms.get("colour")
    last_observation=request.forms.get("last_observation")
    weight_estimate=request.forms.get("weight_estimate")
    
    #the date time passed from the browser doesn't match what we want to add into database
    date=last_observation.split('T')
    last_observation=f"{date[0]} {date[1]}"
    

    #check that the truss_id doesn't already exist
    query = cur.execute(f"select * from trusses_status where truss_id={truss_id}")
    
    #for some reason query.rowcount was returning -1, so I bodged it
    i=0
    for row in query.fetchall():
       i+=1 

    if i:
        return f"""
        <script>
        window.alert('TRUSS ID: [{truss_id}] already exists! Click ok to go back to search page')
        window.location.href='/main'
        </script>"""

    #add the data to the table
    query = cur.execute(f"insert into trusses_status (truss_id, plant_id, colour, last_observation, harvested, harvest_job, x_coordinate, z_coordinate, weight_estimate) values ({truss_id}, '{id}', {colour}, '{last_observation}', '', '', '', '', {weight_estimate})")

    con.commit()

    redirect(f'/relY/{id}')

@post('/add/relX')
def add_to_rel_X():
    """Add a tuple into the plants_active table. 
    Shows user a popup with error if there is a pk clash
    Shows user a popup to inform of successful addition
    """

    #get data from the forms
    plant_id = request.forms.get("plant_id")
    date_planted = request.forms.get("date_planted")
    row_id = request.forms.get("row_id")
    crop_variety = request.forms.get("crop_variety")

    query = cur.execute(f"select * from plants_active where plant_id='{plant_id}'")

    i=0
    #same hacky way used in previous function
    for row in query.fetchall():
        i+=1
        print(row)


    # there already exists a plant with the ID. PK clash!
    if i>0:
        return f"""
        <script>
        window.alert('PLANT ID: [{plant_id}] already exists! Click OK to be redirected to search page');
        window.location.href="/main"
        </script>"""


    cur.execute(f"insert into plants_active (plant_id, row_id, crop_variety, date_planted) values ('{plant_id}','{row_id}','{crop_variety}', '{date_planted}')")

    con.commit()

    return f"""
        <script>
        window.alert('Successfully added plant: [{plant_id}] Click OK to be redirected to search page');
        window.location.href="/main"
        </script>"""

@get('/crop-varieties')
def get_varieties():
    """Returns available crop varieties. Helps the user figure out what they might want to search for
    """

    query = cur.execute("select distinct crop_variety from plants_active")

    data=[]
    for row in query:
        data.append(row[0])

    return template('view/crop_varieties', data=data)

    


if __name__ == '__main__':
    run(host='localhost', port=8080, debug = True)



