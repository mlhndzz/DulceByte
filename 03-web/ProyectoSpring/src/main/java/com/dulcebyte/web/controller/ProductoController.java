package com.dulcebyte.web.controller;

import com.dulcebyte.web.dto.ProductoDto;
import com.dulcebyte.web.dto.ProductoFormDto;
import com.dulcebyte.web.service.CategoriaService;
import com.dulcebyte.web.service.ProductoService;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/productos")
public class ProductoController {

    private final ProductoService productoService;
    private final CategoriaService categoriaService;

    public ProductoController(
            ProductoService productoService,
            CategoriaService categoriaService) {

        this.productoService = productoService;
        this.categoriaService = categoriaService;
    }

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("productos", productoService.listar());
        return "productos/lista";
    }

    @GetMapping("/nuevo")
    public String nuevo(Model model) {
        model.addAttribute("producto", new ProductoFormDto());
        model.addAttribute("categorias", categoriaService.listar());
        model.addAttribute("titulo", "Nuevo producto");

        return "productos/formulario";
    }

    @PostMapping("/guardar")
    public String guardar(
            @Valid @ModelAttribute("producto") ProductoFormDto producto,
            BindingResult result,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            model.addAttribute("categorias", categoriaService.listar());
            model.addAttribute("titulo", "Nuevo producto");
            return "productos/formulario";
        }

        productoService.crear(producto);

        redirectAttributes.addFlashAttribute(
                "mensaje",
                "Producto registrado correctamente"
        );

        return "redirect:/productos";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Integer id, Model model) {

        ProductoDto existente = productoService.obtenerPorId(id);

        ProductoFormDto producto = new ProductoFormDto();

        producto.setNombre(existente.getNombre());
        producto.setDescripcion(existente.getDescripcion());
        producto.setPrecio(existente.getPrecio());
        producto.setDisponible(existente.getDisponible());
        producto.setIdCategoria(existente.getIdCategoria());

        model.addAttribute("producto", producto);
        model.addAttribute("categorias", categoriaService.listar());
        model.addAttribute("titulo", "Editar producto");
        model.addAttribute("idProducto", id);

        return "productos/formulario";
    }

    @PostMapping("/actualizar/{id}")
    public String actualizar(
            @PathVariable Integer id,
            @Valid @ModelAttribute("producto") ProductoFormDto producto,
            BindingResult result,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            model.addAttribute("categorias", categoriaService.listar());
            model.addAttribute("titulo", "Editar producto");
            model.addAttribute("idProducto", id);

            return "productos/formulario";
        }

        productoService.actualizar(id, producto);

        redirectAttributes.addFlashAttribute(
                "mensaje",
                "Producto actualizado correctamente"
        );

        return "redirect:/productos";
    }

    @PostMapping("/eliminar/{id}")
    public String eliminar(
            @PathVariable Integer id,
            RedirectAttributes redirectAttributes) {

        productoService.eliminar(id);

        redirectAttributes.addFlashAttribute(
                "mensaje",
                "Producto eliminado correctamente"
        );

        return "redirect:/productos";
    }
}