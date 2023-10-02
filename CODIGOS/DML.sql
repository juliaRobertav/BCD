/*----------------------------------------------------------------------
Banco: fastbank
Autor: Julia Roberta
Ultima alteração: 02/10/23
Tipo: Inserções, alterações e Exclusões (DML)
      Testes de integridade referencial e restrições DDL
Descrição: Banco de dados de uma instituição financeira virtual fictícia
           como projeto da Unidade Curricular de banco de Dados (BCD)
-----------------------------------------------------------------------*/
/*
Documentação:

--> insert
	(https://dev.mysql.com/doc/refman/8.0/en/insert.html)

--> update
	(https://dev.mysql.com/doc/refman/8.0/en/update.html)

--> delete
	(https://dev.mysql.com/doc/refman/8.0/en/delete.html)
*/

-- Conecta no banco
use fastbank;


-- Tabela Cliente isolada (sem relacionamento)
create table cliente(
	codigo int auto_increment,
    nome_razaosocial varchar(100) not null,
    nomesocial_fantasia varchar(100),
    foto_logo varchar(100) not null,
    datanascimento_abertura date not null,
    usuario char(10) not null,
    senha int not null,
    constraint pk_cliente primary key (codigo),
    constraint uk_cliente unique (usuario),
    constraint chk_cliente_senha check (senha >= 000000 and senha <= 999999)
);

-- INSERT
-- ----------------------------------------------------------------------

-- Inserção de dados para todos os atributos
insert into cliente
	(nome_razaoSocial, nomesocial_fantasia, foto_logo, datanascimento_abertura, usuario, senha) -- atributos
values
	('Alice Barbalho Vilalobos', 'Alice Vilalobos', '\\foto\\2.jpg', '1992-05-17', 'alice', 987); -- valores

-- Verifica resultado
select * from cliente;


-- Inserção somente dos dados obrigatórios
insert into cliente
	(nome_razaosocial, foto_logo, datanascimento_abertura, usuario, senha) -- atributos
values
	('Sheila Tuna Espírito Santo', '\\foto\\4.jpg', '1980-03-05', 'sheila', 123); -- valores

-- Verifica resultado
select * from cliente;


-- (tentativa) Inserção faltando dados obrigatórios
insert into cliente
	(nome_razaosocial, foto_logo, usuario, senha) -- atributos
values
	('Abigail Barateiro Cangueiro', '\\foto\\6.jpg', 'abigail', 147); -- valores
    
-- Error Code: 1364. Field 'datanascimento_abertura' doesn't have a default value

-- Verifica resultado
select * from cliente;


-- (tentativa) Quantidade de atributos e valores diferentes
insert into cliente
	(nome_razaosocial, nomesocial_fantasia, foto_logo, datanascimento_abertura, usuario, senha) -- atributos
values
	('Abigail Barateiro Cangueiro', '\\foto\\6.jpg', '1987-07-30', 'abigail', 147); -- valores

-- Error Code: 1136. Column count doesn't match value count at row 1

-- Verifica resultado
select * from cliente;


-- Inserção correta
insert into cliente
	(nome_razaosocial, foto_logo, datanascimento_abertura, usuario, senha) -- atributos
values
	('Abigail Barateiro Cangueiro', '\\foto\\6.jpg', '1987-07-30', 'abigail', 147); -- valores

-- Verifica resultado
select * from cliente;


-- (tentativa) Inserção com valor do atributo UNIQUE duplicado
insert into cliente
	(nome_razaosocial, nomesocial_fantasia, foto_logo, datanascimento_abertura, usuario, senha) -- atributos
values
	('Regina e Julia Entregas Expressas ME', 'Entregas Express', '\\fotos\\8.jpg', '2018-03-11', 'alice', 987); -- valores

-- Error Code: 1062. Duplicate entry 'alice' for key 'cliente.uk_cliente'

-- Verifica resultado
select * from cliente;
	 

-- Inserção de dados em lote
insert into cliente
	(nome_razaosocial, foto_logo, datanascimento_abertura, usuario, senha) -- atributos
