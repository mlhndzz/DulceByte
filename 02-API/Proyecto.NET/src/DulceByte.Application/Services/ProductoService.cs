using DulceByte.Application.DTOs;
using DulceByte.Application.Interfaces;
using DulceByte.Domain.Entities;
using DulceByte.Domain.Exceptions;
using DulceByte.Domain.Interfaces;

namespace DulceByte.Application.Services;

public class ProductoService : IProductoService
{
    private readonly IProductoRepository _repository;

    public ProductoService(IProductoRepository repository)
    {
        _repository = repository;
    }

    private static ProductoDto ToDto(Producto p) => new(
        p.IdProducto, p.Nombre, p.Descripcion, p.Precio, p.Disponible, p.IdCategoria, p.Categoria?.Nombre);

    public async Task<List<ProductoDto>> GetAllAsync(int? idCategoria, bool? disponible)
    {
        var productos = await _repository.GetAllAsync(idCategoria, disponible);
        return productos.Select(ToDto).ToList();
    }

    public async Task<ProductoDto> GetByIdAsync(int id)
    {
        var producto = await _repository.GetByIdAsync(id)
            ?? throw new NotFoundException($"No existe el producto con id {id}");
        return ToDto(producto);
    }

    public async Task<ProductoDto> CreateAsync(ProductoCreateDto dto)
    {
        if (!await _repository.ExisteCategoriaAsync(dto.IdCategoria))
            throw new BusinessRuleException($"La categoría con id {dto.IdCategoria} no existe");

        var producto = new Producto
        {
            Nombre = dto.Nombre.Trim(),
            Descripcion = dto.Descripcion,
            Precio = dto.Precio,
            Disponible = dto.Disponible,
            IdCategoria = dto.IdCategoria
        };

        await _repository.AddAsync(producto);
        await _repository.SaveChangesAsync();

        var creado = await _repository.GetByIdAsync(producto.IdProducto);
        return ToDto(creado!);
    }

    public async Task<ProductoDto> UpdateAsync(int id, ProductoUpdateDto dto)
    {
        var producto = await _repository.GetByIdAsync(id)
            ?? throw new NotFoundException($"No existe el producto con id {id}");

        if (!await _repository.ExisteCategoriaAsync(dto.IdCategoria))
            throw new BusinessRuleException($"La categoría con id {dto.IdCategoria} no existe");

        producto.Nombre = dto.Nombre.Trim();
        producto.Descripcion = dto.Descripcion;
        producto.Precio = dto.Precio;
        producto.Disponible = dto.Disponible;
        producto.IdCategoria = dto.IdCategoria;

        _repository.Update(producto);
        await _repository.SaveChangesAsync();

        return ToDto(producto);
    }

    public async Task DeleteAsync(int id)
    {
        var producto = await _repository.GetByIdAsync(id)
            ?? throw new NotFoundException($"No existe el producto con id {id}");

        if (await _repository.TieneDetallesAsociadosAsync(id))
            throw new BusinessRuleException(
                "No se puede eliminar el producto porque ya está asociado a pedidos; márquelo como no disponible en su lugar");

        _repository.Remove(producto);
        await _repository.SaveChangesAsync();
    }
}
