package com.dulcebyte.web.controller;

import com.dulcebyte.web.dto.CategoriaDto;
import com.dulcebyte.web.dto.CategoriaFormDto;
import com.dulcebyte.web.service.CategoriaService;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/categorias")
public class CategoriaController {

    private final CategoriaService categoriaService;

    public CategoriaController(CategoriaService categoriaService) {
        this.categoriaService = categoriaService;
    }

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("categorias", categoriaService.listar());
        return "categorias/lista";
    }

    @GetMapping("/nueva")
    public String nueva(Model model) {
        model.addAttribute("categoria", new CategoriaFormDto());
        model.addAttribute("titulo", "Nueva categoría");
        return "categorias/formulario";
    }

    @PostMapping("/guardar")
    public String guardar(
            @Valid @ModelAttribute("categoria") CategoriaFormDto categoria,
            BindingResult result,
            RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            return "categorias/formulario";
        }

        categoriaService.crear(categoria);

        redirectAttributes.addFlashAttribute(
                "mensaje",
                "Categoría registrada correctamente"
        );

        return "redirect:/categorias";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Integer id, Model model) {

        CategoriaDto existente = categoriaService.obtenerPorId(id);

        CategoriaFormDto categoria = new CategoriaFormDto();
        categoria.setNombre(existente.getNombre());
        categoria.setDescripcion(existente.getDescripcion());

        model.addAttribute("categoria", categoria);
        model.addAttribute("titulo", "Editar categoría");
        model.addAttribute("idCategoria", id);

        return "categorias/formulario";
    }

    @PostMapping("/actualizar/{id}")
    public String actualizar(
            @PathVariable Integer id,
            @Valid @ModelAttribute("categoria") CategoriaFormDto categoria,
            BindingResult result,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            model.addAttribute("titulo", "Editar categoría");
            model.addAttribute("idCategoria", id);
            return "categorias/formulario";
        }

        categoriaService.actualizar(id, categoria);

        redirectAttributes.addFlashAttribute(
                "mensaje",
                "Categoría actualizada correctamente"
        );

        return "redirect:/categorias";
    }

    @PostMapping("/eliminar/{id}")
    public String eliminar(
            @PathVariable Integer id,
            RedirectAttributes redirectAttributes) {

        try {
            categoriaService.eliminar(id);

            redirectAttributes.addFlashAttribute(
                    "mensaje",
                    "Categoría eliminada correctamente"
            );
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(
                    "error",
                    "No se puede eliminar una categoría que tenga productos asociados"
            );
        }

        return "redirect:/categorias";
    }
}