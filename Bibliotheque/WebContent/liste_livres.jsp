<%@ page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>

<%@page import="biblio.ComposantBDLivre,
                java.util.ArrayList"%>

<%
  ArrayList<String[]> livres = ComposantBDLivre.listeTousLesLivres();
%>

<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">
      <div class="panel-heading"><h3><i class="glyphicon glyphicon-book"></i> Liste des livres</h3></div> <!-- /.panel-heading -->
      <div class="panel-body">
        <div class="dataTable_wrapper">
          <table class="table table-striped table-bordered table-hover" id="dataTables-example">
            <thead>
              <tr>
                <th>ID</th>
                <th>ISBN10</th>
                <th>ISBN13</th>
                <th>Titre</th>
                <th>Auteur</th>
                <th>Informations</th>
              </tr>
            </thead>
            <tbody>
              <%
              for(String[] livre : livres)
              {
                %>
                <tr>
                  <td><%=livre[0]%></td>
                  <td><%=livre[1]==null ? "" : livre[1] %></td>
                  <td><%=livre[2]==null ? "" : livre[2] %></td>
                  <td><strong><%=livre[3]%></strong></td>
                  <td><%=livre[4]%></td>
                  <td align="center"><a href="template.jsp?action=infos_livre&id=<%=livre[0]%>"><i class="fa fa-eye fa-lg"></i></a></td>
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
