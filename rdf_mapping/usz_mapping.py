from rdflib.namespace import Namespace
from rdflib import RDFS, OWL, RDF, Graph, URIRef, Literal
from typing import Union
import os
from rdf_creator.reader import read_csvdict, get_config
from pathlib import Path
from dataclasses import dataclass, field
from logdecoratorandhandler.log_decorator import LogDecorator
from _paths import PATH_ROOT, INPUT_PATH, OUTPUT_PATH
from db_wrapper import get_mapping


@LogDecorator('INFO - get predicate')
def get_predicate(row) -> str:
    """
    Get class name, either the row value is an attribute or a link.
    """
    try:
        if row['rdf_attribute'][0] in ('h', 'C'):
            return {
                'h': f"{row['rdf_attribute']}",
                'C': f"{row['rdf_concept']}",
            }.get(row['rdf_attribute'][0])
        else:
            print(f'{get_predicate.__name__} - Missing rdf_attribute or '
                  f'wrong spelling in mapping file, i.e. there should only be Concept or has...!')
    except IndexError as e:
        message = f'{get_predicate.__name__} - {e}'
        e.msg = message
        raise e


@dataclass
class Mapping:
    """
    Class for the mapping of the column names of IDP (idp_labels) to the attributes defined by project (has...).
    """
    mapping_df: list
    mapping_graph: Graph = field(init=False)
    data: Union

    def __post_init__(self) -> None:
        """
        Initialise graph.
        """
        self.mapping_graph = Graph()

    def bind_to_graph(self) -> None:
        """
        Bind each of the namespaces to the graph and make a mapping.
        """
        self.mapping_graph.bind("owl", OWL)

        for key, val in self.data['namespaces'].items():
            self.mapping_graph.bind(key, Namespace(val))

    def create_mapping_to(self) -> None:
        """
        Mapping to the data base with Atelier names (idp label predicates) to attributes
        """
        mapping_dict = {
            RDF.type: OWL.AnnotationProperty,
            RDFS.label: Literal('usz_mapping_to'),
        }
        for key, val in mapping_dict.items():
            self.mapping_graph.add((
                URIRef(Namespace(self.data['namespaces']['sphn']) + 'usz_mapping_to'),
                key,
                val
            ))

    def attributes(self, row, classname: str) -> None:
        """
        Add concepts to the mapping.ttl from the mapping file.
        """
        name_space = Namespace(self.data['namespaces'][row['prefix_range']])

        rdf_dict = {
            URIRef(Namespace(self.data['namespaces']['sphn']) + 'usz_mapping_to'): Literal(row['usz_label']),
            RDFS.label: Literal(classname),

        }
        for key, val in rdf_dict.items():
            self.mapping_graph.add((
                URIRef(name_space + classname),
                key,
                val
            ))

    @LogDecorator('INFO - start mapping')
    def mapping(self) -> None:
        """
        Mapp the link, concepts and attributes as defined.
        """
        for row in self.mapping_df:
            try:
                self.attributes(row, get_predicate(row))

            except (IndexError, TypeError) as e:
                message = f'{self.mapping.__name__} - {e}'
                e.msg = message
                raise e

    def map_ttl(self, mapping_ttl: Path) -> None:
        """
        Print the mapping turtle file of RDF ontology (sphn ontogogy) based on mapping csv file (internal db mapping).
        """
        self.bind_to_graph()
        self.create_mapping_to()
        self.mapping()

        self.mapping_graph.serialize(destination=os.fspath(mapping_ttl), format='turtle', type='utf8')
        print(f'{self.map_ttl.__name__} - Mapping: done')


def run_mapping(sphn_project: str) -> None:
    """
    Mapping of the mapping csv file to get turtle file ontology.

    Import mapping csv of project and corresponding ontology!
    """
    # mapping_file = Path(INPUT_PATH/f'mapping_{sphn_project}.csv')
    mapping_ttl = Path(OUTPUT_PATH/f'mapping_{sphn_project}.ttl')
    # mapping_df = read_csvdict(mapping_file)
    mapping_df = get_mapping(sphn_project)
    Mapping(mapping_df, data=get_config(Path(PATH_ROOT/'configuration.yaml'))).map_ttl(mapping_ttl)


if __name__ == '__main__':
    run_mapping('sphn')
