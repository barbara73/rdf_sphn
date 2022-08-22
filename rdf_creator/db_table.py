"""
DB Table

For reading in the data from DB.
"""
from dataclasses import dataclass
import pandas as pd
from logdecoratorandhandler.log_decorator import LogDecorator
from db_connector.base import db_mssql


class TableNotFoundError(Exception):
    pass


class StatementNotFoundError(Exception):
    pass


@dataclass
class DBTable:
    """
    Class for extracting the data from the source table.
    """
    entity: str
    project: str

    @LogDecorator('INFO - read DB table')
    def read_dwh_table(self) -> iter:
        """
        Get the df of a table in atelier. Order by is only needed, when we take chunks.
        Chunks are needed, if data set is very big.
        """
        try:
            query = f"""SELECT subj,pred,obj FROM dbo.{self.project}_{self.entity}"""
            tuple_list = db_mssql.s.execute(query).fetchall()

            return pd.DataFrame(tuple_list, columns=['subj', 'pred', 'obj'])

        except Exception as ex:
            raise TableNotFoundError(f'{self.read_dwh_table.__name__} - '
                                     f'There is no dbo.{self.project}_{self.entity}.') from ex

    @LogDecorator('INFO - read statement')
    def read_statement(self, patient: str) -> iter:
        """
        Get the df of a table in atelier. Order by is only needed, when we take chunks.
        Chunks are needed, if data set is very big.
        """
        try:
            with open(f'../statements/{self.project}_{self.entity.lower()}.sql', 'r') as file:
                query = file.read().format(patient)
            tuple_list = db_mssql.s.execute(query).fetchall()

            return pd.DataFrame(tuple_list, columns=['subj', 'pred', 'obj'])

        except Exception as ex:
            raise StatementNotFoundError(f'{self.read_statement.__name__} - '
                                     f'There is no {self.project}_{self.entity}.sql') from ex
