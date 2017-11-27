
insert into categoria values ('carne');
insert into categoria values ('frango');
insert into categoria values ('peito de frango');
insert into categoria values ('salsicha');

insert into categoria_simples values ('peito de frango');
insert into categoria_simples values ('salsicha');

insert into super_categoria values ('carne');
insert into super_categoria values ('frango');

insert into constituida values ('carne', 'salsicha');
insert into constituida values ('carne', 'frango');
insert into constituida values ('frango', 'peito de frango');

insert into fornecedor values (267081367, 'Antonio');
insert into fornecedor values (907081367, 'Maria');

insert into produto values (1234567890, 'Frankfurt', 'salsicha', 267081367, '2010-05-05');
insert into produto values (9234567899, 'Nobre', 'salsicha', 907081367, '2222-11-11');

insert into fornece_sec values (267081367, 1234567890);
insert into fornece_sec values (907081367, 9234567899);

insert into corredor values (120, 3.12);
insert into corredor values (22, 1.12);

insert into prateleira values (120, 'esquerda', 'chao');
insert into prateleira values (120, 'direita', 'medio');
insert into prateleira values (22, 'esquerda', 'chao');

insert into planograma values (1234567890, 120, 'esquerda', 'chao', 2, 110, 3);

insert into evento_reposicao values (888555444, '2001-09-28');

insert into reposicao values (1234567890, 120, 'esquerda', 'chao', 888555444, '2001-09-28', 553);
