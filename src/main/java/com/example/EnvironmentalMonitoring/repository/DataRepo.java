package com.example.EnvironmentalMonitoring.repository;

import com.example.EnvironmentalMonitoring.model.Location1History;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;

@Repository
public interface DataRepo extends CrudRepository<Location1History, Integer> {

    @Modifying
    @Transactional
    @Query(value = "MERGE INTO location1_history (date_time) KEY(date_time) VALUES (:date_time)", nativeQuery = true)
    void insertTime(@Param("date_time") String dateTime);

    @Modifying
    @Transactional
    @Query(value = "UPDATE location1_history SET temperature = :value WHERE date_time = :date_time", nativeQuery = true)
    void insertTemperature(@Param("value") String value, @Param("date_time") String date_time);

    @Modifying
    @Transactional
    @Query(value = "UPDATE location1_history SET humidity = :value WHERE date_time = :date_time", nativeQuery = true)
    void insertHumidity(@Param("value") String value, @Param("date_time") String date_time);

    @Modifying
    @Transactional
    @Query(value = "UPDATE location1_history SET air = :value WHERE date_time = :date_time", nativeQuery = true)
    void insertAir(@Param("value") String value, @Param("date_time") String date_time);

    @Modifying
    @Transactional
    @Query(value = "UPDATE location1_history SET water = :value WHERE date_time = :date_time", nativeQuery = true)
    void insertWater(@Param("value") String value, @Param("date_time") String date_time);

    @Modifying
    @Transactional
    @Query(value = "SELECT temperature FROM location1_history", nativeQuery = true)
    List<Double> readTemperature();

    @Modifying
    @Transactional
    @Query(value = "SELECT * FROM location1_history", nativeQuery = true)
    List<Location1History> read();

    @Modifying
    @Transactional
    @Query(value = "SELECT humidity FROM location1_history", nativeQuery = true)
    List<Double> readHumidity();

    @Modifying
    @Transactional
    @Query(value = "SELECT air FROM location1_history", nativeQuery = true)
    List<Double> readAir();

    @Modifying
    @Transactional
    @Query(value = "SELECT water FROM location1_history", nativeQuery = true)
    List<Double> readWater();

}
