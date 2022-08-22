"""
This model is needed when you want to work with SQLAlchemy.

- open session for postgres or mssql
- Base is needed for the wrapper of tables in mssql
"""
from sqlalchemy.orm import declarative_base
from db_connector.connection import MSSQLConnect

# This is needed if you want to work with SQLAlchemy
# --------------------------------------------------


Base = declarative_base()

db_mssql = MSSQLConnect()
db_mssql.open_session()
