package org.mockito.integrations.flexunit4
{
import flash.utils.getDefinitionByName;

import flex.lang.reflect.Field;
import flex.lang.reflect.Klass;
import flex.lang.reflect.metadata.MetaDataAnnotation;
import flex.lang.reflect.metadata.MetaDataArgument;

public class MockitoMetadataTools
{
    /**
     * Supported metadata
     * [Mock] attempts to assign mock object based on a field type assuming default constructor
     * Metadata parameters:
     * type="FQCN" mock object type (fully qualified class name)
     * argsList="fieldName" a name of field/property that holds array of arguments to pass to the mock constructor (if required)
     */
    private static const MOCK_METADATA:String = "Mock";
    private static const MOCK_METADATA_TYPE_KEY:String = "type";
    private static const MOCK_METADATA_ARGUMENTS_VAR:String = "argsList";
    private static const MOCK_METADATA_MOCK_NAME:String = "mockName";

    public static function hasMockClasses(testClass:Class):Boolean
    {
        var klass:Klass = new Klass(testClass);
        var array:Array = getArgValuesFromMetaDataNode(klass, MOCK_METADATA, MOCK_METADATA_TYPE_KEY);
        if (array.length > 0)
            return true;
        for each(var field:Field in klass.fields)
        {
            if (field.hasMetaData(MOCK_METADATA))
            {
                return true;
            }
        }

        return false;
    }

    public static function getMockInitializers(testClass:Class, includeClassMetadata:Boolean=false):Array
    {
        var mockInitializers:Array = [];
        var klass:Klass = new Klass(testClass);
        if (includeClassMetadata)
        {
            var array:Array = getArgValuesFromMetaDataNode(klass, MOCK_METADATA, MOCK_METADATA_TYPE_KEY);
            for each (var type:String in array)
            {
                mockInitializers.push({type: mapClass(type)});
            }

        }
        for each(var field:Field in klass.fields)
        {
            if (!field.hasMetaData(MOCK_METADATA))
                continue;
            var mockClass:Class;
            var mockClassName:String = getMetaData(field, MOCK_METADATA, MOCK_METADATA_TYPE_KEY);
            if (!mockClassName)
            {
                mockClass = field.type;
            }
            else
            {
                mockClass = mapClass(mockClassName);
            }
            var name:String = getMetaData(field, MOCK_METADATA, MOCK_METADATA_MOCK_NAME);
            var argumentsProperty:String = getMetaData(field, MOCK_METADATA, MOCK_METADATA_ARGUMENTS_VAR);
            mockInitializers.push({type: mockClass, argsProperty: argumentsProperty, fieldName: field.name, mockName: name});
        }
        return mockInitializers;
    }

    private static function getMetaData(field:Field, meta:String, key:String):String
    {
        var metadata:MetaDataAnnotation = field.getMetaData(meta);
        if (metadata)
        {
            var arg:MetaDataArgument = metadata.getArgument(key);
            if (arg)
            {
                return arg.value;
            }
        }
        return null;
    }

    private static function mapClass(className:String):Class
    {
        var klass:Class = null;

        try
        {
            klass = getDefinitionByName(className) as Class;
        }
        catch(error:Error)
        {
            throw new MockitoMetadataError("[Mock] metadata specified invalid class: " + className);
        }

        return klass;
    }

    public static function getArgValuesFromMetaDataNode(klass:Klass, metaDataName:String, key:String):Array
    {
        var value:String;
        var metaNodes:XMLList;

        var values : Array = new Array();

        for each (var metadata:MetaDataAnnotation in klass.metadata)
        {
            if (metadata.name == metaDataName)
            {
                if (metadata.hasArgument(key))
                    values.push(metadata.getArgument(key).value);
            }
        }
//        for each(var node : XML in nodes.(@name == metaDataName))
//        {
//
//            var typeArg : String = null;
//            var defaultArg : String = null;
//
//            if (node.arg)
//            {
//                typeArg = String(node.arg.(@key == key).@value);
//                defaultArg = String(node.arg.(@key == "").@value);
//            }
//
//            var hasType : Boolean = (typeArg.length > 0);
//            var hasDefault : Boolean = (defaultArg.length > 0);
//
//            if (hasType)
//            {
//                if (values.indexOf(typeArg) == -1)
//                {
//                    values.push(typeArg);
//                }
//            }
//            else if (hasDefault)
//            {
//                if (values.indexOf(defaultArg) == -1)
//                {
//                    values.push(defaultArg);
//                }
//            }
//        }

        return values;
    }
}
}