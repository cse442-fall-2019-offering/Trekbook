package com.example.android;

import android.content.Intent;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.ProgressBar;

import com.example.android.ui.login.LoginActivity;

public class MainActivity extends AppCompatActivity {

    private int i = 0;
    private Handler h = new Handler();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final ProgressBar progBar = findViewById(R.id.loadingLoginBar);
        i = progBar.getProgress();
        new Thread(new Runnable() {
            public void run() {
                //TODO: Hook up to the backend to wait for the server to be ready to accept requests
                while (i < 100) {
                    i += 1;
                    // Update the progress bar and display the current value in text view
                    h.post(new Runnable() {
                        public void run() {
                            progBar.setProgress(i);
                        }
                    });
                    try {
                        // Sleep for 100 milliseconds to show the progress slowly.
                        Thread.sleep(50);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                Intent goToLogin = new Intent(getApplicationContext(), LoginActivity.class);
                startActivity(goToLogin);
            }
        }).start();
    }
}
