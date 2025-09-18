
CREATE TABLE Endereco (
    idEndereco SERIAL PRIMARY KEY,
    logradouro VARCHAR(100),
    numero VARCHAR(10),
    referencia VARCHAR(45),
    cep VARCHAR(9),
    CidadeIdCidade INT
);

CREATE TABLE Pessoa (
    cpfPessoa VARCHAR(20) PRIMARY KEY,
    nomePessoa VARCHAR(60),
    dataNascimentoPessoa DATE,
    EnderecoIdEndereco INT REFERENCES Endereco(idEndereco)
);

CREATE TABLE Cargo (
    idCargo SERIAL PRIMARY KEY,
    nomeCargo VARCHAR(45)
);

CREATE TABLE Funcionario (
    PessoaCpfPessoa VARCHAR(20) PRIMARY KEY REFERENCES Pessoa(cpfPessoa),
    salario DOUBLE PRECISION,
    CargosIdCargo INT REFERENCES Cargo(idCargo),
    porcentagemComissao DOUBLE PRECISION
);

CREATE TABLE Cliente (
    PessoaCpfPessoa VARCHAR(20) PRIMARY KEY REFERENCES Pessoa(cpfPessoa),
    rendaCliente DOUBLE PRECISION,
    dataDeCadastroCliente DATE
);

CREATE TABLE Produto (
    idProduto SERIAL PRIMARY KEY,
    nomeProduto VARCHAR(45),
    quantidadeEmEstoque INT,
    precoUnitario DOUBLE PRECISION
);

CREATE TABLE Pedido (
    idPedido SERIAL PRIMARY KEY,
    dataDoPedido DATE,
    ClientePessoaCpfPessoa VARCHAR(20) REFERENCES Cliente(PessoaCpfPessoa),
    FuncionarioPessoaCpfPessoa VARCHAR(20) REFERENCES Funcionario(PessoaCpfPessoa)
);

CREATE TABLE PedidoHasProduto (
    ProdutoIdProduto INT REFERENCES Produto(idProduto),
    PedidoIdPedido INT REFERENCES Pedido(idPedido),
    quantidade INT,
    precoUnitario DOUBLE PRECISION,
    PRIMARY KEY (ProdutoIdProduto, PedidoIdPedido)
);

CREATE TABLE FormaDePagamento (
    idFormaPagamento SERIAL PRIMARY KEY,
    nomeFormaPagamento VARCHAR(100)
);

CREATE TABLE Pagamento (
    PedidoIdPedido INT PRIMARY KEY REFERENCES Pedido(idPedido),
    dataPagamento TIMESTAMP,
    valorTotalPagamento DOUBLE PRECISION
);

CREATE TABLE PagamentoHasFormaPagamento (
    PagamentoIdPedido INT REFERENCES Pagamento(PedidoIdPedido),
    FormaPagamentoIdFormaPagamento INT REFERENCES FormaDePagamento(idFormaPagamento),
    valorPago DOUBLE PRECISION,
    PRIMARY KEY (PagamentoIdPedido, FormaPagamentoIdFormaPagamento)
);

-- ==========================
-- POPULAÇÃO DE DADOS
-- ==========================

-- Endereco
INSERT INTO Endereco (logradouro, numero, referencia, cep, CidadeIdCidade) VALUES
('Rua A', '100', 'Perto da praça', '87000-001', 1),
('Rua B', '200', 'Esquina mercado', '87000-002', 1),
('Rua C', '300', 'Próx. escola', '87000-003', 2),
('Rua D', '400', 'Centro', '87000-004', 2),
('Rua E', '500', 'Ao lado posto', '87000-005', 3),
('Rua F', '600', 'Esquina lanchonete', '87000-006', 3),
('Rua G', '700', 'Próx. hospital', '87000-007', 4),
('Rua H', '800', 'Próx. rodoviária', '87000-008', 4),
('Rua I', '900', 'Bairro novo', '87000-009', 5),
('Rua J', '1000', 'Final da avenida', '87000-010', 5);

-- Pessoa
INSERT INTO Pessoa VALUES
('11111111111', 'Maria Silva', '1990-05-10', 1),
('22222222222', 'João Souza', '1985-07-20', 2),
('33333333333', 'Ana Costa', '1992-08-15', 3),
('44444444444', 'Pedro Lima', '1998-09-25', 4),
('55555555555', 'Carla Torres', '2000-01-12', 5),
('66666666666', 'Lucas Martins', '1995-03-30', 6),
('77777777777', 'Fernanda Alves', '1988-11-07', 7),
('88888888888', 'Ricardo Santos', '1993-02-18', 8),
('99999999999', 'Juliana Rocha', '1997-04-22', 9),
('10101010101', 'Gabriel Costa', '1991-06-14', 10);

