using DulceByte.Domain.Entities;

namespace DulceByte.Domain.Interfaces;

public interface IEstadoPedidoRepository
{
    Task<List<EstadoPedido>> GetAllAsync();
    Task<EstadoPedido?> GetByIdAsync(int id);
}
