package com.example.android;

import android.content.Intent;
import android.content.SharedPreferences;
import android.support.annotation.StringRes;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.TextView;
import android.graphics.Color;
import android.widget.Toast;

import com.example.android.data.ApiService;
import com.example.android.data.ApiSingleton;
import com.example.android.data.model.LoggedInUser;
import com.example.android.data.model.LoggedInUserPackage;
import com.example.android.data.model.LoginRequestData;
import com.example.android.data.model.SignupRequestData;

import io.reactivex.Single;
import io.reactivex.SingleObserver;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class SignupActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signup);

        final Spinner spinner = (Spinner) findViewById(R.id.regPasswordSpinners);
        final Button signupSubmit = (Button) findViewById(R.id.signupSubmit);

        final TextView firstNameInp = (TextView) findViewById(R.id.regFirstName);
        final TextView lastNameInp = (TextView) findViewById(R.id.regLastName);
        final TextView userNameInp = (TextView) findViewById(R.id.regUserName);
        final TextView passwordInp = (TextView) findViewById(R.id.regPassword);
        final TextView passwordConfInp = (TextView) findViewById(R.id.regConfPassword);
        final Spinner recoveryQInp = (Spinner) findViewById(R.id.regPasswordSpinners);
        final TextView recoveryAInp = (TextView) findViewById(R.id.regRecoveryAns);

        String[] dataSource = getResources().getStringArray(R.array.recovery_questions);
        final ArrayAdapter<String> spinnerArrayAdapter = new ArrayAdapter<String>(
                this,R.layout.spinner_item,dataSource){
            @Override
            public boolean isEnabled(int position){
                if(position == 0)
                {
                    // Disable the first item from Spinner
                    // First item will be use for hint
                    return false;
                }
                else
                {
                    return true;
                }
            }
            @Override
            public View getDropDownView(int position, View convertView,
                                        ViewGroup parent) {
                View view = super.getDropDownView(position, convertView, parent);
                TextView tv = (TextView) view;
                if(position == 0){
                    // Set the hint text color gray
                    tv.setTextColor(Color.DKGRAY);
                }
                else {
                    tv.setTextColor(Color.WHITE);
                }
                return view;
            }
        };
        spinnerArrayAdapter.setDropDownViewResource(R.layout.spinner_item);
        spinner.setAdapter(spinnerArrayAdapter);

        signupSubmit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final String firstNameText = firstNameInp.getText().toString();
                final String lastNameText = lastNameInp.getText().toString();
                final String userNameText = userNameInp.getText().toString();
                final String passwordText = passwordInp.getText().toString();
                final String confPasswordText = passwordConfInp.getText().toString();
                final String recoveryQText = recoveryQInp.getSelectedItem().toString();
                final String recoveryAText = recoveryAInp.getText().toString();

                if(passwordText.equals(confPasswordText)){
                    performSignup(userNameText, passwordText, firstNameText, lastNameText);
                }
                else{
                    //TODO: Warn that password doesnt match
                }


            }
        });
    }

    private void performSignup(String username, String password, String firstname, String lastname){
        ApiService apiService = ApiSingleton.getInstance().getApiService();
        SignupRequestData signupData = new SignupRequestData(firstname, lastname, username, password);
        Single<Response<LoggedInUserPackage>> testObservable= apiService.getNewRegisteredUser(signupData);
        testObservable.subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new SingleObserver<Response<LoggedInUserPackage>>() {
                    @Override
                    public void onSubscribe(Disposable d) {
                    }
                    @Override
                    public void onSuccess(Response<LoggedInUserPackage> userResponse) {
                        if( userResponse.isSuccessful()){
                            SharedPreferences sp = getSharedPreferences("UserInfo", MODE_PRIVATE);
                            SharedPreferences.Editor spE = sp.edit();

                            LoggedInUser user = userResponse.body().getLoggedInUser();
                            updateUiWithUser(user);
                            spE.putInt("uid", user.getUid());
                            spE.apply();
                            Intent goToMap = new Intent(getApplicationContext(), MapActivity.class);
                            startActivity(goToMap);
                        }
                        else{
                            showLoginFailed(R.string.sign_up_user_exists);
                        }

                    }
                    @Override
                    public void onError(Throwable e) {
                        showLoginFailed(R.string.no_connection_to_server);
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


}
