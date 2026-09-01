using DulceByte.Domain.Entities;
using DulceByte.Domain.Interfaces;
using DulceByte.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace DulceByte.Infrastructure.Repositories;

public class EstadoPedidoRepository : IEstadoPedidoRepository
{
    private readonly DulceByteDbContext _context;

    public EstadoPedidoRepository(DulceByteDbContext context)
    {
        _context = context;
    }

    public Task<List<EstadoPedido>> GetAllAsync() =>
        _context.EstadosPedido.AsNoTracking().OrderBy(e => e.IdEstado).ToListAsync();

    public Task<EstadoPedido?> GetByIdAsync(int id) =>
        _context.EstadosPedido.FirstOrDefaultAsync(e => e.IdEstado == id);
}
