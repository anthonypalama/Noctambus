package ch.noctambus.geneve;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.ListView;
import android.widget.SimpleAdapter;

/**
 * Activit� principale
 *
 * @author ??? - HEG-Gen�ve
 * @version 1.0
 */
public class TicketsActivity extends Activity {

	/* Liste des noms de colonnes et des identifiants des vues destination */
	private static final String[] FROM = { "logo", "typeBillet", "detail", "prix" };
	private static final int[] TO = { R.id.iwBillet, R.id.twTypeBillet,
			R.id.twDetail, R.id.twPrix};
	
	private ListView lvTickets;
	
	/* D�finition des r�f�rences aux vues */
	private void definirVariables() {
		lvTickets = (ListView) findViewById(R.id.lvTickets);
	} // definirVariables
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_tickets);
		initialiser();
	} // onCreate
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu items for use in the action bar
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.menutickets, menu);
		return super.onCreateOptionsMenu(menu);
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case android.R.id.home:
			Intent intent = new Intent(getApplicationContext(),
					MenuActivity.class);
			startActivity(intent);
			return true;
		}
		return super.onOptionsItemSelected(item);
	}

	private void initialiser(){
		gererActionBar(getActionBar());
		definirVariables();
		initListe();
	}// initialiser
	
	private void gererActionBar(ActionBar actionBar){	
		actionBar.setDisplayHomeAsUpEnabled(true);
		actionBar.setDisplayHomeAsUpEnabled(false);
	}
	
	private static int logo(Resources res, String nom) {
		return res.getIdentifier(nom.toLowerCase(), "drawable", R.class.getPackage().getName());
	} // blason

	
	  /* DÈfinition de la liste des cantons */
	  private void initListe () {
		  ArrayList<Ticket> listeTickets = new ArrayList<Ticket>(2);
		 // getActionBar().setTitle(listeTickets.size());
		  listeTickets.add(new Ticket("tpg1","Billet","Plein tarif",60,"Tout Genève",10,3, logo(getResources(), "tpg1")));
		  //Log.i("MyActivity", "MyClass.getView() — get item number " + listeTickets.size());
	    /* CrÈation de la liste des donnÈes */
	    List<HashMap<String, Object>> data = new ArrayList<HashMap<String, Object>>(listeTickets.size());
	    for (Ticket t: listeTickets) {
	      HashMap<String, Object> map = new HashMap<String, Object>();
	      map.put(FROM[0], t.getLogo());
	      map.put(FROM[1], t.getTypeBillet());
	      map.put(FROM[2], t.getDescription());
	      map.put(FROM[3], t.getPrix());
	      //map.put(LANGAGE, t);
	      data.add(map);
	    }
	    
	    SimpleAdapter adapter = new SimpleAdapter(getApplicationContext(), data, R.layout.un_ticket, FROM, TO);
	    lvTickets.setAdapter(adapter);
	  } // initListe
	
} // TicketsActivity
