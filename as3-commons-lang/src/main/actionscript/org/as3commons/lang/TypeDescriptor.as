package org.as3commons.lang {
import org.as3commons.lang.typedescription.JSONTypeDescription;
import org.as3commons.lang.typedescription.XMLTypeDescription;

public class TypeDescriptor {

	public static var typeDescriptionKind:TypeDescriptionKind;

	{
		typeDescriptionKind = TypeDescriptionKind.JSON;
	}

	public static function getTypeDescriptionForClass(clazz:Class):ITypeDescription {
		var result:ITypeDescription;

		if (typeDescriptionKind == TypeDescriptionKind.JSON) {
			try {
				result = new JSONTypeDescription(clazz);
			} catch (e:*) {
			}
		}

		if (!result) {
			result = new XMLTypeDescription(clazz);
		}

		return result;
	}

	public function TypeDescriptor() {
		super();
	}

}
}
