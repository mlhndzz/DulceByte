using DulceByte.Application.DTOs;
using DulceByte.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace DulceByte.Api.Controllers;

[ApiController]
[Route("api/pedidos")]
public class PedidosController : ControllerBase
{
    private readonly IPedidoService _service;

    public PedidosController(IPedidoService service)
    {
        _service = service;
    }

    [HttpGet]
    public async Task<ActionResult<List<PedidoDto>>> GetAll() =>
        Ok(await _service.GetAllAsync());

    [HttpGet("cliente/{idCliente:int}")]
    public async Task<ActionResult<List<PedidoDto>>> GetByCliente(int idCliente)
    {
        var pedidos = await _service.GetByClienteAsync(idCliente);
        return Ok(pedidos);
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<PedidoDto>> GetById(int id) =>
        Ok(await _service.GetByIdAsync(id));

    [HttpPost]
    public async Task<ActionResult<PedidoDto>> Create([FromBody] PedidoCreateDto dto)
    {
        var creado = await _service.CreateAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = creado.IdPedido }, creado);
    }

    [HttpPost("{id:int}/detalle")]
    public async Task<ActionResult<PedidoDto>> AgregarDetalle(int id, [FromBody] DetallePedidoCreateDto dto) =>
        Ok(await _service.AgregarDetalleAsync(id, dto));

    [HttpPut("{id:int}/estado")]
    public async Task<ActionResult<PedidoDto>> ActualizarEstado(int id, [FromBody] PedidoEstadoUpdateDto dto)
    {
        var actualizado = await _service.ActualizarEstadoAsync(id, dto);
        return Ok(actualizado);
    }
}
