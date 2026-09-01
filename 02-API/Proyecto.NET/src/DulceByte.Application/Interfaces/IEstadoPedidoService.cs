using DulceByte.Application.DTOs;

namespace DulceByte.Application.Interfaces;

public interface IEstadoPedidoService
{
    Task<List<EstadoPedidoDto>> GetAllAsync();
}
