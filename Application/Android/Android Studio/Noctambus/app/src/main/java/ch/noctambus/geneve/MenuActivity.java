package ch.noctambus.geneve;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.LinearLayout;

import com.parse.FindCallback;
import com.parse.Parse;
import com.parse.ParseObject;
import com.parse.ParseQuery;

import java.io.Serializable;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

/**
 * Activité principale
 *
 * @author João Diogo Amaral Rodrigues
 * @version 1.0
 */
public class MenuActivity extends Activity {
    public ArrayList<Ticket>lstTicket;


    private void recupererTickets(){
        ParseQuery<ParseObject> query = ParseQuery.getQuery("Tickets");
        query.findInBackground(new FindCallback<ParseObject>() {
            @Override
            public void done(List<ParseObject> tickets, com.parse.ParseException e) {
                if (e == null) {
                     lstTicket = new ArrayList<Ticket>(tickets.size());
                    System.out.println("Ouiiiiiiiiiiiiiiii ");
                    for (int i = 0;i< tickets.size();i++){
                        ParseObject po = tickets.get(i);
                       Ticket t= new Ticket(po.get("objectId").toString(), po.get("code").toString(), po.get("name").toString(), po.get("descriptionT").toString(),
                                po.get("nameLogo").toString(), Double.parseDouble(po.get("prix").toString()));
                        lstTicket.add(t);
                    }

                    Log.d("Tickets", "Retrieved " + tickets.size() + " scores");
                    System.out.println(lstTicket.size());

                } else {
                    Log.d("Tickets", "Error: " + e.getMessage());
                }
            }

        });
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Enlever actionbar du layout
        setContentView(R.layout.activity_menu);
        recupererTickets();
    }

    @Override
    protected void onSaveInstanceState (Bundle outState){
        super.onSaveInstanceState(outState);
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState){
        super.onSaveInstanceState(savedInstanceState);
    }



    public void allerVersTickets(View v) {
        Intent intent = new Intent(getApplicationContext(), TicketsActivity.class);
        Serializable lticket = lstTicket;
        intent.putExtra("lstTicket", lticket);
        startActivityForResult(intent, 1);
    }


} // MenuActivity
