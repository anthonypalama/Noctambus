package ch.noctambus.geneve;

import android.app.Application;
import android.util.Log;

import com.parse.FindCallback;
import com.parse.Parse;
import com.parse.ParseObject;
import com.parse.ParseQuery;

import java.util.List;

/**
 * Created by João Rodrigues on 26.11.2015.
 */
public class ParseApplication extends Application {

    private final String APPLICATION_ID_PARSE = "NrIllSQdHSKBj2Sz4YT9jqJwGNvtCwpjgLCJnQQN";
    private final String APPLICATION_CLE_PARSE = "7wXQ94Cu97omFYe55wwor7V5mFgWlK8exPt1y5tR";

    @Override
    public void onCreate() {
        super.onCreate();
        // Enable Local Datastore (Active le stockage local des données)
        Parse.enableLocalDatastore(this);
        ParseObject.registerSubclass(Ticket.class);
        // Initialisation de Parse
        Parse.initialize(this, APPLICATION_ID_PARSE, APPLICATION_CLE_PARSE);
        //getTicketSL();
        getTicketParse();
    }

    private void getTicketParse(){
        // Define the class we would like to query
        ParseQuery<Ticket> query = ParseQuery.getQuery(Ticket.class);
        query.orderByAscending("code");
        // Execute the find asynchronously
        query.findInBackground(new FindCallback<Ticket>() {
            @Override
            public void done(List<Ticket> tickets, com.parse.ParseException e) {
                if (e == null) {
                    // Mettre les tickets dans la base de données local
                    //ParseObject.pinAllInBackground(tickets);
                    //ParseObject.fetchAllIfNeededInBackground(tickets);
                } else {
                    Log.d("getTicketParse()", "Erreur: " + e.getMessage());
                }
            }
        });

    }


}
