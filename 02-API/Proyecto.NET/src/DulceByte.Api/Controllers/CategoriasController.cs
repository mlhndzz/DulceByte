using DulceByte.Application.DTOs;
using DulceByte.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace DulceByte.Api.Controllers;

[ApiController]
[Route("api/categorias")]
public class CategoriasController : ControllerBase
{
    private readonly ICategoriaService _service;

    public CategoriasController(ICategoriaService service)
    {
        _service = service;
    }

    [HttpGet]
    public async Task<ActionResult<List<CategoriaDto>>> GetAll()
    {
        var categorias = await _service.GetAllAsync();
        return Ok(categorias);
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<CategoriaDto>> GetById(int id) =>
        Ok(await _service.GetByIdAsync(id));

    [HttpPost]
    public async Task<ActionResult<CategoriaDto>> Create([FromBody] CategoriaCreateDto dto)
    {
        var creada = await _service.CreateAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = creada.IdCategoria }, creada);
    }

    [HttpPut("{id:int}")]
    public async Task<ActionResult<CategoriaDto>> Update(int id, [FromBody] CategoriaUpdateDto dto) =>
        Ok(await _service.UpdateAsync(id, dto));

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        await _service.DeleteAsync(id);
        return NoContent();
    }
}
