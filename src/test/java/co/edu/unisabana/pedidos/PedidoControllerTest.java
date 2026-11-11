package co.edu.unisabana.pedidos;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

// TESTING: test de integración con MockMvc, no necesita servidor real
@SpringBootTest
@AutoConfigureMockMvc
class PedidoControllerTest {

    @Autowired
    private MockMvc mvc;

    @Test
    void listar_devuelveOk() throws Exception {
        mvc.perform(get("/api/pedidos"))
            .andExpect(status().isOk());
    }

    @Test
    void crear_yConsultar_funciona() throws Exception {
        String body = """
                {
                  "cliente": "Juan Pérez",
                  "producto": "Empanada",
                  "cantidad": 3
                }
                """;

        mvc.perform(post("/api/pedidos")
                .contentType("application/json")
                .content(body))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.cliente").value("Juan Pérez"))
            .andExpect(jsonPath("$.cantidad").value(3));
    }

    @Test
    void crear_conDatosInvalidos_devuelve400() throws Exception {
        String body = """
                {
                  "cliente": "",
                  "producto": "Empanada",
                  "cantidad": -1
                }
                """;

        mvc.perform(post("/api/pedidos")
                .contentType("application/json")
                .content(body))
            .andExpect(status().isBadRequest());
    }

    @Test
    void crear_conCantidadCero_devuelve400() throws Exception {
        String body = """
                {
                  "cliente": "Carlos Mejía",
                  "producto": "Gaseosa",
                  "cantidad": 0
                }
                """;

        mvc.perform(post("/api/pedidos")
                .contentType("application/json")
                .content(body))
            .andExpect(status().isBadRequest());
    }
}
