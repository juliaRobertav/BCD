/*
Banco: fastbank
Autor: Julia
Última alteração: 11/09/23
Tipo: DDL
Descrição: Banco de Dados de uma instituição financeira virtual
fictícia como projeto da matéria de Banco de Dados (BCD)
*/

-- Criação de Tabelas

create database fastbank;

 -- Conecta ao Banco
 
use fastbank;

-- Endereco

create table Endereco(
	codigo int not null auto_increment primary key,
    logradouro varchar(100),
    bairro varchar(75),
    cep char(10),
    cidade varchar(75),
    uf char(2),
    constraint PK_Endereco primary key (codigo)
);

ALTER TABLE Endereco
add codigo int not null primary key;

-- Cliente

create table Cliente(
	codigo int not null,
    codigoEndereco int,
    nome_razaoSocial varchar(100),
    nomeSocial_Fantasia varchar(100),
    foto_logo varchar(100),
    dataNascimento_Abertura date,
    usuario char(10),
    senha int
);

ALTER TABLE Cliente
AUTO_INCREMENT = 1;

-- ClientePJ

create table ClientePJ(
	codigoCliente int,
    cnpj varchar(50),
    inscricaoMunicipal varchar(50),
    inscricaoEstadual varchar(50)
);

-- alterando tabela

alter table ClientePJ
add regiao varchar(100);

alter table ClientePJ
drop column inscricaoMunicipal;

alter table Cliente
add primary key (codigo);

alter table ClientePJ
add foreign key (codigoCliente) REFERENCES Cliente(codigo);

-- Cliente PF

create table ClientePF(
	codigoCliente int,
    rg varchar(20),
    cpf varchar(20),
	foreign key (codigoCliente) references Cliente(codigo)
);

ALTER TABLE ClientePF
AUTO_INCREMENT = 1;

-- Contato

create table Contato(
	codigo int not null primary key,
    codigoCliente int,
    foreign key (codigoCliente) references Cliente(codigo)
);

ALTER TABLE Contato
AUTO_INCREMENT = 1;

-- Conta

create table Conta(
	codigo int not null primary key,
    codigoContaTipo int,
    ativa boolean,
    numero varchar(20),
    limite decimal(10, 2),
    agencia varchar(10)
);

ALTER TABLE Conta
AUTO_INCREMENT = 1;

alter table Conta
add foreign key (codigoContaTipo) references ContaTipo(codigo);

-- ContaTipo

create table ContaTipo(
	codigo int not null primary key,
    descricao varchar(100)
);

ALTER TABLE ContaTipo
AUTO_INCREMENT = 1;

-- ClienteConta

create table ClienteConta(
	codigoCliente int,
    codigoConta int,
	foreign key (codigoCliente) references Cliente(codigo),
    foreign key (codigoConta) references Conta(codigo)
);

-- Cartao

create table Cartao(
	codigo int not null primary key,
    codigoConta int,
    codigoBandeira int,
    situacao varchar(20),
    numero varchar(30),
    validade date,
    cvv char(5),
	foreign key (codigoConta) references Conta(codigo)
);

ALTER TABLE Cartao
AUTO_INCREMENT = 1;

alter table Cartao
add foreign key (codigoBandeira) references Bandeira(codigo);

-- Bandeira

create table Bandeira(
	codigo int not null primary key,
    descricao varchar(100)
);

ALTER TABLE Bandeira
AUTO_INCREMENT = 1;

-- Emprestimo

create table Emprestimo(
	codigo int not null primary key,
    codigoConta int,
    foreign key (codigoConta) references Conta(codigo),
    valorSolicitado decimal(10, 2),
    observacao varchar(200),
    juros float,
    dataSolicitacao date,
    aprovado bool,
    dataAprovacao date,
    numeroParcela int
);

-- Investimento

create table Investimento(
	codigo int not null primary key,
    codigoConta int,
	foreign key (codigoConta) references Conta(codigo),
    codigoInvestimentoTipo int,
    codigoGrauRisco int,
    prazo varchar(20),
    aporte decimal(10, 2),
    rentabilidade decimal(10, 2),
    finalizado bool,
    taxaAdministracao float
);

ALTER TABLE Investimento
AUTO_INCREMENT = 1;

