using DulceByte.Domain.Entities;

namespace DulceByte.Domain.Interfaces;

public interface ICategoriaRepository
{
    Task<List<Categoria>> GetAllAsync();
    Task<Categoria?> GetByIdAsync(int id);
    Task<bool> ExisteNombreAsync(string nombre, int? idExcluir = null);
    Task AddAsync(Categoria categoria);
    void Update(Categoria categoria);
    void Remove(Categoria categoria);
    Task<bool> TieneProductosAsociadosAsync(int idCategoria);
    Task<int> SaveChangesAsync();
}
