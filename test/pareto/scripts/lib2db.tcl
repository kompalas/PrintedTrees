set LIB_PATH $env(LIB_PATH)
if {[string index $LIB_PATH end] != "/"} {
    set LIB_PATH "${LIB_PATH}/"
}
set search_path [list ${LIB_PATH}]

set LIB_TO_COMPILE $env(LIB_TO_COMPILE)
set LIB_OUTPUT_DB $env(LIB_OUTPUT_DB)

set LIB_NAME [string map {".lib" ""} $LIB_TO_COMPILE]

read_lib $LIB_TO_COMPILE
write_lib $LIB_NAME -output $LIB_OUTPUT_DB -format db

quit
