package com.dulcebyte.web.service;

import com.dulcebyte.web.dto.ClienteDto;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.List;

@Service
public class ClienteService {

    private final RestClient restClient;

    public ClienteService(RestClient restClient) {
        this.restClient = restClient;
    }

    public List<ClienteDto> listar() {
        return restClient.get()
                .uri("/api/clientes")
                .retrieve()
                .body(new ParameterizedTypeReference<List<ClienteDto>>() {});
    }
}