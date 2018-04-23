package biblio;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.util.ArrayList;

/**
 * Composant logiciel assurant la gestion des livres et des exemplaires
 * de livre.
 */
public class ComposantBDLivre {

  /**
   * Récupération de la liste complète des livres.
   * 
   * @return un <code>ArrayList<String[]></code>. Chaque tableau de chaînes
   * de caractères contenu correspond à un livre.<br/>
   * Il doit contenir 5 éléments (dans cet ordre) :
   * <ul>
   *   <li>0 : id</li>
   *   <li>1 : isbn10</li>
   *   <li>2 : isbn13</li>
   *   <li>3 : titre</li>
   *   <li>4 : auteur</li>
   * </ul>
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static ArrayList<String[]> listeTousLesLivres() throws SQLException {

	ArrayList<String[]> livres = new ArrayList<String[]>(); // Création de la liste de tous les livres.
	
	Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
	String sql = "select * from livre"; // Requête à exécuter.
	ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
	
	while (rset.next()) { // Récupération de chaque élément en ligne et colonne de la table des données en parcourant ligne par ligne de l'objet rset.
	  String[] livre = new String[5];
	  livre[0] = rset.getString("id");
	  livre[1] = rset.getString("isbn10");
	  livre[2] = rset.getString("isbn13");
	  livre[3] = rset.getString("titre");
	  livre[4] = rset.getString("auteur");
	
	  livres.add(livre); // On récupère chaque livre qu'on ajoute dans la liste de tous les livres.
	}
	
	rset.close(); // Suppression de l'objet créé.
	stmt.close(); // Fermeture de la connexion créée.
	
	return livres; // On retourne la liste de tous les livres.
  }

  /**
   * Retourne le nombre de livres référencés dans la base.
   * 
   * @return le nombre de livres.
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static int nbLivres() throws SQLException {
    
	Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
	String sql = "select distinct count(id) from livre"; // Requête à exécuter.
	ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
	rset.next(); // On va à la première de données du rset.
	
	int nbLivres = rset.getInt(1); // On récupère le count à la première colonne.
	
	rset.close(); // Suppression de l'objet créé.
	stmt.close(); // Fermeture de la connexion créée.
	
	return nbLivres; // On retourne le nombre des livres.
  }

  /**
   * Récupération des informations sur un livre connu à partir de son identifiant.
   * 
   * @param idLivre : id du livre à rechercher
   * @return un tableau de chaînes de caractères (<code>String[]</code>). Chaque
   * tableau doit contenir 5 éléments (dans cet ordre) :
   * <ul>
   *   <li>0 : id</li>
   *   <li>1 : isbn10</li>
   *   <li>2 : isbn13</li>
   *   <li>3 : titre</li>
   *   <li>4 : auteur</li>
   * </ul>
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
   public static String[] getLivre(int idLivre) throws SQLException {
     
	 String[] livre = new String[5]; // Création du tableau de chaînes de caractères pour recevoir les données du livre.
	 
	 Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
	 String sql = "select * from livre where id=" + idLivre; // Requête à exécuter.
	 ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
	 
	 while(rset.next()) { // Récupération de chaque élément en colonne de la table des données.
		 livre[0] = rset.getString("id");
		 livre[1] = rset.getString("isbn10");
		 livre[2] = rset.getString("isbn13");
		 livre[3] = rset.getString("titre");
		 livre[4] = rset.getString("auteur");
	 }
	 
	 rset.close(); // Suppression de l'objet créé.
	 stmt.close(); // Fermeture de la connexion créée.
	 
	 return livre; // On retourne le livre.
   }
  
 /**
  * Récupération des informations sur un livre connu à partir de l'identifiant
  * de l'un de ses exemplaires.
  * 
  * @param idExemplaire : id de l'exemplaire
  * @return un tableau de chaînes de caractères (<code>String[]</code>). Chaque
  * tableau doit contenir 6 éléments (dans cet ordre) :
  * <ul>
  *   <li>0 : id de l'exemplaire</li>
  *   <li>1 : id du livre</li>
  *   <li>2 : isbn10</li>
  *   <li>3 : isbn13</li>
  *   <li>4 : titre</li>
  *   <li>5 : auteur</li>
  * </ul>
  * @throws SQLException en cas d'erreur de connexion à la base.
  */
  public static String[] getLivreParIdExemplaire(int idExemplaire) throws SQLException {
    
	String[] livre = new String[6]; // Création du tableau de chaînes de caractères pour recevoir les données du livre.
	
	Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
	String sql = "select e.id, l.* from livre l join exemplaire e on e.idLivre = l.id where e.id =" + idExemplaire; // Requête à exécuter.
	ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
	
	while(rset.next()) { // Récupération de chaque élément en colonne de la table des données.
		livre[0] = rset.getString("id");
	    livre[1] = rset.getString("id");
	    livre[2] = rset.getString("isbn10");
	    livre[3] = rset.getString("isbn13");
	    livre[4] = rset.getString("titre");
	    livre[5] = rset.getString("auteur");
	}
	
	rset.close(); // Suppression de l'objet créé.
	stmt.close(); // Fermeture de la connexion créée.
	
	return livre; // On retourne le livre.
  }

