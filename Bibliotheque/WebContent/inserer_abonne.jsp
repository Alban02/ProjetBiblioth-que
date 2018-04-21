<%@page import="biblio.ComposantBDAbonne"%>
<%@ page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>
<%
  // Test de la présence du paramètre "submit-insertion" s'il est
  // présent (insererNouvelAbone -> true), on réalise l'insertion,
  // sinon, on affiche le formulaire de saisie.
  boolean insererNouvelAbonne = (request.getParameter("submit-insertion") != null);
%>

<div class="row">
  <div class="col-lg-8">
    <div class="panel panel-default">
      <div class="panel-heading"><h3><i class="fa fa-users"></i> Insérer un nouvel abonné</h3></div> <!-- /.panel-heading -->
      <div class="panel-body">
      <%
      if(!insererNouvelAbonne)  // On veut l'affichage du formulaire
      {
        %>
			  <div class="col-lg-offset-1 col-lg-10
			              col-xs-12">
	        <form role="form" action="template.jsp" method="get">
	          <input type="hidden" name="action" value="inserer_abonne">
            <div class="form-group">
              <input class="form-control" placeholder="Nom" name="nom">
            </div>
            <div class="form-group">
              <input class="form-control" placeholder="Prénom" name="prenom">
            </div>
	          <div class="form-group">
							<select class="form-control" name="statut">
						    <option>Etudiant</option>
						    <option>Enseignant</option>
							</select>
	          </div>

	          <div class="form-group">
	            <input class="form-control" placeholder="Adresse email" name="email">
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

        String nom    = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String statut = request.getParameter("statut");
        String email  = request.getParameter("email");
        
        int idAbonne = ComposantBDAbonne.insererNouvelAbonne(nom, prenom, statut, email);
        
        if(idAbonne == -1)
        {
          %>
                 <div class="alert alert-danger
                             col-xs-offset-2 col-xs-8
                             text-center">
                         <h3>Impossible de traiter la demande,<br/><br/>
                         <em>La fonctionnalité d'insertion d'un nouvel abonné n'est pas encore implémentée.</em></h3>
                 </div>
          <%
        }
        else
        {
          String[] abonne = ComposantBDAbonne.getAbonne(idAbonne);
          %>
          <div class="col-xs-offset-2 col-xs-8">
            <div class="panel panel-success">
              <div class="panel-heading">
                L'abonné a bien été inséré
              </div>
              <div class="panel-body">
                <table>
                  <tr>
                    <td><strong>ID : </strong></td>
                    <td>&nbsp;<%=abonne[0]%></td>
                  </tr>
                  <tr>
                    <td><strong>Nom : </strong></td>
                    <td>&nbsp;<%=abonne[1]%></td>
                  </tr>
                  <tr>
                    <td><strong>Prénom : </strong></td>
                    <td>&nbsp;<%=abonne[2]%></td>
                  </tr>
                  <tr>
                    <td><strong>Statut : </strong></td>
                    <td>&nbsp;<%=abonne[3]%></td>
                  </tr>
                  <tr>
                    <td><strong>Adresse email : </strong></td>
                    <td>&nbsp;<%=abonne[4]%></td>
                  </tr>
                </table>
                <div class="col-xs-offset-4 col-xs-4
                            text-center">
                  <button type="button" class="btn btn-success"
                          onclick="window.location.href='template.jsp?action=infos_abonne&id=<%=abonne[0]%>'">
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
