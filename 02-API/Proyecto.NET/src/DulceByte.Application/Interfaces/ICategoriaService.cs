using DulceByte.Application.DTOs;

namespace DulceByte.Application.Interfaces;

public interface ICategoriaService
{
    Task<List<CategoriaDto>> GetAllAsync();
    Task<CategoriaDto> GetByIdAsync(int id);
    Task<CategoriaDto> CreateAsync(CategoriaCreateDto dto);
    Task<CategoriaDto> UpdateAsync(int id, CategoriaUpdateDto dto);
    Task DeleteAsync(int id);
}
