package com.dulcebyte.web.dto;

import jakarta.validation.constraints.NotBlank;

public class CategoriaFormDto {

    @NotBlank(message = "El nombre es obligatorio")
    private String nombre;

    private String descripcion;

    public CategoriaFormDto() {
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
}