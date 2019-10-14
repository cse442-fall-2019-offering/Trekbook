package com.example.android.data;

import com.example.android.data.model.LoggedInUser;
import com.example.android.data.model.LoginRequestData;
import com.example.android.data.model.SignupRequestData;

//TODO: we want to use reactive
import io.reactivex.Single;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.POST;

public interface ApiService {

    @POST("v1/login")
    Call<LoggedInUser> getLoggedInUser(@Body LoginRequestData req);

    @POST("v1/signup")
    Call<LoggedInUser> getNewRegisteredUser(@Body SignupRequestData req);
}
