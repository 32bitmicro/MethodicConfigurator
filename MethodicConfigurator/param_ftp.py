#!/usr/bin/env python3
'''
decode ftp parameter protocol data
Original file was part of MAVProxy

This file is part of Ardupilot methodic configurator. https://github.com/ArduPilot/MethodicConfigurator

(C) 2024 Amilcar do Carmo Lucas, IAV GmbH

SPDX-License-Identifier:    GPL-3
'''

import struct
import sys


class ParamData():
    """
    A class to manage parameter values and defaults for ArduPilot configuration.
    """
    def __init__(self):
        # params as (name, value, ptype)
        self.params = []
        # defaults as (name, value, ptype)
        self.defaults = None

    def add_param(self, name, value, ptype):
        self.params.append((name, value, ptype))

    def add_default(self, name, value, ptype):
        if self.defaults is None:
            self.defaults = []
        self.defaults.append((name, value, ptype))


def ftp_param_decode(data):  # pylint: disable=too-many-locals, too-many-branches
    '''decode parameter data, returning ParamData'''
    pdata = ParamData()

    magic = 0x671b
    magic_defaults = 0x671c
    if len(data) < 6:
        return None
    magic2, _num_params, total_params = struct.unpack("<HHH", data[0:6])
    if magic2 not in (magic, magic_defaults):
        print("paramftp: bad magic 0x%x expected 0x%x", magic2, magic)
        return None
    with_defaults = magic2 == magic_defaults
    data = data[6:]

    # mapping of data type to type length and format
    data_types = {
        1: (1, 'b'),
        2: (2, 'h'),
        3: (4, 'i'),
        4: (4, 'f'),
    }

    count = 0

    if sys.version_info.major < 3:
        pad_byte = chr(0)
        last_name = ''
    else:
        pad_byte = 0
        last_name = bytes()

    while True:
        while len(data) > 0 and data[0] == pad_byte:
            # skip pad bytes
            data = data[1:]

        if len(data) == 0:
            break

        ptype, plen = struct.unpack("<BB", data[0:2])
        flags = (ptype >> 4) & 0x0F
        has_default = with_defaults and (flags & 1) != 0
        ptype &= 0x0F

        if ptype not in data_types:
            print("paramftp: bad type 0x%x", ptype)
            return None

        (type_len, type_format) = data_types[ptype]
        default_len = type_len if has_default else 0

        name_len = ((plen >> 4) & 0x0F) + 1
        common_len = plen & 0x0F
        name = last_name[0:common_len] + data[2:2+name_len]
        vdata = data[2+name_len:2+name_len+type_len+default_len]
        last_name = name
        data = data[2+name_len+type_len+default_len:]
        if with_defaults:
            if has_default:
                v1, v2, = struct.unpack("<" + type_format + type_format, vdata)
                pdata.add_param(name, v1, ptype)
                pdata.add_default(name, v2, ptype)
            else:
                v, = struct.unpack("<" + type_format, vdata)
                pdata.add_param(name, v, ptype)
                pdata.add_default(name, v, ptype)
        else:
            v, = struct.unpack("<" + type_format, vdata)
            pdata.add_param(name, v, ptype)
        count += 1

    if count != total_params:
        print("paramftp: bad count %u should be %u", count, total_params)
        return None

    return pdata


def main():
    fname = sys.argv[1]
    with open(fname, 'rb') as file:
        data = file.read()
        print(f"Decoding file of length {len(data)}")
        pdata = ftp_param_decode(data)
        if pdata is None:
            print("Decode failed")
            sys.exit(1)
        for (name, value, _ptype) in pdata.params:
            print(name.decode('utf-8'), value)


if __name__ == "__main__":
    main()
