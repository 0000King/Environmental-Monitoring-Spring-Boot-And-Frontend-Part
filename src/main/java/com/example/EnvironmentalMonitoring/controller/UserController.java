package com.example.EnvironmentalMonitoring.controller;

import com.example.EnvironmentalMonitoring.dto.DataDto;
import com.example.EnvironmentalMonitoring.dto.UserDto;
import com.example.EnvironmentalMonitoring.model.Location1History;
import com.example.EnvironmentalMonitoring.repository.DataRepo;
import com.example.EnvironmentalMonitoring.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class UserController {

    @Autowired
    private UserService userService;
    @Autowired
    private DataRepo dataRepo;

    @Value("${GOOGLE_MAPS_KEY}")
    private String googleMapsKey;

    @RequestMapping({"/", "/welcome"})
    public String welcome() {
        return "welcome";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @PostMapping("/login")
    public String loggedIn(@Valid @ModelAttribute UserDto userDto, RedirectAttributes redirectAttributes, HttpSession session) {
        if(userService.login(userDto, session)) {
            return  "redirect:/userDashboard";
        } else {
            redirectAttributes.addFlashAttribute("message", "Invalid username or password");
            return "redirect:/login";
        }
    }

    @GetMapping("/userDashboard")
    public String userDashboard(Model model) {
        model.addAttribute("googleMapsKey", googleMapsKey);
        return "userDashboard";
    }

    @PostMapping("/saveData")
    @ResponseBody
    public void saveData(@RequestBody DataDto dataDto) {
        userService.saveData(dataDto);
    }

    @PostMapping("/processSensorData")
    public ResponseEntity<Map<String, Object>> processSensorData(@RequestParam String email) {

        List<Location1History> list = dataRepo.read().stream().sorted(Comparator.comparing(Location1History::getId)).collect(Collectors.toList());
        Map<String, Object> response = new HashMap<>();
        if(!list.isEmpty()) {
            List<Double> tempList = List.of(Double.parseDouble(list.get(list.size() - 1).getTemperature()));
            List<Double> humidityList = List.of(Double.parseDouble(list.get(list.size() - 1).getHumidity()));
            List<Double> airList = List.of(Double.parseDouble(list.get(list.size() - 1).getAir()));
            List<Double> waterList = List.of(Double.parseDouble(list.get(list.size() - 1).getWater()));
            userService.checkAnomalyAndSendEmail(tempList, humidityList, airList, waterList, email);
            response.put("status", "success");
            response.put("message", "Anomaly check triggered");
        }
        return ResponseEntity.ok(response);
    }
}