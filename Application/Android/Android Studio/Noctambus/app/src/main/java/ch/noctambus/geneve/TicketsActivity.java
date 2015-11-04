package ch.noctambus.geneve;

import android.app.Activity;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.util.Log;
import android.widget.ListView;
import android.widget.SimpleAdapter;


import com.parse.ParseObject;
import com.parse.ParseQueryAdapter;

import java.io.File;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.TreeSet;

public class TicketsActivity extends Activity {

    private ParseQueryAdapter<ParseObject> mainAdapter;
    private ListView lvTickets;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_tickets);
        definirVariables();
        initListe();
    }

    private void definirVariables() {
        lvTickets = (ListView) findViewById(R.id.lvTickets);
    } // definirVariables



}


