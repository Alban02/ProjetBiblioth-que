<%@ page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>

<%@page import="biblio.ComposantBDLivre,
                biblio.ComposantBDEmprunt,
                java.util.List"%>

<%
	String  erreur = null;
  boolean livreSupprime = false;
  // Test de la validité du paramètre id.
  String idStringValue = request.getParameter("id");
  int id = -1;
  String[] livre = null;
  if(idStringValue == null)
  {
    erreur = "La valeur de l'ID du livre n'est pas spécifiée dans les paramètres.";
  }
  else
  {
    try
    {
      id = new Integer(idStringValue);
      // C'est OK : on a bien un id
      if(request.getParameter("submit-modification") != null) // Si le paramètre est présent,
      {                                                       // on veut modifier le livre.
        String isbn10 = request.getParameter("isbn10");
        String isbn13 = request.getParameter("isbn13");
        String titre  = request.getParameter("titre");
        String auteur = request.getParameter("auteur");
        ComposantBDLivre.modifierLivre(id, isbn10, isbn13, titre, auteur);
      }
      // Récupération du livre (modifié ultérieurement ou pas)
      livre = ComposantBDLivre.getLivre(id);
      if(livre[0] == null)  // On a bien un id mais qui ne correspond à aucun livre dans la base
      {
        erreur = "Soit la fonctionnalité n'est pas encore implémentée soit la valeur de l'ID ne correspond à aucun livre dans la base.";
      }
      else  // Tout est OK : on a un ID qui correspond à un livre. On teste pour savoir pour savoir si on 
      {     // effectue une action secondaire (ajout exemplaire, suppression exemplaire ou suppression livre ).
        String actionSecondaire = request.getParameter("action_secondaire");
        if(actionSecondaire != null)
        {
          if(actionSecondaire.equals("supprimer_livre"))
          {
            ComposantBDLivre.supprimerLivre(id);
            livreSupprime = true;
          }
          else if(actionSecondaire.equals("supprimer_exemplaire"))
          {
            int idExemplaire = new Integer(request.getParameter("id_exemplaire"));
            ComposantBDLivre.supprimerExemplaire(idExemplaire);
          }
          else if(actionSecondaire.equals("ajouter_exemplaire"))
          {
            ComposantBDLivre.ajouterExemplaire(id);
          }
        }
      }
    }
    catch(NumberFormatException e)
    {
      erreur = "La valeur de l'ID n'est pas numérique";
    }
  }
%>

