package ch.noctambus.geneve;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;

import android.R.integer;
import android.content.res.Resources;
import android.net.ParseException;
import android.util.Log;

public class Tickets {
	private static final int EOF = -1; /* Marque de fin de fichier */

	/*
	 * Retourne la r�f�rence de R.drawable du logo du lanage du fichierIcone
	 * donn�
	 */
	private static int logo(Resources res, String nom) {
		return res.getIdentifier(nom.toLowerCase(), "drawable", R.class.getPackage().getName());
	} // blason

	/*
	 * Lecture de l'InputStream in et retour de la s�quence de charact�res dans
	 * un String
	 */
	private static String lireStr(InputStream in) {
		StringBuilder b = new StringBuilder();
		try {
			b.ensureCapacity(in.available() + 1);
			int c = in.read();
			while (c != EOF) {
				b.append((char) c);
				c = in.read();
			}
			in.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return b.toString();
	} // lireStr
	
	  /* Retourne la liste des cantons, dans l'ordre du fichier de donn�es */
	  public static ArrayList<Ticket> getTickets (Resources res) {
	    String[] ticketStr = lireStr(res.openRawResource(R.raw.tickets)).split("\r\n");
	    ArrayList<Ticket> langages = new ArrayList<Ticket>(ticketStr.length);
	    for (String lig : ticketStr) {
	      String[] valeurs = lig.split(";");
	      String code = valeurs[0];
	      String typeBillet = valeurs[1];
	      String typeTarif = valeurs[2];
	      int minutes = Integer.parseInt(valeurs[3]);
	      String description = valeurs[4];
	      int zone = Integer.parseInt(valeurs[5]);
	      int prix = Integer.parseInt(valeurs[6]);
	      int logo = logo(res, valeurs[0]);
	      langages.add(new Ticket(code, typeBillet, typeTarif, minutes, description, zone, prix, logo));
	    }
	    return langages;
	  } // getCantons


}
