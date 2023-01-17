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

    .container {
    width: 300px;

    }

    .container input {
    width: 100%;

    }
</style>

<h1> Tomato Varieties currently in the database</h1>

<table border="1">
 
     %for i in range(len(data)):
     <tr>

        <td>   {{data[i]}}  </td> 
      %end
     </tr>
    %end

</table>
<br>
<br>
<br>
<h3>Here are some real tomato varieties if you want to add some to the table</h3>
<br>
Click on the links to see more.
<br>
<br>
<table border="2">

<tr> <td> <a href="">sunstream</a></td></tr>
<tr> <td> <a href="https://freshproduce.hazera.com/products1/summer-sun/">sumersun</a></td></tr>
<tr> <td> <a href="https://www.rijkzwaan.co.uk/find-your-variety/tomato/roterno-rz">roterno</a></td></tr>
<tr> <td> <a href="https://www.prominent-tomatoes.nl/en/de-tomaat/assortiment/roma/">roma</a></td></tr>

<tr> <td> <a href="https://duijvestijntomaten.nl/en/our-products/our-tomatovarieties/">romindo</a></td></tr>
</table>
<br>

If you want to go down the rabbit hole...<a href="https://www.notion.so/anthonyk/Syngenta-Tomato-Varieties-ba4d9f63269e4876a98ccbc96d0b3cc7">here's a lot more about tomato varieties </a>
<br>
<br>
<br>
<a href="/main">Return to search</a>