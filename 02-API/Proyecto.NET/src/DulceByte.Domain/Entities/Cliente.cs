namespace DulceByte.Domain.Entities;

public class Cliente
{
    public int IdCliente { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string? Telefono { get; set; }
    public string? Correo { get; set; }

    public ICollection<Pedido> Pedidos { get; set; } = new List<Pedido>();
}
