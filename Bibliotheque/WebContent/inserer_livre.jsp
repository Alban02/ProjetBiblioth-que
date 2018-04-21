<%@ page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>

<%@page import="biblio.ComposantBDLivre"%>

<%
  // Test de la présence du paramètre "submit-insertion" s'il est
  // présent (insererNouveauLivre -> true), on réalise l'insertion,
  // sinon, on affiche le formulaire de saisie.
  boolean insererNouveauLivre = (request.getParameter("submit-insertion") != null);
%>

<div class="row">
  <div class="col-lg-8">
    <div class="panel panel-default">
      <div class="panel-heading"><h3><i class="glyphicon glyphicon-book"></i> Insérer un nouveau livre</h3></div> <!-- /.panel-heading -->
      <div class="panel-body">
      <%
      if(!insererNouveauLivre)  // On veut l'affichage du formulaire
      {
        %>
			  <div class="col-lg-offset-1 col-lg-10
			              col-xs-12">
	        <form role="form" action="template.jsp" method="get">
	          <input type="hidden" name="action" value="inserer_livre">
            <div class="form-group">
              <!-- <label>Titre</label> -->
              <input class="form-control" placeholder="Titre" name="titre">
            </div>
            <div class="form-group">
              <!-- <label>Auteur</label> -->
              <input class="form-control" placeholder="Auteur" name="auteur">
            </div>
	          <div class="form-group">
	            <!-- <label>ISBN 10</label> -->
	            <input class="form-control" placeholder="ISBN 10" name="isbn10">
	          </div>
	          <div class="form-group">
	            <!-- <label>ISBN 13</label> -->
	            <input class="form-control" placeholder="ISBN 13" name="isbn13">
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
        String isbn10 = request.getParameter("isbn10");
        String isbn13 = request.getParameter("isbn13");
        String titre  = request.getParameter("titre");
        String auteur = request.getParameter("auteur");
        
        int idLivre = ComposantBDLivre.insererNouveauLivre(isbn10, isbn13, titre, auteur);
        
        if(idLivre == -1)
        {
          %>
                 <div class="alert alert-danger
                             col-xs-offset-2 col-xs-8
                             text-center">
                         <h3>Impossible de traiter la demande,<br/><br/>
                         <em>La fonctionnalité d'insertion d'un nouveau livre n'est pas encore implémentée.</em></h3>
                 </div>
          <%
        }
        else
        {
          String[] livre = ComposantBDLivre.getLivre(idLivre);
          %>
          <div class="col-xs-offset-2 col-xs-8">
            <div class="panel panel-success">
              <div class="panel-heading">
                Le livre a bien été inséré
              </div>
              <div class="panel-body">
                <table>
                  <tr>
                    <td><strong>ID : </strong></td>
                    <td>&nbsp;<%=livre[0]%></td>
                  </tr>
                  <tr>
                    <td><strong>Titre : </strong></td>
                    <td>&nbsp;<%=livre[3]%></td>
                  </tr>
                  <tr>
                    <td><strong>Auteur : </strong></td>
                    <td>&nbsp;<%=livre[4]%></td>
                  </tr>
                  <tr>
                    <td><strong>ISBN10 : </strong></td>
                    <td>&nbsp;<%=livre[1]%></td>
                  </tr>
                  <tr>
                    <td><strong>ISBN13 : </strong></td>
                    <td>&nbsp;<%=livre[2]%></td>
                  </tr>
                </table>
                <div class="col-xs-offset-4 col-xs-4
                            text-center">
                  <button type="button" class="btn btn-success"
                          onclick="window.location.href='template.jsp?action=infos_livre&id=<%=livre[0]%>'">
                    Consulter sa fiche
                  </button>
                </div>
              </div>
            </div>
          </div> <!-- /.col-lg-4 -->
          <%
        }
      }
      %>
      </div> <!-- /.panel-body -->
    </div> <!-- /.panel -->
  </div> <!-- /.col-lg-12 -->
</div> <!-- /.row -->
