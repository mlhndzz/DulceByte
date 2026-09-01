using DulceByte.Application.DTOs;
using DulceByte.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace DulceByte.Api.Controllers;

[ApiController]
[Route("api/clientes")]
public class ClientesController : ControllerBase
{
    private readonly IClienteService _service;

    public ClientesController(IClienteService service)
    {
        _service = service;
    }

    [HttpGet]
    public async Task<ActionResult<List<ClienteDto>>> GetAll() =>
        Ok(await _service.GetAllAsync());

    [HttpGet("{id:int}")]
    public async Task<ActionResult<ClienteDto>> GetById(int id)
    {
        var cliente = await _service.GetByIdAsync(id);
        return Ok(cliente);
    }

    [HttpPost]
    public async Task<ActionResult<ClienteDto>> Create([FromBody] ClienteCreateDto dto)
    {
        var creado = await _service.CreateAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = creado.IdCliente }, creado);
    }

    [HttpPut("{id:int}")]
    public async Task<ActionResult<ClienteDto>> Update(int id, [FromBody] ClienteUpdateDto dto) =>
        Ok(await _service.UpdateAsync(id, dto));
}
