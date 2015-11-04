package ch.noctambus.geneve;

/**
 * Created by JoaoRodrigues on 22.10.15.
 */
public class Ticket implements Comparable<Ticket>{
    public static final int NUMERO = 788;

    private String code;
    private String typeBillet;
    private String description;
    private double prix;
    //private int logo;

    public Ticket (String code, String typeBillet, String description, double prix/*, int logo*/) {
        this.code = code;
        this.typeBillet = typeBillet;
        this.description = description;
        this.prix = prix;
        //this.logo = logo; /* Identifiant de l'image du logo */
    } // Constructeur

    @Override
    public boolean equals (Object o) {return code == ((Ticket)o).code;}

    @Override
    public int compareTo (Ticket t) {
        int res = code.compareTo(t.code);
        //return (res != 0) ? res : code - t.code;
        return res;
    } // compareTo

    public static int getNumero() {
        return NUMERO;
    }

    public String getCode() {
        return code;
    }

    public String getTypeBillet() {
        return typeBillet;
    }

    public String getDescription() {
        return description;
    }

    public double getPrix() {
        return prix;
    }

    /*public int getLogo() {
        return logo;
    }*/

}
