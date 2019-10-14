package com.example.android.data;

import retrofit2.Retrofit;
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;
import retrofit2.converter.gson.GsonConverterFactory;

public class ApiSingleton {

    private static ApiSingleton instance = null;
    public static final String BASE_URL = "your_base_url";

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
                .baseUrl("https://e1bd96bf-16ed-4fac-96f3-9cb1495039ec.mock.pstmn.io")
                .addConverterFactory(GsonConverterFactory.create())
                .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                .build();

        this.service = retrofit.create(ApiService.class);
    }

    public ApiService getApiService() {
        return this.service;
    }


}
