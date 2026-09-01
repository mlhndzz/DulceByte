using DulceByte.Application.DTOs;

namespace DulceByte.Application.Interfaces;

public interface IClienteService
{
    Task<List<ClienteDto>> GetAllAsync();
    Task<ClienteDto> GetByIdAsync(int id);
    Task<ClienteDto> CreateAsync(ClienteCreateDto dto);
    Task<ClienteDto> UpdateAsync(int id, ClienteUpdateDto dto);
}
