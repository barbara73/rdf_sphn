"""
Literal Factory

Get the literal type (RDF range or data type of literal).
"""
from abc import ABCMeta, abstractmethod
from datetime import datetime
from rdflib import XSD, Literal, term
from rdf_creator.utils import validate_date, validate_datetime, validate_time, validate_year


class LiteralFactoryInterface(metaclass=ABCMeta):
    """
    Abstract class for choosing the correct literal data type.
    """
    @staticmethod
    @abstractmethod
    def get_literal(obj):
        pass


class DatetimeLiteral(LiteralFactoryInterface):
    """
    Class for date time.
    """
    @staticmethod
    def get_literal(obj) -> Literal:
        """
        For different range of dateTime.
        """
        if validate_datetime(obj):
            return Literal(obj + 'Z', datatype=XSD.dateTime)
        if validate_date(obj):
            return Literal(obj + 'Z', datatype=XSD.date)
        if validate_time(obj):
            return Literal(obj + 'Z', datatype=XSD.time)
        if validate_year(obj):
            return Literal(obj + 'Z', datatype=XSD.gYear)
        if len(str(obj)) < 2:
            return Literal(f'---0{obj}Z', datatype=XSD.gDay)
        if len(str(obj)) == 2:
            return Literal(f'---{obj}Z', datatype=XSD.gDay)

        ## expected month name, otherwise there is no way to find out if
        ## is a month or a day
        datetime_object = datetime.strptime(obj, '%B')
        month_number = datetime_object.month
        return Literal(f'--{month_number:02}Z', datatype=XSD.gMonth)


class StringLiteral(LiteralFactoryInterface):
    """
    Class for string.
    """
    @staticmethod
    def get_literal(obj) -> Literal:
        """
        If it is no datetime, float or other concept,
        then the literal must be a string.
        """
        return Literal(str(obj), datatype=XSD.string)


class FloatLiteral(LiteralFactoryInterface):
    """
    Class for float.
    """
    @staticmethod
    def get_literal(obj) -> Literal:
        """
        If the data is not a float or cannot be converted to float,
        then it must be a string.
        """
        try:
            return Literal(float(obj), datatype=XSD.double)
        except (ValueError, TypeError):
            return Literal(str(obj), datatype=XSD.string)
