package com.dulcebyte.web.service;

import com.dulcebyte.web.dto.*;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.List;

@Service
public class PedidoService {

    private final RestClient restClient;

    public PedidoService(RestClient restClient) {
        this.restClient = restClient;
    }

    public List<PedidoDto> listar() {
        return restClient.get()
                .uri("/api/pedidos")
                .retrieve()
                .body(new ParameterizedTypeReference<List<PedidoDto>>() {});
    }

    public PedidoDto obtenerPorId(Integer id) {
        return restClient.get()
                .uri("/api/pedidos/{id}", id)
                .retrieve()
                .body(PedidoDto.class);
    }

    public PedidoDto crear(CrearPedidoDto pedido) {
        return restClient.post()
                .uri("/api/pedidos")
                .body(pedido)
                .retrieve()
                .body(PedidoDto.class);
    }

    public PedidoDto agregarDetalle(Integer id, AgregarDetalleDto detalle) {
        return restClient.post()
                .uri("/api/pedidos/{id}/detalle", id)
                .body(detalle)
                .retrieve()
                .body(PedidoDto.class);
    }

    public PedidoDto cambiarEstado(Integer id, CambiarEstadoDto estado) {
        return restClient.put()
                .uri("/api/pedidos/{id}/estado", id)
                .body(estado)
                .retrieve()
                .body(PedidoDto.class);
    }
}