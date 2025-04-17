package com.example.EnvironmentalMonitoring.repository;

import com.example.EnvironmentalMonitoring.model.User;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepo extends CrudRepository<User, Integer> {

    @Query(value = "SELECT * from users", nativeQuery = true)
    List<User> getUsers();

}
