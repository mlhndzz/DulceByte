using System.ComponentModel.DataAnnotations;

namespace DulceByte.Application.DTOs;

public record ClienteDto(int IdCliente, string Nombre, string? Telefono, string? Correo);

public class ClienteCreateDto
{
    [Required(ErrorMessage = "El nombre del cliente es obligatorio")]
    [StringLength(100)]
    public string Nombre { get; set; } = string.Empty;

    [StringLength(20)]
    public string? Telefono { get; set; }

    [EmailAddress]
    [StringLength(120)]
    public string? Correo { get; set; }
}

public class ClienteUpdateDto
{
    [Required(ErrorMessage = "El nombre del cliente es obligatorio")]
    [StringLength(100)]
    public string Nombre { get; set; } = string.Empty;

    [StringLength(20)]
    public string? Telefono { get; set; }

    [EmailAddress]
    [StringLength(120)]
    public string? Correo { get; set; }
}