-- Cargo
INSERT INTO Cargo (nomeCargo) VALUES
('Atendente'), ('Caixa'), ('Gerente'), ('Supervisor'),
('Estoquista'), ('Vendedor'), ('Administrador'),
('Auxiliar'), ('Entregador'), ('Diretor');

-- Funcionario
INSERT INTO Funcionario VALUES
('11111111111', 2500, 1, 5.0),
('22222222222', 1800, 2, 3.0),
('33333333333', 3500, 3, 7.0),
('44444444444', 4000, 4, 8.0),
('55555555555', 2200, 5, 4.0),
('66666666666', 2600, 6, 6.0),
('77777777777', 5000, 7, 10.0),
('88888888888', 1500, 8, 2.0),
('99999999999', 2000, 9, 3.5),
('10101010101', 8000, 10, 12.0);

-- Cliente
INSERT INTO Cliente VALUES
('11111111111', 3000, '2020-01-01'),
('22222222222', 1500, '2021-02-01'),
('33333333333', 2500, '2022-03-01'),
('44444444444', 1800, '2023-04-01'),
('55555555555', 2200, '2023-05-01'),
('66666666666', 4000, '2022-06-01'),
('77777777777', 3500, '2021-07-01'),
('88888888888', 2800, '2020-08-01'),
('99999999999', 2600, '2019-09-01'),
('10101010101', 5000, '2018-10-01');

-- Produto
INSERT INTO Produto (nomeProduto, quantidadeEmEstoque, precoUnitario) VALUES
('Chocolate', 100, 5.0),
('Bala de Goma', 200, 0.5),
('Pirulito', 150, 1.0),
('Chiclete', 300, 0.8),
('Paçoca', 120, 1.5),
('Doce de Leite', 80, 3.0),
('Cocada', 60, 2.5),
('Pé de Moleque', 90, 2.0),
('Trufa', 70, 4.0),
('Brigadeiro', 200, 2.2);

-- Pedido
INSERT INTO Pedido (dataDoPedido, ClientePessoaCpfPessoa, FuncionarioPessoaCpfPessoa) VALUES
('2025-01-01', '11111111111', '22222222222'),
('2025-01-02', '33333333333', '44444444444'),
('2025-01-03', '55555555555', '66666666666'),
('2025-01-04', '77777777777', '88888888888'),
('2025-01-05', '99999999999', '10101010101'),
('2025-01-06', '22222222222', '33333333333'),
('2025-01-07', '44444444444', '55555555555'),
('2025-01-08', '66666666666', '77777777777'),
('2025-01-09', '88888888888', '99999999999'),
('2025-01-10', '10101010101', '11111111111');

-- PedidoHasProduto (relacional, 5 registros)
INSERT INTO PedidoHasProduto VALUES
(1, 1, 2, 5.0),
(2, 2, 5, 0.5),
(3, 3, 3, 1.0),
(4, 4, 4, 0.8),
(5, 5, 6, 3.0);

-- FormaDePagamento
INSERT INTO FormaDePagamento (nomeFormaPagamento) VALUES
('Dinheiro'), ('Cartão de Crédito'), ('Cartão de Débito'),
('Pix'), ('Boleto'), ('Vale Alimentação'),
('Transferência Bancária'), ('Cheque'), ('Criptomoeda'), ('Cartão Presente');

-- Pagamento
INSERT INTO Pagamento VALUES
(1, '2025-01-01 10:00:00', 10.0),
(2, '2025-01-02 11:00:00', 2.5),
(3, '2025-01-03 12:00:00', 3.0),
(4, '2025-01-04 13:00:00', 3.2),
(5, '2025-01-05 14:00:00', 9.0),
(6, '2025-01-06 15:00:00', 12.0),
(7, '2025-01-07 16:00:00', 7.5),
(8, '2025-01-08 17:00:00', 8.0),
(9, '2025-01-09 18:00:00', 11.0),
(10, '2025-01-10 19:00:00', 5.5);

-- PagamentoHasFormaPagamento (relacional, 5 registros)
INSERT INTO PagamentoHasFormaPagamento VALUES
(1, 1, 10.0),
(2, 2, 2.5),
(3, 3, 3.0),
(4, 4, 3.2),
(5, 5, 9.0);