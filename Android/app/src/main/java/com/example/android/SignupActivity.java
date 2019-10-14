package com.example.android;

import android.content.Intent;
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

import com.example.android.data.ApiService;
import com.example.android.data.ApiSingleton;
import com.example.android.data.model.LoggedInUser;
import com.example.android.data.model.SignupRequestData;

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
                    ApiService apiService = ApiSingleton.getInstance().getApiService();
                    SignupRequestData data = new SignupRequestData(firstNameText, lastNameText, userNameText,
                            passwordText, recoveryQText, recoveryAText);
                    Call<LoggedInUser> call = apiService.getNewRegisteredUser(data);

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
                                //We can do a catch of everything here
                                Log.e("Bad API code", "Successful call to server, but bad code: " + response.toString());
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
    }
}
