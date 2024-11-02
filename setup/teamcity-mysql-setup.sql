--


-- https://www.jetbrains.com/help/teamcity/setting-up-an-external-database.html#MySQL

create database teamcity collate utf8_bin;
create user teamcity identified by 'teamcity';
grant all privileges on teamcity.* to teamcity;
grant process on *.* to teamcity;
