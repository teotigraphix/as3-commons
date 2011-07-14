/*
* Copyright 2007-2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.as3commons.bytecode.reflect {
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.util.AbcFileUtil;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Constructor;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Parameter;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;
	import org.as3commons.reflect.as3commons_reflect;

	public final class PlayerGlobalData {

		private static const PERIOD:String = '.';
		private static const ASTERISK:String = '*';
		private static const NULL_IDENT:String = 'null';
		private static const STRING_IDENT:String = 'String';
		private static const INT_IDENT:String = 'int';
		private static const UINT_IDENT:String = 'uint';
		private static const NUMBER_IDENT:String = 'Number';
		private static const BOOLEAN_IDENT:String = 'Boolean';
		private static const TRUE_IDENT:String = 'true';
		private static const COLON:String = ':';

		public static function forName(fullyQualifiedClassName:String):ByteCodeType {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var type:Type = Type.forName(fullyQualifiedClassName, applicationDomain);
			if (type != null) {
				return typeToByteCodeType(type, applicationDomain);
			} else {
				return null;
			}
		}

		private static function typeToByteCodeType(type:Type, applicationDomain:ApplicationDomain):ByteCodeType {
			var result:ByteCodeType = new ByteCodeType(applicationDomain);
			result.as3commons_reflect::setIsNative(true);
			result.name = type.name;
			result.fullName = type.fullName;
			result.clazz = type.clazz;
			result.extendsClasses = type.extendsClasses.concat([]);
			result.interfaces = type.interfaces.concat([]);
			for each (var param:* in type.parameters) {
				result.parameters[result.parameters.length] = param;
			}
			result.as3commons_reflect::setInstanceConstructor(constructorToByteCodeConstructor(type.constructor, applicationDomain));
			result.constructor = new Constructor(type.fullName, applicationDomain, result.instanceConstructor.parameters);
			var methods:Array = [];
			for each (var method:Method in type.methods) {
				methods[methods.length] = methodToByteCodeMethod(method, applicationDomain);
			}
			result.methods = methods;
			for each (var acc:Accessor in result.accessors) {
				result.accessors[result.accessors.length] = accessorToBytecodeAccessor(acc, applicationDomain);
			}
			for each (var variable:Variable in result.variables) {
				result.variables[result.variables.length] = variableToBytecodeVariable(variable, applicationDomain);
			}
			return result;
		}

		private static function constructorToByteCodeConstructor(constructor:Constructor, applicationDomain:ApplicationDomain):ByteCodeMethod {
			var params:Array = [];
			var idx:int = 0;
			var len:int = constructor.parameters.length;
			for each (var param:Parameter in constructor.parameters) {
				params[params.length] = paramToByteCodeParam(idx++, AbcFileUtil.normalizeFullName(constructor.declaringType.fullName) + PERIOD + constructor.declaringType.name, param, applicationDomain, len);
			}
			var result:ByteCodeMethod = new ByteCodeMethod(constructor.declaringType.fullName, constructor.declaringType.name, false, params, ASTERISK, applicationDomain);
			result.as3commons_reflect::setVisibility(NamespaceKind.PACKAGE_NAMESPACE);
			return result;
		}

		private static function variableToBytecodeVariable(variable:Variable, applicationDomain:ApplicationDomain):ByteCodeVariable {
			var result:ByteCodeVariable = new ByteCodeVariable(variable.name, variable.type.fullName, variable.declaringType.fullName, false, applicationDomain);
			result.as3commons_reflect::setVisibility(NamespaceKind.PACKAGE_NAMESPACE);
			return result;
		}

		private static function accessorToBytecodeAccessor(accessor:Accessor, applicationDomain:ApplicationDomain):ByteCodeAccessor {
			var result:ByteCodeAccessor = new ByteCodeAccessor(accessor.name, accessor.access, accessor.type.fullName, accessor.declaringType.fullName, false, applicationDomain);
			result.as3commons_reflect::setVisibility(NamespaceKind.PACKAGE_NAMESPACE);
			return result;
		}

		private static function methodToByteCodeMethod(method:Method, applicationDomain:ApplicationDomain):ByteCodeMethod {
			var params:Array = [];
			var idx:int = 0;
			var len:int = method.parameters.length;
			for each (var param:Parameter in method.parameters) {
				params[params.length] = paramToByteCodeParam(idx++, AbcFileUtil.normalizeFullName(method.declaringType.fullName) + PERIOD + method.name, param, applicationDomain, len);
			}
			var result:ByteCodeMethod = new ByteCodeMethod(method.declaringType.fullName, method.name, false, params, method.returnType.fullName, applicationDomain);
			result.as3commons_reflect::setVisibility(NamespaceKind.PACKAGE_NAMESPACE);
			return result;
		}

		private static function paramToByteCodeParam(index:int, key:String, parameter:Parameter, applicationDomain:ApplicationDomain, total:int):ByteCodeParameter {
			var defaultVal:* = parameter.isOptional ? createDefaultValue(key, index, total) : null;
			return new ByteCodeParameter(parameter.type.fullName, applicationDomain, parameter.isOptional, defaultVal);
		}

		private static function createDefaultValue(key:String, index:int, total:int):* {
			var params:Array = optionalArgumentDefaultValues[key] as Array;
			if (params != null) {
				var idx:int = (index) - (total - params.length);
				if (idx < params.length) {
					var parts:Array = String(params[idx]).split(COLON);
					switch (String(parts[0])) {
						case ASTERISK:
							if (String(parts[1]) == ASTERISK) {
								return undefined;
							} else if (String(parts[1]) == NULL_IDENT) {
								return null;
							} else {
								var i:int = parseInt(String(parts[1]));
								return isNaN(i) ? parts[1] : i;
							}
							break;
						case STRING_IDENT:
							return (parts[1] == NULL_IDENT) ? null : String(parts[1]);
							break;
						case INT_IDENT:
						case UINT_IDENT:
						case NUMBER_IDENT:
							return parseInt(String(parts[1]));
							break;
						case BOOLEAN_IDENT:
							return (String(parts[1]) == TRUE_IDENT);
							break;
						default:
							return null;
							break;
					}
				}
			}
			return null;
		}

		public static const optionalArgumentDefaultValues:Dictionary = new Dictionary();
		{
			//Methods:
			optionalArgumentDefaultValues['Object.isPrototypeOf'] = ['*:null'];
			optionalArgumentDefaultValues['Object.hasOwnProperty'] = ['*:null'];
			optionalArgumentDefaultValues['Object.propertyIsEnumerable'] = ['*:null'];
			optionalArgumentDefaultValues['Function.call'] = ['*:null'];
			optionalArgumentDefaultValues['Function.apply'] = ['*:null', '*:null'];
			optionalArgumentDefaultValues['Array.join'] = ['*:null'];
			optionalArgumentDefaultValues['Array.slice'] = ['*:0', '*:4294967295'];
			optionalArgumentDefaultValues['Array.sortOn'] = ['*:0'];
			optionalArgumentDefaultValues['Array.indexOf'] = ['*:0'];
			optionalArgumentDefaultValues['Array.lastIndexOf'] = ['*:2147483647'];
			optionalArgumentDefaultValues['Array.every'] = ['*:null'];
			optionalArgumentDefaultValues['Array.filter'] = ['*:null'];
			optionalArgumentDefaultValues['Array.forEach'] = ['*:null'];
			optionalArgumentDefaultValues['Array.map'] = ['*:null'];
			optionalArgumentDefaultValues['Array.some'] = ['*:null'];
			optionalArgumentDefaultValues['flash.events.IEventDispatcher.addEventListener'] = ['Boolean:false', 'int:0', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.events.IEventDispatcher.removeEventListener'] = ['Boolean:false'];
			optionalArgumentDefaultValues['flash.events.EventDispatcher.addEventListener'] = ['Boolean:false', 'int:0', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.events.EventDispatcher.removeEventListener'] = ['Boolean:false'];
			optionalArgumentDefaultValues['flash.utils.IDataInput.readBytes'] = ['uint:0', 'uint:0'];
			optionalArgumentDefaultValues['flash.utils.ObjectInput.readBytes'] = ['uint:0', 'uint:0'];
			optionalArgumentDefaultValues['flash.net.drm.DRMVoucherDownloadContext.download'] = ['Boolean:false'];
			optionalArgumentDefaultValues['flash.display.DisplayObject.hitTestPoint'] = ['Boolean:false'];
			optionalArgumentDefaultValues['flash.geom.Matrix.createBox'] = ['Number:0', 'Number:0', 'Number:0'];
			optionalArgumentDefaultValues['flash.geom.Matrix.createGradientBox'] = ['Number:0', 'Number:0', 'Number:0'];
			optionalArgumentDefaultValues['flash.display.Stage.addEventListener'] = ['Boolean:false', 'int:0', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.display.ShaderJob.start'] = ['Boolean:false'];
			optionalArgumentDefaultValues['flash.net.NetStream.attachCamera'] = ['int:-1'];
			optionalArgumentDefaultValues['flash.net.NetStream.publish'] = ['String:null', 'String:null'];
			optionalArgumentDefaultValues['flash.net.FileReference.browse'] = ['Array:null'];
			optionalArgumentDefaultValues['flash.net.FileReference.download'] = ['String:null'];
			optionalArgumentDefaultValues['flash.net.FileReference.upload'] = ['String:Filedata', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.net.FileReference.save'] = ['String:null'];
			optionalArgumentDefaultValues['flash.net.URLLoader.addEventListener'] = ['Boolean:false', 'int:0', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.utils.IDataOutput.writeBytes'] = ['uint:0', 'uint:0'];
			optionalArgumentDefaultValues['flash.net.Socket.readBytes'] = ['uint:0', 'uint:0'];
			optionalArgumentDefaultValues['flash.net.Socket.writeBytes'] = ['uint:0', 'uint:0'];
			optionalArgumentDefaultValues['flash.display.BitmapData.copyPixels'] = ['flash.display.BitmapData:null', 'flash.geom.Point:null', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.display.BitmapData.draw'] = ['flash.geom.Matrix:null', 'flash.geom.ColorTransform:null', 'String:null', 'flash.geom.Rectangle:null', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.display.BitmapData.getColorBoundsRect'] = ['Boolean:true'];
			optionalArgumentDefaultValues['flash.display.BitmapData.hitTest'] = ['flash.geom.Point:null', 'uint:1'];
			optionalArgumentDefaultValues['flash.display.BitmapData.noise'] = ['uint:0', 'uint:255', 'uint:7', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.display.BitmapData.paletteMap'] = ['Array:null', 'Array:null', 'Array:null', 'Array:null'];
			optionalArgumentDefaultValues['flash.display.BitmapData.perlinNoise'] = ['uint:7', 'Boolean:false', 'Array:null'];
			optionalArgumentDefaultValues['flash.display.BitmapData.pixelDissolve'] = ['int:0', 'int:0', 'uint:0'];
			optionalArgumentDefaultValues['flash.display.BitmapData.threshold'] = ['uint:0', 'uint:4294967295', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.display.BitmapData.unlock'] = ['flash.geom.Rectangle:null'];
			optionalArgumentDefaultValues['flash.display.BitmapData.histogram'] = ['flash.geom.Rectangle:null'];
			optionalArgumentDefaultValues['flash.net.SharedObject.connect'] = ['String:null'];
			optionalArgumentDefaultValues['flash.net.SharedObject.flush'] = ['int:0'];
			optionalArgumentDefaultValues['flash.net.SharedObject.setProperty'] = ['Object:null'];
			optionalArgumentDefaultValues['RegExp.exec'] = ['String:'];
			optionalArgumentDefaultValues['RegExp.test'] = ['String:'];
			optionalArgumentDefaultValues['flash.geom.Matrix3D.decompose'] = ['String:eulerAngles'];
			optionalArgumentDefaultValues['flash.geom.Matrix3D.recompose'] = ['String:eulerAngles'];
			optionalArgumentDefaultValues['flash.geom.Matrix3D.appendRotation'] = ['flash.geom.Vector3D:null'];
			optionalArgumentDefaultValues['flash.geom.Matrix3D.prependRotation'] = ['flash.geom.Vector3D:null'];
			optionalArgumentDefaultValues['flash.geom.Matrix3D.pointAt'] = ['flash.geom.Vector3D:null', 'flash.geom.Vector3D:null'];
			optionalArgumentDefaultValues['flash.net.NetConnection.addHeader'] = ['Boolean:false', 'Object:null'];
			optionalArgumentDefaultValues['flash.text.TextField.getTextFormat'] = ['int:-1', 'int:-1'];
			optionalArgumentDefaultValues['flash.text.TextField.getTextRuns'] = ['int:0', 'int:2147483647'];
			optionalArgumentDefaultValues['flash.text.TextField.getXMLText'] = ['int:0', 'int:2147483647'];
			optionalArgumentDefaultValues['flash.text.TextField.insertXMLText'] = ['Boolean:false'];
			optionalArgumentDefaultValues['flash.text.TextField.setTextFormat'] = ['int:-1', 'int:-1'];
			optionalArgumentDefaultValues['flash.printing.PrintJob.addPage'] = ['flash.geom.Rectangle:null', 'flash.printing.PrintJobOptions:null', 'int:0'];
			optionalArgumentDefaultValues['flash.net.GroupSpecifier.setPublishPassword'] = ['String:null', 'String:null'];
			optionalArgumentDefaultValues['flash.net.GroupSpecifier.setPostingPassword'] = ['String:null', 'String:null'];
			optionalArgumentDefaultValues['flash.net.GroupSpecifier.addIPMulticastAddress'] = ['*:null', 'String:null'];
			optionalArgumentDefaultValues['flash.net.FileReferenceList.browse'] = ['Array:null'];
			optionalArgumentDefaultValues['flash.geom.Vector3D.equals'] = ['Boolean:false'];
			optionalArgumentDefaultValues['flash.geom.Vector3D.nearEquals'] = ['Boolean:false'];
			optionalArgumentDefaultValues['flash.desktop.Clipboard.setData'] = ['Boolean:true'];
			optionalArgumentDefaultValues['flash.desktop.Clipboard.setDataHandler'] = ['Boolean:true'];
			optionalArgumentDefaultValues['flash.desktop.Clipboard.getData'] = ['String:originalPreferred'];
			optionalArgumentDefaultValues['flash.display.Sprite.startDrag'] = ['Boolean:false', 'flash.geom.Rectangle:null'];
			optionalArgumentDefaultValues['flash.display.Sprite.startTouchDrag'] = ['Boolean:false', 'flash.geom.Rectangle:null'];
			optionalArgumentDefaultValues['flash.text.ime.IIMEClient.confirmComposition'] = ['String:null', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.utils.ByteArray.readBytes'] = ['uint:0', 'uint:0'];
			optionalArgumentDefaultValues['flash.utils.ByteArray.writeBytes'] = ['uint:0', 'uint:0'];
			optionalArgumentDefaultValues['flash.media.Sound.load'] = ['flash.media.SoundLoaderContext:null'];
			optionalArgumentDefaultValues['flash.media.Sound.play'] = ['Number:0', 'int:0', 'flash.media.SoundTransform:null'];
			optionalArgumentDefaultValues['flash.media.Sound.extract'] = ['Number:-1'];
			optionalArgumentDefaultValues['flash.net.URLStream.readBytes'] = ['uint:0', 'uint:0'];
			optionalArgumentDefaultValues['flash.text.TextSnapshot.getSelectedText'] = ['Boolean:false'];
			optionalArgumentDefaultValues['flash.text.TextSnapshot.getText'] = ['Boolean:false'];
			optionalArgumentDefaultValues['flash.text.TextSnapshot.hitTestTextNearPos'] = ['Number:0'];
			optionalArgumentDefaultValues['flash.text.TextSnapshot.setSelectColor'] = ['uint:16776960'];
			optionalArgumentDefaultValues['flash.display.Loader.load'] = ['flash.system.LoaderContext:null'];
			optionalArgumentDefaultValues['flash.display.Loader.loadBytes'] = ['flash.system.LoaderContext:null'];
			optionalArgumentDefaultValues['flash.display.Loader.unloadAndStop'] = ['Boolean:true'];
			optionalArgumentDefaultValues['flash.utils.ObjectOutput.writeBytes'] = ['uint:0', 'uint:0'];
			optionalArgumentDefaultValues['flash.display.MovieClip.gotoAndPlay'] = ['String:null'];
			optionalArgumentDefaultValues['flash.display.MovieClip.gotoAndStop'] = ['String:null'];
			//Constructors:
			optionalArgumentDefaultValues['flash.events.EventDispatcher.EventDispatcher'] = ['flash.events.IEventDispatcher:null'];
			optionalArgumentDefaultValues['flash.net.Responder.Responder'] = ['Function:null'];
			optionalArgumentDefaultValues['Error.Error'] = ['*:', '*:0'];
			optionalArgumentDefaultValues['DefinitionError.DefinitionError'] = ['*:', '*:0'];
			optionalArgumentDefaultValues['EvalError.EvalError'] = ['*:', '*:0'];
			optionalArgumentDefaultValues['RangeError.RangeError'] = ['*:', '*:0'];
			optionalArgumentDefaultValues['ReferenceError.ReferenceError'] = ['*:', '*:0'];
			optionalArgumentDefaultValues['SecurityError.SecurityError'] = ['*:', '*:0'];
			optionalArgumentDefaultValues['SyntaxError.SyntaxError'] = ['*:', '*:0'];
			optionalArgumentDefaultValues['TypeError.TypeError'] = ['*:', '*:0'];
			optionalArgumentDefaultValues['URIError.URIError'] = ['*:', '*:0'];
			optionalArgumentDefaultValues['VerifyError.VerifyError'] = ['*:', '*:0'];
			optionalArgumentDefaultValues['UninitializedError.UninitializedError'] = ['*:', '*:0'];
			optionalArgumentDefaultValues['ArgumentError.ArgumentError'] = ['*:', '*:0'];
			optionalArgumentDefaultValues['flash.errors.IllegalOperationError.IllegalOperationError'] = ['String:', 'int:0'];
			optionalArgumentDefaultValues['flash.errors.IOError.IOError'] = ['String:', 'int:0'];
			optionalArgumentDefaultValues['flash.errors.MemoryError.MemoryError'] = ['String:', 'int:0'];
			optionalArgumentDefaultValues['flash.errors.StackOverflowError.StackOverflowError'] = ['String:', 'int:0'];
			optionalArgumentDefaultValues['flash.errors.ScriptTimeoutError.ScriptTimeoutError'] = ['String:', 'int:0'];
			optionalArgumentDefaultValues['flash.errors.InvalidSWFError.InvalidSWFError'] = ['String:', 'int:0'];
			optionalArgumentDefaultValues['flash.errors.EOFError.EOFError'] = ['String:', 'int:0'];
			optionalArgumentDefaultValues['flash.text.engine.ContentElement.ContentElement'] = ['flash.text.engine.ElementFormat:null', 'flash.events.EventDispatcher:null', 'String:rotate0'];
			optionalArgumentDefaultValues['flash.display.Bitmap.Bitmap'] = ['flash.display.BitmapData:null', 'String:auto', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.events.Event.Event'] = ['Boolean:false', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.events.KeyboardEvent.KeyboardEvent'] = ['Boolean:true', 'Boolean:false', 'uint:0', 'uint:0', 'uint:0', 'Boolean:false', 'Boolean:false', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.geom.Matrix.Matrix'] = ['Number:1', 'Number:0', 'Number:0', 'Number:1', 'Number:0', 'Number:0'];
			optionalArgumentDefaultValues['flash.geom.Rectangle.Rectangle'] = ['Number:0', 'Number:0', 'Number:0', 'Number:0'];
			optionalArgumentDefaultValues['flash.utils.Timer.Timer'] = ['int:0'];
			optionalArgumentDefaultValues['flash.geom.Point.Point'] = ['Number:0', 'Number:0'];
			optionalArgumentDefaultValues['flash.display.ShaderJob.ShaderJob'] = ['flash.display.Shader:null', 'Object:null', 'int:0', 'int:0'];
			optionalArgumentDefaultValues['flash.net.NetStream.NetStream'] = ['String:connectToFMS'];
			optionalArgumentDefaultValues['flash.printing.PrintJobOptions.PrintJobOptions'] = ['Boolean:false'];
			optionalArgumentDefaultValues['flash.events.TextEvent.TextEvent'] = ['Boolean:false', 'Boolean:false', 'String:'];
			optionalArgumentDefaultValues['flash.net.URLLoader.URLLoader'] = ['flash.net.URLRequest:null'];
			optionalArgumentDefaultValues['flash.filters.ConvolutionFilter.ConvolutionFilter'] = ['Number:0', 'Number:0', 'Array:null', 'Number:1', 'Number:0', 'Boolean:true', 'Boolean:true', 'uint:0', 'Number:0'];
			optionalArgumentDefaultValues['flash.events.StatusEvent.StatusEvent'] = ['Boolean:false', 'Boolean:false', 'String:', 'String:'];
			optionalArgumentDefaultValues['flash.system.LoaderContext.LoaderContext'] = ['Boolean:false', 'flash.system.ApplicationDomain:null', 'flash.system.SecurityDomain:null'];
			optionalArgumentDefaultValues['flash.system.JPEGLoaderContext.JPEGLoaderContext'] = ['Number:0', 'Boolean:false', 'flash.system.ApplicationDomain:null', 'flash.system.SecurityDomain:null'];
			optionalArgumentDefaultValues['flash.net.Socket.Socket'] = ['String:null', 'int:0'];
			optionalArgumentDefaultValues['flash.events.ProgressEvent.ProgressEvent'] = ['Boolean:false', 'Boolean:false', 'Number:0', 'Number:0'];
			optionalArgumentDefaultValues['flash.events.ErrorEvent.ErrorEvent'] = ['Boolean:false', 'Boolean:false', 'String:', 'int:0'];
			optionalArgumentDefaultValues['flash.events.IOErrorEvent.IOErrorEvent'] = ['Boolean:false', 'Boolean:false', 'String:', 'int:0'];
			optionalArgumentDefaultValues['flash.events.AsyncErrorEvent.AsyncErrorEvent'] = ['Boolean:false', 'Boolean:false', 'String:', 'Error:null'];
			optionalArgumentDefaultValues['flash.display.BitmapData.BitmapData'] = ['Boolean:true', 'uint:4294967295'];
			optionalArgumentDefaultValues['flash.events.ShaderEvent.ShaderEvent'] = ['Boolean:false', 'Boolean:false', 'flash.display.BitmapData:null', 'flash.utils.ByteArray:null', '__AS3__.vec.Vector:null'];
			optionalArgumentDefaultValues['flash.events.TimerEvent.TimerEvent'] = ['Boolean:false', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.events.DRMAuthenticateEvent.DRMAuthenticateEvent'] = ['Boolean:false', 'Boolean:false', 'String:', 'String:', 'String:', 'String:', 'String:', 'flash.net.NetStream:null'];
			optionalArgumentDefaultValues['flash.events.SampleDataEvent.SampleDataEvent'] = ['Boolean:false', 'Boolean:false', 'Number:0', 'flash.utils.ByteArray:null'];
			optionalArgumentDefaultValues['flash.media.SoundLoaderContext.SoundLoaderContext'] = ['Number:1000', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.events.AccelerometerEvent.AccelerometerEvent'] = ['Boolean:false', 'Boolean:false', 'Number:0', 'Number:0', 'Number:0', 'Number:0'];
			optionalArgumentDefaultValues['flash.events.DRMStatusEvent.DRMStatusEvent'] = ['String:drmStatus', 'Boolean:false', 'Boolean:false', 'flash.net.drm.DRMContentData:null', 'flash.net.drm.DRMVoucher:null', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.text.TextFormat.TextFormat'] = ['String:null', 'Object:null', 'Object:null', 'Object:null', 'Object:null', 'Object:null', 'String:null', 'String:null', 'String:null', 'Object:null', 'Object:null', 'Object:null', 'Object:null'];
			optionalArgumentDefaultValues['flash.events.NetStatusEvent.NetStatusEvent'] = ['Boolean:false', 'Boolean:false', 'Object:null'];
			optionalArgumentDefaultValues['RegExp.RegExp'] = ['*:null', '*:null'];
			optionalArgumentDefaultValues['flash.display.Shader.Shader'] = ['flash.utils.ByteArray:null'];
			optionalArgumentDefaultValues['flash.events.IMEEvent.IMEEvent'] = ['Boolean:false', 'Boolean:false', 'String:', 'flash.text.ime.IIMEClient:null'];
			optionalArgumentDefaultValues['flash.geom.Matrix3D.Matrix3D'] = ['__AS3__.vec.Vector:null'];
			optionalArgumentDefaultValues['flash.events.ActivityEvent.ActivityEvent'] = ['Boolean:false', 'Boolean:false', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.events.GestureEvent.GestureEvent'] = ['Boolean:true', 'Boolean:false', 'String:null', 'Number:0', 'Number:0', 'Boolean:false', 'Boolean:false', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.events.PressAndTapGestureEvent.PressAndTapGestureEvent'] = ['Boolean:true', 'Boolean:false', 'String:null', 'Number:0', 'Number:0', 'Number:0', 'Number:0', 'Boolean:false', 'Boolean:false', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.net.drm.DRMContentData.DRMContentData'] = ['flash.utils.ByteArray:null'];
			optionalArgumentDefaultValues['flash.net.XMLSocket.XMLSocket'] = ['String:null', 'int:0'];
			optionalArgumentDefaultValues['flash.utils.Dictionary.Dictionary'] = ['Boolean:false'];
			optionalArgumentDefaultValues['flash.automation.KeyboardAutomationAction.KeyboardAutomationAction'] = ['uint:0'];
			optionalArgumentDefaultValues['flash.events.TransformGestureEvent.TransformGestureEvent'] = ['Boolean:true', 'Boolean:false', 'String:null', 'Number:0', 'Number:0', 'Number:1', 'Number:1', 'Number:0', 'Number:0', 'Number:0', 'Boolean:false', 'Boolean:false', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.events.DataEvent.DataEvent'] = ['Boolean:false', 'Boolean:false', 'String:'];
			optionalArgumentDefaultValues['flash.events.FocusEvent.FocusEvent'] = ['Boolean:true', 'Boolean:false', 'flash.display.InteractiveObject:null', 'Boolean:false', 'uint:0'];
			optionalArgumentDefaultValues['flash.events.HTTPStatusEvent.HTTPStatusEvent'] = ['Boolean:false', 'Boolean:false', 'int:0'];
			optionalArgumentDefaultValues['flash.events.DRMAuthenticationErrorEvent.DRMAuthenticationErrorEvent'] = ['Boolean:false', 'Boolean:false', 'String:', 'int:0', 'int:0', 'String:null', 'String:null'];
			optionalArgumentDefaultValues['flash.events.NetFilterEvent.NetFilterEvent'] = ['Boolean:false', 'Boolean:false', 'flash.utils.ByteArray:null', 'flash.utils.ByteArray:null'];
			optionalArgumentDefaultValues['flash.geom.Vector3D.Vector3D'] = ['Number:0', 'Number:0', 'Number:0', 'Number:0'];
			optionalArgumentDefaultValues['flash.automation.MouseAutomationAction.MouseAutomationAction'] = ['Number:0', 'Number:0', 'int:0'];
			optionalArgumentDefaultValues['flash.events.SyncEvent.SyncEvent'] = ['Boolean:false', 'Boolean:false', 'Array:null'];
			optionalArgumentDefaultValues['flash.events.DRMErrorEvent.DRMErrorEvent'] = ['String:drmError', 'Boolean:false', 'Boolean:false', 'String:', 'int:0', 'int:0', 'flash.net.drm.DRMContentData:null', 'Boolean:false', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.media.Video.Video'] = ['int:320', 'int:240'];
			optionalArgumentDefaultValues['flash.events.TouchEvent.TouchEvent'] = ['Boolean:true', 'Boolean:false', 'int:0', 'Boolean:false', 'Number:NaN', 'Number:NaN', 'Number:NaN', 'Number:NaN', 'Number:NaN', 'flash.display.InteractiveObject:null', 'Boolean:false', 'Boolean:false', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.events.MouseEvent.MouseEvent'] = ['Boolean:true', 'Boolean:false', 'Number:null', 'Number:null', 'flash.display.InteractiveObject:null', 'Boolean:false', 'Boolean:false', 'Boolean:false', 'Boolean:false', 'int:0'];
			optionalArgumentDefaultValues['flash.xml.XMLDocument.XMLDocument'] = ['String:null'];
			optionalArgumentDefaultValues['flash.events.DRMAuthenticationCompleteEvent.DRMAuthenticationCompleteEvent'] = ['Boolean:false', 'Boolean:false', 'String:null', 'String:null', 'flash.utils.ByteArray:null'];
			optionalArgumentDefaultValues['flash.events.SecurityErrorEvent.SecurityErrorEvent'] = ['Boolean:false', 'Boolean:false', 'String:', 'int:0'];
			optionalArgumentDefaultValues['flash.media.Sound.Sound'] = ['flash.net.URLRequest:null', 'flash.media.SoundLoaderContext:null'];
			optionalArgumentDefaultValues['flash.display.SimpleButton.SimpleButton'] = ['flash.display.DisplayObject:null', 'flash.display.DisplayObject:null', 'flash.display.DisplayObject:null', 'flash.display.DisplayObject:null'];
			optionalArgumentDefaultValues['flash.net.URLVariables.URLVariables'] = ['String:null'];
			optionalArgumentDefaultValues['flash.events.FullScreenEvent.FullScreenEvent'] = ['Boolean:false', 'Boolean:false', 'Boolean:false'];
			optionalArgumentDefaultValues['flash.automation.StageCaptureEvent.StageCaptureEvent'] = ['Boolean:false', 'Boolean:false', 'String:', 'uint:0'];
			optionalArgumentDefaultValues['flash.geom.ColorTransform.ColorTransform'] = ['Number:1', 'Number:1', 'Number:1', 'Number:1', 'Number:0', 'Number:0', 'Number:0', 'Number:0'];
			optionalArgumentDefaultValues['flash.events.UncaughtErrorEvent.UncaughtErrorEvent'] = ['String:uncaughtError', 'Boolean:true', 'Boolean:true', '*:null'];
			optionalArgumentDefaultValues['flash.filters.ShaderFilter.ShaderFilter'] = ['flash.display.Shader:null'];
			optionalArgumentDefaultValues['flash.events.GeolocationEvent.GeolocationEvent'] = ['Boolean:false', 'Boolean:false', 'Number:0', 'Number:0', 'Number:0', 'Number:0', 'Number:0', 'Number:0', 'Number:0', 'Number:0'];
			optionalArgumentDefaultValues['flash.events.ContextMenuEvent.ContextMenuEvent'] = ['Boolean:false', 'Boolean:false', 'flash.display.InteractiveObject:null', 'flash.display.InteractiveObject:null'];
		}
	}
}
