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

    ArrayList<String[]> livres = new ArrayList<String[]>();

    Statement stmt = Connexion.getConnection().createStatement();
    String sql = "select * from livre";
    ResultSet rset = stmt.executeQuery(sql);

    while (rset.next()) {
      String[] livre = new String[5];
      livre[0] = rset.getString("id");
      livre[1] = rset.getString("isbn10");
      livre[2] = rset.getString("isbn13");
      livre[3] = rset.getString("titre");
      livre[4] = rset.getString("auteur");

      livres.add(livre);
    }
    rset.close();
    stmt.close();

    return livres;
  }

  /**
   * Retourne le nombre de livres référencés dans la base.
   * 
   * @return le nombre de livres.
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
  public static int nbLivres() throws SQLException {
    
	Statement stmt = Connexion.getConnection().createStatement();
	String sql = "select distinct count(id) from livre";
	ResultSet rset = stmt.executeQuery(sql);
	rset.next();
	
    int nbLivres = rset.getInt(1);
    
    rset.close();
    stmt.close();
	
    return nbLivres;
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
     
	 String[] livre = new String[5];
	 
     Statement stmt = Connexion.getConnection().createStatement();
     String sql = "select * from livre where id=" + idLivre;
     ResultSet rset = stmt.executeQuery(sql);
     rset.next();
     
     livre[0] = rset.getString("id");
     livre[1] = rset.getString("isbn10");
     livre[2] = rset.getString("isbn13");
     livre[3] = rset.getString("titre");
     livre[4] = rset.getString("auteur");
     
     rset.close();
     stmt.close();
     
     return livre;
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
    
	String[] livre = new String[6];
    
    Statement stmt = Connexion.getConnection().createStatement();
    String sql = "select e.id, l.* from livre l join exemplaire e on e.idLivre = l.id where e.id =" + idExemplaire;
    ResultSet rset = stmt.executeQuery(sql);
    
    while(rset.next()) {
    	livre[0] = rset.getString("id");
        livre[1] = rset.getString("id");
        livre[2] = rset.getString("isbn10");
        livre[3] = rset.getString("isbn13");
        livre[4] = rset.getString("titre");
        livre[5] = rset.getString("auteur");
    }
    
    rset.close();
    stmt.close();
    
    return livre;
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
	String sql = "select * from livre where isbn10 = ? 	or  isbn13 = ?";
	PreparedStatement pstmt = Connexion.getConnection().prepareStatement(sql);
	pstmt.setString(1, isbn10);
	pstmt.setString(2, isbn13);
	ResultSet prset = pstmt.executeQuery();
	if(prset.next()) {
		return -1; // Echec de la requête.
	}
	
	int insert = 0; // Une variable pour vérifier le succès ou non de l'insertion.
	
	String sql1 = "insert into livre values(nextval('livre_id_seq'), ?, ?, ?, ?)";
	PreparedStatement pstmt1 = Connexion.getConnection().prepareStatement(sql1);
	pstmt1.setString(1, isbn10);
	pstmt1.setString(2, isbn13);
	pstmt1.setString(3, titre);
	pstmt1.setString(4, auteur);
	insert = pstmt1.executeUpdate(); 
	pstmt1.close();
	
	if(insert == 0) {		 
		return -1; // Echec de la requête.
	}
	else {
		Statement stmt = Connexion.getConnection().createStatement();
		String sql2 = "select currval('livre_id_seq') as current_id_Livre";
		ResultSet rset = stmt.executeQuery(sql2);
		rset.next();
		
		int id = rset.getInt("current_id_Livre");
		
		rset.close();
		stmt.close();
		  
		return id;
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
    
	  String sql = "update livre set isbn10 = ?, isbn13 = ?, titre = ?, auteur = ? where id = ? ";
	  
	  PreparedStatement pstmt = Connexion.getConnection().prepareStatement(sql);
	  pstmt.setString(1, isbn10);
	  pstmt.setString(2, isbn13);
	  pstmt.setString(3, titre);
	  pstmt.setString(4, auteur);
	  pstmt.setInt(5, idLivre);
	  
	  pstmt.executeUpdate(); 
	  
	  pstmt.close();
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
	  Statement stmt = Connexion.getConnection().createStatement();
	  String sql = "delete from livre where id=" + idLivre;
	  stmt.executeUpdate(sql);
	  stmt.close();
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
     
     Statement stmt = Connexion.getConnection().createStatement();
	 String sql = "select count(*) from exemplaire e join livre l on e.idLivre = l.id where l.id=" + String.valueOf(idLivre);
     ResultSet rset = stmt.executeQuery(sql);
     rset.next();
     
     int nbExemplaires = rset.getInt(1);
     
     rset.close();
     stmt.close();
     
     return nbExemplaires;
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
    
	ArrayList<Integer> exemplaires = new ArrayList<Integer>();
    
	Statement stmt = Connexion.getConnection().createStatement();
	String sql = "select e.id from exemplaire e join livre l on e.idLivre = l.id where l.id=" + String.valueOf(idLivre);
    ResultSet rset = stmt.executeQuery(sql);
    rset.next();
    
    while(rset.next()){
    	int exemplaire = rset.getInt(1);
    	exemplaires.add(exemplaire);
    }
    
    rset.close();
    stmt.close();
    
    return exemplaires;
  }

  /**
   * Ajout d'un exemplaire à un livre donné connu par son identifiant.
   * 
   * @param id identifiant du livre dont on veut ajouter un exemplaire.
   * @throws SQLException en cas d'erreur de connexion à la base.
   */
   public static void ajouterExemplaire(int idLivre) throws SQLException {
	   
	Statement stmt = Connexion.getConnection().createStatement();
	String sql = "insert into exemplaire values(nextval('exemplaire_id_seq')," + String.valueOf(idLivre) + ")";
    ResultSet rset = stmt.executeQuery(sql);
    rset.close();
    stmt.close();
   }

    /**
     * Suppression d'un exemplaire donné connu par son identifiant.
     * 
     * @param idExemplaire : identifiant du livre dont on veut supprimer un exemplaire.
     * @throws SQLException en cas d'erreur de connexion à la base.
     */
   public static void supprimerExemplaire(int idExemplaire) throws SQLException {
     
	 Statement stmt = Connexion.getConnection().createStatement();
	 String sql = "delete * from exemplaire where id=" + String.valueOf(idExemplaire);
	 ResultSet rset = stmt.executeQuery(sql);
	 rset.close();
	 stmt.close();
   }

}
