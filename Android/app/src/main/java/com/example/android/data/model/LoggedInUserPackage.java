package com.example.android.data.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class LoggedInUserPackage {
    @SerializedName("data")
    @Expose
    private LoggedInUser data;
    @SerializedName("code")
    @Expose
    private String code;

    public LoggedInUser getLoggedInUser(){
        return data;
    }
}
