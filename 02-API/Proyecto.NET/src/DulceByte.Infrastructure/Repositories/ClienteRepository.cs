using DulceByte.Domain.Entities;
using DulceByte.Domain.Interfaces;
using DulceByte.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace DulceByte.Infrastructure.Repositories;

public class ClienteRepository : IClienteRepository
{
    private readonly DulceByteDbContext _context;

    public ClienteRepository(DulceByteDbContext context)
    {
        _context = context;
    }

    public Task<List<Cliente>> GetAllAsync() =>
        _context.Clientes.AsNoTracking().OrderBy(c => c.Nombre).ToListAsync();

    public Task<Cliente?> GetByIdAsync(int id) =>
        _context.Clientes.FirstOrDefaultAsync(c => c.IdCliente == id);

    public Task<bool> ExisteCorreoAsync(string correo, int? idExcluir = null) =>
        _context.Clientes.AnyAsync(c =>
            c.Correo != null && c.Correo.ToLower() == correo.ToLower() && (idExcluir == null || c.IdCliente != idExcluir));

    public async Task AddAsync(Cliente cliente) =>
        await _context.Clientes.AddAsync(cliente);

    public void Update(Cliente cliente) =>
        _context.Clientes.Update(cliente);

    public Task<int> SaveChangesAsync() => _context.SaveChangesAsync();
}
