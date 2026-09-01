using DulceByte.Application.DTOs;

namespace DulceByte.Application.Interfaces;

public interface IProductoService
{
    Task<List<ProductoDto>> GetAllAsync(int? idCategoria, bool? disponible);
    Task<ProductoDto> GetByIdAsync(int id);
    Task<ProductoDto> CreateAsync(ProductoCreateDto dto);
    Task<ProductoDto> UpdateAsync(int id, ProductoUpdateDto dto);
    Task DeleteAsync(int id);
}
