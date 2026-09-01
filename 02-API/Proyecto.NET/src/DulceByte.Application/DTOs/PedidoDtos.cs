using System.ComponentModel.DataAnnotations;

namespace DulceByte.Application.DTOs;

public record EstadoPedidoDto(int IdEstado, string Nombre, string? Descripcion);

public record DetallePedidoDto(
    int IdDetalle,
    int IdProducto,
    string? Producto,
    int Cantidad,
    decimal PrecioUnitario,
    decimal Subtotal);

public record PedidoDto(
    int IdPedido,
    DateTime Fecha,
    decimal Total,
    int IdCliente,
    string? Cliente,
    int IdEstado,
    string? Estado,
    List<DetallePedidoDto> Detalles);

public class PedidoCreateDto
{
    [Range(1, int.MaxValue, ErrorMessage = "Debe indicar un cliente válido")]
    public int IdCliente { get; set; }
}

public class DetallePedidoCreateDto
{
    [Range(1, int.MaxValue, ErrorMessage = "Debe indicar un producto válido")]
    public int IdProducto { get; set; }

    [Range(1, int.MaxValue, ErrorMessage = "La cantidad debe ser mayor que cero")]
    public int Cantidad { get; set; }
}

public class PedidoEstadoUpdateDto
{
    [Range(1, int.MaxValue, ErrorMessage = "Debe indicar un estado válido")]
    public int IdEstado { get; set; }
}
