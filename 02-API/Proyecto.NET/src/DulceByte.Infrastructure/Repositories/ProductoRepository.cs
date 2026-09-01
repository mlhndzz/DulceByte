using DulceByte.Domain.Entities;
using DulceByte.Domain.Interfaces;
using DulceByte.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace DulceByte.Infrastructure.Repositories;

public class ProductoRepository : IProductoRepository
{
    private readonly DulceByteDbContext _context;

    public ProductoRepository(DulceByteDbContext context)
    {
        _context = context;
    }

    public Task<List<Producto>> GetAllAsync(int? idCategoria, bool? disponible)
    {
        var query = _context.Productos.AsNoTracking().Include(p => p.Categoria).AsQueryable();

        if (idCategoria.HasValue)
            query = query.Where(p => p.IdCategoria == idCategoria.Value);

        if (disponible.HasValue)
            query = query.Where(p => p.Disponible == disponible.Value);

        return query.OrderBy(p => p.Nombre).ToListAsync();
    }

    public Task<Producto?> GetByIdAsync(int id) =>
        _context.Productos.Include(p => p.Categoria).FirstOrDefaultAsync(p => p.IdProducto == id);

    public Task<bool> ExisteCategoriaAsync(int idCategoria) =>
        _context.Categorias.AnyAsync(c => c.IdCategoria == idCategoria);

    public Task<bool> TieneDetallesAsociadosAsync(int idProducto) =>
        _context.DetallesPedido.AnyAsync(d => d.IdProducto == idProducto);

    public async Task AddAsync(Producto producto) =>
        await _context.Productos.AddAsync(producto);

    public void Update(Producto producto) =>
        _context.Productos.Update(producto);

    public void Remove(Producto producto) =>
        _context.Productos.Remove(producto);

    public Task<int> SaveChangesAsync() => _context.SaveChangesAsync();
}
