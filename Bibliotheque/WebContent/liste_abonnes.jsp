<%@ page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>

<%@page import="biblio.ComposantBDAbonne,
                java.util.ArrayList"%>

<%
  ArrayList<String[]> abonnes = ComposantBDAbonne.listeTousLesAbonnes();
%>

<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">
      <div class="panel-heading"><h3><i class="fa fa-users"></i> Liste des abonnés</h3></div> <!-- /.panel-heading -->
      <div class="panel-body">
        <div class="dataTable_wrapper">
          <table class="table table-striped table-bordered table-hover" id="dataTables-example">
            <thead>
              <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Prénom</th>
                <th>Statut</th>
                <th>Adresse email</th>
                <th>Informations</th>
              </tr>
            </thead>
            <tbody>
              <%
              for(String[] abonne : abonnes)
              {
                %>
                <tr>
                  <td><%=abonne[0]%></td>
                  <td><strong><%=abonne[1]==null ? "" : abonne[1] %></strong></td>
                  <td><strong><%=abonne[2]==null ? "" : abonne[2] %></strong></td>
                  <td><%=abonne[3]==null ? "" : abonne[3] %></td>
                  <td><%=abonne[4]==null ? "" : "<a href=\"mailto:" + abonne[4] + "\">" + abonne[4] + "</a>" %></td>
                  <td align="center"><a href="template.jsp?action=infos_abonne&id=<%=abonne[0]%>"><i class="fa fa-eye fa-lg"></i></a></td>
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
