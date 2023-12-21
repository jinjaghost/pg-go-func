package main

/*
#include "postgres.h"
#include "utils/elog.h"
#include "fmgr.h"
extern void elog_error(char* string);

*/
import "C"

import "fmt"

var _ = fmt.Printf

//
// invoked in pg using :
//
// CREATE OR REPLACE FUNCTION return_true(text, text) RETURNS boolean
// AS '$PATH/functions.so', 'ReturnTrue'
// LANGUAGE C STRICT;
//

//export ReturnTrue
func ReturnTrue(fcinfo *funcInfo) Datum {
	// get args
	var a string
	var b string
	err := fcinfo.Scan(
		&a,
		&b,
	)

	if err != nil {
		C.elog_error(C.CString(
			err.Error(),
		))
	}

	// do job
	return toDatum(true)
}
