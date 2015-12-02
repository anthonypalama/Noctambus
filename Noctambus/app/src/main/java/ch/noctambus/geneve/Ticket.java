package ch.noctambus.geneve;

import com.parse.ParseClassName;
import com.parse.ParseFile;
import com.parse.ParseObject;
import com.parse.ParseQuery;

/**
 * Created by JoaoRodrigues on 22.10.15.
 */
@ParseClassName("Ticket")
public class Ticket extends ParseObject {
    public static final int NUMERO = 788;

    public Ticket() {
        super();
    }

    public String getCode() {
        return getString("code");
    }

    public String getTypeBillet() {
        return getString("typeBillet");
    }

    public String getDescription() {
        return getString("description");
    }

    public double getPrix(){
        return getDouble("prix");
    }

    public ParseFile getLogo() {
        return getParseFile("logo");
    }

}
