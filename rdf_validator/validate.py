import os
from pathlib import Path

from pyshacl import validate
from rdflib import Graph
from _paths import INPUT_PATH, OUTPUT_PATH

sg = Graph()
sg.parse(Path(INPUT_PATH, 'shacl_2022-2.ttl'))

og = Graph()
og.parse(Path(INPUT_PATH, 'sphn_ontology.ttl'))

data_graph = Graph()
for file in os.listdir(OUTPUT_PATH/'sphn'):
    data_graph.parse(Path(OUTPUT_PATH, f'sphn/{file}'))
data_graph.parse(Path(INPUT_PATH, 'terminologies_2022-1.zip'))

r = validate(data_graph,
             shacl_graph=sg,
             ont_graph=og,
             inference='rdfs',
             abort_on_first=False,
             allow_infos=False,
             allow_warnings=False,
             meta_shacl=False,
             advanced=False,
             js=False,
             debug=False)


if __name__ == '__main__':
    conforms, results_graph, results_text = r

    with open(Path(OUTPUT_PATH / 'all_concepts.txt'), 'w') as f:
        print(results_text, file=f)
