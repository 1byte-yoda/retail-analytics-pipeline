CREATE DATABASE IF NOT EXISTS retail;

USE retail;

CREATE TABLE IF NOT EXISTS region (
  r_regionkey  INTEGER PRIMARY KEY NOT NULL,
  r_name       TEXT NOT NULL,
  r_comment    TEXT,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS nation (
  n_nationkey   INTEGER PRIMARY KEY NOT NULL,
  n_name        TEXT NOT NULL,
  n_regionkey   INTEGER NOT NULL,
  n_comment     TEXT,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (n_regionkey) REFERENCES region(r_regionkey)
);

CREATE TABLE IF NOT EXISTS part (
  p_partkey     INTEGER PRIMARY KEY NOT NULL,
  p_name        VARCHAR(255) NOT NULL,
  p_mfgr        VARCHAR(255) NOT NULL,
  p_brand       VARCHAR(255) NOT NULL,
  p_type        VARCHAR(255) NOT NULL,
  p_size        INTEGER NOT NULL,
  p_container   VARCHAR(255) NOT NULL,
  p_retailprice DECIMAL(7, 2) NOT NULL,
  p_comment     TEXT NOT NULL,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS supplier (
  s_suppkey     INTEGER PRIMARY KEY NOT NULL,
  s_name        VARCHAR(255) NOT NULL,
  s_address     TEXT NOT NULL,
  s_nationkey   INTEGER NOT NULL,
  s_phone       VARCHAR(255) NOT NULL,
  s_acctbal     DECIMAL(10, 2) NOT NULL,
  s_comment     TEXT NOT NULL,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (s_nationkey) REFERENCES nation(n_nationkey)
);

CREATE TABLE IF NOT EXISTS partsupp (
  ps_partkey    INTEGER NOT NULL,
  ps_suppkey    INTEGER NOT NULL,
  ps_availqty   INTEGER NOT NULL,
  ps_supplycost DECIMAL(10, 2) NOT NULL,
  ps_comment    TEXT NOT NULL,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (ps_partkey, ps_suppkey),
  FOREIGN KEY (ps_suppkey) REFERENCES supplier(s_suppkey),
  FOREIGN KEY (ps_partkey) REFERENCES part(p_partkey)
);

CREATE TABLE IF NOT EXISTS customer (
  c_custkey    INTEGER PRIMARY KEY NOT NULL,
  c_name       VARCHAR(255) NOT NULL,
  c_address    TEXT NOT NULL,
  c_nationkey  INTEGER NOT NULL,
  c_phone      VARCHAR(255) NOT NULL,
  c_acctbal    DECIMAL(7, 2)   NOT NULL,
  c_mktsegment VARCHAR(255) NOT NULL,
  c_comment    TEXT NOT NULL,
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (c_nationkey) REFERENCES nation(n_nationkey)
);

CREATE TABLE IF NOT EXISTS orders (
  o_orderkey      INTEGER PRIMARY KEY NOT NULL,
  o_custkey       INTEGER NOT NULL,
  o_orderstatus   VARCHAR(16) NOT NULL,
  o_totalprice    DECIMAL(10, 2) NOT NULL,
  o_orderdate     DATE NOT NULL,
  o_orderpriority VARCHAR(128) NOT NULL,
  o_clerk         VARCHAR(128) NOT NULL,
  o_shippriority  VARCHAR(128) NOT NULL,
  o_comment       TEXT NOT NULL,
  created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (o_custkey) REFERENCES customer(c_custkey)
);

CREATE TABLE IF NOT EXISTS lineitem (
  l_orderkey      INTEGER NOT NULL,
  l_partkey       INTEGER NOT NULL,
  l_suppkey       INTEGER NOT NULL,
  l_linenumber    INTEGER NOT NULL,
  l_quantity      INTEGER NOT NULL,
  l_extendedprice DECIMAL(10, 2) NOT NULL,
  l_discount      DECIMAL(5, 2) NOT NULL,
  l_tax           DECIMAL(5, 2) NOT NULL,
  l_returnflag    VARCHAR(128) NOT NULL,
  l_linestatus    VARCHAR(128) NOT NULL,
  l_shipdate      DATE NOT NULL,
  l_commitdate    DATE NOT NULL,
  l_receiptdate   DATE NOT NULL,
  l_shipinstruct  VARCHAR(255) NOT NULL,
  l_shipmode      VARCHAR(255) NOT NULL,
  l_comment       TEXT NOT NULL,
  created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (l_orderkey, l_linenumber),
  FOREIGN KEY (l_orderkey) REFERENCES `orders`(o_orderkey),
  FOREIGN KEY (l_partkey, l_suppkey) REFERENCES partsupp(ps_partkey, ps_suppkey)
);
