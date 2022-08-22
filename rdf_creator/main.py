"""
This is the main module.

Start from here with command line.
- run this file - add project name (psss, spo, frailty,...)
- the run_mapping is only necessary after changes, but since it is fast, you can run it every time.
- run_creator makes all the things necessary to convert data to rdf - data is written in ttl file.
"""
from rdf_creator.creator import run_creator
from rdf_mapping.usz_mapping import run_mapping


def main(argv):
    """
    This is the starting point:

    - first, the mapping is done
    - second, the creator returns the turtle files
    """
    run_mapping(argv)
    run_creator(argv)


if __name__ == '__main__':
    import time

    ## uncomment following one line, if used from command line:
    # main(argv=sys.argv[1])

    ## comment following 4 lines, if used from command line
    start = time.time()
    main('sphn')
    end = time.time()
    print(end - start)
