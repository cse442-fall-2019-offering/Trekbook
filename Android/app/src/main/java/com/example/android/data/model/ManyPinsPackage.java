package com.example.android.data.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class ManyPinsPackage {
    @SerializedName("data")
    @Expose
    private dataPackage data;
    @SerializedName("code")
    @Expose
    private String code;

    class dataPackage{
        @SerializedName("markers")
        @Expose
        private List<PinSaveData> pins;
        public List<PinSaveData> getPins(){return this.pins;        }
    }

    public List<PinSaveData> getPins(){
        return data.getPins();
    }

}
