"""
Connection to DB

Either open a session with SQLAlchemy or connect to DB.
"""
from pathlib import Path
import os
from dataclasses import dataclass
from dotenv import load_dotenv
from sqlalchemy import create_engine, MetaData
from sqlalchemy.orm import sessionmaker, session
from sqlalchemy.engine.url import URL
from sqlalchemy import engine
from _paths import PATH_ROOT

load_dotenv(Path(PATH_ROOT / '.env'))
metadata = MetaData()


class ConnectionFailed(Exception):
    pass


@dataclass
class MSSQLConnect:
    """
    Connection to MSSQL DB.

    - either use SQLAlchemy with open_session
    - or connect directly to DB with connect_db
    """
    engine: engine = None
    s: session = None

    @staticmethod
    def get_url():
        type_ = 'mssql'
        connector = 'pyodbc'
        driver: str = 'ODBC Driver 17 for SQL Server'
        trusted_connection: bool = True
        drivername = f'{type_}+{connector}'

        _query = dict({
            'driver': 'ODBC Driver 17 for SQL Server' if trusted_connection else driver,
            'Trusted_Connection': 'yes' if trusted_connection else 'no',
        })

        return URL.create(drivername=drivername,
                          host=os.getenv('MSSQL_SERVER'),
                          database=os.getenv('MSSQL_NAME'),
                          query=_query
                          )

    def open_session(self):
        """
        Opens a session for SQLAlchemy.
        """
        try:
            self.engine = create_engine(self.get_url())
        except (ConnectionError, Exception) as ex:
            raise ConnectionFailed('Connection failed!') from ex

        s = sessionmaker()
        s.configure(bind=self.engine)
        self.s = s()
