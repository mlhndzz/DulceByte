package com.dulcebyte.web.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public class AgregarDetalleDto {

    @NotNull
    private Integer idProducto;

    @NotNull
    @Min(value = 1, message = "La cantidad debe ser mayor a 0")
    @Max(value = 100, message = "La cantidad máxima es 100")
    private Integer cantidad;

    public AgregarDetalleDto() {
    }

    public Integer getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(Integer idProducto) {
        this.idProducto = idProducto;
    }

    public Integer getCantidad() {
        return cantidad;
    }

    public void setCantidad(Integer cantidad) {
        this.cantidad = cantidad;
    }
}