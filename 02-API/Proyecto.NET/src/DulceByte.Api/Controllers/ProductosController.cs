using DulceByte.Application.DTOs;
using DulceByte.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace DulceByte.Api.Controllers;

[ApiController]
[Route("api/productos")]
public class ProductosController : ControllerBase
{
    private readonly IProductoService _service;

    public ProductosController(IProductoService service)
    {
        _service = service;
    }

    [HttpGet]
    public async Task<ActionResult<List<ProductoDto>>> GetAll([FromQuery] int? idCategoria, [FromQuery] bool? disponible) =>
        Ok(await _service.GetAllAsync(idCategoria, disponible));

    [HttpGet("{id:int}")]
    public async Task<ActionResult<ProductoDto>> GetById(int id)
    {
        var producto = await _service.GetByIdAsync(id);
        return Ok(producto);
    }

    [HttpPost]
    public async Task<ActionResult<ProductoDto>> Create([FromBody] ProductoCreateDto dto)
    {
        var creado = await _service.CreateAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = creado.IdProducto }, creado);
    }

    [HttpPut("{id:int}")]
    public async Task<ActionResult<ProductoDto>> Update(int id, [FromBody] ProductoUpdateDto dto)
    {
        var actualizado = await _service.UpdateAsync(id, dto);
        return Ok(actualizado);
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        await _service.DeleteAsync(id);
        return NoContent();
    }
}
