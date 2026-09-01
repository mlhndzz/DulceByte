using DulceByte.Application.DTOs;
using DulceByte.Application.Interfaces;
using DulceByte.Domain.Entities;
using DulceByte.Domain.Exceptions;
using DulceByte.Domain.Interfaces;

namespace DulceByte.Application.Services;

public class PedidoService : IPedidoService
{
    private readonly IPedidoRepository _pedidoRepository;
    private readonly IClienteRepository _clienteRepository;
    private readonly IEstadoPedidoRepository _estadoRepository;

    public PedidoService(
        IPedidoRepository pedidoRepository,
        IClienteRepository clienteRepository,
        IEstadoPedidoRepository estadoRepository)
    {
        _pedidoRepository = pedidoRepository;
        _clienteRepository = clienteRepository;
        _estadoRepository = estadoRepository;
    }

    private static PedidoDto ToDto(Pedido p) => new(
        p.IdPedido,
        p.Fecha,
        p.Total,
        p.IdCliente,
        p.Cliente?.Nombre,
        p.IdEstado,
        p.Estado?.Nombre,
        p.Detalles.Select(d => new DetallePedidoDto(
            d.IdDetalle, d.IdProducto, d.Producto?.Nombre, d.Cantidad, d.PrecioUnitario, d.Cantidad * d.PrecioUnitario
        )).ToList());

    public async Task<List<PedidoDto>> GetAllAsync()
    {
        var pedidos = await _pedidoRepository.GetAllAsync();
        return pedidos.Select(ToDto).ToList();
    }

    public async Task<List<PedidoDto>> GetByClienteAsync(int idCliente)
    {
        if (await _clienteRepository.GetByIdAsync(idCliente) is null)
            throw new NotFoundException($"No existe el cliente con id {idCliente}");

        var pedidos = await _pedidoRepository.GetByClienteAsync(idCliente);
        return pedidos.Select(ToDto).ToList();
    }

    public async Task<PedidoDto> GetByIdAsync(int id)
    {
        var pedido = await _pedidoRepository.GetByIdAsync(id)
            ?? throw new NotFoundException($"No existe el pedido con id {id}");
        return ToDto(pedido);
    }

    public async Task<PedidoDto> CreateAsync(PedidoCreateDto dto)
    {
        if (await _clienteRepository.GetByIdAsync(dto.IdCliente) is null)
            throw new NotFoundException($"No existe el cliente con id {dto.IdCliente}");

        const int idEstadoPendiente = 1;

        var pedido = new Pedido
        {
            Fecha = DateTime.Now,
            Total = 0m,
            IdCliente = dto.IdCliente,
            IdEstado = idEstadoPendiente
        };

        await _pedidoRepository.AddAsync(pedido);
        await _pedidoRepository.SaveChangesAsync();

        var creado = await _pedidoRepository.GetByIdAsync(pedido.IdPedido);
        return ToDto(creado!);
    }

    public async Task<PedidoDto> AgregarDetalleAsync(int idPedido, DetallePedidoCreateDto dto)
    {
        var pedido = await _pedidoRepository.GetByIdTrackedAsync(idPedido)
            ?? throw new NotFoundException($"No existe el pedido con id {idPedido}");

        if (pedido.Detalles.Any(d => d.IdProducto == dto.IdProducto))
            throw new BusinessRuleException(
                "El producto ya se encuentra en este pedido; para cambiar la cantidad, actualícelo directamente");

        var producto = await _pedidoRepository.GetProductoDisponibleAsync(dto.IdProducto)
            ?? throw new BusinessRuleException("El producto no existe o no está disponible");

        var detalle = new DetallePedido
        {
            IdPedido = idPedido,
            IdProducto = dto.IdProducto,
            Cantidad = dto.Cantidad,
            PrecioUnitario = producto.Precio
        };

        await _pedidoRepository.AddDetalleAsync(detalle);
        await _pedidoRepository.SaveChangesAsync();

        var actualizado = await _pedidoRepository.GetByIdAsync(idPedido);
        return ToDto(actualizado!);
    }

    public async Task<PedidoDto> ActualizarEstadoAsync(int idPedido, PedidoEstadoUpdateDto dto)
    {
        var pedido = await _pedidoRepository.GetByIdTrackedAsync(idPedido)
            ?? throw new NotFoundException($"No existe el pedido con id {idPedido}");

        if (await _estadoRepository.GetByIdAsync(dto.IdEstado) is null)
            throw new NotFoundException($"No existe el estado con id {dto.IdEstado}");

        pedido.IdEstado = dto.IdEstado;
        await _pedidoRepository.SaveChangesAsync();

        var actualizado = await _pedidoRepository.GetByIdAsync(idPedido);
        return ToDto(actualizado!);
    }
}
