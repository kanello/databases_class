%# view_record.tpl
<style>
    body {
        text-align:center;
        font-family: Lucida Console, Courier New, monospace;
    
    }
    table {
        margin: 0 auto

    }

    h2 {
        color: green
    }
</style>

<h2> Below is the detailed Data for {{plant_id}}</h2>
<br>
<table border="2">

<tr><th>Column Names</th><th>Data</th></tr>
<tr><td> Plant ID </td> <td> {{plant_id}} </td></tr>
<tr><td> Row ID </td> <td> {{row_id}} </td></tr>
<tr><td> Crop Variety </td> <td> {{crop_variety}} </td></tr>
<tr><td> Date Planted </td> <td> {{date_planted}} </td> </tr>

</table>


<br>
<br>
<br>
<br>
<br>

<h3>

To update the record, please change the values you'd like to change below

</h3>
<br>

<form  action="/view/{{plant_id}}" method="POST">
<table border="1">
<tr><th>Column Names</th><th>Data</th></tr>
<tr><td> Greenhouse Row ID </td> <td>
<select required name="row_id" id="g_rows">
<option disabled selected value> -- select an option -- </option>
% for i in range(len(g_rows)):
    <option value="{{g_rows[i]}}">{{g_rows[i]}}</option>
%end
</select>
</td></tr>
<tr><td> Crop Variety </td> <td> <input required value= {{crop_variety}} name="crop_variety"> </input> </td></tr>
<tr><td> Date Planted </td><td> <input type="date" required value={{date_planted}} name="date_planted"></input> </td> </tr>
</table>
<input type="submit" value="Update Record">
</form>
<br>

<a href="/main">Return to search</a>

