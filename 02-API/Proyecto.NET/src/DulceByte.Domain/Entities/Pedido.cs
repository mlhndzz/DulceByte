namespace DulceByte.Domain.Entities;

public class Pedido
{
    public int IdPedido { get; set; }
    public DateTime Fecha { get; set; } = DateTime.Now;
    public decimal Total { get; set; }

    public int IdCliente { get; set; }
    public Cliente? Cliente { get; set; }

    public int IdEstado { get; set; }
    public EstadoPedido? Estado { get; set; }

    public ICollection<DetallePedido> Detalles { get; set; } = new List<DetallePedido>();
}