  /**
   * Référencement d'un nouveau livre dans la base de données.
   * 
   * @param isbn10
   * @param isbn13
   * @param titre
   * @param auteur
   * @return l'identifiant (id) du livre créé.
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static int insererNouveauLivre(String isbn10, String isbn13, String titre, String auteur) throws SQLException {
    
	// On vérifie l'isbn du livre à insérer.
	String sql = "select * from livre where isbn10 = ? 	or  isbn13 = ?"; // Requête à exécuter.
	PreparedStatement pstmt = Connexion.getConnection().prepareStatement(sql); // Création de la connexion à la BD pour faire une requête préparée.
	pstmt.setString(1, isbn10); // On définit le premier ? de sql à isbn10.
	pstmt.setString(2, isbn13); // On définit le deuxième ? de sql à isbn13.
	ResultSet prset = pstmt.executeQuery();  // Création de la table des données après exécution de la requête.
	if(prset.next()) { // On va à la première ligne de données du prset.
		return -1; // Echec de la requête.
	}
	
	int insert = 0; // Une variable pour vérifier le succès ou non de l'insertion.
	
	String sql1 = "insert into livre values(nextval('livre_id_seq'), ?, ?, ?, ?)"; // Requête à exécuter.
	PreparedStatement pstmt1 = Connexion.getConnection().prepareStatement(sql1); // Création d'une autre connexion à la BD pour faire une requête préparée.
	pstmt1.setString(1, isbn10); // On définit le premier ? de sql1 à isbn10.
	pstmt1.setString(2, isbn13); // On définit le deuxième ? de sql1 à isbn13.
	pstmt1.setString(3, titre); // On définit le troisième ? de sql1 à titre.
	pstmt1.setString(4, auteur); // On définit le quatrième ? de sql1 à auteur.
	insert = pstmt1.executeUpdate(); // On met le résultat de la requête dans insert.
	pstmt1.close(); // Fermeture de la connexion créée.
	
	if(insert == 0) { // On vérifie si l'insertion n'a pas réussi.
		return -1; // Echec de la requête.
	}
	else { // Insertion réussie.
		Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
		String sql2 = "select currval('livre_id_seq')"; // Requête à exécuter.
		ResultSet rset = stmt.executeQuery(sql2); // Création de la table des données après exécution de la requête.
		rset.next(); // On va à la première ligne de données du rset.
		
		int id = rset.getInt(1); // On récupère l'id du livre.
		
		rset.close(); // Suppression de l'objet créé.
		stmt.close(); // Fermeture de la connexion créée.
		  
		return id; // On retourne l'id du livre.
	}
  }
  
/**
   * Modification des informations d'un livre donné connu à partir de son
   * identifiant : les nouvelles valeurs (isbn10, isbn13, etc.) écrasent les
   * anciennes.
   * 
   * @param idLivre : id du livre à modifier.
   * @param isbn10 : nouvelle valeur d'isbn10.
   * @param isbn13 : nouvelle valeur d'isbn13.
   * @param titre : nouvelle valeur du titre.
   * @param auteur : nouvel auteur.
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static void modifierLivre(int idLivre, String isbn10, String isbn13, String titre, String auteur) throws SQLException {
    
	  String sql = "update livre set isbn10 = ?, isbn13 = ?, titre = ?, auteur = ? where id = ? "; // Requête à exécuter.
	  
	  PreparedStatement pstmt = Connexion.getConnection().prepareStatement(sql); // Création de la connexion à la BD pour faire une requête préparée.
	  pstmt.setString(1, isbn10); // On définit le premier ? de sql à isbn10.
	  pstmt.setString(2, isbn13); // On définit le deuxième ? de sql à isbn13.
	  pstmt.setString(3, titre); // On définit le troisième ? de sql à titre.
	  pstmt.setString(4, auteur); // On définit le quatrième ? de sql à auteur.
	  pstmt.setInt(5, idLivre); // On définit le cinquième ? de sql à idLivre.
	  
	  pstmt.executeUpdate(); // On exécute la requête.
	  pstmt.close(); // Fermeture de la connexion créée.
  }

  /**
   * Suppression d'un abonné connu à partir de son identifiant.
   * 
   * @param idLivre : id du livre à supprimer.
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
   public static void supprimerLivre(int idLivre) throws SQLException {
	   
	  ArrayList<Integer> expList = listeExemplaires(idLivre); // On récupère tous les exemplaires du livre à supprimer.
	  
	  for(Integer id : expList) {
		  if(!ComposantBDEmprunt.estEmprunte(id)) continue; // Si un exemplaire du livre n'est pas emprunté, continuer le code.
	  }
	  
	  for (Integer id : expList) {
		  supprimerExemplaire(id); // Par contre, si aucun exemplaire du livre n'est emprunté, on supprime tous les exemplaires du livre.
	  }
	  
	  // Suppression du livre.
	  Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
	  String sql = "delete from livre where id=" + idLivre; // Requête à exécuter.
	  stmt.executeUpdate(sql); // On exécute la requête.
	  
	  stmt.close(); // Fermeture de la connexion créée.
   }

   /**
    * Retourne le nombre d'exemplaire d'un livre donné connu à partir
    * de son identifiant.
    * 
    * @param idLivre : id du livre dont on veut connaître le nombre d'exemplaires.
    * @return le nombre d'exemplaires
    * @throws SQLException en cas d'erreur de connexion à la base.
    */
   public static int nbExemplaires(int idLivre) throws SQLException {
     
	 Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
	 String sql = "select distinct count(id) from exemplaire where id_Livre =" + idLivre; // Requête à exécuter.
	 ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
	 rset.next(); // On va à la première ligne de données du rset.
	 
	 int nbExemplaires = rset.getInt(1); // On récupère le nombre d'exemplaires du livre.
	 
	 rset.close(); // Suppression de l'objet créé.
	 stmt.close(); // Fermeture de la connexion créée.
	 
	 return nbExemplaires; // On retourne le nombre d'exemplaires du livre.
   }

