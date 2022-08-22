"""
DB Wrapper

This is a wrapper for tables to be written into DB.

Update tablename and/or add __schema__ if needed.
"""
from sqlalchemy import Column, Integer, String
from db_connector.base import Base, db_mssql


class SPHNMapping(Base):
    __tablename__ = 'mapping_sphn'

    id = Column(Integer, primary_key=True, nullable=False, unique=True)
    prefix_range = Column(String)
    rdf_attribute = Column(String)
    rdf_concept = Column(String)
    datatype = Column(String)
    usz_label = Column(String)


def get_mapping(project):
    if project == 'sphn':
        out = db_mssql.s.query(SPHNMapping)

    else:
        out = None

    return [to_dict(item) for item in out]


def to_dict(row):
    if row is None:
        return None

    rtn_dict = dict()
    keys = row.__table__.columns.keys()
    for key in keys:
        rtn_dict[key] = getattr(row, key)
    return rtn_dict
