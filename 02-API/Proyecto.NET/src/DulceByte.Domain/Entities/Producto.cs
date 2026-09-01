namespace DulceByte.Domain.Entities;

public class Producto
{
    public int IdProducto { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string? Descripcion { get; set; }
    public decimal Precio { get; set; }
    public bool Disponible { get; set; } = true;

    public int IdCategoria { get; set; }
    public Categoria? Categoria { get; set; }

    public ICollection<DetallePedido> DetallesPedido { get; set; } = new List<DetallePedido>();
}
