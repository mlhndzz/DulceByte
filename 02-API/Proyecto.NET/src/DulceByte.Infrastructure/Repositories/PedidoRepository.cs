using DulceByte.Domain.Entities;
using DulceByte.Domain.Interfaces;
using DulceByte.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace DulceByte.Infrastructure.Repositories;

public class PedidoRepository : IPedidoRepository
{
    private readonly DulceByteDbContext _context;

    public PedidoRepository(DulceByteDbContext context)
    {
        _context = context;
    }

    private IQueryable<Pedido> QueryConDetalle() =>
        _context.Pedidos
            .Include(p => p.Cliente)
            .Include(p => p.Estado)
            .Include(p => p.Detalles).ThenInclude(d => d.Producto);

    public Task<List<Pedido>> GetAllAsync() =>
        QueryConDetalle().AsNoTracking().OrderByDescending(p => p.Fecha).ToListAsync();

    public Task<List<Pedido>> GetByClienteAsync(int idCliente) =>
        QueryConDetalle().AsNoTracking()
            .Where(p => p.IdCliente == idCliente)
            .OrderByDescending(p => p.Fecha)
            .ToListAsync();

    public Task<Pedido?> GetByIdAsync(int id) =>
        QueryConDetalle().AsNoTracking().FirstOrDefaultAsync(p => p.IdPedido == id);

    public Task<Pedido?> GetByIdTrackedAsync(int id) =>
        QueryConDetalle().FirstOrDefaultAsync(p => p.IdPedido == id);

    public async Task AddAsync(Pedido pedido) =>
        await _context.Pedidos.AddAsync(pedido);

    public Task<Producto?> GetProductoDisponibleAsync(int idProducto) =>
        _context.Productos.FirstOrDefaultAsync(p => p.IdProducto == idProducto && p.Disponible);

    public async Task AddDetalleAsync(DetallePedido detalle) =>
        await _context.DetallesPedido.AddAsync(detalle);

    public Task<int> SaveChangesAsync() => _context.SaveChangesAsync();
}