values
	('Regina e Julia Entregas Expressas ME', '\\fotos\\8.jpg', '2018-03-11', 'express', 987),  -- valores
	('João Barbalho Vilalobos', '\\fotos\\10.jpg', '1990-06-15', 'joao', 357),
	('Juan e Valentina Alimentos ME', '\\fotos\\12.jpg','2015-11-12', 'avenida', 258);

-- Verifica resultado
select * from cliente;


/* Obs.: É possível a inserção de dados sem identificação dos campos, 
         porém, devem ser informados valores para todos os atributos na ordem de criação
         inclusive a chave primária, ou seja, sem utilizar ou ignorando o auto_increment */



-- Restrições de relacionamento
-- ----------------------------------------------------------------------

drop table cliente;

create table endereco(
	codigo int auto_increment,
    logradouro varchar(100) not null,
    bairro varchar(75) not null,
    cep char(10) not null,
    cidade varchar(75) not null,
    uf enum('AC','AL','AM','AP','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO'),
    constraint pk_endereco primary key (codigo)
);

create table cliente(
	codigo int auto_increment,
    codigo_endereco int not null,
    nome_razaosocial varchar(100) not null,
    nomesocial_fantasia varchar(100),
    foto_logo varchar(100) not null,
    datanascimento_abertura date not null,
    usuario char(10) not null,
    senha int not null,
    constraint pk_cliente primary key (codigo),
    constraint uk_cliente unique (usuario),
    constraint chk_cliente_senha check (senha >= 000000 and senha <= 999999),
    constraint fk_cliente_endereco foreign key (codigo_endereco) references endereco (codigo)
);


-- (tentativa) Inserção de cliente
insert into cliente
	(codigo_endereco, nome_razaosocial, nomesocial_fantasia, foto_logo, datanascimento_abertura, usuario, senha)
values
	(1, 'Alice Barbalho Vilalobos', 'Alice Vilalobos', '\\foto\\2.jpg', '1992-05-17', 'alice', 987);

-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails 
-- (`fastbank`.`cliente`, CONSTRAINT `fk_cliente_endereco` FOREIGN KEY (`codigo_endereco`) REFERENCES `endereco` (`codigo`))


-- Pra inserção de um cliente seu endereço já deve existir
-- Endereco(1,1) <-> (1,n)Cliente
insert into endereco
	(logradouro, bairro, cidade, uf, cep)
values
	('Avenida Cristiano Olsen, 10', 'Jardim Sumaré', 'Araçatuba','SP','16015244');

-- Verifica resultado
select * from endereco;


insert into cliente
	(codigo_endereco, nome_razaosocial, nomesocial_fantasia, foto_logo, datanascimento_abertura, usuario, senha)
values
	(1, 'Alice Barbalho Vilalobos', 'Alice Vilalobos', '\\foto\\2.jpg', '1992-05-17', 'alice', 987);

-- Verifica resultado
select * from endereco;
select * from cliente;



-- Restrições de CHECK
-- ----------------------------------------------------------------------

insert into cliente
	(codigo_endereco, nome_razaosocial, foto_logo, datanascimento_abertura, usuario, senha)
values
	(1, 'Abigail Barateiro Cangueiro', '\\foto\\6.jpg', '1987-07-30', 'abigail', -123);

-- Error Code: 3819. Check constraint 'chk_cliente_senha' is violated.

-- Verifica resultado
select * from cliente;


insert into cliente
	(codigo_endereco, nome_razaosocial, foto_logo, datanascimento_abertura, usuario, senha)
values
	(1, 'Abigail Barateiro Cangueiro', '\\foto\\6.jpg', '1987-07-30', 'abigail', 123);

-- Verifica resultado
select * from cliente;



-- Exclusão em cascata
-- ----------------------------------------------------------------------

create table contato(
	codigo int auto_increment,
    codigo_cliente int not null,
    ddd char(3) not null,
    numero varchar(10) not null,
    ramal varchar(10),
    email varchar(50),
    observacao varchar(50),
    constraint pk_contato primary key (codigo),
    constraint fk_contato_cliente foreign key (codigo_cliente) references cliente (codigo)
    on update cascade
    on delete cascade
);

