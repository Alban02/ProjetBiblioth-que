<%@ page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>

<%@page import="biblio.ComposantBDEmprunt,
                biblio.ComposantBDAbonne,
                biblio.ComposantBDLivre"%>

<%
  int nbLivres          = ComposantBDLivre.nbLivres();
  int nbAbonnes         = ComposantBDAbonne.nbAbonnes();
  int nbEmpruntsEnCours = ComposantBDEmprunt.nbEmpruntsEnCours();
%>

<div class="row">

  <div class="col-lg-4 col-md-6">
    <div class="panel panel-primary">
      <div class="panel-heading">
        <div class="row">
          <div class="col-xs-3">
            <i class="glyphicon glyphicon-book fa-5x"></i>
          </div>
          <div class="col-xs-9 text-right">
            <div class="huge"><%=nbLivres%></div>
            <div><%=(nbLivres <=1 ? "livre" : "livres")%></div>
          </div>
        </div>
    </div>
    <a href="template.jsp?action=liste_livres">
      <div class="panel-footer">
        <span class="pull-left">Liste des livres</span> <span
          class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
        <div class="clearfix"></div>
      </div>
    </a>
  </div>
</div>

<div class="col-lg-4 col-md-6">
  <div class="panel panel-green">
    <div class="panel-heading">
      <div class="row">
        <div class="col-xs-3">
          <i class="fa fa-users fa-5x"></i>
        </div>
        <div class="col-xs-9 text-right">
          <div class="huge"><%=nbAbonnes%></div>
          <div><%=(nbAbonnes <=1 ? "abonné" : "abonnés")%></div>
        </div>
      </div>
    </div>
    <a href="template.jsp?action=liste_abonnes">
      <div class="panel-footer">
        <span class="pull-left">Liste des abonnés</span> <span
          class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
        <div class="clearfix"></div>
      </div>
    </a>
  </div>
</div>

<div class="col-lg-4 col-md-6">
  <div class="panel panel-yellow">
    <div class="panel-heading">
      <div class="row">
        <div class="col-xs-3">
          <i class="glyphicon glyphicon-transfer fa-5x"></i>
        </div>
        <div class="col-xs-9 text-right">
          <div class="huge"><%=nbEmpruntsEnCours%></div>
          <div><%=(nbEmpruntsEnCours <=1 ? "emprunt" : "emprunts")%></div>
          </div>
        </div>
      </div>
      <a href="template.jsp?action=emprunts_en_cours">
        <div class="panel-footer">
          <span class="pull-left">Liste des emprunts en cours</span> <span
            class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
          <div class="clearfix"></div>
        </div>
      </a>
    </div>
  </div>

</div> <!-- /.row -->

<%--
<div class="panel panel-default">
  <div class="panel-heading">
    Mouvements de la bibliothèque
  </div> <!-- /.panel-heading -->
  <div class="panel-body">
    <div id="mouvements_bibliotheque" style="height: 300px;"></div>
  </div> <!-- /.panel-body -->
</div> <!-- /.panel-default -->
--%>