<div class="row">
	<%
	if(erreur != null) // Une erreur a été détectée.
	{
	  %>
		<div class="col-lg-12">
		  <div class="panel panel-default">
		    <div class="panel-heading"><h3><i class="glyphicon glyphicon-book"></i> Gestion du livre</h3></div> <!-- /.panel-heading -->
		   <div class="panel-body">
		      <div class="row">
		       <div class="alert alert-danger
		                   col-xs-offset-2 col-xs-8
		                   text-center">
		               <h3>Impossible de traiter la demande,<br/><br/><em><%=erreur%></em></h3>
		       </div> <!-- /.col-lg-12 -->
		      </div> <!-- /.row -->
		   </div> <!-- /.panel-body -->
		 </div> <!-- /.panel -->
		</div> <!-- /.col-lg-12 -->
	  <%
	}
	else
	{
	  if(livreSupprime)
	  {
	    %>
	    <div class="col-lg-12">
	      <div class="panel panel-default">
	        <div class="panel-heading"><h3><i class="glyphicon glyphicon-book"></i> Gestion du livre</h3></div> <!-- /.panel-heading -->
	        <div class="panel-body">
	          <div class="row">
	            <div class="alert alert-success
	                        col-xs-offset-2 col-xs-8
	                        text-center">
	               <h3>Le livre <em><%=livre[3]%></em> (id = <em><%=livre[0]%></em>)<br/><br/>a été supprimé.</h3>
	            </div> <!-- /.col-lg-12 -->
	          </div> <!-- /.row -->
	        </div> <!-- /.panel-body -->
	      </div> <!-- /.panel -->
	    </div> <!-- /.col-lg-12 -->
	    <%
	  }
	  else
	  {
	    %>
	    <div class="col-lg-6">
	      <div class="panel panel-default">
	        <div class="panel-heading">
	          <div class="row">
	            <div class="col-lg-6">
	              <h3><i class="glyphicon glyphicon-book"></i> Gestion du livre</h3>
	            </div>
	          </div>
	        </div> <!-- /.panel-heading -->
	        <div class="panel-body">
	            <div class="col-xs-12">
	              <form role="form" action="template.jsp" method="get">
	                <input type="hidden" name="action" value="infos_livre">
	                <input type="hidden" name="id" value="<%=livre[0]%>">
	                <div class="form-group">
	                  <label>ID</label>
	                  <input class="form-control" placeholder="ID" name="id" value="<%=livre[0]%>" disabled>
	                </div>
	                <div class="form-group">
	                  <label>Titre</label>
	                  <input class="form-control" placeholder="Titre" name="titre" value="<%=livre[3]==null ? "" : livre[3] %>">
	                </div>
	                <div class="form-group">
	                  <label>Auteur</label>
	                  <input class="form-control" placeholder="Auteur" name="auteur" value="<%=livre[4]==null ? "" : livre[4] %>">
	                </div>
	                <div class="form-group">
	                  <label>ISBN 10</label>
	                  <input class="form-control" placeholder="ISBN 10" name="isbn10" value="<%=livre[1]==null ? "" : livre[1] %>">
	                </div>
	                <div class="form-group">
	                  <label>ISBN 13</label>
	                  <input class="form-control" placeholder="ISBN 13" name="isbn13" value="<%=livre[2]==null ? "" : livre[2] %>">
	                </div>
	                <div class="col-lg-12 text-center">
	                  <button type="submit" class="btn btn-success btn-circle btn-lg" name="submit-modification"><i class="fa fa-check"></i></button>
	                  <button type="reset"  class="btn btn-warning btn-circle btn-lg"><i class="fa fa-times"></i></button>
	                </div>
	              </form>
	              <div class="col-lg-12 text-center">
	                <br/>
                  <!-- Button trigger modal -->
                  <button class="btn btn-danger" data-toggle="modal" data-target="#myModal">
                    <i class="glyphicon glyphicon-remove-sign fa-lg"></i> Supprimer ce livre
                  </button>
                  <!-- Modal -->
                  <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
                    <div class="modal-dialog">
                      <div class="modal-content">
                        <div class="modal-header">
                          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                          <h4 class="modal-title" id="myModalLabel">Suppression d'un libre</h4>
                        </div>
                        <div class="modal-body">
                          Êtes-vous sûr ?
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                            <button type="button"
                                    class="btn btn-primary"
                                    onclick="window.location.href='template.jsp?action=infos_livre&action_secondaire=supprimer_livre&id=<%=livre[0]%>'">
                              Supprimer
                            </button>
                        </div>
                      </div>
                      <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                  </div>
                  <!-- /.modal -->
	              </div>
	            </div>
	        </div> <!-- /.panel-body -->
	      </div> <!-- /.panel -->
	    </div> <!-- /.col-lg-6 -->
	    
	    <div class="col-lg-6">
	      <div class="panel panel-default">
	        <div class="panel-heading"><h3><i class="fa fa-th"></i> Gestion des exemplaires</h3></div> <!-- /.panel-heading -->
	        <div class="panel-body">
	          <p><strong>Nombre d'exemplaires : <%=ComposantBDLivre.nbExemplaires(id)%></strong></p>
	          
	          <table class="table">
	            <thead>
	              <tr>
	                <th>ID</th>
	                <th>État</th>
	                <th>Supprimer</th>
	              </tr>
	            </thead>
	            <tbody>
	              <%
	              for(int idExemplaire : ComposantBDLivre.listeExemplaires(id))
	              {
	                %>
	                <tr>
	                  <td><%=idExemplaire%></td>
	                  <td>
	                    <strong><%=ComposantBDEmprunt.estEmprunte(idExemplaire) ? "<p class=\"text-danger\">Emprunté</p>" : "<p class=\"text-success\">Disponible</p>"%></strong>
	                  </td>
	                  <td>
	                    <a href="template.jsp?action=infos_livre&action_secondaire=supprimer_exemplaire&id=<%=livre[0]%>&id_exemplaire=<%=idExemplaire%>"><i class="glyphicon glyphicon-remove-sign fa-lg"></i></a>
	                  </td>
	                </tr>
	                <%
	              }
	              %>
	            </table>
              <div class="col-lg-12 text-center">
	              <button type="button" class="btn btn-success"
	                      onclick="window.location.href='template.jsp?action=infos_livre&action_secondaire=ajouter_exemplaire&id=<%=livre[0]%>'">
	                  <i class="fa fa-plus-circle fa-lg"></i> Ajouter un exemplaire
	              </button>
	        </div>

	        </div> <!-- /.panel-body -->
	      </div> <!-- /.panel -->
	    </div> <!-- /.col-lg-6 -->
	    <%
	  }
	}
	%>
</div> <!-- /.row -->
