"""
Utilities

- validation of date and date times
- conversion to dictionary
- delete characters
"""
import re


def validate_datetime(datetime_str: str) -> bool:
    """
    Validate date time.
    """
    regex = r'^(-?(?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):([0-5][' \
            r'0-9]):([0-5][0-9])(\.[0-9]+)?(Z|[+-](?:2[0-3]|[01][0-9]):[0-5][0-9])?$'
    match_datetime = re.compile(regex).match

    if match_datetime(datetime_str) is not None:
        return True
    return False


def validate_year(datetime_str: str) -> bool:
    """
    Validate date time.
    """
    regex = r'^(-?(?:[1-9][0-9]*)?[0-9]{4})'
    match_datetime = re.compile(regex).match

    if match_datetime(datetime_str) is not None:
        return True
    return False


def validate_time(datetime_str: str) -> bool:
    """
    Validate date time.
    """
    regex = r'^(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(\.[0-9]+)?(Z|[+-](?:2[0-3]|[01][0-9]):[0-5][0-9])?$'
    match_datetime = re.compile(regex).match

    if match_datetime(datetime_str) is not None:
        return True
    return False


def validate_date(date_string: str) -> bool:
    """
    Validate date.
    """
    regex = r'^(-?(?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])?$'
    match_date = re.compile(regex).match

    if match_date(date_string) is not None:
        return True
    return False


def replace_char(obj: str) -> str:
    """
    Replace of special characters for units.
    """
    return obj.replace(" ", "_").replace("(", "").replace("'", "").replace(
        "/", "_").replace(")", "").replace("%", "percent").replace("`", "").replace(
        "'", "apo").replace("µ", "u").replace("*", "exp").replace("^", "exp")


def to_dict(row) -> dict:
    """
    Convert row entries to dictionary.
    """
    return {key: getattr(row, key) for key in row.__table__.columns.keys()}
