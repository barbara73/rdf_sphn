"""
Triple

s, p, o are the triples for a ttl.-file, which are filled into graph.
"""
from dataclasses import dataclass, field
from typing import Union
from rdflib import Namespace, Graph
from logdecoratorandhandler.log_decorator import LogDecorator
from rdf_creator.output_graph import ConceptTriple, AttributeTriple, ResourceFactory
from rdf_creator.uri_factory import ResourceURI
from rdf_creator.utils import replace_char


@dataclass
class Triple:
    """
    Class for the triple (the output is called triple as well)

    Here, the output is created.
    """
    sphn_g: Graph
    data: Union
    sphn_ns: Namespace = field(init=False)

    def __post_init__(self) -> None:
        """
        Initialise namespaces.
        """
        self.sphn_ns = Namespace(self.data['namespaces']['sphn'])

    @LogDecorator('INFO - get datatype')
    def get_datatype(self, obj: str) -> tuple:
        """
        Check if datatype is a terminology or an internal code.
        In the DB, we explicitly write atc: or other range in front of the code to get the correct one.
        """
        if obj.find(':') != -1:
            new_obj = obj.rpartition(':')[0]
            if new_obj in self.data['terminologies'].get(new_obj.upper())[0]:
                datatype = new_obj.upper()
                obj = obj.rpartition(':')[2]
                return datatype, obj
            return None, None
        return 'Code', obj

    @LogDecorator('INFO - fill graph with data')
    def fill_graph(self, row, look_up, entity_graph) -> Graph:
        """
        Fill the graph with data from database one row after the other.

        If anything changes in the output, the output triples need to be changed.
        """
        # Spaces and special characters are not allowed in uri, so replace_char
        pred = row.pred
        subj = replace_char(row.subj)
        obj = row.obj

        datatype = look_up[pred]['datatype']
        rdf_concept = look_up[pred]['rdf_concept']

        # UnionOf allows two different ranges, that's why I have to check if the content of object.
        if datatype == 'UnionOf':
            datatype, obj = self.get_datatype(obj)

        resource_uri = ResourceURI().uri(self.data, rdf_concept, subj)

        output = ResourceFactory(subj=subj,
                                 obj=obj,
                                 rdf_concept=rdf_concept,
                                 sphn_g=self.sphn_g,
                                 data=self.data).get_resources(datatype=datatype,
                                                               entity_graph=entity_graph)

        ConceptTriple().add_triple(output_graph=entity_graph,
                                   resource_uri=resource_uri,
                                   rdf_range=output.rdf_range())

        AttributeTriple().add_triple(output_graph=entity_graph,
                                     resource_uri=resource_uri,
                                     attribute=output.attribute_name(pred),
                                     rdf_object=output.rdf_object(obj))

        return entity_graph
