# SPHN RDF HospFAIR

More information can be found on Wiki (https://wiki.usz.ch/display/MDM/SPHN_USZ_HospFAIR).

> IMPORTANT:
>
> Please do not change the code!
>
> Replace new ontology version with `sphn_ontology.ttl`, adapt the mapping file accordingly (add concepts with correct datatype). 
>
> Add also new concepts, value sets, name spaces, terminologies and instances in `configuration.yaml`.
>
> If structure changes (e.g. nesting of BodySite drops), change this in mapping file (e.g. instead of datatype=BodySite, datatype=SNOMED). There is no need of changing the code!
>
> If there should be a big change in the structure, then only the `uri_factory.py` needs to be changed. 

This code works for all SPHN projects and converts data from DB into RDF format. This `README` covers only the explanation of the code.



#### Requirements

- **Data** prepared as subject, predicate, object (s, p, o) for each concept (called entity in code) - see the [source table](#source-table) section:
  - either with a local DB, such as `SQLite3`, or
  - with a data mart in the DWH and connection to the DB - see [connection](#connection) section.
- **Mapping file** `mapping_[project]` in DB  - see [mapping](#mapping) section.
- **Ontology** `input/[project]_ontology.ttl`, defined for your project - see for more explanation the [sphn-documentation][https://github.com/IDSC-io/sphn-documentation].
- **[Configuration](#configuration)** `configuration.yaml` with defined namespaces and concepts you want to run - see the [configuration](#configuration) section.



#### Output

- **Mapping file** `output/ontology_[project].ttl`, which maps the column names of DB to the names (predicate) in the ontology.
- **Turtle file** for each concept `output/transfer/CHE_229_707_417_[project_name]_[concept].ttl` file which can be shipped to SPHN - check the [resources](#resources) section.
- **Log file** `logging.log` (comes from the `logdecoratorandhandler` package)

  


## Source Table
The source table is created in SQL. In the data mart for HospFAIR, you can find nearly all the concepts, which are defined so far. Look in the stored procedures how they are created.

A table contains these columns:

| subj = identifier | pred = column header name | obj = values |
| ----------------- | ------------------------- | ------------ |
| 1                 | case ID                   | 123          |
| 1                 | PID                       | 1234         |

> IMPORTANT: `subj` is unique!! The triple is explicitely called subj, pred and obj. Don't giv

For those who have no access to this `Atelier_PSSS`, I make two examples:

Your flat table looks like this:

| subj | pid  | death_date | death_status |
| ---- | ---- | ---------- | ------------ |
| 1    | abc  | 2021-01-01 | Death        |
| 2    | def  | NULL       | Unknown      |

The pivoted table should look like following:

| subj | pred         | obj        |
| ---- | ------------ | ---------- |
| 1    | pid          | abc        |
| 1    | death_date   | 2021-01-01 |
| 1    | death_status | Death      |
| 2    | pid          | def        |
| 2    | death_date   | NULL       |
| 2    | death_status | Unknown    |

> The `pred` values are the column names of the flat table and `obj` contains the corresponding values!


## Mapping
In the mapping part, the name of the `pred` in the source table will be mapped to the `idp_name` (column name of flat table) in the `mapping_[project]` in the HospFAIR data mart.

The `usz_mapping_to` property is added to the `ontology_[project].ttl`, which is needed for creating the RDF.



#### Mapping file

| prefix     | rdf_attribute              | rdf_concept         | idp_label                  | datatype  |
|------------| -------------------------- | ------------------- | -------------------------- | --------- |
|  [project] | [Concept, has[attribute]]  | concept (CamelCase) | matching name in source db | data type |

> All the columns are required to create RDF files. Also important: all the `[project]` names should be the same, e.g. `mapping_psss`, if the project is `psss`.



A more thorough explanation:

| prefix | rdf_attribute              | rdf_concept | datatype                | idp_label    |
| ------ | -------------------------- | ----------- | ----------------------- | ------------ |
| sphn   | Concept                    | DeathStatus | self                    |              |
| sphn   | hasDeathStatus             | DeathStatus | Death_status            | death_status |
| sphn   | hasDeathStatusDateTime     | DeathStatus | dateTime                | death_date   |
| sphn   | hasSubjectPseudoIdentifier | DeathStatus | SubjectPseudoIdentifier | patient      |
| sphn   | hasDataProviderInstitute   | DeathStatus | DataProviderInstitute   | institute    |

> The `prefix` tells you, who defined the ontology (either sphn or some project)
>
> The `rdf_attribute` is the name of the attribute inside the concept (`rdf_concept`) defined in the corresponding ontology.
>
> The `datatype` is either a string, a dateTime, a double, an external terminology (i.e. SNOMED), a value set or another concept.
>
> The `idp_label` is the column name of the DB (which is also the name of the `pred`).

So, this mapping file is needed to map our DB names to the defined RDF Ontology names.



#### Mapping file - ttl

The script `ontology_mapping.py`:
1. reads the `mapping_[project]`.
2. creates a `usz_mapping_to` with the `idp_name` as value and
3. stores ontology as `ontology_[project].ttl`.




## Resources
#### Resources file -ttl

The `creator.py` needs as input
- the `ontology_[project].ttl` mapping file and
- the ontology defined by project `input/[project]_ontology.ttl`.

and gives the output `CHE_229_707_417_[project]_[entity].ttl` for each concept (entity).

These files are then transferred to a `BiomedIT Node`. If you want to know, how the data is processed, you need to look at the description in the code itself or see [Run code](#run-code).



## Configuration

In the `configuration.yaml` configure your project and add which concepts you want to create.
You also need to add the resource URI for your project or may add value sets.

> Important: Add only your project name, e.g. `psss`, the same way as `sphn` and add your concept names the same way as in the mapping file (CamelCase).
>
> Please do not delete any existing namespaces, terminologies, instances or value sets. Only add, if there are more

A more thorough explanation:

- **sphn** 
  - default project defined by DCC - do not delete!
  - add your project name in the same way.
  - not necessary to delete existing projects like `psss`

- **concepts**
  - add or delete concepts
  - here you decide, which ones you want to create (not yet all `sphn` concepts implemented!!) 
- **namespaces**
  - add the namespace of your project (do not delete or change existing ones!)
- **terminologies**
  - external terminologies which are provided by DCC  
  - there will be more in future, please add them here (do not delete or change existing ones!)
- **instances**
  - for those you do not have to create tables, since they are created on the go. Only possible for one line value sets and UCUM units.
  - If you need exact location, you will have to create a table (not for SPHN projects).
- **valusets**
  - defined by DCC and project `psss`
  - you can keep all the defined ones here (even the ones which are define by other projects)
  - but uncomment the ones you create in instances.




## Connection

The connection works with `_config.py`. Make sure to include and `.env` file with the following information at the same place as this `README.md`.
Also, make sure to install all required packages (see `requirement.txt`)

```

DB_HOST=...
DB_INSTANCE=...
DB_NAME=...
DB_USER=...
```

> Important: Put the .env file in the project folder `sphn-rdf/.env`.



## Run code

In Terminal run `python main.py [project]`. 

The code

1. parses all `ttl` files into one graph,
2. creates a new resource graph.
2. for each row of the source table a resource is created in the resource graph,
   1. creates the concept class as subject.
   2. finds the attribute in the graph and uses as predicate.
   3. adds the literal or the resource of a concept as object.
4. serializes as turtle and writes to `.ttl` file for each entity separate.

> Important: Run the code for `sphn` and your project separately if you have two ontologies. So, you will also need two mapping files.



## Error Handling

The code runs perfectly as it is, but if you need to add concepts or use it on other projects, it will probably give you some errors. Then, best use the unit tests in `tests` to check what the output means. I tried to catch most of them, but with each change, there is another error possible and I didn't have time to write the unit test again and again. 

Please check:

- all files in place: `log_application - ERROR - run_mapping - 'bool' object is not iterable` is an error for missing file. You need as input ontology and csv file.
- mapping correct: main reason for an error!
  - missing attributes: if they miss in the DB, it is not a problem, but if it is missing in mapping file, you get an error.
  - missing classes: in the mapping file, each concept needs to be there as class (self).
  - naming: capital or small letters, missing ones...
  - predicate name same as name in mapping file$

> Please report errors, then I can add them here.



## Logging

I have made a package for the logging. Just install with pip and import.
```shell
pip install -r requirements.txt --trusted-host pypi.org --trusted-host pypi.python.org --cert="C:\your_path_to_certificates\.certificates\USZRootCA2.cer" --proxy="http://proxy.usz.ch:8080"
```

The decorator `logdecoratorandhandler` can also be used for INFO. Then you need to set the log level to INFO:
```python
from logdecoratorandhandler.log_decorator import Options

Options.log_level = 'INFO'
```
Then you can decorate each of you functions like so:
```python
from logdecoratorandhandler.log_decorator import LogDecorator

@LogDecorator('INFO - some info.')
def foo():
    pass
```