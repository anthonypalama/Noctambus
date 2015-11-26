package ch.noctambus.geneve;

/**
 * Created by JoaoRodrigues on 22.10.15.
 */
public class Ticket implements Comparable<Ticket>{
    public static final int NUMERO = 788;
    private String objectId;
    private String code;
    private String name;
    private String descriptionT;
    private String nameLogo;
    private double prix;
    //private int logo;

    public Ticket (String objectId,String code, String name, String descriptionT,String nameLogo, double prix/*, int logo*/) {
        this.objectId = objectId;
        this.code = code;
        this.name = name;
        this.descriptionT = descriptionT;
        this.nameLogo = nameLogo;
        this.prix = prix;
    } // Constructeur

    @Override
    public boolean equals (Object o) {return code == ((Ticket)o).code;}

    @Override
    public int compareTo (Ticket t) {
        int res = code.compareTo(t.code);
        //return (res != 0) ? res : code - t.code;
        return res;
    } // compareTo

    public static int getNUMERO() {
        return NUMERO;
    }

    public String getObjectId() {
        return objectId;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }

    public String getDescriptionT() {
        return descriptionT;
    }

    public String getNameLogo() {
        return nameLogo;
    }

    public double getPrix() {
        return prix;
    }
}
