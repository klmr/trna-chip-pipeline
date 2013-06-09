#!/usr/bin/env python

import sys
import re

# Variables in configurations are either simple or complex.
# Simple variables have the form `$name`.
# Complex variables either have the form `${name}` or `${section:name}`.
# Where no section name is given the current section name is assumed.
# The special value `$$` is an escaped value that is replaced by `$`.
# Variable substitution happens recursively, i.e. in the config
#
#   foo=a
#   bar=$foo
#   baz=$bar
#
# `baz` will have the value `a` after substitution. Circular dependencies are
# disallowed.

variable = re.compile('\$(\w+)|\$\{(\w+)(?::(\w+))?\}|\$\$')

def resolve_value(sections, section, key, already_replaced_values):
    # TODO Offer error diagnostics for circular variable replacements.
    def resolver(match):
        var = match.group(1) or match.group(3) or match.group(2)
        if var is None:
            return '$'
        else:
            var_section = match.group(2) if match.group(3) else section
            return resolve_value(sections, var_section, var, already_replaced_values)

    value = sections[section][key]
    if (section, key) in already_replaced_values:
        return value
    else:
        already_replaced_values.add((section, key))
        sections[section][key] = variable.sub(resolver, value)


def parse_conf(file):
    lines = map(str.strip, open(file, 'r').read().split('\n'))
    section_header = re.compile('^\[(.*?)\]$')
    sections = {}
    current_section = None
    for line in lines:
        if line.startswith('#'):
            continue
        header_match = section_header.match(line)
        if header_match:
            current_section = {}
            sections[header_match.group(1)] = current_section
        else:
            key, value = map(str.strip, line.split('='))
            current_section[key] = value

    # Patch the values: substitute variables by their values
    already_replaced_values = set()
    for header, content in sections.items():
        for key in section.keys():
            resolve_value(sections, header, key, already_replaced_values)


    return sections


def read(args):
    (file, section, search_key) = args
    #lines = map(str.strip, open(file, 'r').read().split('\n'))
    config = parse_conf(file)
    return config[section][search_key]

def unused():
    any_section = re.compile('^\[.*?\]$')
    target_section = re.compile('^\[{}\]$'.format(section))

    in_section = False
    for line in lines:
        if line.startswith('#'):
            continue
        if in_section:
            if any_section.match(line):
                break
            else:
                key, value = map(str.strip, line.split('='))
                if key == search_key:
                    return value
        elif target_section.match(line):
            in_section = True

    return None


def main():
    # TODO Check argument validity
    actions = {
        'read': read
    }

    action = actions[sys.argv[1]]
    result = action(sys.argv[2 : ])

    if result:
        print result
        return 0
    else:
        return 1


if __name__ == '__main__':
    sys.exit(main())
