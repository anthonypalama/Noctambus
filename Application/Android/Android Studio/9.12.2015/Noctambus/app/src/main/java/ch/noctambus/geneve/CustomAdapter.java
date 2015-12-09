package ch.noctambus.geneve;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.parse.Parse;
import com.parse.ParseFile;
import com.parse.ParseImageView;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseQueryAdapter;

public class CustomAdapter extends ParseQueryAdapter<ParseObject> {


	public CustomAdapter(Context context) {
		// Use the QueryFactory to construct a PQA that will only show
		// Todos marked as high-pri
		super(context, new ParseQueryAdapter.QueryFactory<ParseObject>() {
			public ParseQuery create() {
				ParseQuery query = new ParseQuery("Tickets");
				query.fromLocalDatastore();
				return query;
			}
		});
	}

	// Customize the layout by overriding getItemView
	@Override
	public View getItemView(final ParseObject object, View v, ViewGroup parent) {

		if (v == null) {
			v = View.inflate(getContext(), R.layout.un_ticket_test, null);
		}

		Ticket t = (Ticket)object;

		super.getItemView(object, v, parent);


		// Add and download the image
		ParseImageView logo = (ParseImageView) v.findViewById(R.id.logo);
		ParseFile imageFile = t.getLogo();
		if (imageFile != null) {
			logo.setParseFile(imageFile);
			logo.loadInBackground();
		}

		TextView twTypeBillet = (TextView) v.findViewById(R.id.twTypeBillet);
		twTypeBillet.setText(t.getTypeBillet());

		// Add a reminder of how long this item has been outstanding
		TextView twDescription = (TextView) v.findViewById(R.id.twDescription);
		twDescription.setText(t.getDescription());

		// Add a reminder of how long this item has been outstanding
		TextView twPrix = (TextView) v.findViewById(R.id.twPrix);
		twPrix.setText(String.valueOf(t.getPrix())+ " "+getContext().getString(R.string.libCHF));

		v.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// Send single item click data to SingleItemView Class
				//Intent intent = new Intent(mContext, SingleItemView.class);
				// Pass all data
				//intent.putExtra("title", meal.getTitle());
				//intent.putExtra("id", meal.getParseFile("photo").getUrl());
				//intent.putExtra("mealID", meal.getObjectId());
				//mContext.startActivity(intent);
				//Log.d("getTicketParse()", "Erreur: " + String.valueOf(object.getCode()));
				alertStandard();
			}
		});

		return v;
	}

	/* Affiche une AlertDialog standard; les listeners rendent compte des choix de l'utilisateur */
	private void alertStandard () {
		new AlertDialog.Builder(getContext())
				//.setIcon(R.drawable.question)
				.setTitle("Test")
				.setMessage("Test")
				.setPositiveButton("oui", new DialogInterface.OnClickListener() {
					@Override
					public void onClick (DialogInterface dialog, int which) {
						Log.d("getTicketParse()", "Envoyer SMS");
					} // onClick
				})
				.setNegativeButton("non", new DialogInterface.OnClickListener() {
					@Override
					public void onClick (DialogInterface dialog, int which) {
						return;
					} // onClick
				})
				.show();
	} // alertStandard

}
