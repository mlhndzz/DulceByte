namespace DulceByte.Domain.Entities;

public class EstadoPedido
{
    public int IdEstado { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string? Descripcion { get; set; }

    public ICollection<Pedido> Pedidos { get; set; } = new List<Pedido>();
}
