CREATE TABLE companies (
  id   SERIAL NOT NULL PRIMARY KEY,
  name TEXT   NOT NULL UNIQUE
);

CREATE VIEW companies_v1 AS
SELECT
  id     AS id,
  "name" AS name
FROM companies;

CREATE OR REPLACE FUNCTION update_companies_v1() RETURNS TRIGGER AS
$update_companies_v1$
DECLARE
  new_id INTEGER;
BEGIN
  IF (TG_OP = 'INSERT')
  THEN
    INSERT
    INTO
      companies("name")
    VALUES
      (NEW.name) RETURNING id INTO new_id;
    NEW.id = new_id;
    RETURN NEW;
  ELSEIF (TG_OP = 'UPDATE')
  THEN
    UPDATE companies
    SET
      name = NEW.name
    WHERE
      id = OLD.id;
    RETURN NEW;
  ELSEIF (TG_OP = 'DELETE')
  THEN
    DELETE FROM companies WHERE id = OLD.id;
    RETURN OLD;
  END IF;
END;
$update_companies_v1$
  LANGUAGE plpgsql;

CREATE TRIGGER companies_trigger_v1
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON companies_v1
  FOR EACH ROW
EXECUTE PROCEDURE update_companies_v1();



CREATE TABLE products (
  id         SERIAL NOT NULL PRIMARY KEY,
  name       TEXT   NOT NULL UNIQUE,
  price      MONEY  NOT NULL,
  company_id INTEGER REFERENCES companies (id)
);

CREATE VIEW products_v1 AS
SELECT
  id         AS id,
  "name"     AS name,
  price      AS price,
  company_id AS company_id
FROM products;

CREATE OR REPLACE FUNCTION update_products_v1() RETURNS TRIGGER AS
$update_products_v1$
DECLARE
  new_id INTEGER;
BEGIN
  IF (TG_OP = 'INSERT')
  THEN
    INSERT
    INTO
      products("name", price, company_id)
    VALUES
      (NEW.name, NEW.price, NEW.company_id) RETURNING id INTO new_id;
    NEW.id = new_id;
    RETURN NEW;
  ELSEIF (TG_OP = 'UPDATE')
  THEN
    UPDATE products
    SET
      name       = NEW.name,
      price      = NEW.price,
      company_id = NEW.company_id
    WHERE
      id = OLD.id;
    RETURN NEW;
  ELSEIF (TG_OP = 'DELETE')
  THEN
    DELETE FROM products WHERE id = OLD.id;
    RETURN OLD;
  END IF;
END;
$update_products_v1$
  LANGUAGE plpgsql;

CREATE TRIGGER products_trigger_v1
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON products_v1
  FOR EACH ROW
EXECUTE PROCEDURE update_products_v1();



CREATE TABLE customers (
  id    SERIAL NOT NULL PRIMARY KEY,
  email TEXT   NOT NULL UNIQUE
);

CREATE VIEW customers_v1 AS
SELECT
  id    AS id,
  email AS email
FROM customers;

CREATE OR REPLACE FUNCTION update_customers_v1() RETURNS TRIGGER AS
$update_customers_v1$
DECLARE
  new_id INTEGER;
BEGIN
  IF (TG_OP = 'INSERT')
  THEN
    INSERT
    INTO
      customers(email)
    VALUES
      (NEW.email) RETURNING id INTO new_id;
    NEW.id = new_id;
    RETURN NEW;
  ELSEIF (TG_OP = 'UPDATE')
  THEN
    UPDATE customers
    SET
      email = NEW.email
    WHERE
      id = OLD.id;
    RETURN NEW;
  ELSEIF (TG_OP = 'DELETE')
  THEN
    DELETE FROM customers WHERE id = OLD.id;
    RETURN OLD;
  END IF;
END;
$update_customers_v1$
  LANGUAGE plpgsql;

CREATE TRIGGER customers_trigger_v1
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON customers_v1
  FOR EACH ROW
EXECUTE PROCEDURE update_customers_v1();



CREATE TABLE invoices (
  id          SERIAL  NOT NULL PRIMARY KEY,
  customer_id INTEGER NOT NULL REFERENCES customers (id)
);

CREATE VIEW invoices_v1 AS
SELECT
  id            AS id,
  "customer_id" AS customer_id
FROM invoices;

CREATE OR REPLACE FUNCTION update_invoices_v1() RETURNS TRIGGER AS
$update_invoices_v1$
DECLARE
  new_id INTEGER;
BEGIN
  IF (TG_OP = 'INSERT')
  THEN
    INSERT
    INTO
      invoices("customer_id")
    VALUES
      (NEW.customer_id) RETURNING id INTO new_id;
    NEW.id = new_id;
    RETURN NEW;
  ELSEIF (TG_OP = 'UPDATE')
  THEN
    UPDATE invoices
    SET
      customer_id = NEW.customer_id
    WHERE
      id = OLD.id;
    RETURN NEW;
  ELSEIF (TG_OP = 'DELETE')
  THEN
    DELETE FROM invoices WHERE id = OLD.id;
    RETURN OLD;
  END IF;
