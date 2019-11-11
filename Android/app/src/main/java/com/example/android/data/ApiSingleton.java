package com.example.android.data;

import retrofit2.Retrofit;
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;
import retrofit2.converter.gson.GsonConverterFactory;

public class ApiSingleton {

    private static ApiSingleton instance = null;
    public static final String BASE_URL = "http://10.0.2.2:8000";

    private ApiService service;

    private ApiSingleton(){
        this.buildRetrofit();
    }

    public static ApiSingleton getInstance() {
        if (instance == null) {
            instance = new ApiSingleton();
        }
        return instance;
    }

    private void buildRetrofit() {
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(GsonConverterFactory.create())
                .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                .build();

        this.service = retrofit.create(ApiService.class);
    }

    public ApiService getApiService() {
        return this.service;
    }


}
