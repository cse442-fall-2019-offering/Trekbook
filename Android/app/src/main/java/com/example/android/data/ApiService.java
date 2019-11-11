package com.example.android.data;

import com.example.android.data.model.LoggedInUser;
import com.example.android.data.model.LoggedInUserPackage;
import com.example.android.data.model.LoginRequestData;
import com.example.android.data.model.SignupRequestData;

//TODO: we want to use reactive
import io.reactivex.Single;
import retrofit2.Call;
import retrofit2.Response;
import retrofit2.http.Body;
import retrofit2.http.Field;
import retrofit2.http.POST;

public interface ApiService {

    @POST("v1/login")
    Single<Response<LoggedInUserPackage>> getLoggedInUser(@Body LoginRequestData data);

    @POST("v1/signup")
    Single<Response<LoggedInUserPackage>> getNewRegisteredUser(@Body SignupRequestData req);
}
