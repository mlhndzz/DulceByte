using DulceByte.Application.DTOs;
using DulceByte.Application.Interfaces;
using DulceByte.Domain.Entities;
using DulceByte.Domain.Exceptions;
using DulceByte.Domain.Interfaces;

namespace DulceByte.Application.Services;

public class ClienteService : IClienteService
{
    private readonly IClienteRepository _repository;

    public ClienteService(IClienteRepository repository)
    {
        _repository = repository;
    }

    private static ClienteDto ToDto(Cliente c) => new(c.IdCliente, c.Nombre, c.Telefono, c.Correo);

    public async Task<List<ClienteDto>> GetAllAsync()
    {
        var clientes = await _repository.GetAllAsync();
        return clientes.Select(ToDto).ToList();
    }

    public async Task<ClienteDto> GetByIdAsync(int id)
    {
        var cliente = await _repository.GetByIdAsync(id)
            ?? throw new NotFoundException($"No existe el cliente con id {id}");
        return ToDto(cliente);
    }

    public async Task<ClienteDto> CreateAsync(ClienteCreateDto dto)
    {
        if (!string.IsNullOrWhiteSpace(dto.Correo) && await _repository.ExisteCorreoAsync(dto.Correo))
            throw new BusinessRuleException($"Ya existe un cliente con el correo '{dto.Correo}'");

        var cliente = new Cliente
        {
            Nombre = dto.Nombre.Trim(),
            Telefono = dto.Telefono,
            Correo = dto.Correo
        };

        await _repository.AddAsync(cliente);
        await _repository.SaveChangesAsync();

        return ToDto(cliente);
    }

    public async Task<ClienteDto> UpdateAsync(int id, ClienteUpdateDto dto)
    {
        var cliente = await _repository.GetByIdAsync(id)
            ?? throw new NotFoundException($"No existe el cliente con id {id}");

        if (!string.IsNullOrWhiteSpace(dto.Correo) && await _repository.ExisteCorreoAsync(dto.Correo, id))
            throw new BusinessRuleException($"Ya existe un cliente con el correo '{dto.Correo}'");

        cliente.Nombre = dto.Nombre.Trim();
        cliente.Telefono = dto.Telefono;
        cliente.Correo = dto.Correo;

        _repository.Update(cliente);
        await _repository.SaveChangesAsync();

        return ToDto(cliente);
    }
}
