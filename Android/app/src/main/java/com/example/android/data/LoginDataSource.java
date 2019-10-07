package com.example.android.data;

import android.util.Log;


import com.example.android.data.model.LoggedInUser;
import com.example.android.data.model.LoginRequestData;


import io.reactivex.Single;
import io.reactivex.SingleObserver;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Class that handles authentication w/ login credentials and retrieves user information.
 */
public class LoginDataSource{

    public Result<LoggedInUser> login(String username, String password) {

        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl("https://e1bd96bf-16ed-4fac-96f3-9cb1495039ec.mock.pstmn.io")
                .addConverterFactory(GsonConverterFactory.create())
                .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                .build();

        ApiService apiService = retrofit.create(ApiService.class);

        LoginRequestData data = new LoginRequestData(username, password);

        Call<LoggedInUser> call = apiService.getLoggedInUser(data);

        call.enqueue(new Callback<LoggedInUser>() {
            @Override
            public void onResponse(Call<LoggedInUser> call, Response<LoggedInUser> response) {
                Log.i("API success", response.body().toString());
            }

            @Override
            public void onFailure(Call<LoggedInUser> call, Throwable t) {
                Log.e("API failure", t.toString());
            }
        });


        return new Result.Success<>(new LoggedInUser("1","Liam"));
    }

    public void logout() {
        // TODO: revoke authentication
    }
}
