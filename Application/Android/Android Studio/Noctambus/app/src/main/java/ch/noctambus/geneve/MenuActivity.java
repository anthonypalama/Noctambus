package ch.noctambus.geneve;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.LinearLayout;
import com.parse.Parse;
import com.parse.ParseObject;

import java.text.ParseException;

/**
 * Activité principale
 *
 * @author João Diogo Amaral Rodrigues
 * @version 1.0
 */
public class MenuActivity extends Activity {

    private LinearLayout layPortrait;
    private LinearLayout layPaysage;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Enlever actionbar du layout
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_menu);
        initialiser();
    }

    private void initialiser() {
        definirControles();
        gererRotation();
        connecterParse();
    }// initialiser

    private void definirControles() {
        layPortrait = (LinearLayout) findViewById(R.id.layPortrait);
        layPaysage = (LinearLayout) findViewById(R.id.layPaysage);
    } // definirControles

    private void gererRotation() {
        if (getResources().getDisplayMetrics().widthPixels > getResources().getDisplayMetrics().heightPixels) {
            layPortrait.setVisibility(View.GONE);
            layPaysage.setVisibility(View.VISIBLE);
        } else {
            layPortrait.setVisibility(View.VISIBLE);
            layPaysage.setVisibility(View.GONE);
        }
    }// gererRotation

    public void allerVersTickets(View v) {
        Intent intent = new Intent(getApplicationContext(), TicketsActivity.class);
        startActivity(intent);
    }

    private void connecterParse(){
        // Enable Local Datastore.
        Parse.enableLocalDatastore(this);
        Parse.initialize(this, "NrIllSQdHSKBj2Sz4YT9jqJwGNvtCwpjgLCJnQQN", "7wXQ94Cu97omFYe55wwor7V5mFgWlK8exPt1y5tR");
    }

} // MenuActivity
