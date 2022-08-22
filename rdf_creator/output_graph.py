"""
OutputGraph

Here, the data is added as triple into graph.
"""
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Union
from rdflib import Literal, URIRef, Namespace, Graph, RDF, RDFS
from rdf_creator.literal_factory import DatetimeLiteral, FloatLiteral, StringLiteral
from rdf_creator.uri_factory import TerminologyURI, ResourceURI, TerminologyRange
from rdf_creator.uri_factory import InstanceRange, InstanceObjectURI, InstanceValueURI, ValueSetURI
from rdf_creator.utils import replace_char


@dataclass
class OutputGraph(ABC):
    """
    Class for filling the graph with the data triples from the data base.
    """
    rdf_concept: str
    datatype: str
    sphn_g: Graph
    data: Union

    def rdf_range(self) -> Graph:
        """
        Prepare subject of each row. It tells you which concept (class) it is.
        """
        return self.sphn_g.value(predicate=RDFS.label,
                                 object=Literal(self.rdf_concept)
                                 )

    def attribute_name(self, pred: str) -> Graph:
        """
        Prepare predicate of each row. It is mapped to the mapping file
        (database names) - attributes of concepts.
        """
        sphn_ns = Namespace(self.data['namespaces']['sphn'])
        return self.sphn_g.value(predicate=sphn_ns.usz_mapping_to,
                                 object=Literal(pred)
                                 )

    @abstractmethod
    def rdf_object(self, obj):
        """
        Prepare object. It is either a Literal (plain value) or an url.
        Second part of the ttl.-file. It is the value of an attribute.
        """
        pass


class ResourceType(OutputGraph):
    def rdf_object(self, obj) -> Literal:
        return URIRef(ResourceURI().uri(self.data, self.datatype, replace_char(obj)))


class DateTimeType(OutputGraph):
    def rdf_object(self, obj) -> Literal:
        return Literal(DatetimeLiteral().get_literal(obj))


class StringType(OutputGraph):
    def rdf_object(self, obj: str) -> Literal:
        return Literal(StringLiteral().get_literal(obj))


class FloatType(OutputGraph):
    def rdf_object(self, obj: str) -> Literal:
        return Literal(FloatLiteral().get_literal(obj))


class TerminologyType(OutputGraph):
    def rdf_object(self, obj: str) -> Literal:
        return URIRef(TerminologyURI().uri(self.data, self.datatype, obj))


class ValueSetType(OutputGraph):
    def rdf_object(self, obj: str) -> Literal:
        return URIRef(ValueSetURI().uri(self.data, self.datatype, obj))


class InstanceType(OutputGraph):
    def rdf_object(self, obj: str) -> Literal:
        return URIRef(InstanceObjectURI().uri(self.data, self.datatype, obj))

    def instance(self, datatype: str) -> Graph:
        """
        Instance for value sets and unit.
        """
        return self.sphn_g.value(predicate=RDFS.label,
                                 object=Literal(self.data['instances'].get(datatype)[1])
                                 )


@dataclass
class ResourceFactory:
    subj: str
    obj: str
    rdf_concept: str
    sphn_g: Graph
    data: Union

    def get_resources(self, datatype, entity_graph):
        """
        The turtle output is different for different types.
        """
        if datatype == 'string':
            output = StringType(self.rdf_concept, datatype, self.sphn_g, self.data)
            return output

        if datatype.lower() == 'datetime':
            output = DateTimeType(self.rdf_concept, datatype.lower(), self.sphn_g, self.data)
            return output

        if datatype == 'float':
            output = FloatType(self.rdf_concept, datatype, self.sphn_g, self.data)
            return output

        if datatype in self.data['terminologies'].keys():
            ## terminology instances with one line
            obj = self.obj.replace(' ', '')  # error if object has trailing spaces
            output = TerminologyType(self.rdf_concept, datatype, self.sphn_g, self.data)
            ConceptTriple.add_triple(output_graph=entity_graph,
                                     resource_uri=output.rdf_object(obj),
                                     rdf_range=TerminologyRange().rdf_range(self.data, datatype, obj)
                                     )
            return output

        if datatype in self.data['instances'].keys():
            ## the instance ot unit and other value sets have two lines
            output = InstanceType(self.rdf_concept, datatype, self.sphn_g, self.data)

            ConceptTriple.add_triple(output_graph=entity_graph,
                                     resource_uri=output.rdf_object(self.obj),
                                     rdf_range=InstanceRange().rdf_range(self.data, datatype, self.obj)
                                     )

            AttributeTriple.add_triple(output_graph=entity_graph,
                                       resource_uri=output.rdf_object(self.obj),
                                       attribute=output.instance(datatype),
                                       rdf_object=URIRef(InstanceValueURI().uri(self.data, datatype, self.obj))
                                       )
            return output

        if datatype in self.data['valuesets'].keys():
            output = ValueSetType(self.rdf_concept, datatype, self.sphn_g, self.data)
            return output

        output = ResourceType(self.rdf_concept, datatype, self.sphn_g, self.data)
        return output


class ConceptTriple:
    """
    Class for the concepts.
    """
    @staticmethod
    def add_triple(output_graph, resource_uri, rdf_range) -> None:
        """
        First line of turtle file output:
        resource:CHE-229.707.417-HealthcareEncounter-006c6887 a sphn: HealthcareEncounter
        """
        output_graph.add((
            URIRef(resource_uri),       # resource:CHE-229.707.417-HealthcareEncounter-006c6887
            RDF.type,                   # a
            URIRef(rdf_range)           # sphn:HealthcareEncounter
        ))


class AttributeTriple:
    """
    Class for the attributes.
    """
    @staticmethod
    def add_triple(output_graph: Graph, resource_uri, attribute, rdf_object) -> None:
        """
        Second line of turtle file output:
        sphn:hasIdentifier "006c6887"^^xsd:string ;
        """
        output_graph.add((
            URIRef(resource_uri),       # resource:CHE-229.707.417-HealthcareEncounter-006c6887
            URIRef(attribute),          # sphn:hasIdentifier
            rdf_object                  # "006c6887"^^xsd:string ;
        ))
