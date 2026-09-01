using DulceByte.Domain.Entities;

namespace DulceByte.Domain.Interfaces;

public interface IPedidoRepository
{
    Task<List<Pedido>> GetAllAsync();
    Task<List<Pedido>> GetByClienteAsync(int idCliente);
    Task<Pedido?> GetByIdAsync(int id);
    Task<Pedido?> GetByIdTrackedAsync(int id);
    Task AddAsync(Pedido pedido);
    Task<Producto?> GetProductoDisponibleAsync(int idProducto);
    Task AddDetalleAsync(DetallePedido detalle);
    Task<int> SaveChangesAsync();
}
