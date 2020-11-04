import os


def find_table_beginning(lines):
    while True:
        line = next(lines)
        if line.startswith(r"\% Table begins"):
            table_name = line.split(':')[1]
            table_name = table_name.strip()
            if not table_name:
                # Look for the table name in the next line
                table_name = next(lines).strip()
            table_name = table_name.strip().replace('\\', '')
            return table_name


def write_out_table(table_name, lines):
    with open("Results_preamble.txt", "r") as file:
        header = file.read()
    header += "\n\\begin{document}"
    footer = r"\end{document}"
    with open(table_name + ".tex", "w+") as file:
        file.write(header)
        while True:
            line = next(lines)
            if line.startswith(r"\% Table ends"):
                break
            file.write(line)
        file.write(footer)


if __name__ == "__main__":

    with open("Results.tex", "r") as texfile:

        lines = iter(texfile)
        try:
            while True:
                table_name = find_table_beginning(lines)
                write_out_table(table_name, lines)

        except StopIteration:
            pass
