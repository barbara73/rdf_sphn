"""
Creator

This module is needed to iterate over all the entities.
"""
from pathlib import Path
from dataclasses import dataclass, field
import time
import os
from typing import Union
# from multiprocessing import Pool

from pyshacl import validate
from rdflib import Graph, OWL
from rdf_creator.triple import Triple
from rdf_creator.db_table import DBTable
from rdf_creator.lu_dictionary import LookUpDictionary
from rdf_creator.reader import get_config
from logdecoratorandhandler.log_decorator import LogDecorator
from _paths import PATH_ROOT, OUTPUT_PATH, INPUT_PATH


class FileNotWrittenError(Exception):
    pass


@dataclass
class Creator:
    """
    Class for creation of the ttl files.

    For creating a concept (class) one needs
    - a graph,
    - bind the namespace to it,
    - iterate over the table from database and
    - add values as triple (s, p, o) to the graph.
    """
    patient: str
    project: str
    input_files: tuple
    data: Union
    project_graph: Graph
    shacl_graph: Graph = field(default=None)
    sphn_graph: Graph = field(init=False)

    def __post_init__(self) -> None:
        """
        Initialise graph.
        """
        self.sphn_graph = self.create_graph()

    def create_graph(self) -> Graph:
        """
        Creates the graph for the ontology (input graph). Add as many ontologies as needed.
        """
        sphn_g = Graph()
        for file in self.input_files:
            sphn_g.parse(os.fspath(file), format='ttl')

        for key, val in self.data['namespaces'].items():
            sphn_g.bind(key, val)
        return sphn_g

    @LogDecorator('INFO - prepare rdf')
    def prepare_rdf(self, entity: str) -> None:
        """
        Creates RDF output file as ttl.-file of each concept = entity.
        """
        ## DB table is read in chunks (much faster, when DB is large)
        db_table = DBTable(entity, self.project)
        # chunks = db_table.read_dwh_table()        # was for concept-wise reading from db
        chunks = db_table.read_statement(self.patient)

        ## look up the range, concept name and rdf label in the mapping file
        lu_dict = LookUpDictionary(entity, self.project)
        look_up = lu_dict.look_up_dict()

        ## here starts the rdf generation
        triple = Triple(self.sphn_graph, self.data)

        ## for each concept a new graph is made and namespaces are bound
        ## if we want per patient, then the graph needs to be set global (per patient)
        entity_graph = Graph()
        # for key, val in self.data['namespaces'].items():
        #     entity_graph.bind(key, val)
        # entity_graph.bind("owl", OWL)

        ## iterate over each row of the DB of each concept and fill the graph
        for row in chunks.itertuples():
            entity_graph = triple.fill_graph(row, look_up, entity_graph)

        ## this is only needed for validation
        ## can also be used, if we want only one file
        self.project_graph += entity_graph
        for key, val in self.data['namespaces'].items():
            self.project_graph.bind(key, val)
        self.project_graph.bind("owl", OWL)

        ## then the write needs to be outside and writes the project graph
        # self.write_rdf(entity_graph, entity, 0)         # was for writing concept-wise
        print(f'{self.prepare_rdf.__name__} - {entity}: done')

    @LogDecorator('INFO - write turtle file')
    # def write_rdf(self, entity_graph: Graph, entity: str, idx: int) -> None:
    def write_rdf(self) -> None:
        """
        Write RDF from output graph into a turtle file.
        """
        try:
            ## make project folder, if it doesn't exist.
            directory = Path(OUTPUT_PATH/f'{self.project}/')
            if not os.path.exists(directory):
                os.makedirs(directory)

            ## here the output path is specified and the turtle files are written
            # file = Path(OUTPUT_PATH/f'{self.project}/{self.project}_{entity}_{idx}.ttl')  # concept-wise
            file = Path(OUTPUT_PATH/f'{self.project}/163_CHE-108.904.325_{self.patient}.ttl')
            # entity_graph.serialize(destination=os.fspath(file), format='turtle', type='utf8')
            self.project_graph.serialize(destination=os.fspath(file), format='turtle', type='utf8')
            # print(f'{self.write_rdf.__name__} - {entity}: done')
            print(f'{self.write_rdf.__name__} - {self.patient}: done')

        except (FileNotFoundError, FileExistsError, TypeError) as ex:
            # raise FileNotWrittenError(f'{self.write_rdf.__name__} - {entity}: not written!') from ex
            raise FileNotWrittenError(f'{self.write_rdf.__name__} - {self.patient}: not written!') from ex

    def validate_rdf(self):
        """
        Only run this, when the data is not too big.
        Gives a text file with wrong concepts in the output folder.
        """
        r = validate(self.project_graph,
                     shacl_graph=self.shacl_graph,
                     ont_graph=self.sphn_graph,
                     inference='rdfs',
                     abort_on_first=True,
                     allow_infos=False,
                     allow_warnings=False,
                     meta_shacl=False,
                     advanced=False,
                     js=False,
                     debug=False)
        conforms, results_graph, results_text = r

        with open(Path(OUTPUT_PATH/f'{self.project}/{self.patient}_validation.txt'), 'w') as f:
            print(results_text, file=f)


def run_creator(sphn_project: str) -> None:
    """
    Converts the data to RDF.

    - First, read in the mapping file of project (output of mapping) and ontology. Sphn ontology is the core.
    - Then, read in you configuration and run over your concepts.
    """
    mapping_ttl = Path(OUTPUT_PATH/f'mapping_{sphn_project}.ttl')
    sphn_ontology_ttl = Path(INPUT_PATH/'sphn_ontology.ttl')  # check your version!
    # ontology_ttl = Path(INPUT_PATH/f'{sphn_project}_ontology.ttl')

    ## Shacl graph for validation (not needed for turtle creation - uncomment if dataset gets too big)
    sg = Graph()
    sg.parse(Path(INPUT_PATH, 'shacl_2022-2.ttl'))
    project_graph = Graph()


    ## Input files are the mapping to usz label, the ontology of sphn and if exists, the one for the project
    input_files = (mapping_ttl,             # contains the mapping to db of project
                   sphn_ontology_ttl,       # sphn ontology
                   # ontology_ttl,            # project ontology
                   )

    ## The yaml file contains configuration, the list of concepts, the valuesets, namespaces and terminologies)
    data = get_config(Path(PATH_ROOT/'configuration.yaml'))

    ## entity == concept
    entities = data[sphn_project]['concepts']

    # creator = Creator(project=sphn_project,
    #                   input_files=input_files,
    #                   data=data,
    #                   project_graph=project_graph,
    #                   shacl_graph=sg,
    #                   )

    ## uncomment the following three lines, if no parallelisation!
    patient_list = ('6D4E31E4-AD56-45E7-BAE3-98F390656FCF',
                    'F70CEAC7-3404-4584-BEE2-7DD5CF18D897',
                    'C04920AD-B2C8-493C-B1B9-58198F7A30E0',
                    'B5BA28C9-328C-430F-B846-E257EEEA6749',
                    '2FB8ABD7-2010-4D34-A0D8-A1EAD5DE9C01',
                    '4193EB08-5A4E-47F5-95DD-516D3A348484')

    for patient in patient_list:
        creator = Creator(patient=patient,
                          project=sphn_project,
                          input_files=input_files,
                          data=data,
                          project_graph=project_graph,
                          shacl_graph=sg,
                          )
        for entity in entities:
            creator.prepare_rdf(entity)
        creator.write_rdf()
        creator.validate_rdf()

    ## uncomment for parallelisation
    # with Pool(processes=4) as pool:
    #     pool.map(creator.prepare_rdf, entities)