END;
$update_invoices_v1$
  LANGUAGE plpgsql;

CREATE TRIGGER invoices_trigger_v1
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON invoices_v1
  FOR EACH ROW
EXECUTE PROCEDURE update_invoices_v1();


CREATE TABLE invoice_items (
  id         SERIAL  NOT NULL PRIMARY KEY,
  invoice_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity   INTEGER DEFAULT 1,
  discount   MONEY   DEFAULT 0
);

CREATE VIEW invoice_items_v1 AS
SELECT
  id         AS id,
  invoice_id AS invoice_id,
  product_id AS product_id,
  quantity   AS quantity,
  discount   AS discount
FROM invoice_items;

CREATE OR REPLACE FUNCTION update_invoice_items_v1() RETURNS TRIGGER AS
$update_invoice_items_v1$
DECLARE
  new_id INTEGER;
BEGIN
  IF (TG_OP = 'INSERT')
  THEN
    INSERT
    INTO
      invoice_items(invoice_id, product_id, quantity, discount)
    VALUES
    (NEW.invoice_id, NEW.product_id, NEW.quantity, NEW.discount) RETURNING id INTO new_id;
    NEW.id = new_id;
    RETURN NEW;
  ELSEIF (TG_OP = 'UPDATE')
  THEN
    UPDATE invoice_items
    SET
      invoice_id = NEW.invoice_id,
      product_id = NEW.product_id,
      quantity   = NEW.quantity,
      discount   = NEW.discount
    WHERE
      id = OLD.id;
    RETURN NEW;
  ELSEIF (TG_OP = 'DELETE')
  THEN
    DELETE FROM invoice_items WHERE id = OLD.id;
    RETURN OLD;
  END IF;
END;
$update_invoice_items_v1$
  LANGUAGE plpgsql;

CREATE TRIGGER invoice_items_trigger_v1
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON invoice_items_v1
  FOR EACH ROW
EXECUTE PROCEDURE update_invoice_items_v1();


INSERT
INTO
  companies (name)
VALUES
  ('ACME'),
  ('Monty');

INSERT
INTO
  customers (email)
VALUES
  ('example1@example.com'),
  ('example2@example.com'),
  ('example3@example.com'),
  ('example4@example.com');


INSERT
INTO
  products (name, price, company_id)
VALUES
('something', 20, (SELECT id FROM companies WHERE name = 'ACME')),
('something else', 20, (SELECT id FROM companies WHERE name = 'ACME')),
('another thing', 20, (SELECT id FROM companies WHERE name = 'ACME')),
('and another', 20, (SELECT id FROM companies WHERE name = 'ACME'));

INSERT
INTO
  invoices (customer_id)
VALUES
((SELECT id FROM customers WHERE email = 'example1@example.com')),
((SELECT id FROM customers WHERE email = 'example2@example.com')),
((SELECT id FROM customers WHERE email = 'example3@example.com')),
((SELECT id FROM customers WHERE email = 'example4@example.com'));

INSERT
INTO
  invoice_items (invoice_id, product_id)
VALUES
((SELECT id FROM invoices WHERE customer_id = (SELECT id FROM customers WHERE email = 'example1@example.com')), (SELECT id FROM products WHERE name = 'something')),
((SELECT id FROM invoices WHERE customer_id = (SELECT id FROM customers WHERE email = 'example1@example.com')), (SELECT id FROM products WHERE name = 'something else')),
((SELECT id FROM invoices WHERE customer_id = (SELECT id FROM customers WHERE email = 'example1@example.com')), (SELECT id FROM products WHERE name = 'another thing')),
((SELECT id FROM invoices WHERE customer_id = (SELECT id FROM customers WHERE email = 'example1@example.com')), (SELECT id FROM products WHERE name = 'and another')),
((SELECT id FROM invoices WHERE customer_id = (SELECT id FROM customers WHERE email = 'example2@example.com')), (SELECT id FROM products WHERE name = 'something')),
((SELECT id FROM invoices WHERE customer_id = (SELECT id FROM customers WHERE email = 'example3@example.com')), (SELECT id FROM products WHERE name = 'another thing')),
((SELECT id FROM invoices WHERE customer_id = (SELECT id FROM customers WHERE email = 'example3@example.com')), (SELECT id FROM products WHERE name = 'something else')),
((SELECT id FROM invoices WHERE customer_id = (SELECT id FROM customers WHERE email = 'example4@example.com')), (SELECT id FROM products WHERE name = 'and another'));
