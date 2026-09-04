package com.dulcebyte.web.dto;

import jakarta.validation.constraints.NotNull;

public class CambiarEstadoDto {

    @NotNull
    private Integer idEstado;

    public CambiarEstadoDto() {
    }

    public Integer getIdEstado() {
        return idEstado;
    }

    public void setIdEstado(Integer idEstado) {
        this.idEstado = idEstado;
    }
}