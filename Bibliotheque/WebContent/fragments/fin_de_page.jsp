<%@page import="biblio.ComposantBDEmprunt,
                java.util.HashMap,
                java.util.Collections,
                java.util.ArrayList,
                java.util.Date,
                java.text.DateFormat,
                java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>

<%
  String dataForChart = "";

  HashMap<String, int[]> stats = ComposantBDEmprunt.statsEmprunts();
  if(stats.size() > 0)
  {
    int MILLISEC_PER_DAY = 86400000;
    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); 
    ArrayList<String> sortedKeys = new ArrayList<String>(stats.keySet()); 
    Collections.sort(sortedKeys);
    
    Date previousDate = new Date(dateFormat.parse(sortedKeys.get(0)).getTime() - MILLISEC_PER_DAY);
    String today = dateFormat.format(new Date());
    boolean end = false;
    int index = 0;
    while(true)
    {
      Date nextDate = new Date(previousDate.getTime() + MILLISEC_PER_DAY);
      if(index >= sortedKeys.size())
      {
        if(today.equals(dateFormat.format(nextDate)))
        {
          dataForChart += "{ jour: '" + today + "', emprunts: 0, retours: 0 },\n";
          break;
        }
        else
          dataForChart += "{ jour: '" + dateFormat.format(nextDate) + "', emprunts: 0, retours: 0 },\n";
      }
      else
      {
        String nextDateStats = sortedKeys.get(index);
        if(nextDateStats.equals(dateFormat.format(nextDate)))
        {
          dataForChart += "{ jour: '" + nextDateStats + "', emprunts: " + stats.get(nextDateStats)[0] + ", retours: " + stats.get(nextDateStats)[1] + " },\n";
          index++;
        }
        else
          dataForChart += "{ jour: '" + dateFormat.format(nextDate) + "', emprunts: 0, retours: 0 },\n";

        if(today.equals(dateFormat.format(nextDate)))
          break;
      }
      previousDate = nextDate;
    }
    //System.out.println(dataForChart);
  }
%>
 
<style type="text/css">
  <!--
    /* CSS used here will be applied after bootstrap.css */
    .navbar
    {
      background-image: url('/bibliotheque/images/livre.png');
      background-position: right;
      /* background-position: top; */
      background-repeat: no-repeat;
      height: 150px;
    }
    .sidebar
    {
      margin-top: 151px;
    }
    .navbar-toggle {
      background-color: #959595;
    }
  -->
</style>

<!-- jQuery -->
<script src="bootstrap/bower_components/jquery/dist/jquery.min.js"></script>

<!-- Bootstrap Core JavaScript -->
<script src="bootstrap/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>

<!-- Metis Menu Plugin JavaScript -->
<script src="bootstrap/bower_components/metisMenu/dist/metisMenu.min.js"></script>

<!-- DataTables JavaScript -->
<script src="bootstrap/bower_components/datatables/media/js/jquery.dataTables.min.js"></script>
<script src="bootstrap/bower_components/datatables-plugins/integration/bootstrap/3/dataTables.bootstrap.min.js"></script>

<!-- Custom Theme JavaScript -->
<script src="bootstrap/dist/js/sb-admin-2.js"></script>

<script src="bootstrap/bower_components/raphael/raphael-min.js"></script>
<script src="bootstrap/bower_components/morrisjs/morris.min.js"></script>


<!-- Page-Level Demo Scripts - Tables - Use for reference -->
<script>
	$(document).ready(function() {
	    $('#dataTables-example').DataTable({
	            responsive: true
	  });
	});
</script>

<script>
	Morris.Line({
	    // ID of the element in which to draw the chart.
	    element: 'mouvements_bibliotheque',
	    // Chart data records -- each entry in this array corresponds to a point on
	    // the chart.
	    
      data: [<%=dataForChart%>],
	    // The name of the data record attribute that contains x-values.
	    xkey: 'jour',
	    // A list of names of data record attributes that contain y-values.
	    ykeys: ['emprunts','retours'],
	    // Labels for the ykeys -- will be displayed when you hover over the
	    // chart.
	    labels: ['Nombre d\'emprunts','Nombre de retours']
	  });
</script>
