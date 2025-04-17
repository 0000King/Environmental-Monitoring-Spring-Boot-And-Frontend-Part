package com.example.EnvironmentalMonitoring.dto;

import java.util.List;

public class DataDto {
    private String labelName;
    private List<String> labels;
    private List<Double> values;

    public String getLabelName() { return labelName; }
    public void setLabelName(String labelName) { this.labelName = labelName; }

    public List<String> getLabels() { return labels; }

    public void setLabels(List<String> labels) { this.labels = labels; }

    public List<Double> getValues() { return values; }
    public void setValues(List<Double> values) { this.values = values; }

}