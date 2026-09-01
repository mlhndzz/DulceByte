using DulceByte.Domain.Entities;

namespace DulceByte.Domain.Interfaces;

public interface IClienteRepository
{
    Task<List<Cliente>> GetAllAsync();
    Task<Cliente?> GetByIdAsync(int id);
    Task<bool> ExisteCorreoAsync(string correo, int? idExcluir = null);
    Task AddAsync(Cliente cliente);
    void Update(Cliente cliente);
    Task<int> SaveChangesAsync();
}
