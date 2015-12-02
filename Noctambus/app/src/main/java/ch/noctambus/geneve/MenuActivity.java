package ch.noctambus.geneve;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;

import com.parse.FindCallback;
import com.parse.Parse;
import com.parse.ParseObject;
import com.parse.ParseQuery;

import java.util.List;

public class MenuActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Enlever actionbar du layout
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_menu);
        //getTicketSL();
    }

    private void getTicketSL(){
        // Define the class we would like to query
        ParseQuery<Ticket> query = ParseQuery.getQuery(Ticket.class);
        query.fromLocalDatastore();
        // Execute the find asynchronously
        query.findInBackground(new FindCallback<Ticket>() {
            @Override
            public void done(List<Ticket> tickets, com.parse.ParseException e) {
                if (e == null) {
                    // Access the array of results here
                    for (int i = 0; i < tickets.size(); i++) {
                        Log.d("(Storage Local)", "code: " + tickets.get(i).getCode());
                        Log.d("(Storage Local)", "typeBillet: " + tickets.get(i).getTypeBillet());
                        Log.d("(Storage Local)", "description: " + tickets.get(i).getDescription());
                        Log.d("(Storage Local)", "prix: " + tickets.get(i).getPrix());

                    }
                } else {
                    Log.d("(Storage Local)", "Error: " + e.getMessage());
                }
            }
        });
    }

    public void allerVersTickets(View v) {
        Intent intent = new Intent(this, TicketsActivity.class);
        startActivity(intent);
    }






}
