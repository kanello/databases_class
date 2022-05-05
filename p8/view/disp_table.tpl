%# disp_table.tpl
<p>Here are the plant IDs:</p>
<table border="1">
 
     %for i in range(cases):
     <tr>

        <td> {{rows[i]}} </td> <td> <a href="view/{{rows[i]}}">View / Edit </a></td> <td> <a href="delete/{{rows[i]}}">Delete</a></td> <td> Show RelationY</td> <td> Add new RelationY </td>
      %end
     </tr>
    %end
   
</table>
