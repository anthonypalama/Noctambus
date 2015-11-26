package ch.noctambus.geneve;
import android.app.Application;
import com.parse.Parse;
/**
 * Created by Anthony on 25.11.2015.
 */

public class App extends Application {
    private static String APPLICATIONID = "PIKbWCJ808pCwESSaqPbOiey1v8YP9ju6osXBbAw";
    private static String CLIENTKEY = "Ev5LuFbUPtXWYKQXj6e71npPOLpcdQ4zIWsJUDKT";

    @Override public void onCreate() {
        super.onCreate();
        Parse.enableLocalDatastore(this);
        Parse.initialize(this, APPLICATIONID, CLIENTKEY); // Your Application ID and Client Key are defined elsewhere
    }
}
