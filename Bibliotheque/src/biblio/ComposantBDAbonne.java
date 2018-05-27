package biblio;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.util.ArrayList;

/**
 * Composant logiciel assurant la gestion des abonnés.
 */
public class ComposantBDAbonne {

  /**
   * Récupération de la liste complète des abonnés.
   * 
   * @return un <code>ArrayList<String[]></code>. Chaque tableau de chaînes
   * de caractères contenu correspond à un abonné.<br/>
   * Il doit contenir 5 éléments (dans cet ordre) :
   * <ul>
   *   <li>0 : id</li>
   *   <li>1 : nom</li>
   *   <li>2 : prénom</li>
   *   <li>3 : statut</li>
   *   <li>4 : adresse email</li>
   * </ul>
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static ArrayList<String[]> listeTousLesAbonnes() throws SQLException {
    
    ArrayList<String[]> abonnes = new ArrayList<String[]>(); // Création de la liste des abonnés.
    
    Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
    String sql = "select * from abonne"; // Requête à exécuter.
    ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
    
    while (rset.next()) { // Récupération de chaque élément en ligne et colonne de la table des données en parcourant ligne par ligne de l'objet rset.
        String[] abonne = new String[5];
        abonne[0] = rset.getString("id");
        abonne[1] = rset.getString("nom");
        abonne[2] = rset.getString("prenom");
        abonne[3] = rset.getString("statut");
        abonne[4] = rset.getString("email");

        abonnes.add(abonne); // On récupère chaque abonné qu'on ajoute dans la liste de tous les abonnés.
      }
      
      
    rset.close(); // Suppression de l'objet créé.
    stmt.close(); // Fermeture de la connexion créée.
  
    return abonnes; // On retourne la liste de tous les abonnés.
  }

  /**
   * Retourne le nombre d'abonnés référencés dans la base.
   * 
   * @return le nombre d'abonnés.
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static int nbAbonnes() throws SQLException {
    
	Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
	String sql = "select distinct count(id) from abonne"; // Requête à exécuter.
	ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
	rset.next(); // On va à la première ligne de données du rset.
	
	int nbAbonnes = rset.getInt(1); // On récupère le count à la première colonne.
	
	rset.close(); // Suppression de l'objet créé.
	stmt.close(); // Fermeture de la connexion créée.
	
	return nbAbonnes; // On retourne le nombre des abonnés.
  }

  /**
   * Récupération des informations sur un abonné à partir de son identifiant.
   * 
   * @param idAbonne : id de l'abonné à rechercher
   * @return un tableau de chaînes de caractères (<code>String[]</code>). Chaque
   * tableau doit contenir 5 éléments (dans cet ordre) :
   * <ul>
   *   <li>0 : id</li>
   *   <li>1 : nom</li>
   *   <li>2 : prénom</li>
   *   <li>3 : statut</li>
   *   <li>4 : adresse email</li>
   * </ul>
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static String[] getAbonne(int idAbonne) throws SQLException {
    
	String[] abonne = new String[5]; // Création du tableau de chaînes de caractères pour recevoir les données de l'abonné.
	
	Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
    String sql = "select * from abonne where id =" + idAbonne; // Requête à exécuter.
    ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
    
    while (rset.next()) { // Récupération de chaque élément en colonne de la table des données.
    	abonne[0] = rset.getString("id");
        abonne[1] = rset.getString("nom");
        abonne[2] = rset.getString("prenom");
        abonne[3] = rset.getString("statut");
        abonne[4] = rset.getString("email");
      }
    
    rset.close(); // Suppression de l'objet créé.
    stmt.close(); // Fermeture de la connexion créée.
    
    return abonne; // On retourne l'abonné.
  }

  /**
   * Référencement d'un nouvel abonné dans la base de données.
   * 
   * @param nom
   * @param prenom
   * @param statut (deux valeurs possibles <i>Etudiant</i> et <i>Enseignant</i>)
   * @param email
   * @return l'identifiant de l'abonné référencé.
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static int insererNouvelAbonne(String nom, String prenom, String statut, String email) throws SQLException {
    
	  int insert = 0; // Une variable pour vérifier le succès ou non de l'insertion.
	  
	  String sql = "insert into abonne values(nextval('abonne_id_seq'), ?, ?, ?, ?)"; // Requête préparée à exécuter.
	  PreparedStatement pstmt = Connexion.getConnection().prepareStatement(sql); // Création de la connexion à la BD pour faire une requête préparée.
	  pstmt.setString(1, nom); // On définit le premier ? de sql à nom.
	  pstmt.setString(2, prenom); // On définit le deuxième ? de sql à prenom.
	  pstmt.setString(3, statut); // On définit le troisième ? de sql à statut.
	  pstmt.setString(4, email); // On définit le quatrième ? de sql à email.
	  insert = pstmt.executeUpdate(); // On met le résultat de la requête dans insert.
	  pstmt.close(); // Fermeture de la connexion créée.
	  
	  if(insert == 0) { // On vérifie si l'insertion n'a pas réussi.
		  return -1; // Echec de la requête.  
	  }
	  else { // Insertion réussie.
		  Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
		  String sql1 = "select currval('abonne_id_seq')"; // Requête à exécuter.
		  ResultSet rset = stmt.executeQuery(sql1); // Création de la table des données après exécution de la requête.
		  rset.next(); // On va à la première ligne de données du rset.
		  
		  int id = rset.getInt(1); // On récupère l'id de l'abonné.
		  
		  rset.close(); // Suppression de l'objet créé.
		  stmt.close(); // Fermeture de la connexion créée.
		  
		  return id; // On retourne l'id de l'abonné.
	  }
  }

  /**
   * Modification des informations d'un abonné donné connu à partir de son
   * identifiant : les nouvelles valeurs (nom, prenom, etc.) écrasent les anciennes.
   * 
   * @param idAbonne : identifiant de l'abonné dont on veut modifier les informations.
   * @param nom
   * @param prenom
   * @param statut (deux valeurs possibles <i>Etudiant</i> et <i>Enseignant</i>)
   * @param email
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static void modifierAbonne(int idAbonne, String nom, String prenom, String statut, String email) throws SQLException {
    
	  String sql = "update abonne set nom = ?, prenom = ?, statut =?, email = ? where id = ?"; // Requête préparée à exécuter.
	  
	  PreparedStatement pstmt = Connexion.getConnection().prepareStatement(sql); // Création de la connexion à la BD pour faire une requête préparée.
	  
	  pstmt.setString(1, nom); // On définit le premier ? de sql à nom.
	  pstmt.setString(2, prenom); // On définit le deuxième ? de sql à prenom.
	  pstmt.setString(3, statut); // On définit le troisième ? de sql à statut.
	  pstmt.setString(4, email); // On définit le quatrième ? de sql à email.
	  pstmt.setInt(5, idAbonne); // On définit le cinquième ? de sql à idAbonne.
	  
	  pstmt.executeUpdate(); // On exécute la requête.
	  pstmt.close(); // Fermeture de la connexion créée.
  }

  /**
   * Suppression d'un abonné connu à partir de son identifiant.
   * 
   * @param idAbonne : identifiant de l'utilisateur
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static void supprimerAbonne(int idAbonne) throws SQLException {
    
	  if(ComposantBDEmprunt.listeEmpruntsEnCours(idAbonne).isEmpty()) { // On vérifie que la liste des emprunts de l'abonné est vide.
		 ComposantBDEmprunt.supprimerEmprunt(1, idAbonne); // On supprime l'emprunt fait par l'abonné. 
		 
		 Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD. 
		 String sql = "delete from abonne where id =" + idAbonne; // Requête à exécuter.
		 stmt.executeUpdate(sql); // On exécute la requête.
		 
		 stmt.close(); // Fermeture de la connexion créée.
	  }
	  else throw new SQLException("Cet abonné a des emprunts en cours.");
  }
}
