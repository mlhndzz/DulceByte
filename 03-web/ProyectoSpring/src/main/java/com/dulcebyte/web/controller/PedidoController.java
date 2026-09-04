package com.dulcebyte.web.controller;

import com.dulcebyte.web.dto.AgregarDetalleDto;
import com.dulcebyte.web.dto.CambiarEstadoDto;
import com.dulcebyte.web.dto.CrearPedidoDto;
import com.dulcebyte.web.dto.PedidoDto;
import com.dulcebyte.web.service.ClienteService;
import com.dulcebyte.web.service.EstadoPedidoService;
import com.dulcebyte.web.service.PedidoService;
import com.dulcebyte.web.service.ProductoService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/pedidos")
public class PedidoController {

    private final PedidoService pedidoService;
    private final ClienteService clienteService;
    private final ProductoService productoService;
    private final EstadoPedidoService estadoPedidoService;

    public PedidoController(
            PedidoService pedidoService,
            ClienteService clienteService,
            ProductoService productoService,
            EstadoPedidoService estadoPedidoService) {

        this.pedidoService = pedidoService;
        this.clienteService = clienteService;
        this.productoService = productoService;
        this.estadoPedidoService = estadoPedidoService;
    }

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("pedidos", pedidoService.listar());
        return "pedidos/lista";
    }

    @GetMapping("/nuevo")
    public String nuevo(Model model) {
        model.addAttribute("clientes", clienteService.listar());
        model.addAttribute("pedido", new CrearPedidoDto());
        return "pedidos/nuevo";
    }

    @PostMapping("/guardar")
    public String guardar(
            @ModelAttribute CrearPedidoDto pedido,
            RedirectAttributes redirectAttributes) {

        PedidoDto creado = pedidoService.crear(pedido);

        redirectAttributes.addFlashAttribute(
                "mensaje",
                "Pedido creado correctamente"
        );

        return "redirect:/pedidos/" + creado.getIdPedido();
    }

    @GetMapping("/{id}")
    public String detalle(@PathVariable Integer id, Model model) {

        model.addAttribute("pedido", pedidoService.obtenerPorId(id));
        model.addAttribute("productos", productoService.listar());
        model.addAttribute("estados", estadoPedidoService.listar());

        model.addAttribute("detalleNuevo", new AgregarDetalleDto());
        model.addAttribute("estadoNuevo", new CambiarEstadoDto());

        return "pedidos/detalle";
    }

    @PostMapping("/{id}/detalle")
    public String agregarDetalle(
            @PathVariable Integer id,
            @ModelAttribute AgregarDetalleDto detalle,
            RedirectAttributes redirectAttributes) {

        pedidoService.agregarDetalle(id, detalle);

        redirectAttributes.addFlashAttribute(
                "mensaje",
                "Producto agregado al pedido"
        );

        return "redirect:/pedidos/" + id;
    }

    @PostMapping("/{id}/estado")
    public String cambiarEstado(
            @PathVariable Integer id,
            @ModelAttribute CambiarEstadoDto estado,
            RedirectAttributes redirectAttributes) {

        pedidoService.cambiarEstado(id, estado);

        redirectAttributes.addFlashAttribute(
                "mensaje",
                "Estado actualizado correctamente"
        );

        return "redirect:/pedidos/" + id;
    }
}