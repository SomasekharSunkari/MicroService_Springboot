create table if not exists category(
    id integer not null primary key,
    description varchar(255),
    name varchar(255),
    image_url varchar(500) -- new column for default category image
);

create table if not exists product(
    id integer not null primary key,
    description varchar(255),
    name varchar(255),
    available_quantity double precision not null,
    price numeric(38,2),
    category_id integer constraint fk1_sekhar references category,
    image_url varchar(500) -- new column for product image URL
);

create sequence if not exists category_seq increment by 50;
create sequence if not exists product_seq increment by 50