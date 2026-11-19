"""Load the small CI test data into a DuckDB file.

The real Olist data (100k+ orders) is too large to keep in Git, so CI runs
the dbt models against a handful of hand-made rows in ci/fixtures/.
Each CSV becomes a table in the `main` schema, the same place the real
data lives locally, so the dbt sources resolve exactly as they do on a laptop.
"""
from pathlib import Path

import duckdb

CI_DIR = Path(__file__).parent
DB_PATH = CI_DIR / "ci.duckdb"
TABLES = ["orders", "customers", "order_items", "products"]

con = duckdb.connect(str(DB_PATH))
for table in TABLES:
    csv_path = (CI_DIR / "fixtures" / f"{table}.csv").as_posix()
    con.execute(
        f"create or replace table main.{table} as "
        f"select * from read_csv('{csv_path}', header = true)"
    )
    rows = con.execute(f"select count(*) from main.{table}").fetchone()[0]
    print(f"loaded {table}: {rows} rows")
con.close()
