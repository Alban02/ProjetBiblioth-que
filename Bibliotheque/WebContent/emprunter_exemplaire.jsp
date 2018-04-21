<%@page import="biblio.ComposantBDLivre,
                biblio.ComposantBDEmprunt,
                biblio.ComposantBDAbonne"%>
<%@ page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>
<%
  // Test de la présence du paramètre "submit-insertion" s'il est
  // présent (insererNouvelEmprunt -> true), on réalise l'insertion,
  // sinon, on affiche le formulaire de saisie.
  boolean insererNouvelEmprunt = (request.getParameter("submit-insertion") != null);
%>

<div class="row">
  <div class="col-lg-8">
    <div class="panel panel-default">
      <div class="panel-heading"><h3><i class="glyphicon glyphicon-transfer"></i> Emprunter un exemplaire</h3></div> <!-- /.panel-heading -->
      <div class="panel-body">
      <%
      if(!insererNouvelEmprunt)  // On veut l'affichage du formulaire
      {
        %>
        <div class="col-lg-offset-1 col-lg-10
                    col-xs-12">
          <form role="form" action="template.jsp" method="get">
            <input type="hidden" name="action" value="emprunter_exemplaire">
            <div class="form-group">
              <input class="form-control" placeholder="Identifiant de l'exemplaire" name="id_exemplaire"/>
            </div>
            <div class="form-group">
              <input class="form-control" placeholder="Identifiant de l'abonné" name="id_abonne"/>
            </div>
            <div class="text-center">
              <button type="submit" class="btn btn-success btn-circle btn-lg" name="submit-insertion"><i class="fa fa-check"></i></button>
              <button type="reset"  class="btn btn-warning btn-circle btn-lg"><i class="fa fa-times"></i></button>
            </div>
          </form>
        </div>
        <%
      }
      else  // On réalise l'insertion
      {
        int idExemplaire = new Integer(request.getParameter("id_exemplaire"));
        int idAbonne     = new Integer(request.getParameter("id_abonne"));
        
        ComposantBDEmprunt.emprunter(idAbonne, idExemplaire);
        
        String[] livreEmprunte = ComposantBDLivre.getLivreParIdExemplaire(idExemplaire);
        String[] abonne        = ComposantBDAbonne.getAbonne(idAbonne);
        %>
        <div class="col-xs-offset-2 col-xs-8">
          <div class="panel panel-success">
            <div class="panel-heading">
              Emprunt réalisé
            </div>
            <div class="panel-body">
              L'exemplaire du livre <strong><%=livreEmprunte[4]%> (<em>ID exemplaire = <%=idExemplaire%></em>)</strong> a été emprunté par l'abonné <strong><%=abonne[1]%> <%=abonne[2]%></strong>
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
