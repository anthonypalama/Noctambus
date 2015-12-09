package ch.noctambus.geneve;

import android.app.ActionBar;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;

import com.parse.FindCallback;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseQueryAdapter;

import java.util.ArrayList;
import java.util.List;


public class TicketsActivity extends Activity {

    private ParseQueryAdapter<ParseObject> mainAdapter;
    private CustomAdapter urgentTodosAdapter;
    private ListView listView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_tickets);
        gererActionBar();

        // Initialize main ParseQueryAdapter
        /*mainAdapter = new ParseQueryAdapter<ParseObject>(this, "Ticket");
        mainAdapter.setImageKey("logo");
        mainAdapter.setTextKey("typeBillet");
        mainAdapter.setTextKey("description");
        mainAdapter.setTextKey("prix");*/


        // Initialize the subclass of ParseQueryAdapter
        urgentTodosAdapter = new CustomAdapter(this);

        // Initialize ListView and set initial view to mainAdapter
        listView = (ListView) findViewById(R.id.list);
       /* listView.setAdapter(mainAdapter);
        mainAdapter.loadObjects();*/
        listView.setAdapter(urgentTodosAdapter);
        urgentTodosAdapter.loadObjects();



        // Initialize toggle button
        /*Button toggleButton = (Button) findViewById(R.id.toggleButton);
        toggleButton.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                if (listView.getAdapter() == mainAdapter) {
                    listView.setAdapter(urgentTodosAdapter);
                    urgentTodosAdapter.loadObjects();
                } else {
                    listView.setAdapter(mainAdapter);
                    mainAdapter.loadObjects();
                }
            }

        });*/
    }


    private void gererActionBar(){
        getActionBar().setDisplayHomeAsUpEnabled(true);
        getActionBar().setDisplayHomeAsUpEnabled(false);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu items for use in the action bar
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menutickets, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                Intent intent = new Intent(getApplicationContext(),
                        MenuActivity.class);
                startActivity(intent);
                return true;
            case R.id.refresh:
                new AlertDialog.Builder(this)
                        .setTitle("Information")
                        .setMessage("Mettre à cet endroit le code 'refresh'")
                        .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                // continue with delete
                            }
                        })
                        .setIcon(android.R.drawable.ic_dialog_info)
                        .show();
                return true;
            case R.id.information:
                new AlertDialog.Builder(this)
                        .setTitle("Information")
                        .setMessage("Mettre à cet endroit le code 'information'")
                        .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                // continue with delete
                            }
                        })
                        .setIcon(android.R.drawable.ic_dialog_info)
                        .show();
                return true;
        }
        return super.onOptionsItemSelected(item);
    }

}
