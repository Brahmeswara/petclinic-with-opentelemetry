CREATE TABLE visits (
  id            INTEGER IDENTITY PRIMARY KEY,
  pet_id        INTEGER NOT NULL,
  visit_date    DATE,
  description   VARCHAR(8192),
  billing_status VARCHAR(20) DEFAULT  'Not Invoiced',
);

CREATE INDEX visits_pet_id ON visits (pet_id);