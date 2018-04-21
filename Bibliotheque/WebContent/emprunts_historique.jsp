<%@ page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>

<%@page import="biblio.ComposantBDEmprunt,
                java.util.ArrayList"%>

<%
  ArrayList<String[]> emprunts = ComposantBDEmprunt.listeEmpruntsHistorique();
%>

<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">
      <div class="panel-heading"><h3><i class="glyphicon glyphicon-transfer"></i> Historique des emprunts</h3></div> <!-- /.panel-heading -->
      <div class="panel-body">
        <div class="dataTable_wrapper">
          <table class="table table-striped table-bordered table-hover" id="dataTables-example">
            <thead>
              <tr>
                <th>ID exemplaire</th>
                <th>Livre</th>
                <th>Emprunteur</th>
                <th>Date emprunt</th>
                <th>Date retour</th>
              </tr>
            </thead>
            <tbody>
              <%
              for(String[] emprunt : emprunts)
              {
                %>
                <tr>
                  <td><%=emprunt[0]%></td>
                  <td>(<%=emprunt[1]%>) <strong><%=emprunt[2]%></strong> - <em><%=emprunt[3]%></em></td>
                  <td>(<%=emprunt[4]%>) <%=emprunt[5]%> <%=emprunt[6]%></td>
                  <td><%=emprunt[7]%></td>
                  <td><%=emprunt[8]%></td>
                </tr>
                <%
              }
              %>
            </tbody>
          </table>
        </div> <!-- /.table-responsive -->
      </div> <!-- /.panel-body -->
    </div> <!-- /.panel -->
  </div> <!-- /.col-lg-12 -->
</div> <!-- /.row -->
