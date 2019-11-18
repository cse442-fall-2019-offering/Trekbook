package com.example.android.data.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class ManyLoggedInUsersPackage {
    @SerializedName("data")
    @Expose
    private dataPackage data;
    @SerializedName("code")
    @Expose
    private String code;

    class dataPackage{
        @SerializedName("users")
        @Expose
        private List<LoggedInUser> users;
        public List<LoggedInUser> getUsers(){return this.users;        }
    }

    public List<LoggedInUser> getListOfUsers(){
        return data.getUsers();
    }

}
