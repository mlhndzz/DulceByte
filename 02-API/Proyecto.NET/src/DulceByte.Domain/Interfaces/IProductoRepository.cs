using DulceByte.Domain.Entities;

namespace DulceByte.Domain.Interfaces;

public interface IProductoRepository
{
    Task<List<Producto>> GetAllAsync(int? idCategoria, bool? disponible);
    Task<Producto?> GetByIdAsync(int id);
    Task<bool> ExisteCategoriaAsync(int idCategoria);
    Task<bool> TieneDetallesAsociadosAsync(int idProducto);
    Task AddAsync(Producto producto);
    void Update(Producto producto);
    void Remove(Producto producto);
    Task<int> SaveChangesAsync();
}
