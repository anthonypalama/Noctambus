package ch.noctambus.geneve;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.parse.ParseFile;
import com.parse.ParseImageView;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseQueryAdapter;

import ch.noctambus.geneve.R;

public class CustomAdapter extends ParseQueryAdapter<ParseObject> {


	public CustomAdapter(Context context) {
		// Use the QueryFactory to construct a PQA that will only show
		// Todos marked as high-pri
		super(context, new ParseQueryAdapter.QueryFactory<ParseObject>() {
			public ParseQuery create() {
				ParseQuery query = new ParseQuery("Ticket");
				query.fromLocalDatastore();
				return query;
			}
		});
	}

	// Customize the layout by overriding getItemView
	@Override
	public View getItemView(ParseObject object, View v, ViewGroup parent) {
		if (v == null) {
			v = View.inflate(getContext(), R.layout.un_ticket, null);
		}

		super.getItemView(object, v, parent);

		// Add and download the image
		ParseImageView todoImage = (ParseImageView) v.findViewById(R.id.icon);
		ParseFile imageFile = object.getParseFile("logo");
		if (imageFile != null) {
			todoImage.setParseFile(imageFile);
			todoImage.loadInBackground();
		}

		// Add the title view
		TextView titleTextView = (TextView) v.findViewById(R.id.twTypeBillet);
		titleTextView.setText(object.getString("typeBillet"));

		// Add a reminder of how long this item has been outstanding
		TextView titleTextView1 = (TextView) v.findViewById(R.id.twDescription);
		titleTextView1.setText(object.getString("description"));

		// Add a reminder of how long this item has been outstanding
		TextView titleTextView2 = (TextView) v.findViewById(R.id.twPrix);
		titleTextView2.setText(String.valueOf(object.getDouble("prix")));

		return v;
	}

}
