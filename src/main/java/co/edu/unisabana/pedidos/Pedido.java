package co.edu.unisabana.pedidos;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import jakarta.validation.constraints.Min;
import java.time.Instant;

// CAPA DE DOMINIO: entidad JPA que se mapea a la tabla pedidos
@Entity
@Table(name = "pedidos")
public class Pedido {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Size(max = 120)
    private String cliente;

    @NotBlank
    @Size(max = 200)
    private String producto;

    @Positive
    @Min(value = 1, message = "La cantidad debe ser al menos 1")
    private int cantidad;

    @Column(name = "creado_en")
    private Instant creadoEn;

    @PrePersist
    void prePersist() { this.creadoEn = Instant.now(); }

    // Getters / Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getCliente() { return cliente; }
    public void setCliente(String cliente) { this.cliente = cliente; }
    public String getProducto() { return producto; }
    public void setProducto(String producto) { this.producto = producto; }
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    public Instant getCreadoEn() { return creadoEn; }
}
