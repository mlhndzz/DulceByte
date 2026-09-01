using System.ComponentModel.DataAnnotations;

namespace DulceByte.Application.DTOs;

public record CategoriaDto(int IdCategoria, string Nombre, string? Descripcion);

public class CategoriaCreateDto
{
    [Required(ErrorMessage = "El nombre de la categoría es obligatorio")]
    [StringLength(80)]
    public string Nombre { get; set; } = string.Empty;

    [StringLength(255)]
    public string? Descripcion { get; set; }
}

public class CategoriaUpdateDto
{
    [Required(ErrorMessage = "El nombre de la categoría es obligatorio")]
    [StringLength(80)]
    public string Nombre { get; set; } = string.Empty;

    [StringLength(255)]
    public string? Descripcion { get; set; }
}
