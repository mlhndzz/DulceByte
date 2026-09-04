package com.dulcebyte.web.service;

import com.dulcebyte.web.dto.EstadoPedidoDto;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.List;

@Service
public class EstadoPedidoService {

    private final RestClient restClient;

    public EstadoPedidoService(RestClient restClient) {
        this.restClient = restClient;
    }

    public List<EstadoPedidoDto> listar() {
        return restClient.get()
                .uri("/api/estados-pedido")
                .retrieve()
                .body(new ParameterizedTypeReference<List<EstadoPedidoDto>>() {});
    }
}