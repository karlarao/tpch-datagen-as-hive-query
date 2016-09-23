DROP DATABASE IF EXISTS ${hiveconf:ORCDBNAME} CASCADE;
CREATE DATABASE IF NOT EXISTS ${hiveconf:ORCDBNAME};

USE ${hiveconf:ORCDBNAME};

DROP TABLE IF EXISTS lineitem;

CREATE TABLE IF NOT EXISTS lineitem 
(L_ORDERKEY BIGINT,
L_PARTKEY INT,
L_SUPPKEY INT,
L_LINENUMBER INT,
L_QUANTITY DOUBLE,
L_EXTENDEDPRICE DOUBLE,
L_DISCOUNT DOUBLE,
L_TAX DOUBLE,
L_RETURNFLAG STRING,
L_LINESTATUS STRING,
L_COMMITDATE STRING,
L_RECEIPTDATE STRING,
L_SHIPINSTRUCT STRING,
L_SHIPMODE STRING,
L_COMMENT STRING)
PARTITIONED BY (L_SHIPDATE STRING)
STORED AS ORC
TBLPROPERTIES('orc.bloom.filter.columns'='*','orc.compress'='ZLIB');

INSERT OVERWRITE TABLE lineitem PARTITION(L_SHIPDATE)
SELECT 
L_ORDERKEY ,
L_PARTKEY ,
L_SUPPKEY ,
L_LINENUMBER ,
L_QUANTITY ,
L_EXTENDEDPRICE ,
L_DISCOUNT ,
L_TAX ,
L_RETURNFLAG ,
L_LINESTATUS ,
L_COMMITDATE ,
L_RECEIPTDATE ,
L_SHIPINSTRUCT ,
L_SHIPMODE ,
L_COMMENT ,
L_SHIPDATE
FROM ${hiveconf:SOURCE}.lineitem
;

DROP TABLE IF EXISTS orders;

CREATE TABLE IF NOT EXISTS orders 
(O_ORDERKEY INT,
O_CUSTKEY BIGINT,
O_ORDERSTATUS STRING,
O_TOTALPRICE DOUBLE,
O_ORDERPRIORITY STRING,
O_CLERK STRING,
O_SHIPPRIORITY INT,
O_COMMENT STRING)
PARTITIONED BY (O_ORDERDATE STRING)
STORED AS ORC
TBLPROPERTIES('orc.bloom.filter.columns'='*','orc.compress'='ZLIB');

INSERT OVERWRITE TABLE orders PARTITION(O_ORDERDATE)
SELECT 
O_ORDERKEY ,
O_CUSTKEY ,
O_ORDERSTATUS ,
O_TOTALPRICE ,
O_ORDERPRIORITY ,
O_CLERK ,
O_SHIPPRIORITY ,
O_COMMENT,
O_ORDERDATE
FROM ${hiveconf:SOURCE}.orders
;

DROP TABLE IF EXISTS customer;

CREATE TABLE IF NOT EXISTS customer
STORED AS ORC
TBLPROPERTIES('orc.bloom.filter.columns'='*','orc.compress'='ZLIB')
AS SELECT * FROM ${hiveconf:SOURCE}.customer
CLUSTER BY C_MKTSEGMENT
;

DROP TABLE IF EXISTS supplier;
CREATE TABLE IF NOT EXISTS supplier
STORED AS ORC
TBLPROPERTIES('orc.bloom.filter.columns'='*','orc.compress'='ZLIB')
AS SELECT * FROM ${hiveconf:SOURCE}.supplier
CLUSTER BY s_nationkey, s_suppkey
;

DROP TABLE IF EXISTS part;
CREATE TABLE IF NOT EXISTS part
STORED AS ORC
TBLPROPERTIES('orc.bloom.filter.columns'='*','orc.compress'='ZLIB')
AS SELECT * FROM ${hiveconf:SOURCE}.part
CLUSTER BY p_brand
;

DROP TABLE IF EXISTS partsupp;
CREATE TABLE IF NOT EXISTS partsupp
STORED AS ORC
TBLPROPERTIES('orc.bloom.filter.columns'='*','orc.compress'='ZLIB')
AS SELECT * FROM ${hiveconf:SOURCE}.partsupp
CLUSTER BY PS_SUPPKEY
;

DROP TABLE IF EXISTS region;
CREATE TABLE IF NOT EXISTS region
STORED AS ORC
TBLPROPERTIES('orc.bloom.filter.columns'='*','orc.compress'='ZLIB')
AS SELECT * FROM ${hiveconf:SOURCE}.region;

DROP TABLE IF EXISTS nation;
CREATE TABLE IF NOT EXISTS nation
STORED AS ORC
AS SELECT * FROM ${hiveconf:SOURCE}.nation;
