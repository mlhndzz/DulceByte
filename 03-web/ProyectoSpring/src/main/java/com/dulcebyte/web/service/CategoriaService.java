package com.dulcebyte.web.service;

import com.dulcebyte.web.dto.CategoriaDto;
import com.dulcebyte.web.dto.CategoriaFormDto;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.List;

@Service
public class CategoriaService {

    private final RestClient restClient;

    public CategoriaService(RestClient restClient) {
        this.restClient = restClient;
    }

    public List<CategoriaDto> listar() {
        return restClient.get()
                .uri("/api/categorias")
                .retrieve()
                .body(new ParameterizedTypeReference<List<CategoriaDto>>() {});
    }

    public CategoriaDto obtenerPorId(Integer id) {
        return restClient.get()
                .uri("/api/categorias/{id}", id)
                .retrieve()
                .body(CategoriaDto.class);
    }

    public CategoriaDto crear(CategoriaFormDto categoria) {
        return restClient.post()
                .uri("/api/categorias")
                .body(categoria)
                .retrieve()
                .body(CategoriaDto.class);
    }

    public CategoriaDto actualizar(Integer id, CategoriaFormDto categoria) {
        return restClient.put()
                .uri("/api/categorias/{id}", id)
                .body(categoria)
                .retrieve()
                .body(CategoriaDto.class);
    }

    public void eliminar(Integer id) {
        restClient.delete()
                .uri("/api/categorias/{id}", id)
                .retrieve()
                .toBodilessEntity();
    }
}