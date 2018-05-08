package biblio;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Composant logiciel assurant la gestion des emprunts d'exemplaires
 * de livre par les abonnés.
 */
public class ComposantBDEmprunt {

  /**
   * Retourne le nombre total d'emprunts en cours référencés dans la base.
   * 
   * @return le nombre d'emprunts.
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static int nbEmpruntsEnCours() throws SQLException {
    
	Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
	String sql = "select distinct count(id_abonne) from emprunt where date_retour is null"; // Requête à exécuter.
	ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
	rset.next(); // On va à la première ligne de données du rset.
	
	int nbEmprunt = rset.getInt(1); // On récupère le count à la première colonne.
	
	rset.close(); // Suppression de l'objet créé.
	stmt.close(); // Fermeture de la connexion créée.
	
	return nbEmprunt; // On retourne le nombre des abonnés.
  }

  /**
   * Retourne le nombre d'emprunts en cours pour un abonné donné connu
   * par son identifiant.
   * 
   * @return le nombre d'emprunts.
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static int nbEmpruntsEnCours(int idAbonne) throws SQLException {
    
	Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
	String sql = "select distinct count(id_abonne) from emprunt where date_retour is null and id_abonne =" + idAbonne; // Requête à exécuter.
	ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
	rset.next(); // On va à la première ligne de données du rset.

	int nbEmprunt = rset.getInt(1); // On récupère le count à la première colonne.
	
	rset.close(); // Suppression de l'objet créé.
	stmt.close(); // Fermeture de la connexion créée.
	
	return nbEmprunt; // On retourne le nombre des abonnés.
  }

  
  /**
   * Récupération de la liste complète des emprunts en cours.
   * 
   * @return un <code>ArrayList<String[]></code>. Chaque tableau de chaînes
   * de caractères contenu correspond à un emprunt en cours.<br/>
   * Il doit contenir 8 éléments (dans cet ordre) :
   * <ul>
   *   <li>0 : id de l'exemplaire</li>
   *   <li>1 : id du livre correspondant</li>
   *   <li>2 : titre du livre</li>
   *   <li>3 : son auteur</li>
   *   <li>4 : id de l'abonné</li>
   *   <li>5 : nom de l'abonné</li>
   *   <li>6 : son prénom</li>
   *   <li>7 : la date de l'emprunt</li>
   * </ul>
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static ArrayList<String[]> listeEmpruntsEnCours() throws SQLException {
    
	ArrayList<String[]> emprunts = new ArrayList<String[]>(); // Oncrée la liste de tous les emprunts en cours.
	
    Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
    // Requête à exécuter.
    String sql = "select e.id, l.id, l.titre, l.auteur, a.id, a.nom, a.prenom, em.date_emprunt from emprunt em "
			+ "join exemplaire e on e.id = em.id_exemplaire "
			+ "join livre l on l.id = e.id_livre "
			+ "join abonne a on a.id = em.id_abonne "
			+ "where em.date_retour is null";	    

	ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
	
	while (rset.next()) { // Récupération de chaque élément en ligne et colonne de la table des données en parcourant ligne par ligne de l'objet rset.
		String[] emprunt = new String[8];
		emprunt[0] = rset.getString("id");
		emprunt[1] = rset.getString("id");
		emprunt[2] = rset.getString("titre");
		emprunt[3] = rset.getString("auteur");
		emprunt[4] = rset.getString("id");
		emprunt[5] = rset.getString("nom");
		emprunt[6] = rset.getString("prenom");     
		emprunt[7] = formatageDate.format(rset.getTimestamp("date_emprunt"));
		
		emprunts.add(emprunt); // On récupère chaque emprunt qu'on ajoute dans la liste de tous les emprunts.
	}
	
	rset.close(); // Suppression de l'objet créé.
	stmt.close(); // Fermeture de la connexion créée.
	
	return emprunts; // On retourne la liste de tous les emprunts en cours.
  }
  
  /**
   * Formatage de la date en jour/mois/année Heure:minutes.
   */
  private static SimpleDateFormat formatageDate = new SimpleDateFormat("dd/MM/yyyy HH:mm");
  
  
  /**
   * Récupération de la liste des emprunts en cours pour un abonné donné.
   * 
   * @return un <code>ArrayList<String[]></code>. Chaque tableau de chaînes
   * de caractères contenu correspond à un emprunt en cours pour l'abonné.<br/>
   * Il doit contenir 5 éléments (dans cet ordre) :
   * <ul>
   *   <li>0 : id de l'exemplaire</li>
   *   <li>1 : id du livre correspondant</li>
   *   <li>2 : titre du livre</li>
   *   <li>3 : son auteur</li>
   *   <li>4 : la date de l'emprunt</li>
   * </ul>
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static ArrayList<String[]> listeEmpruntsEnCours(int idAbonne) throws SQLException {
    
	ArrayList<String[]> emprunts = new ArrayList<String[]>(); // Oncrée la liste de tous les emprunts en cours effectués par l'abonné.
    
	Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
	// Requête à exécuter.
	String sql = "select e.id, l.id, l.titre, l.auteur, em.date_emprunt from emprunt em "
			+ "join exemplaire e on e.id = em.id_exemplaire "
			+ "join livre l on l.id = e.id_livre "
			+ "join abonne a on a.id = em.id_abonne "
			+ "where em.date_retour is null and a.id ="+ idAbonne;	

	ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
	
	while (rset.next()) { // Récupération de chaque élément en ligne et colonne de la table des données en parcourant ligne par ligne de l'objet rset.
		String[] emprunt = new String[5];
		emprunt[0] = rset.getString("id");
		emprunt[1] = rset.getString("id");
		emprunt[2] = rset.getString("titre");
		emprunt[3] = rset.getString("auteur");     
		emprunt[4] = formatageDate.format(rset.getTimestamp("date_emprunt"));
		
		emprunts.add(emprunt); // On récupère chaque emprunt qu'on ajoute dans la liste de tous les emprunts.
	}
	
	rset.close(); // Suppression de l'objet créé.
	stmt.close(); // Fermeture de la connexion créée.
	
	
	return emprunts; // On retourne la liste de tous les emprunts en cours effectués par l'abonné.
  }

  /**
   * Récupération de la liste complète des emprunts passés.
   * 
   * @return un <code>ArrayList<String[]></code>. Chaque tableau de chaînes
   * de caractères contenu correspond à un emprunt passé.<br/>
   * Il doit contenir 9 éléments (dans cet ordre) :
   * <ul>
   *   <li>0 : id de l'exemplaire</li>
   *   <li>1 : id du livre correspondant</li>
   *   <li>2 : titre du livre</li>
   *   <li>3 : son auteur</li>
   *   <li>4 : id de l'abonné</li>
   *   <li>5 : nom de l'abonné</li>
   *   <li>6 : son prénom</li>
   *   <li>7 : la date de l'emprunt</li>
   *   <li>8 : la date de retour</li>
   * </ul>
   * @return un <code>ArrayList</code> contenant autant de tableaux de String (5 chaînes de caractères) que d'emprunts dans la base.
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static ArrayList<String[]> listeEmpruntsHistorique() throws SQLException {
    
	ArrayList<String[]> emprunts = new ArrayList<String[]>(); // Oncrée la liste de tous les emprunts passés.
    
	Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
	// Requête à exécuter.
    String sql = "select e.id, l.id, l.titre, l.auteur, a.id, a.nom, a.prenom, em.date_emprunt, em.date_retour from emprunt em "
			+ "join exemplaire e on e.id = em.id_exemplaire "
			+ "join livre l on l.id = e.id_livre "
			+ "join abonne a on a.id = em.id_abonne "
			+ "where em.date_retour is not null";	    

	ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
	
	while (rset.next()) { // Récupération de chaque élément en ligne et colonne de la table des données en parcourant ligne par ligne de l'objet rset.
		String[] emprunt = new String[9];
		emprunt[0] = rset.getString("id");
		emprunt[1] = rset.getString("id");
		emprunt[2] = rset.getString("titre");
		emprunt[3] = rset.getString("auteur");
		emprunt[4] = rset.getString("id");
		emprunt[5] = rset.getString("nom");
		emprunt[6] = rset.getString("prenom");
		emprunt[7] = formatageDate.format(rset.getTimestamp("date_emprunt"));
		emprunt[8] = formatageDate.format(rset.getTimestamp("date_retour"));
		
		emprunts.add(emprunt); // On récupère chaque emprunt qu'on ajoute dans la liste de tous les emprunts.
	}
	
	rset.close(); // Suppression de l'objet créé.
	stmt.close(); // Fermeture de la connexion créée.
	
	return emprunts; // On retourne la liste de tous les emprunts passés.
  }

  /**
   * Emprunter un exemplaire à partir de l'identifiant de l'abonné et de
   * l'identifiant de l'exemplaire.
   * 
   * @param idAbonne : id de l'abonné emprunteur.
   * @param idExemplaire id de l'exemplaire emprunté.
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static void emprunter(int idAbonne, int idExemplaire) throws SQLException {
    
	String sql = "insert into emprunt values(?, ?, ?, NULL)"; // Requête préparée à exécuter.
	
    Timestamp dateEmprunt = new Timestamp(new Date().getTime()); // Création de la variable de la date d'emprunt. On récupère la date et l'heure de l'emprunt effectué.
  
    PreparedStatement pstmt = Connexion.getConnection().prepareStatement(sql); // Création de la connexion à la BD pour faire une requête préparée.
    pstmt.setInt(1, idAbonne); // On définit le premier ? de sql à idAbonne.
    pstmt.setInt(2,idExemplaire); // On définit le deuxième ? de sql à idExemplaire.
    pstmt.setTimestamp(3,dateEmprunt); // On définit le troisième ? de sql à dateEemprunt.
    
    pstmt.executeUpdate(); // On exécute la requête.
	pstmt.close(); // Fermeture de la connexion créée.
  }

  /**
   * Retourner un exemplaire à partir de son identifiant.
   * 
   * @param idExemplaire id de l'exemplaire à rendre.
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static void rendre(int idExemplaire) throws SQLException {
	  
	String sql = "update emprunt set date_retour = ? where id_exemplaire = ? and date_retour is null"; // Requête préparée à exécuter.
	
	Timestamp dateRetour = new Timestamp(new Date().getTime()); // Création de la variable de la date de retour. On récupère la date et l'heure du retour de l'emprunt.
	  
	PreparedStatement pstmt = Connexion.getConnection().prepareStatement(sql); // Création de la connexion à la BD pour faire une requête préparée.
	  
	pstmt.setTimestamp(1, dateRetour); // On définit le premier ? de sql à dateRetour.
	pstmt.setInt(2, idExemplaire); // On définit le deuxième ? de sql à idExemplaire.
	  
	pstmt.executeUpdate(); // On exécute la requête.
	pstmt.close(); // Fermeture de la connexion créée.
  }
  
  /**
   * Détermine si un exemplaire sonné connu par son identifiant est
   * actuellement emprunté.
   * 
   * @param idExemplaire
   * @return <code>true</code> si l'exemplaire est emprunté, <code>false</code> sinon
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static boolean estEmprunte(int idExemplaire) throws SQLException {
    
	Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
    String sql = "select * from emprunt where date_retour is null and id_exemplaire =" + idExemplaire; // Requête à exécuter.
    ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
    
    if(rset.next()) { // Si rset n'est pas vide, on retourne vraie (true).
    	rset.close();
    	stmt.close();
    	return true;
    }
    
    return false; // Sinon, on retourne faux (false).
  }

  /**
   * Récupération des statistiques sur les emprunts (nombre d'emprunts et de
   * retours par jour).
   * 
   * @return un <code>HashMap<String, int[]></code>. Chaque enregistrement de la
   * structure de données est identifiée par la date (la clé) exprimée sous la forme
   * d'une chaîne de caractères. La valeur est un tableau de 2 entiers qui représentent :
   * <ul>
   *   <li>0 : le nombre d'emprunts</li>
   *   <li>1 : le nombre de retours</li>
   * </ul>
   * Exemple :
   * <pre>
   * +-------------------------+
   * | "2017-04-01" --> [3, 1] |
   * | "2017-04-02" --> [0, 1] |
   * | "2017-04-07" --> [5, 9] |
   * +-------------------------+
   * </pre>
   *   
   * @throws SQLException
   */
  public static HashMap<String, int[]> statsEmprunts() throws SQLException
  {
    HashMap<String, int[]> stats = new HashMap<String, int[]>();
    //
    // A COMPLETER
    //
    return stats;
  }
  
  public static void supprimerEmprunt(int head, int id) throws SQLException {
	
	Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
	
	// Suppression d'un emprunt par id_abonne.
	String sql = "delete from emprunt where date_retour is not null and id_abonne =" + id; // Requête à exécuter.
	
	// Suppression d'un emprunt par id_exemplaire.
	if(head == 0) sql = "delete from emprunt where date_retour is not null and id_exemplaire =" + id;
	    
	stmt.executeUpdate(sql); // execution de la requette
	stmt.close();
  }
}
