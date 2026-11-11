package co.edu.unisabana.pedidos;

import org.springframework.data.jpa.repository.JpaRepository;

// CAPA DE PERSISTENCIA: Spring Data JPA nos da el CRUD gratis
public interface PedidoRepository extends JpaRepository<Pedido, Long> {
}
