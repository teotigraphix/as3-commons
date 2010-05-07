package org.as3commons.emit.tags {
import flash.errors.IllegalOperationError;

import org.as3commons.emit.ISWFInput;
import org.as3commons.emit.ISWFOutput;
import org.as3commons.lang.Assert;

public class AbstractTag {
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param tagId the id of the tag
	 */
	public function AbstractTag(tagId:uint) {
		Assert.notAbstract(this, AbstractTag);
		_tagId = tagId;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  tagId
	//----------------------------------
	
	private var _tagId:uint;

	public function get tagId():uint {
		return _tagId;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	public function readData(input:ISWFInput):void {
		throw new IllegalOperationError("Abstract method must be overridden in subclass");
	}
	
	public function writeData(output:ISWFOutput):void {
		throw new IllegalOperationError("Abstract method must be overridden in subclass");
	}
}
}