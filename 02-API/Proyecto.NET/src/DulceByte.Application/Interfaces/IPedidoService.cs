using DulceByte.Application.DTOs;

namespace DulceByte.Application.Interfaces;

public interface IPedidoService
{
    Task<List<PedidoDto>> GetAllAsync();
    Task<List<PedidoDto>> GetByClienteAsync(int idCliente);
    Task<PedidoDto> GetByIdAsync(int id);
    Task<PedidoDto> CreateAsync(PedidoCreateDto dto);
    Task<PedidoDto> AgregarDetalleAsync(int idPedido, DetallePedidoCreateDto dto);
    Task<PedidoDto> ActualizarEstadoAsync(int idPedido, PedidoEstadoUpdateDto dto);
}
