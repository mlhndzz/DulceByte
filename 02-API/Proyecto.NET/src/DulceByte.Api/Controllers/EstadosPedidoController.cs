using DulceByte.Application.DTOs;
using DulceByte.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace DulceByte.Api.Controllers;

[ApiController]
[Route("api/estados-pedido")]
public class EstadosPedidoController : ControllerBase
{
    private readonly IEstadoPedidoService _service;

    public EstadosPedidoController(IEstadoPedidoService service)
    {
        _service = service;
    }

    [HttpGet]
    public async Task<ActionResult<List<EstadoPedidoDto>>> GetAll()
    {
        var estados = await _service.GetAllAsync();
        return Ok(estados);
    }
}
