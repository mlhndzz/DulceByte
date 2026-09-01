using DulceByte.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace DulceByte.Infrastructure.Data;

public class DulceByteDbContext : DbContext
{
    public DulceByteDbContext(DbContextOptions<DulceByteDbContext> options) : base(options)
    {
    }

    public DbSet<Categoria> Categorias => Set<Categoria>();
    public DbSet<Cliente> Clientes => Set<Cliente>();
    public DbSet<Producto> Productos => Set<Producto>();
    public DbSet<EstadoPedido> EstadosPedido => Set<EstadoPedido>();
    public DbSet<Pedido> Pedidos => Set<Pedido>();
    public DbSet<DetallePedido> DetallesPedido => Set<DetallePedido>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Categoria>(e =>
        {
            e.ToTable("categoria");
            e.HasKey(x => x.IdCategoria);
            e.Property(x => x.IdCategoria).HasColumnName("idCategoria");
            e.Property(x => x.Nombre).HasColumnName("nombre").HasMaxLength(80).IsRequired();
            e.Property(x => x.Descripcion).HasColumnName("descripcion").HasMaxLength(255);
            e.HasIndex(x => x.Nombre).IsUnique();
        });

        modelBuilder.Entity<Cliente>(e =>
        {
            e.ToTable("cliente");
            e.HasKey(x => x.IdCliente);
            e.Property(x => x.IdCliente).HasColumnName("idCliente");
            e.Property(x => x.Nombre).HasColumnName("nombre").HasMaxLength(100).IsRequired();
            e.Property(x => x.Telefono).HasColumnName("telefono").HasMaxLength(20);
            e.Property(x => x.Correo).HasColumnName("correo").HasMaxLength(120);
            e.HasIndex(x => x.Correo).IsUnique();
        });

        modelBuilder.Entity<Producto>(e =>
        {
            e.ToTable("producto");
            e.HasKey(x => x.IdProducto);
            e.Property(x => x.IdProducto).HasColumnName("idProducto");
            e.Property(x => x.Nombre).HasColumnName("nombre").HasMaxLength(100).IsRequired();
            e.Property(x => x.Descripcion).HasColumnName("descripcion").HasMaxLength(255);
            e.Property(x => x.Precio).HasColumnName("precio").HasColumnType("decimal(10,2)");
            e.Property(x => x.Disponible).HasColumnName("disponible");
            e.Property(x => x.IdCategoria).HasColumnName("idCategoria");

            e.HasOne(x => x.Categoria)
                .WithMany(c => c.Productos)
                .HasForeignKey(x => x.IdCategoria)
                .OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<EstadoPedido>(e =>
        {
            e.ToTable("estadopedido");
            e.HasKey(x => x.IdEstado);
            e.Property(x => x.IdEstado).HasColumnName("idEstado");
            e.Property(x => x.Nombre).HasColumnName("nombre").HasMaxLength(50).IsRequired();
            e.Property(x => x.Descripcion).HasColumnName("descripcion").HasMaxLength(255);
            e.HasIndex(x => x.Nombre).IsUnique();
        });

        modelBuilder.Entity<Pedido>(e =>
        {
            e.ToTable("pedido");
            e.HasKey(x => x.IdPedido);
            e.Property(x => x.IdPedido).HasColumnName("idPedido");
            e.Property(x => x.Fecha).HasColumnName("fecha");
            e.Property(x => x.Total).HasColumnName("total").HasColumnType("decimal(10,2)");
            e.Property(x => x.IdCliente).HasColumnName("idCliente");
            e.Property(x => x.IdEstado).HasColumnName("idEstado");

            e.HasOne(x => x.Cliente)
                .WithMany(c => c.Pedidos)
                .HasForeignKey(x => x.IdCliente)
                .OnDelete(DeleteBehavior.Restrict);

            e.HasOne(x => x.Estado)
                .WithMany(s => s.Pedidos)
                .HasForeignKey(x => x.IdEstado)
                .OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<DetallePedido>(e =>
        {
            e.ToTable("detallepedido");
            e.HasKey(x => x.IdDetalle);
            e.Property(x => x.IdDetalle).HasColumnName("idDetalle");
            e.Property(x => x.Cantidad).HasColumnName("cantidad");
            e.Property(x => x.PrecioUnitario).HasColumnName("precioUnitario").HasColumnType("decimal(10,2)");
            e.Property(x => x.IdPedido).HasColumnName("idPedido");
            e.Property(x => x.IdProducto).HasColumnName("idProducto");
            e.HasIndex(x => new { x.IdPedido, x.IdProducto }).IsUnique();

            e.HasOne(x => x.Pedido)
                .WithMany(p => p.Detalles)
                .HasForeignKey(x => x.IdPedido)
                .OnDelete(DeleteBehavior.Cascade);

            e.HasOne(x => x.Producto)
                .WithMany(p => p.DetallesPedido)
                .HasForeignKey(x => x.IdProducto)
                .OnDelete(DeleteBehavior.Restrict);
        });
    }
}
