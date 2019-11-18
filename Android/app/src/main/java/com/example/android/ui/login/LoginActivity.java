package com.example.android.ui.login;

import android.content.Intent;
import android.content.SharedPreferences;
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
import com.example.android.data.model.LoggedInUserPackage;
import com.example.android.data.model.LoginRequestData;

import io.reactivex.Single;
import io.reactivex.SingleObserver;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class LoginActivity extends AppCompatActivity {


    private EditText usernameEditText;
    private EditText passwordEditText;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        usernameEditText = findViewById(R.id.username);
        passwordEditText = findViewById(R.id.regLastName);
        final Button loginButton = findViewById(R.id.login);
        final Button signUpButton = findViewById(R.id.signup);
        final ProgressBar loadingProgressBar = findViewById(R.id.loading);

        passwordEditText.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if(usernameEditText.getText() != null && passwordEditText.getText() != null) {
                    performLogin();
                }
                return false;
            }
        });

        loginButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                performLogin();
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

    private void updateUiWithUser(LoggedInUser user) {
        String welcome = getString(R.string.welcome_user) + user.getFirstName();
        // TODO : initiate successful logged in experience
        Toast.makeText(getApplicationContext(), welcome, Toast.LENGTH_LONG).show();
    }

    private void showLoginFailed(@StringRes Integer errorString) {
        Toast.makeText(getApplicationContext(), errorString, Toast.LENGTH_SHORT).show();
    }

    private void performLogin(){
        if(!usernameEditText.getText().toString().equals("") && !passwordEditText.getText().toString().equals("")) {
            ApiService apiService = ApiSingleton.getInstance().getApiService();
            LoginRequestData data = new LoginRequestData(usernameEditText.getText().toString(),
                    passwordEditText.getText().toString());
            Single<Response<LoggedInUserPackage>> testObservable= apiService.getLoggedInUser(data);
            testObservable.subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(new SingleObserver<Response<LoggedInUserPackage>>() {
                        @Override
                        public void onSubscribe(Disposable d) {
                        }
                        @Override
                        public void onSuccess(Response<LoggedInUserPackage> userResponse) {
                            if( userResponse.isSuccessful()){
                                updateUiWithUser(userResponse.body().getLoggedInUser());
                                Intent goToMap = new Intent(getApplicationContext(), MapActivity.class);
                                startActivity(goToMap);
                            }
                            else{
                                showLoginFailed(R.string.login_failed);
                            }

                        }
                        @Override
                        public void onError(Throwable e) {
                            showLoginFailed(R.string.no_connection_to_server);
                        }
                    });
        }
        else{
            showLoginFailed(R.string.login_no_text);
        }
    }

}
