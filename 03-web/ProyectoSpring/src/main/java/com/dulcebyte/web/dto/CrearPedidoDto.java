package com.dulcebyte.web.dto;

import jakarta.validation.constraints.NotNull;

public class CrearPedidoDto {

    @NotNull
    private Integer idCliente;

    public CrearPedidoDto() {
    }

    public Integer getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(Integer idCliente) {
        this.idCliente = idCliente;
    }
}