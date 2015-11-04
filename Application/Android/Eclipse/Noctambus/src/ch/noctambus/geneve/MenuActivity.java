package ch.noctambus.geneve;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.LinearLayout;

/**
 * Activit� principale
 *
 * @author ??? - HEG-Gen�ve
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

} // MenuActivity
