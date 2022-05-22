from rich import pretty
from rich.console import Console
from rich import inspect as inspct

def inspect(obj):
        inspct(obj, methods=True)

pretty.install()
print = Console().print