alter table Investimento
add foreign key (codigoInvestimentoTipo) references InvestimentoTipo(codigo),
add foreign key (codigoGrauRisco) references GrauRisco(codigo);

-- Movimentacao

create table Movimentacao(
	codigo int not null primary key,
    codigoOperacao int,
    dataHora datetime,
    valor decimal(10, 2)
);

ALTER TABLE Movimentacao
AUTO_INCREMENT = 1;

alter table Movimentacao
add foreign key (codigoOperacao) references Operacao(codigo);

-- Operacao

create table Operacao(
	codigo int not null primary key,
    descricao varchar(100)
);

ALTER TABLE Operacao
AUTO_INCREMENT = 1;
-- Grau Risco

create table GrauRisco(
	codigo int not null primary key,
    descricao varchar(100)
);

ALTER TABLE GrauRisco
AUTO_INCREMENT = 1;

-- Investimento Tipo

create table InvestimentoTipo(
	codigo int not null primary key,
    descricao varchar(100)
);

ALTER TABLE InvestimentoTipo
AUTO_INCREMENT = 1;

-- Emprestimo Parcela

create table EmprestimoParcela(
	codigo int not null primary key,
    codigoEmprestimo int,
    foreign key (codigoEmprestimo) references Emprestimo(codigo),
    valorParcela decimal(10, 2),
    valorPago decimal(10, 2),
    numero int,
    dataPagamento date,
    dataVencimento date
);

ALTER TABLE EmprestimoParcela
AUTO_INCREMENT = 1;
-- Seguro

create table Seguro(
	codigo int not null primary key,
    codigoConta int,
	foreign key (codigoConta) references Conta(codigo),
    descricao varchar(50)
);

ALTER TABLE Seguro
AUTO_INCREMENT = 1;

-- Cobertura

create table Cobertura(
	codigo int not null primary key,
    descricao int
);

ALTER TABLE Cobertura
AUTO_INCREMENT = 1;

alter table Cobertura
drop column descricao,
add descricao varchar(100);

-- Seguro Cobertura

create table SeguroCobertura(
	codigoSeguro int,
    codigoCobertura int,
	foreign key (codigoSeguro) references Seguro(codigo),
	foreign key (codigoCobertura) references Cobertura(codigo)
);

-- Servico
create table Servico(
	codigo int not null primary key,
    descricao int
);

ALTER TABLE Servico
AUTO_INCREMENT = 1;

alter table Servico
drop column descricao,
add descricao varchar(100);

-- Seguro Pagamento

create table SeguroPagamento(
	codigo int not null primary key,
    codigoSeguro int,
	foreign key (codigoSeguro) references Seguro(codigo),
    quantidadeParcelas int,
    valorPago decimal(10, 2),
    dataVencimento date,
    dataPagamento date,
    valorTotal decimal(10, 2),
    numeroParcela int
);

ALTER TABLE SeguroPagamento
AUTO_INCREMENT = 1;

-- Tipo Imovel

create table tipoImovel(
	codigo int not null primary key,
    descricao varchar(50)
);

ALTER TABLE TipoImovel
AUTO_INCREMENT = 1;
-- Imovel

create table Imovel(
	codigo int not null primary key,
    codigoTipoImovel int,
    codigoEndereco int,
    valor decimal(10, 2),
    foreign key (codigoTipoImovel) references TipoImovel(codigo)
);

ALTER TABLE Imovel
AUTO_INCREMENT = 1;

alter table Imovel
add foreign key (codigoEndereco) references Endereco(codigo);

-- Sinistro

create table Sinistro(
	codigo int not null primary key,
    codigoImovel int,
	foreign key (codigoImovel) references Imovel(codigo),
    indenizacao decimal(10, 2),
    dataAbertura date,
    dataFinalizacao date,
    descricao varchar(300)
);

ALTER TABLE Sinistro
AUTO_INCREMENT = 1;

-- Sinistro Cobertura

create table SinistroCobertura(
	codigoCobertura int,
    codigoSinistro int,
    foreign key (codigoCobertura) references Cobertura(codigo),
	foreign key (codigoSinistro) references Sinistro(codigo)
);

-- Sinistro Servico

create table SinistroServico(
	codigoServico int,
    codigoSinistro int,
    foreign key (codigoServico) references Servico(codigo),
	foreign key (codigoSinistro) references Sinistro(codigo)
);
