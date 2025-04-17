package com.example.EnvironmentalMonitoring.service;

import com.example.EnvironmentalMonitoring.dto.DataDto;
import com.example.EnvironmentalMonitoring.dto.UserDto;
import com.example.EnvironmentalMonitoring.model.User;
import com.example.EnvironmentalMonitoring.repository.DataRepo;
import com.example.EnvironmentalMonitoring.repository.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;

@Service
public class UserService {

    private final DataRepo dataRepo;

    @Autowired
    public UserService(DataRepo dataRepo) {
        this.dataRepo = dataRepo;
    }

    public boolean login(UserDto userDto, HttpSession session) {
        return "abc".equals(userDto.getUsername()) && "abc".equals(userDto.getPassword());
    }

    public void saveData(DataDto dataDto) {
        String labelName = dataDto.getLabelName().toLowerCase();
        List<String> dateTime = dataDto.getLabels();
        if(labelName.equalsIgnoreCase("fetch temperature \uD83C\uDF21️")) {
            dateTime.forEach(dataRepo::insertTime);
        }
        List<Double> values = dataDto.getValues();
        for (int i = 0; i < values.size(); i++) {
            String stringValue = String.valueOf(values.get(i));
            String time = dateTime.get(i);

            switch (labelName) {
                case "fetch temperature \uD83C\uDF21️":
                    dataRepo.insertTemperature(stringValue, time);
                    break;
                case "fetch humidity \uD83D\uDCA7":
                    dataRepo.insertHumidity(stringValue, time);
                    break;
                case "fetch air quality \uD83C\uDF2B️":
                    dataRepo.insertAir(stringValue, time);
                    break;
                case "fetch water quality \uD83D\uDEB0":
                    dataRepo.insertWater(stringValue, time);
                    break;
            }
        }
    }

    public void checkAnomalyAndSendEmail(List<Double> tempList,
                                            List<Double> humidityList,
                                            List<Double> airList,
                                            List<Double> waterList,
                                            String email) {
        RestTemplate restTemplate = new RestTemplate();
        String flaskApi = "https://environmental-monitoring-flask-part.onrender.com/detect-anomaly";

        List<List<Double>> featureVectors = new ArrayList<>();

        int dataSize = Math.min(Math.min(tempList.size(), humidityList.size()),
                Math.min(airList.size(), waterList.size()));

        for (int i = 0; i < dataSize; i++) {
            List<Double> feature = new ArrayList<>();
            feature.add(tempList.get(i));
            feature.add(humidityList.get(i));
            feature.add(airList.get(i));
            feature.add(waterList.get(i));
            featureVectors.add(feature);
        }

        Map<String, Object> payload = new HashMap<>();
        payload.put("features", featureVectors); // [[temp, hum, air, water], ...]
        payload.put("email", email);

        try {
            restTemplate.postForEntity(flaskApi, payload, Map.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
