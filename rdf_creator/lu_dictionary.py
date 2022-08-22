"""
LookUpDictionary

from mapping file.
"""
from dataclasses import dataclass
from pathlib import Path
import pandas as pd
from logdecoratorandhandler.log_decorator import LogDecorator
from db_wrapper import get_mapping


class MappingFileError(Exception):
    pass


@dataclass
class LookUpDictionary:
    """
    Class for the look up dictionary.
    """
    entity: str
    project: str

    @LogDecorator('INFO - get look up dictioary')
    def look_up_dict(self) -> dict:
        """
        Dictionary of mapping file to get datatype.
        Needed for exceptions for codes, literals and uri in object.
        """
        ## the mapping file is in the DB (could be saved as csv)
        mapping_dict_list = get_mapping(self.project)

        try:
            df = pd.DataFrame(mapping_dict_list).drop('id', axis=1)
            df = df.rename(columns={'usz_label': 'pred'})
            df = df.where(df.rdf_concept == self.entity)

            df.loc[df['datatype'] == 'dateTime', ['datatype']] = 'datetime'
            df['concept_type'] = df['datatype']

            df.concept_type = df.concept_type.str.islower() * 1
            df.dropna(inplace=True)
            df.set_index('pred', inplace=True)

            dict_lu = df.to_dict('index')
            return dict_lu

        except KeyError as ex:
            raise MappingFileError(f'{self.look_up_dict.__name__} - '
                                   f'Error in mapping file!') from ex
