using DulceByte.Api.Middleware;
using DulceByte.Application.Interfaces;
using DulceByte.Application.Services;
using DulceByte.Domain.Interfaces;
using DulceByte.Infrastructure.Data;
using DulceByte.Infrastructure.Repositories;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("DulceByteDb")
    ?? throw new InvalidOperationException("No se encontró la cadena de conexión 'DulceByteDb' en appsettings.json");

builder.Services.AddDbContext<DulceByteDbContext>(options =>
    options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString)));

builder.Services.AddScoped<ICategoriaRepository, CategoriaRepository>();
builder.Services.AddScoped<IClienteRepository, ClienteRepository>();
builder.Services.AddScoped<IProductoRepository, ProductoRepository>();
builder.Services.AddScoped<IPedidoRepository, PedidoRepository>();
builder.Services.AddScoped<IEstadoPedidoRepository, EstadoPedidoRepository>();

builder.Services.AddScoped<ICategoriaService, CategoriaService>();
builder.Services.AddScoped<IClienteService, ClienteService>();
builder.Services.AddScoped<IProductoService, ProductoService>();
builder.Services.AddScoped<IPedidoService, PedidoService>();
builder.Services.AddScoped<IEstadoPedidoService, EstadoPedidoService>();

builder.Services.AddCors(options =>
{
    options.AddPolicy("PermitirClientes", policy =>
        policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
});

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
    {
        Title = "DulceByte API",
        Version = "v1"
    });
});

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI(options =>
{
    options.SwaggerEndpoint("/swagger/v1/swagger.json", "DulceByte API v1");
    options.RoutePrefix = "swagger";
});

app.UseMiddleware<ExceptionHandlingMiddleware>();

app.UseHttpsRedirection();
app.UseCors("PermitirClientes");
app.UseAuthorization();

app.MapControllers();

app.Run();
