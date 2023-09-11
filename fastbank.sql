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

-- Cliente

create table Cliente(
	codigo int,
    codigoEndereco int,
    nome_razaoSocial varchar(100),
    nomeSocial_Fantasia varchar(100),
    foto_logo varchar(100),
    dataNascimento_Abertura date,
    usuario char(10),
    senha int
);

-- ClientePJ

create table ClientePJ(
	codigoCliente int,
    cnpj varchar(50),
    inscricaoMunicipal varchar(50),
    inscricaoEstadual varchar(50)
);

alter table ClientePJ
add regiao varchar(100);

alter table ClientePJ
drop column inscricaoMunicipal;