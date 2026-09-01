using System.ComponentModel.DataAnnotations;

namespace DulceByte.Application.DTOs;

public record ProductoDto(
    int IdProducto,
    string Nombre,
    string? Descripcion,
    decimal Precio,
    bool Disponible,
    int IdCategoria,
    string? Categoria);

public class ProductoCreateDto
{
    [Required(ErrorMessage = "El nombre del producto es obligatorio")]
    [StringLength(100)]
    public string Nombre { get; set; } = string.Empty;

    [StringLength(255)]
    public string? Descripcion { get; set; }

    [Range(0, 999999.99, ErrorMessage = "El precio no puede ser negativo")]
    public decimal Precio { get; set; }

    public bool Disponible { get; set; } = true;

    [Range(1, int.MaxValue, ErrorMessage = "Debe indicar una categoría válida")]
    public int IdCategoria { get; set; }
}

public class ProductoUpdateDto
{
    [Required(ErrorMessage = "El nombre del producto es obligatorio")]
    [StringLength(100)]
    public string Nombre { get; set; } = string.Empty;

    [StringLength(255)]
    public string? Descripcion { get; set; }

    [Range(0, 999999.99, ErrorMessage = "El precio no puede ser negativo")]
    public decimal Precio { get; set; }

    public bool Disponible { get; set; } = true;

    [Range(1, int.MaxValue, ErrorMessage = "Debe indicar una categoría válida")]
    public int IdCategoria { get; set; }
}
