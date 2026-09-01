using DulceByte.Application.DTOs;
using DulceByte.Application.Interfaces;
using DulceByte.Domain.Interfaces;

namespace DulceByte.Application.Services;

public class EstadoPedidoService : IEstadoPedidoService
{
    private readonly IEstadoPedidoRepository _repository;

    public EstadoPedidoService(IEstadoPedidoRepository repository)
    {
        _repository = repository;
    }

    public async Task<List<EstadoPedidoDto>> GetAllAsync()
    {
        var estados = await _repository.GetAllAsync();
        return estados.Select(e => new EstadoPedidoDto(e.IdEstado, e.Nombre, e.Descripcion)).ToList();
    }
}
