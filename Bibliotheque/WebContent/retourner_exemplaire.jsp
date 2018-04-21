<%@page import="biblio.ComposantBDLivre,
                biblio.ComposantBDEmprunt"%>
<%@ page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>
<%
  // Test de la présence du paramètre "submit-insertion" s'il est
  // présent (rendreEmprunt -> true), on réalise l'insertion,
  // sinon, on affiche le formulaire de saisie.
  boolean rendreEmprunt = (request.getParameter("submit-insertion") != null);
  int idExemplaire = -1;
  String idExemplaireString = request.getParameter("id_exemplaire");
  if(idExemplaireString != null && !idExemplaireString.equals(""))
  {
    idExemplaire = new Integer(idExemplaireString);
  }
%>

<div class="row">
  <div class="col-lg-8">
    <div class="panel panel-default">
      <div class="panel-heading"><h3><i class="glyphicon glyphicon-transfer"></i> Retourner un exemplaire</h3></div> <!-- /.panel-heading -->
      <div class="panel-body">
      <%
      if(!rendreEmprunt)  // On veut l'affichage du formulaire
      {
        %>
        <div class="col-lg-offset-1 col-lg-10
                    col-xs-12">
          <form role="form" action="template.jsp" method="get">
            <input type="hidden" name="action" value="retourner_exemplaire">
            <div class="form-group">
              <input class="form-control" placeholder="Identifiant de l'exemplaire" name="id_exemplaire" <%=(idExemplaire==-1?"":"value=\"" + idExemplaire + "\"")%>/>
            </div>
            <div class="text-center">
              <button type="submit" class="btn btn-success btn-circle btn-lg" name="submit-insertion"><i class="fa fa-check"></i></button>
              <button type="reset"  class="btn btn-warning btn-circle btn-lg"><i class="fa fa-times"></i></button>
            </div>
          </form>
        </div>
        <%
      }
      else  // On réalise le retour de l'exemplaire
      {
        ComposantBDEmprunt.rendre(idExemplaire);
        
        String[] livreEmprunte = ComposantBDLivre.getLivreParIdExemplaire(idExemplaire);
        %>
        <div class="col-xs-offset-2 col-xs-8">
          <div class="panel panel-success">
            <div class="panel-heading">
              Exemplaire rendu
            </div>
            <div class="panel-body">
              L'exemplaire du livre <strong><%=livreEmprunte[4]%> (<em>ID exemplaire = <%=idExemplaire%></em>)</strong> a été rendu.
            </div>
          </div>
        </div> <!-- /.col-lg-4 -->
        <%
      
      }
      %>
      </div> <!-- /.panel-body -->
    </div> <!-- /.panel -->
  </div> <!-- /.col-lg-12 -->
</div> <!-- /.row -->
