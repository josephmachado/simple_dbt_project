CREATE USER stakeholder WITH PASSWORD 'password1234';

GRANT USAGE ON SCHEMA warehouse TO stakeholder;

GRANT
SELECT
    ON ALL TABLES IN SCHEMA warehouse TO stakeholder;