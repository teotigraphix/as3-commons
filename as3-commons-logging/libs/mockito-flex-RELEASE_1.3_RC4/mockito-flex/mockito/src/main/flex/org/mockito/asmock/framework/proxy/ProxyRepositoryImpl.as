package org.mockito.asmock.framework.proxy
{
	import org.mockito.asmock.util.ClassUtility;
	import org.mockito.asmock.framework.util.MethodUtil;
	import org.mockito.asmock.reflection.Type;
	
	import flash.display.Loader;
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import org.mockito.flemit.framework.*;
	import org.mockito.flemit.framework.bytecode.*;
	import org.mockito.flemit.framework.tags.*;
	
	[ExcludeClass]
	public class ProxyRepositoryImpl implements IProxyRepository
	{
		private var _proxyGenerator : ProxyGenerator;

		private var _proxies : Dictionary;
		
		private var _loaders : Array;
		
		public function ProxyRepositoryImpl()
		{
			_proxyGenerator = new ProxyGenerator();
			
			_loaders = new Array();
			_proxies = new Dictionary();
		}
		
		public function create(cls : Class, args : Array, interceptor : IInterceptor) : Object
		{
			var proxyClass : Class = _proxies[cls];
			
			if (proxyClass == null)
			{
				throw new ArgumentError("A proxy for " + getQualifiedClassName(cls) + " has not been prepared yet"); 
			}
			
			var proxyListener : IProxyListener = new InterceptorProxyListener(interceptor);
			
			var constructorArgCount : int = Type.getType(proxyClass).constructor.parameters.length;
			var constructorRequiredArgCount : int = MethodUtil.getRequiredArgumentCount(Type.getType(proxyClass).constructor);
			
			args = args.concat([]);
			args.unshift(proxyListener);
			
			if (args.length > ClassUtility.MAX_CREATECLASS_ARG_COUNT)
			{
				if (args.length != constructorArgCount)
				{
					throw new ArgumentError("Constructors with more than " + ClassUtility.MAX_CREATECLASS_ARG_COUNT + " arguments must supply the exact number of arguments (including optional).");
				}
				
				var createMethod : Function = proxyClass[ProxyGenerator.CREATE_METHOD];
			
				return createMethod.apply(proxyClass, args) as Object;
			}
			else
			{
				if (args.length < constructorRequiredArgCount)
				{
					throw new ArgumentError("Incorrect number of constructor arguments supplied.");
				}
				
				return ClassUtility.createClass(proxyClass, args);
			}
		}
		
		public function prepare(types : Array, applicationDomain : ApplicationDomain = null) : IEventDispatcher
		{
			applicationDomain = applicationDomain || ApplicationDomain.currentDomain;
			
			//applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			applicationDomain = ApplicationDomain.currentDomain;
			
			types = types.filter(typeAlreadyPreparedFilter);
			
			if (types.length == 0) 
			{
				return new CompletedEventDispatcher();
			}
			
			var dynamicClasses : Array = new Array();
			
			var layoutBuilder : IByteCodeLayoutBuilder = new ByteCodeLayoutBuilder();
			
			var generatedNames : Dictionary = new Dictionary();
			
			for each(var cls : Class in types)
			{
				var type : Type = Type.getType(cls);
				
				if (type.isGeneric || type.isGenericTypeDefinition)
				{
					throw new IllegalOperationError("Generic types (Vector) are not supported. (feature request #2599097)");
				}
				
				if (type.qname.ns.kind != NamespaceKind.PACKAGE_NAMESPACE)
				{
					throw new IllegalOperationError("Private (package) classes are not supported. (feature request #2549289)");
				}
				
				var qname : QualifiedName = generateQName(type);
				
				generatedNames[cls] = qname;

				var dynamicClass : DynamicClass = (type.isInterface)
					? _proxyGenerator.createProxyFromInterface(qname, [type])
					: _proxyGenerator.createProxyFromClass(qname, type, []);

				layoutBuilder.registerType(dynamicClass);
			}
			
			var layout : IByteCodeLayout = layoutBuilder.createLayout();
			
			var loader : Loader = createSwf(layout, applicationDomain);
			_loaders.push(loader);			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoadedHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, swfErrorHandler);
			loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, swfErrorHandler);
			
			var eventDispatcher : EventDispatcher = new EventDispatcher();
			
			return eventDispatcher;
			
			function swfErrorHandler(error : ErrorEvent) : void
			{
				trace("Error generating swf: " + error.text);
				
				eventDispatcher.dispatchEvent(error);
			}
			
			function swfLoadedHandler(event : Event) : void
			{
				for each(var cls : Class in types)
				{
					var qname : QualifiedName = generatedNames[cls];
					
					var fullName : String = qname.ns.name.concat('::', qname.name); 
					
					var generatedClass : Class = loader.contentLoaderInfo.applicationDomain.getDefinition(fullName) as Class;
					
					Type.getType(generatedClass);
					
					_proxies[cls] = generatedClass;
				}
				
				eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function createSwf(layout : IByteCodeLayout, applicationDomain : ApplicationDomain) : Loader
		{
			var buffer : ByteArray = new ByteArray();
			
			var header : SWFHeader = new SWFHeader(10);
			
			var swfWriter : SWFWriter = new SWFWriter();
				
			swfWriter.write(buffer, header, [
					FileAttributesTag.create(false, false, false, true, true),
					new ScriptLimitsTag(),
					new SetBackgroundColorTag(0xFF, 0x0, 0x0),
					new FrameLabelTag("ProxyFrameLabel"),
					new DoABCTag(false, "ProxyGenerated", layout),
					new ShowFrameTag(),
					new EndTag()
			]);
			
			/* buffer.position = 0;
			trace(ByteArrayUtil.toString(buffer, 0)); */	
			
			buffer.position = 0;
			
			var loaderContext : LoaderContext = new LoaderContext(false, applicationDomain);
			
			// Needed for AIR
			if (loaderContext.hasOwnProperty("allowLoadBytesCodeExecution"))
			{
				loaderContext["allowLoadBytesCodeExecution"] = true;
			}
			
			var loader : Loader = new Loader();
			loader.loadBytes(buffer, loaderContext);
			
			return loader;
		}
		
		private function generateQName(type : Type) : QualifiedName
		{
			var ns : BCNamespace = (type.qname.ns.kind != NamespaceKind.PACKAGE_NAMESPACE)
				? type.qname.ns
				: BCNamespace.packageNS("asmock.generated");
			
			return new QualifiedName(ns, type.name + GUID.create());
		}
		
		private function typeAlreadyPreparedFilter(cls : Class, index : int, array : Array) : Boolean
		{
			return (_proxies[cls] == null);
		}
	}
}
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	

class CompletedEventDispatcher extends EventDispatcher
{
	public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
	{
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		
		if (type == Event.COMPLETE)
		{
			dispatchEvent(new Event(Event.COMPLETE));
			
			super.removeEventListener(type, listener, useCapture);
		}
	}
}