  /**
   * Récupération de la liste des identifiants d'exemplaires d'un livre donné
   * connu à partir de son identifiant.
   * 
   * @param idLivre : identifiant du livre dont on veut la liste des exemplaires.
   * @return un <code>ArrayList<Integer></code> contenant les identifiants des exemplaires
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static ArrayList<Integer> listeExemplaires(int idLivre) throws SQLException {
    
	ArrayList<Integer> exemplaires = new ArrayList<Integer>(); // Création de la liste de tous les id d'exemplaires du livre.
	
	Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
	String sql = "select * from exemplaire where id_Livre =" + idLivre; // Requête à exécuter.
	ResultSet rset = stmt.executeQuery(sql); // Création de la table des données après exécution de la requête.
	rset.next(); // On va à la première ligne de données du rset.
	
	while(rset.next()){ // Récupération de chaque élément en colonne de la table des données.
		int exemplaire = rset.getInt("id"); // On récupère le id de l'exemplaire du livre.
		exemplaires.add(exemplaire);
	}
	
	rset.close(); // Suppression de l'objet créé.
	stmt.close(); // Fermeture de la connexion créée.
	
	return exemplaires; // On retourne la liste d'id des exemplaires du livre.
  }

  /**
   * Ajout d'un exemplaire à un livre donné connu par son identifiant.
   * 
   * @param id identifiant du livre dont on veut ajouter un exemplaire.
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
   public static void ajouterExemplaire(int idLivre) throws SQLException {
	   
	Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
	String sql = "insert into exemplaire values(nextval('exemplaire_id_seq')," + idLivre + ")"; // Requête à exécuter.
	stmt.executeUpdate(sql); // On exécute la requête.
	
	stmt.close(); // Fermeture de la connexion créée.
   }

    /**
     * Suppression d'un exemplaire donné connu par son identifiant.
     * 
     * @param idExemplaire : identifiant du livre dont on veut supprimer un exemplaire.
     * @throws SQLException en cas d'erreur de connexion à la base.
     */
   public static void supprimerExemplaire(int idExemplaire) throws SQLException {
     
	if(!ComposantBDEmprunt.estEmprunte(idExemplaire)) { // On vérifie si l'exemplaire n'est pas emprunté.
		ComposantBDEmprunt.supprimerEmprunt(idExemplaire); // On supprime l'emprunt de cet exemplaire.
		
		Statement stmt = Connexion.getConnection().createStatement(); // Création de la connexion à la BD.
		String sql = "delete from exemplaire where id =" + idExemplaire; // Requête à exécuter.
		stmt.executeUpdate(sql); // On exécute la requête.
		
		stmt.close(); // Fermeture de la connexion créée.
	}
   }

}
