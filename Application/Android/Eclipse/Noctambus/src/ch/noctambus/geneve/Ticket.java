package ch.noctambus.geneve;

public class Ticket {
	  public static final int NUMERO = 788; 
		
	  private String code;
	  private String typeBillet;
	  private String typeTarif;
	  private int minutes;
	  private String description;
	  private int zone;
	  private int prix;
	  private int logo;
	  
	  public Ticket (String code, String typeBillet, String typeTarif, int minutes, String description, int zone, int prix, int logo) {
		    this.code = code;
		    this.typeBillet = typeBillet;
		    this.typeTarif = typeTarif;
		    this.minutes = minutes;
		    this.description = description;
		    this.zone = zone;
		    this.prix = prix;
		    this.logo = logo; /* Identifiant de l'image du logo */
	} // Constructeur

	public static int getNumero() {
		return NUMERO;
	}

	public String getCode() {
		return code;
	}

	public String getTypeBillet() {
		return typeBillet;
	}

	public String getTypeTarif() {
		return typeTarif;
	}

	public int getMinutes() {
		return minutes;
	}

	public String getDescription() {
		return description;
	}

	public int getZone() {
		return zone;
	}

	public int getPrix() {
		return prix;
	}

	public int getLogo() {
		return logo;
	}
	  
	
}
