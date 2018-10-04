#!/usr/bin/env python3
#
# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree. An additional grant
# of patent rights can be found in the PATENTS file in the same directory.
#

import os
import sys


__version__ = "0.6"

_endstr = ".dev"

release_file = os.path.join(os.path.dirname(__file__), "RELEASE")
if os.path.exists(release_file):
    with open(release_file) as release_fileobj:
        _endstr = ".{}".format(release_fileobj.read().strip())

__version__ += _endstr

sys.modules[__name__] = __version__
