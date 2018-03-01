#
# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree. An additional grant
# of patent rights can be found in the PATENTS file in the same directory.
#


cimport pystemd.dbusc as dbusc
from pystemd.utils import x2char_star


LISTEN_FDS_START = dbusc.SD_LISTEN_FDS_START


def listen_fds(int unset_environment=0):
  return dbusc.sd_listen_fds(unset_environment)


def notify(int unset_environment, *states, **kwstates):
  """
  interface to systemd sd_notify,

  params:
    unset_environment[int] = 1 if we should remove the notify information,
      otherwize 0.
    states/kwstates = array with states statements that are 'IDENTIFIER=VALUE'.
      e.g: 'READY=1' or keywords states like `ready=1`
      (This will be clear in usage).

  usage:
    * `pystemd.daemon.notify(1, ready=1)`: this will signal `READY=1` to systemd
      notify and will remove all information from the enviroment. You should not
      try to talk to systemd notify socket again.
    *  `pystemd.daemon.notify(True, "READY=1")`: same as above just passed as a
      string.
    *  `pystemd.daemon.notify(False, ready=1, status='gime gime gime')`: will
      signal systemd that the app is ready and also set the status to
      'gime gime gime'. This command does not clean the notify enviroment.

    For info on sd_notify, check https://github.com/systemd/systemd/blob/\
master/src/systemd/sd-daemon.h#L173-L232

  """
  pystates = [x2char_star(s) for s in states]
  pystates.extend(
    b'='.join([x2char_star(k.upper()), x2char_star(v, convert_all=True)])
    for k, v in kwstates.items()
  )
  state = b'\n'.join(pystates)
  return dbusc.sd_notify(unset_environment, state)
