using DulceByte.Application.DTOs;
using DulceByte.Application.Interfaces;
using DulceByte.Domain.Entities;
using DulceByte.Domain.Exceptions;
using DulceByte.Domain.Interfaces;

namespace DulceByte.Application.Services;

public class CategoriaService : ICategoriaService
{
    private readonly ICategoriaRepository _repository;

    public CategoriaService(ICategoriaRepository repository)
    {
        _repository = repository;
    }

    private static CategoriaDto ToDto(Categoria c) => new(c.IdCategoria, c.Nombre, c.Descripcion);

    public async Task<List<CategoriaDto>> GetAllAsync()
    {
        var categorias = await _repository.GetAllAsync();
        return categorias.Select(ToDto).ToList();
    }

    public async Task<CategoriaDto> GetByIdAsync(int id)
    {
        var categoria = await _repository.GetByIdAsync(id)
            ?? throw new NotFoundException($"No existe la categoría con id {id}");
        return ToDto(categoria);
    }

    public async Task<CategoriaDto> CreateAsync(CategoriaCreateDto dto)
    {
        if (await _repository.ExisteNombreAsync(dto.Nombre))
            throw new BusinessRuleException($"Ya existe una categoría con el nombre '{dto.Nombre}'");

        var categoria = new Categoria
        {
            Nombre = dto.Nombre.Trim(),
            Descripcion = dto.Descripcion
        };

        await _repository.AddAsync(categoria);
        await _repository.SaveChangesAsync();

        return ToDto(categoria);
    }

    public async Task<CategoriaDto> UpdateAsync(int id, CategoriaUpdateDto dto)
    {
        var categoria = await _repository.GetByIdAsync(id)
            ?? throw new NotFoundException($"No existe la categoría con id {id}");

        if (await _repository.ExisteNombreAsync(dto.Nombre, id))
            throw new BusinessRuleException($"Ya existe una categoría con el nombre '{dto.Nombre}'");

        categoria.Nombre = dto.Nombre.Trim();
        categoria.Descripcion = dto.Descripcion;

        _repository.Update(categoria);
        await _repository.SaveChangesAsync();

        return ToDto(categoria);
    }

    public async Task DeleteAsync(int id)
    {
        var categoria = await _repository.GetByIdAsync(id)
            ?? throw new NotFoundException($"No existe la categoría con id {id}");

        if (await _repository.TieneProductosAsociadosAsync(id))
            throw new BusinessRuleException("No se puede eliminar la categoría porque tiene productos asociados");

        _repository.Remove(categoria);
        await _repository.SaveChangesAsync();
    }
}
