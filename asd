package com.restaurante.pedidos.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
public class Pedido {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String cliente;

    private String endereco;

    @ElementCollection
    private List<String> itens;

    @Enumerated(EnumType.STRING)
    private StatusPedido status;

    @Enumerated(EnumType.STRING)
    private Plataforma plataforma;

    // Getters e Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCliente() {
        return cliente;
    }

    public void setCliente(String cliente) {
        this.cliente = cliente;
    }

    public String getEndereco() {
        return endereco;
    }

    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }

    public List<String> getItens() {
        return itens;
    }

    public void setItens(List<String> itens) {
        this.itens = itens;
    }

    public StatusPedido getStatus() {
        return status;
    }

    public void setStatus(StatusPedido status) {
        this.status = status;
    }

    public Plataforma getPlataforma() {
        return plataforma;
    }

    public void setPlataforma(Plataforma plataforma) {
        this.plataforma = plataforma;
    }
}


package com.restaurante.pedidos.model;

public enum Plataforma {
    MOBILE,
    PRESENCIAL,
    WEB
}

package com.restaurante.pedidos.model;


public enum StatusPedido {
    ABERTO,
    EM_PREPARACAO,
    FINALIZADO
}


package com.restaurante.pedidos.repository;

import com.restaurante.pedidos.model.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PedidoRepository extends JpaRepository<Pedido, Long> {
    List<Pedido> findByStatus(String status);
}


package com.restaurante.pedidos;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}

package com.restaurante.pedidos.service;

import com.restaurante.pedidos.dto.PedidoDTO;
import com.restaurante.pedidos.model.Pedido;
import com.restaurante.pedidos.model.StatusPedido;
import com.restaurante.pedidos.repository.PedidoRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PedidoService {

    private final PedidoRepository pedidoRepository;

    public PedidoService(PedidoRepository pedidoRepository) {
        this.pedidoRepository = pedidoRepository;
    }


    public Pedido criarPedido(PedidoDTO pedidoDTO) {
        Pedido pedido = new Pedido();


        pedido.setCliente(pedidoDTO.getCliente());
        pedido.setEndereco(pedidoDTO.getEndereco());
        pedido.setItens(pedidoDTO.getItens());
        pedido.setStatus(pedidoDTO.getStatus());
        pedido.setPlataforma(pedidoDTO.getPlataforma());

        return pedidoRepository.save(pedido);
    }


    public List<Pedido> listarPedidosAbertos() {
        return pedidoRepository.findByStatus( String.valueOf ( StatusPedido.ABERTO ) );
    }


    public Pedido atualizarStatus(Long id, StatusPedido status) {
        Pedido pedido = pedidoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pedido não encontrado"));
        pedido.setStatus(status);
        return pedidoRepository.save(pedido);
    }


    public void excluirPedido(Long id) {
        pedidoRepository.deleteById(id);
    }
}
