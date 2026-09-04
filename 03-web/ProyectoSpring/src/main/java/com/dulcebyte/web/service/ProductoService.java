package com.dulcebyte.web.service;

import com.dulcebyte.web.dto.ProductoDto;
import com.dulcebyte.web.dto.ProductoFormDto;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.List;

@Service
public class ProductoService {

    private final RestClient restClient;

    public ProductoService(RestClient restClient) {
        this.restClient = restClient;
    }

    public List<ProductoDto> listar() {
        return restClient.get()
                .uri("/api/productos")
                .retrieve()
                .body(new ParameterizedTypeReference<List<ProductoDto>>() {});
    }

    public ProductoDto obtenerPorId(Integer id) {
        return restClient.get()
                .uri("/api/productos/{id}", id)
                .retrieve()
                .body(ProductoDto.class);
    }

    public ProductoDto crear(ProductoFormDto producto) {
        return restClient.post()
                .uri("/api/productos")
                .body(producto)
                .retrieve()
                .body(ProductoDto.class);
    }

    public ProductoDto actualizar(Integer id, ProductoFormDto producto) {
        return restClient.put()
                .uri("/api/productos/{id}", id)
                .body(producto)
                .retrieve()
                .body(ProductoDto.class);
    }

    public void eliminar(Integer id) {
        restClient.delete()
                .uri("/api/productos/{id}", id)
                .retrieve()
                .toBodilessEntity();
    }
}