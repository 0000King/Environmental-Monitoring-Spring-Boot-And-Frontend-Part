package com.example.EnvironmentalMonitoring.model;

import javax.persistence.*;

@Entity
@Table(name = "location1_history")
public class Location1History {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(unique = true)
    private String dateTime;
    private String temperature;
    private String humidity;
    private String air;
    private String water;

    public int getId() {
        return id;
    }

    public String getDateTime() {
        return dateTime;
    }

    public String getTemperature() {
        return temperature;
    }

    public String getHumidity() {
        return humidity;
    }

    public String getAir() {
        return air;
    }

    public String getWater() {
        return water;
    }
}