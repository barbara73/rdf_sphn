"""
Reader

for reading configuration file and csv.
"""
import csv
import yaml
from logdecoratorandhandler.log_decorator import LogDecorator


class ConfigFileError(Exception):
    pass


@LogDecorator('INFO - get configuration')
def get_config(config_file: yaml) -> dict:
    """
    Get data from test_config.yaml.
    """
    try:
        with open(config_file, 'r') as yamlfile:
            return yaml.load(yamlfile, Loader=yaml.FullLoader)

    except (FileNotFoundError, FileExistsError, AttributeError) as ex:
        raise ConfigFileError(f'{get_config.__name__} - Check configuration.yaml!') from ex


@LogDecorator('INFO - read csv dictionary')
def read_csvdict(fp, fieldnames=None) -> list:
    """
    Read csv file into list.
    """
    try:
        with fp.open('r', encoding='utf8') as csvfile:
            reader = csv.DictReader(csvfile, fieldnames=fieldnames)

            data = [ii for ii in reader]
        return data

    except (FileNotFoundError, FileExistsError, AttributeError) as ex:
        raise Exception(f'{read_csvdict.__name__} - csv error!') from ex
