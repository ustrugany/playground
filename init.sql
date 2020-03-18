create table pilots (
  id integer not null,
  name text not null
);

alter table pilots add constraint pilot_pkey primary key (id);

create table jets (
  id integer not null,
  pilot_id integer not null,
  age integer not null,
  name text not null,
  color text not null
);

alter table jets add constraint jet_pkey primary key (id);
alter table jets add constraint jet_pilots_fkey foreign key (pilot_id) references pilots(id);

create table languages (
  id integer not null,
  language text not null
);

alter table languages add constraint language_pkey primary key (id);

-- join table
create table pilot_languages (
  pilot_id integer not null,
  language_id integer not null
);

-- composite primary key
alter table pilot_languages add constraint pilot_language_pkey primary key (pilot_id, language_id);
alter table pilot_languages add constraint pilot_language_pilots_fkey foreign key (pilot_id) references pilots(id);
alter table pilot_languages add constraint pilot_language_languages_fkey foreign key (language_id) references languages(id);

insert into pilots (id, name) values (1, 'Piotr');
insert into pilots (id, name) values (2, 'Wojtek');
insert into pilots (id, name) values (3, 'Bartek');
insert into languages (id, language) values (1, 'English');
insert into languages (id, language) values (2, 'Polish');
insert into languages (id, language) values (3, 'French');
insert into jets values (1, 1, 5, 'F-22A Raptor', 'gray');
insert into jets values (2, 2, 4, 'HC-130H(N) King', 'white');
insert into jets values (3, 3, 10, 'F-35A Lightning II', 'silver');

insert into pilot_languages (pilot_id, language_id) values (1, 1);
insert into pilot_languages (pilot_id, language_id) values (1, 2);
insert into pilot_languages (pilot_id, language_id) values (2, 1);
insert into pilot_languages (pilot_id, language_id) values (2, 2);
insert into pilot_languages (pilot_id, language_id) values (3, 1);
insert into pilot_languages (pilot_id, language_id) values (3, 2);
insert into pilot_languages (pilot_id, language_id) values (3, 3);


select * from jets j join pilots p on j.pilot_id = p.id join pilot_languages pl on pl.pilot_id = p.id join languages l on l.id = pl.language_id;