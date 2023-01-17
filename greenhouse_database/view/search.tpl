<style>
    body {
        text-align:center;
        font-family: Lucida Console, Courier New, monospace;
    
    }
    table {
        margin: 0 auto

    }

    h1 {
        color: green;
        font-size: 40;
    }

    h2 {
        color: green;
        font-size: 30;
    }

    .container {
    width: 300px;

    }

    .container input {
    width: 100%;

    }
</style>

<h1>View the tomato plants that are currently in the database</h1>
<h2>ADD A NEW PLANT TO THE DATABASE</h2>
<div style="padding-bottom:8px;" > If a plant_id which is already in use, you will be stopped and the plant won't be added. <br>Try searching for the plant_id below to check that it doesn't exist</div>
<br>
<form class="form" action="/add/relX" method="POST">
    Greenhouse Row ID 
    <select required name="row_id" id="g_rows">
    <option disabled selected value> -- select an option -- </option>
    % for i in range(len(g_rows)):
    <option value="{{g_rows[i]}}">{{g_rows[i]}}</option>
%end
</select>
    Plant ID <input required style="margin" type="text" name="plant_id">
    Date Planted <input required style="margin" type="date" name="date_planted">
    Crop Variety <input required style="margin" type="text" name="crop_variety">
      
    <input type="submit" value="Add">
</form>
<br>
<hr>
<br>
<h2>SEARCH FOR INDIVIDUAL TOMATO PLANTS</h2>
<div style="text-decoration: underline; font-size:20; padding-bottom:8px;"> RUN A SEARCH</div>
<div> Enter details in the fields below for the search you'd like to run
<br> You may find a list of greenhouse rows in the dropdown provided in add function</div>
<br>
<a href="/crop-varieties"> Lookup available crop varieties </a>
<br>
<br>

<div class="">
<form class="form" action="/search" method="POST">
    Greenhouse Row ID <input style="margin" type="text" size="10" maxlength="50" name="row_id">
    Crop Variety* <input type="text" size="20" maxlength="50" name="crop_variety">
    # of results to output <input type="number" max=20 min=1 name="limit" value="20">
    <input type="submit" value="Run search">
</form>
</div>


<br>
<hr>
<br>
<div style="text-decoration: underline; font-size:20"> SEARCH RESULTS</div>
<p>Greenhouse Row ID: {{row_ids}} | Crop Variety: {{crop_variety}} | Results Requested: {{requested}} | Results Available: {{results}}</p>
<table border="1">
 
     %for i in range(cases):
     <tr>

        <td>   {{rows[i]}}  </td> <td> <a href="view/{{rows[i]}}">View / Edit </a></td> <td> <a href="delete/{{rows[i]}}">Delete</a></td> <td> <a href="relY/{{rows[i]}}">Show trusses on this plant</a></td> <td> <a href="relY/{{rows[i]}}"> Add a truss to this plant </a></td>
      %end
     </tr>
    %end

</table>
