////////////////////////////////////////////////////////////////////////////////
//  valueIsIn.as
//  2008.04.04, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package {
	
	public function valueIsIn(value: Object, ...values): Boolean {
		for each (var v: Object in values)
			if (v == value)
				return true;
				
		return false;
	}
}
