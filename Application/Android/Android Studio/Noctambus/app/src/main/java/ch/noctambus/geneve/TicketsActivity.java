package ch.noctambus.geneve;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.util.Log;
import android.view.View;
import android.widget.ListView;
import android.widget.SimpleAdapter;


import com.parse.ParseObject;
//import com.parse.ParseQueryAdapter;

import java.io.File;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.TreeSet;

public class TicketsActivity extends Activity {
    private static final String[] FROM = new String[] {"typeBilletRef", "detailRef", "prixRef"};
    private static final int[] TO = new int[] {R.id.twTypeBillet, R.id.twDetail, R.id.twPrix};

    private ArrayList<Ticket> lstTicket;
    ParseObject ticket = new ParseObject("Tickets");
    private final String TICKET ="ticket";
    //private ParseQueryAdapter<ParseObject> mainAdapter;
    private ListView lvTickets;

    @SuppressWarnings("unchecked")
    private void etatInit(){
        lstTicket=(ArrayList<Ticket>)getIntent().getSerializableExtra("lstTicket");
        affTicket();
    }

    private void affTicket() {
        List<HashMap<String, Object>> data = new ArrayList<HashMap<String, Object>>();
        for(int i=0;i<lstTicket.size();i++){
            Ticket t = (Ticket)lstTicket.get(i);
            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put(FROM[0], t.getCode().toString());
            map.put(FROM[1], t.getDescriptionT().toString());
            map.put(FROM[2], t.getPrix()+" CHF");

            map.put(TICKET, t);
            data.add(map);
        }
    }

    private class MyComp implements Comparator<Ticket> {
        @Override
        public int compare(Ticket lhs, Ticket rhs) {
            return lhs.getCode().compareTo(rhs.getCode());
        }
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_tickets);
        definirVariables();
        etatInit();
        //initListe();
    }

    private void definirVariables() {
        lvTickets = (ListView) findViewById(R.id.lvTickets);
    } // definirVariables



}