-- Para inserir um Contato o Cliente já deve existir
-- Contato(1,n) <-> (1,1)Cliente

-- Verifica resultado
select * from cliente;

insert into contato
	(codigo_cliente, ddd, numero, ramal, email, observacao)
values
	(2, '19', '3754-8198', 'Ramal 12', 'alice@gmail.com', 'Comercial');

insert into contato
	(codigo_cliente, ddd, numero, email, observacao)
values
	(2, '19', '98756-2568', 'alice@gmail.com', 'Pessoal');
 
 
 -- Verifica resultado
select * from endereco;
select * from cliente;
select * from contato;


-- DELETE
-- ----------------------------------------------------------------------

-- WHERE: Cláusula que filtra/seleciona registros (linhas)

-- (tentativa) Exclusão de registro relacionado
delete from endereco
where codigo = 1;

-- Comportamento "normal"

-- Error Code: 1064. You have an error in your SQL syntax; 
-- check the manual that corresponds to your MySQL server version for the right syntax to use near 
-- 'SELECT * FROM endereco SELECT * FROM cliente SELECT * FROM contato

-- Verifica resultado
select * from endereco;
select * from cliente;
select * from contato;


-- Devido ao on update delete cascade a exclusão ocorre na tabela Cliente 
-- e também (em cascata) na tabela Contato (registros relacionados)

delete from cliente
where codigo = 2;

-- Verifica resultado
select * from endereco;
select * from cliente;
select * from contato;


-- (tentativa) Delete sem where (todos os registos são excluidos)
delete from cliente;

-- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  
-- To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

/* Menu Edit -> Preferences -> SQL Editor
   Desmarcar a opção: Safe Updates (rejects UPDATES and DELETEs with no restrictions)
   Reconnect to DBMS
*/

-- Delete sem where (todos os registos são excluidos)
delete from cliente;
delete from endereco;

-- Verifica resultado
select * from endereco;
select * from cliente;
select * from contato;


-- Exclui tabelas (respeitando a sequencia dos relacionamentos)
drop table contato;
drop table cliente;
drop table endereco;



-- UPDATE
-- ----------------------------------------------------------------------

-- Tabela Cliente isolada (sem relacionamento)
create table cliente(
	codigo int auto_increment,
    nome_razaosocial varchar(100) not null,
    nomesocial_fantasia varchar(100),
    foto_logo varchar(100) not null,
    datanascimento_abertura date not null,
    usuario char(10) not null,
    senha int not null,
    constraint pk_cliente primary key (codigo),
    constraint uk_cliente unique (usuario),
    constraint chk_cliente_senha check (senha >= 000000 and senha <= 999999)
);


insert into cliente
	(nome_razaosocial, nomesocial_fantasia, foto_logo, datanascimento_abertura, usuario, senha)
values
	('Derek Bicudo Lagos', null, '\\fotos\\10.jpg', '2002-03-12', 'derek', 258),
	('Marcelo Frois Caminha', null, '\\fotos\\12.jpg', '2001-11-23', 'ana', 654),   
    ('Gabriel e Marcelo Corretores Associados Ltda', 'Imobiliária Cidade', '\\fotos\\18.jpg', '2017-09-26', 'cidade', 474);

-- Obs.: Caso não haja valor para algum atributo (obrigatório ou não) informe null

-- Verifica resultado
select * from cliente;

-- Update sem where (todos os registos são alterados)
update cliente
set foto_logo = '\\foto\\testes';

-- Verifica resultado
select * from cliente;


-- WHERE: Cláusula que filtra/seleciona registros (linhas)

update cliente
set nomesocial_fantasia = 'Entregas Express'
where codigo = 5;

update cliente
set foto_logo = '\\fotos\\006.jpg',
	usuario = 'entregas'
where codigo = 6;

-- Verifica resultado
select * from cliente;


-- Sugestão: recomenda-se utilizar a instrução SELECT para montar e testar a 
-- cláusula WHERE antes de executar um UDPADE ou DELETE, por exemplo

select * 
from cliente
where usuario = 'derek';


update cliente
set senha = '852'
where usuario = 'derek';

-- Verifica resultado
select * from cliente;