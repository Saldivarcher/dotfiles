set print pretty on
set print object on
set print vtbl on

set mi-async off
set non-stop off

set history save on
set history filename ~/.gdb_history

set height 0
set width 0

set disassembly-flavor intel

set tui border-kind acs
set tui border-mode normal
set tui active-border-mode bold

define lsb
  info breakpoints
end

define argv
  show args
end

define frame
  info frame
  info args
  info locals
end

define func
  info functions
end

define var
  info variables
end

define lib
  info sharedlibrary
end

define sig
  info signals
end

define thread
  info threads
end

add-auto-load-safe-path /

source ~/.config/gdb/stl_view.gdb
source ~/.config/gdb/pdgcs.gdb

python
import sys
import os
path_to_pretty_printer = os.path.expanduser('~/.config/gdb/python')
sys.path.insert(0, path_to_pretty_printer)
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers(None)
end
