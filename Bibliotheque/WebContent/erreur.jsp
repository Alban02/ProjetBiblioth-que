<%--<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8"%> --%>
<%@ page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page isErrorPage="true" %>
<%@page import="java.util.List,
                java.util.ArrayList"%>

<%
  String message = exception.getMessage();
  if(exception.getCause() != null)
  {
    if(exception.getCause().getMessage() != null)
    {
      if(!message.contains(exception.getCause().getMessage()))
      {
        message += "\n" + exception.getCause().getMessage();
      }
    }
  }
  List<StackTraceElement> tracesAAfficher = new ArrayList<StackTraceElement>();
  Throwable t = exception;
  while(t != null)
  {
    StackTraceElement[] elements = t.getStackTrace(); 
    for(StackTraceElement element : elements)
    {
      //if(element.getClassName().contains("postgres") || element.getClassName().contains("biblio") || element.getClassName().contains("org.apache.jsp"))
      if(element.getClassName().contains("postgres") || element.getClassName().contains("biblio"))
      {
        tracesAAfficher.add(element);
      }
    }
    t = t.getCause();
  }
%>

<!DOCTYPE html>
<html lang="en">
  <jsp:include page="fragments/head.html" />
  <body>
    <div id="wrapper">
      <!-- Navigation -->
      <nav class="navbar
                  navbar-default
                  navbar-static-top"
           role="navigation"
           style="margin-bottom: 0">
        <jsp:include page="fragments/bandeau.html" />
        <jsp:include page="fragments/menu.html" />
      </nav>
      <div id="page-wrapper">
<p style="font-size: 5">&nbsp;</p>
				<div class="row">
				  <div class="col-lg-12">
				    <div class="panel panel-default">
				      <div class="panel-heading"><h3><i class="glyphicon glyphicon-bell"></i> Erreur !</h3></div> <!-- /.panel-heading -->
				      <div class="panel-body">
				        <div class="panel panel-red">
				          <div class="panel-heading">Message d'erreur</div>
				          <div class="panel-body">
                    <%--<p><em><strong><%=message%></strong></em></p> --%>
                    <pre><%=message%></pre>
				          </div>
				        </div>
				        <div class="panel panel-yellow">
				          <div class="panel-heading">Pile d'erreurs simplifiée</div>
				          <div class="panel-body">
						        <div class="table-responsive">
						          <table class="table">
						            <thead>
						              <tr>
						                <th>Classe</th>
						                <th>Méthode</th>
						                <th>Ligne</th>
						              </tr>
						            </thead>
						            <tbody>
						            <%
						            for (int i = tracesAAfficher.size() - 1; i >= 0; i--)
						            {
						              StackTraceElement element = tracesAAfficher.get(i);
						              if(element.getClassName().contains("biblio"))
						              {
						                %>
						                <tr class="danger">
						                  <td><strong><%=element.getClassName()%></strong></td>
						                  <td><strong><%=element.getMethodName()%></strong></td>
						                  <td><strong><%=element.getLineNumber()%></strong></td>
						                </tr>
						                <%
						              }
						              else
						              {
						                %>
						                <tr class="warning">
						                  <td><%=element.getClassName()%></td>
						                  <td><%=element.getMethodName()%></td>
						                  <td><%=element.getLineNumber()%></td>
						                </tr>
						                <%
						              }
						              %>
						              <%
						            }
						            %>
						            </tbody>
						          </table>
						        </div> <!-- /.table-responsive -->
				          </div> <!-- /.panel-body -->
				        </div> <!-- /.panel-yellow -->
				      </div> <!-- /.panel-body -->
				    </div> <!-- /.panel -->
				  </div> <!-- /.col-lg-12 -->
				</div> <!-- /.row -->
      </div> <!-- /#page-wrapper -->
    </div> <!-- /#wrapper -->
    <jsp:include page="fragments/fin_de_page.jsp" />
  </body>
</html>
