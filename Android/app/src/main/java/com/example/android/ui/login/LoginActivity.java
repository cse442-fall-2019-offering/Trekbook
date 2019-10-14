package com.example.android.ui.login;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.StringRes;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.example.android.MapActivity;
import com.example.android.R;
import com.example.android.SignupActivity;
import com.example.android.data.ApiService;
import com.example.android.data.ApiSingleton;
import com.example.android.data.model.LoggedInUser;
import com.example.android.data.model.LoginRequestData;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class LoginActivity extends AppCompatActivity {


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        final EditText usernameEditText = findViewById(R.id.username);
        final EditText passwordEditText = findViewById(R.id.regLastName);
        final Button loginButton = findViewById(R.id.login);
        final Button signUpButton = findViewById(R.id.signup);
        final ProgressBar loadingProgressBar = findViewById(R.id.loading);

        passwordEditText.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if(usernameEditText.getText() != null && passwordEditText.getText() != null) {
                    //TODO: This needs to be made modular for the submit button listener

                    ApiService apiService = ApiSingleton.getInstance().getApiService();
                    LoginRequestData data = new LoginRequestData(usernameEditText.getText().toString(),
                            passwordEditText.getText().toString());
                    Call<LoggedInUser> call = apiService.getLoggedInUser(data);

                    call.enqueue(new Callback<LoggedInUser>() {
                        @Override
                        public void onResponse(Call<LoggedInUser> call, Response<LoggedInUser> response) {
                            //Response code is in the range [200..300)
                            if (response.isSuccessful()) {
                                Log.i("API response success", response.toString());
                                Intent goToMap = new Intent(getApplicationContext(), MapActivity.class);
                                startActivity(goToMap);
                            }
                            //Server has returned some sort of error code
                            else {
                                Log.e("Bad API code", "Successful call to server, but bad return code");
                            }

                        }

                        //This happens if something basic goes wrong, internet not connected?
                        @Override
                        public void onFailure(Call<LoggedInUser> call, Throwable t) {
                            Log.e("API failure", t.toString());
                        }
                    });
                }
                return false;
            }
        });

        loginButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.d("API response success", "The button was clicked");
                if(usernameEditText.getText() != null && passwordEditText.getText() != null) {
                    ApiService apiService = ApiSingleton.getInstance().getApiService();
                    LoginRequestData data = new LoginRequestData(usernameEditText.getText().toString(),
                            passwordEditText.getText().toString());
                    Call<LoggedInUser> call = apiService.getLoggedInUser(data);

                    call.enqueue(new Callback<LoggedInUser>() {
                        @Override
                        public void onResponse(Call<LoggedInUser> call, Response<LoggedInUser> response) {
                            //Response code is in the range [200..300)
                            if (response.isSuccessful()) {
                                Log.i("API response success", response.toString());
                                Intent goToMap = new Intent(getApplicationContext(), MapActivity.class);
                                startActivity(goToMap);
                            }
                            //Server has returned some sort of error code
                            else {
                                Log.e("Bad API code", "Successful call to server, but bad code");
                            }

                        }

                        //This happens if something basic goes wrong, internet not connected?
                        @Override
                        public void onFailure(Call<LoggedInUser> call, Throwable t) {
                            Log.e("API failure", t.toString());
                        }
                    });
                }
            }
        });

        signUpButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent goToSignup = new Intent(getApplicationContext(), SignupActivity.class);
                startActivity(goToSignup);
            }
        });
    }

    private void updateUiWithUser(LoggedInUserView model) {
        String welcome = getString(R.string.welcome_user) + model.getDisplayName();
        // TODO : initiate successful logged in experience
        Toast.makeText(getApplicationContext(), welcome, Toast.LENGTH_LONG).show();
    }

    private void showLoginFailed(@StringRes Integer errorString) {
        Toast.makeText(getApplicationContext(), errorString, Toast.LENGTH_SHORT).show();
    }

}
