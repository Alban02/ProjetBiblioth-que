<%@ page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>

<%@page import="biblio.ComposantBDAbonne,
                biblio.ComposantBDEmprunt,
                java.util.List"%>

<%
	String  erreur = null;
  boolean abonneSupprime = false;
  // Test de la validité du paramètre id.
  String idStringValue = request.getParameter("id");
  int id = -1;
  String[] abonne = null;
  if(idStringValue == null)
  {
    erreur = "La valeur de l'ID de l'abonné n'est pas spécifiée dans les paramètres.";
  }
  else
  {
    try
    {
      id = new Integer(idStringValue);
      // C'est OK : on a bien un id
      if(request.getParameter("submit-modification") != null) // Si le paramètre est présent,
      {                                                       // on veut modifier l'abonné.
        String nom    = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String statut = request.getParameter("statut");
        String email  = request.getParameter("email");
        ComposantBDAbonne.modifierAbonne(id, nom, prenom, statut, email);
      }
      // Récupération de l'abonné (modifié ultérieurement ou pas)
      abonne = ComposantBDAbonne.getAbonne(id);
      if(abonne[0] == null)  // On a bien un id mais qui ne correspond à aucun abonné dans la base
      {
        erreur = "Soit la fonctionnalité n'est pas encore implémentée soit la valeur de l'ID ne correspond à aucun abonné dans la base.";
      }
      else  // Tout est OK : on a un ID qui correspond à un abonné. On teste pour savoir pour savoir si on 
      {     // effectue une action secondaire (suppression abonné).
        String actionSecondaire = request.getParameter("action_secondaire");
        if(actionSecondaire != null)
        {
          if(actionSecondaire.equals("supprimer_abonne"))
          {
            ComposantBDAbonne.supprimerAbonne(id);
            abonneSupprime = true;
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
		    <div class="panel-heading"><h3><i class="fa fa-users"></i> Gestion de l'abonné</h3></div> <!-- /.panel-heading -->
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
	  if(abonneSupprime)
	  {
	    %>
      <div class="col-lg-12">
        <div class="panel panel-default">
          <div class="panel-heading"><h3><i class="fa fa-users"></i> Gestion de l'abonné</h3></div> <!-- /.panel-heading -->
          <div class="panel-body">
            <div class="row">
              <div class="alert alert-success
                          col-xs-offset-2 col-xs-8
                          text-center">
                 <h3>L'abonné <em><%=abonne[1]%> <%=abonne[2]%></em> (id = <em><%=abonne[0]%></em>)<br/><br/>a été supprimé.</h3>
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
	              <h3><i class="fa fa-users"></i> Gestion de l'abonné</h3>
	            </div>
	          </div>
	        </div> <!-- /.panel-heading -->
	        <div class="panel-body">
	            <div class="col-xs-12">
	              <form role="form" action="template.jsp" method="get">
	                <input type="hidden" name="action" value="infos_abonne">
	                <input type="hidden" name="id" value="<%=abonne[0]%>">
	                <div class="form-group">
	                  <label>ID</label>
	                  <input class="form-control" placeholder="ID" name="id" value="<%=abonne[0]%>" disabled>
	                </div>
	                <div class="form-group">
	                  <label>Nom</label>
	                  <input class="form-control" placeholder="Nom" name="nom" value="<%=abonne[1]==null ? "" : abonne[1] %>">
	                </div>
	                <div class="form-group">
	                  <label>Prénom</label>
	                  <input class="form-control" placeholder="Prénom" name="prenom" value="<%=abonne[2]==null ? "" : abonne[2] %>">
	                </div>
	                <div class="form-group">
	                  <label>Statut</label>
                    <select class="form-control" name="statut">
                        <option <%=abonne[3].equalsIgnoreCase("Etudiant") ? "selected=\"selected\"" : "" %>>Etudiant</option>
                        <option <%=abonne[3].equalsIgnoreCase("Enseignant") ? "selected=\"selected\"" : "" %>>Enseignant</option>
                    </select>
	                </div>
	                <div class="form-group">
	                  <label>Adresse email</label>
	                  <input class="form-control" placeholder="Email" name="email" value="<%=abonne[4]==null ? "" : abonne[4] %>">
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
                    <i class="glyphicon glyphicon-remove-sign fa-lg"></i> Supprimer cet abonné
									</button>
									<!-- Modal -->
									<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
													<h4 class="modal-title" id="myModalLabel">Suppression d'un abonné</h4>
												</div>
												<div class="modal-body">
												  Êtes-vous sûr ?
												</div>
												<div class="modal-footer">
												    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
												    <button type="button"
												            class="btn btn-primary"
												            onclick="window.location.href='template.jsp?action=infos_abonne&action_secondaire=supprimer_abonne&id=<%=abonne[0]%>'">
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
          <div class="panel-heading"><h3><i class="glyphicon glyphicon-transfer"></i> Emprunts de l'abonné</h3></div> <!-- /.panel-heading -->
          <div class="panel-body">
            <p><strong>Nombre d'emprunts en cours : <%=ComposantBDEmprunt.nbEmpruntsEnCours(id)%></strong></p>
            
            <table class="table">
              <thead>
                <tr>
                  <th>ID exemplaire</th>
                  <th>Livre</th>
                  <th>Date emprunt</th>
                  <th>Retourner</th>
                </tr>
              </thead>
              <tbody>
                <%
                List<String[]> emprunts = ComposantBDEmprunt.listeEmpruntsEnCours(id);
                if(emprunts.size() != 0)
                {
	                for(String[] emprunt : emprunts)
	                {
	                  %>
	                  <tr>
	                    <td><%=emprunt[0]%></td>
	                    <td>(<%=emprunt[1]%>) <%=emprunt[2]%> - <em><%=emprunt[3]%></em></td>
                      <td><%=emprunt[4]%></td>
                      <td>
                        <button type="button"
                                class="btn btn-outline btn-primary btn-xs"
                                onclick="window.location.href='template.jsp?action=retourner_exemplaire&id_exemplaire=<%=emprunt[0]%>'">
                          <i class="fa  fa-chevron-circle-right"></i>
                        </button>
                      </td>
	                  </tr>
	                  <%
	                }
                }
                %>
              <tbody>
            </table>
            <%
            if(emprunts.size() == 0)
            {
              %>
              <div class="alert alert-success
                          col-xs-offset-2 col-xs-8
                          text-center">
                 <h4>Aucun emprunt en cours.</h4>
              </div> <!-- /.col-lg-12 -->
              <%
            }
            %>
          </div> <!-- /.panel-body -->
        </div> <!-- /.panel -->
      </div> <!-- /.col-lg-6 -->
      <%
	  }
	}
	%>
</div> <!-- /.row -->
