using DulceByte.Domain.Entities;
using DulceByte.Domain.Interfaces;
using DulceByte.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace DulceByte.Infrastructure.Repositories;

public class CategoriaRepository : ICategoriaRepository
{
    private readonly DulceByteDbContext _context;

    public CategoriaRepository(DulceByteDbContext context)
    {
        _context = context;
    }

    public Task<List<Categoria>> GetAllAsync() =>
        _context.Categorias.AsNoTracking().OrderBy(c => c.Nombre).ToListAsync();

    public Task<Categoria?> GetByIdAsync(int id) =>
        _context.Categorias.FirstOrDefaultAsync(c => c.IdCategoria == id);

    public Task<bool> ExisteNombreAsync(string nombre, int? idExcluir = null) =>
        _context.Categorias.AnyAsync(c =>
            c.Nombre.ToLower() == nombre.ToLower() && (idExcluir == null || c.IdCategoria != idExcluir));

    public async Task AddAsync(Categoria categoria) =>
        await _context.Categorias.AddAsync(categoria);

    public void Update(Categoria categoria) =>
        _context.Categorias.Update(categoria);

    public void Remove(Categoria categoria) =>
        _context.Categorias.Remove(categoria);

    public Task<bool> TieneProductosAsociadosAsync(int idCategoria) =>
        _context.Productos.AnyAsync(p => p.IdCategoria == idCategoria);

    public Task<int> SaveChangesAsync() => _context.SaveChangesAsync();
}
