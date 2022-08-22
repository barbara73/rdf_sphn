"""
URI Factory

for creating correct urls.
"""
from abc import ABCMeta, abstractmethod
from rdflib import Namespace
from rdf_creator.utils import replace_char


class URIInterface(metaclass=ABCMeta):
    """
    Abstract class for creating the URI (triple output).
    """
    @staticmethod
    @abstractmethod
    def uri(data, datatype, obj):
        pass


class RangeInterface(metaclass=ABCMeta):
    """
    Abstract class for choosing the type of the range (instantiation).
    """
    @staticmethod
    @abstractmethod
    def rdf_range(data, datatype, obj):
        pass


class ResourceURI(URIInterface):
    """
    Class for creating the resource URI.
    """
    @staticmethod
    def uri(data: dict, datatype: str, obj: str) -> str:
        """
        In subject and object of nested concept:

        resource:CHE-108_904_325-AdministrativeCase-ff17893b
        """
        return f'{Namespace(data["namespaces"]["resource"])}CHE-108_904_325-{datatype}-{obj}'


class TerminologyURI(URIInterface):
    """
    Class for creating the external terminology URI.
    These are provided by DCC and do not have to be in a table in your
    data base (but needs to be listed in your configuration.yaml under terminologies).
    """
    @staticmethod
    def uri(data, datatype, obj):
        """
        In object and subject of instance:

        resource:Code-SNOMED-CT-29092000
        """
        ns = data["namespaces"]["resource"]                             # resource:
        concept_str = data["terminologies"].get(datatype)[1]            # Code-SNOMED-CT

        return f'{Namespace(ns)}{concept_str}{obj.replace(" ", "")}'    # resource:Code-SNOMED-CT-29092000


class InstanceObjectURI(URIInterface):
    """
    Class for the object instantiating value sets or UCUM. These do not have to
    be in a table in your data base, but included in the configuration.yaml (under instances).
    """
    @staticmethod
    def uri(data: dict, datatype: str, obj: str) -> str:
        """
        Instances of UCUM and other shared concepts with value set entries:

        ucum:Unit-UCUM-cm
        """
        ns = data["namespaces"]["resource"]                                         # resource:
        concept_str = data["instances"].get(datatype)[3]                            # Unit-UCUM-

        if data['namespaces'].get('ucum') == data["namespaces"].get(data["instances"].get(datatype)[2]):
            return f'{Namespace(ns)}{concept_str}{obj}'               # resource:Unit-UCUM-cm

        return f'{Namespace(ns)}{concept_str}{obj.replace(" ", "")}'                # resource:Location-Hospital


class InstanceValueURI(URIInterface):
    """
    Class for the value instantiating value sets or UCUM.
    """
    @staticmethod
    def uri(data: dict, datatype: str, obj: str) -> str:
        """
        Instances of UCUM and other shared concepts with value set entries:

        ucum:Unit-UCUM-cm
        """
        ns = data["namespaces"].get(data["instances"].get(datatype)[2])     # ucum:

        if data['namespaces'].get('ucum') == ns:
            return f'{Namespace(ns)}{obj}'                    # ucum:cm

        return f'{Namespace(ns)}{obj.replace(" ", "")}'                 # sphn:Hospital


class ValueSetURI(URIInterface):
    """
    Class for value sets. Please include the value sets in the configuration.yaml with the prefix of the project who
    provided these value sets.
    """
    @staticmethod
    def uri(data, datatype, obj):
        """
        Value set uri:

        sphn:Negative ;
        """
        ns = data["namespaces"].get(data["valuesets"].get(datatype))
        return f'{Namespace(ns)}{obj}'                             # psss:negative


class InstanceRange(RangeInterface):
    """
    Class for the instance data type.
    """
    @staticmethod
    def rdf_range(data: dict, datatype: str, obj: str) -> str:
        """
        Type of instance:

        a sphn:Unit
        """
        ns = data["namespaces"].get(data["instances"].get(datatype)[0])
        return f'{Namespace(ns)}{data["instances"].get(datatype)[4]}'               # a sphn:Unit


class TerminologyRange(RangeInterface):
    """
    Class for the external terminologies.
    """
    @staticmethod
    def rdf_range(data: dict, datatype: str, obj: str) -> str:
        """
        Type of terminology:

        a snomed:261665006
        """
        ns = data["namespaces"].get(data["terminologies"].get(datatype)[0])
        return f'{Namespace(ns)}{obj}'                                              # a snomed:261665006


class TerminologyInstanceRange(RangeInterface):
    """
    Class for the external terminologies.
    """
    @staticmethod
    def rdf_range(data: dict, datatype: str, obj: str) -> str:
        """
        Type of terminology:

        a snomed:261665006
        """
        ns = data["namespaces"].get(data["terminology_instances"].get(datatype))
        return f'{Namespace(ns)}{obj}'                                              # a snomed:261665006