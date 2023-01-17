%# view_table.tpl
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
<br>

<h2>Here are the trusses for plant id: {{plant_id}}</h2>
<br>
You may add trusses to this plant using the last row of the below table.
<br>
Ensure that all fields are completed as you won't be allowed to add your truss otherwise.
<br>
Plant colors range: 1-5
<br>
Weight estimates range: 150-150
<br>
<table border="1">
     <tr><th>truss_id</th><th>colour</th><th>last observation</th><th>weight_estimate</th></tr>
 
     %for i in range(loop):
     <tr>

        <td> {{dicti[i]["truss_id"]}}</td> 
        <td> {{dicti[i]["colour"]}}</td> 
        <td> {{dicti[i]["last_observation"]}}</td> 
        <td> {{dicti[i]["weight_estimate"]}}</td>
      %end
     </tr>
    %end
    <br>
    <form action="/relY/add/{{plant_id}}" method="POST">
    <tr> <td> <input name="truss_id" type="number" required> </td> <td> <input name="colour" min=1 max=5 type="number" required></td> <td> <input  required name="last_observation" type="datetime-local"></td> <td><input required name="weight_estimate" type="number" min=150 max=400></td></tr>
   <button type="submit">Add new values</button>
   </form>
</table>
   <div class="footer">Look above the table for button to add data</div>
   <br>
   <a href="/main">Return to search</a>
   <br>
   <br>
   
