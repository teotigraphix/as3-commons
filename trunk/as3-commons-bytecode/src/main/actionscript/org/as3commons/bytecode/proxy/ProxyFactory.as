package org.as3commons.bytecode.proxy {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.bytecode.emit.impl.AbcBuilder;
	import org.as3commons.bytecode.reflect.ByteCodeAccessor;
	import org.as3commons.bytecode.reflect.ByteCodeMethod;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.reflect.ByteCodeVariable;
	import org.as3commons.bytecode.util.MultinameUtil;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;

	public class ProxyFactory extends EventDispatcher implements IProxyFactory {

		private static const CHARACTERS:String = "abcdefghijklmnopqrstuvwxys";
		private var _abcBuilder:IAbcBuilder;
		private var _domains:Dictionary;

		public function ProxyFactory() {
			super();
			initProxyFactory();
		}

		protected function initProxyFactory():void {
			_abcBuilder = new AbcBuilder();
			_domains = new Dictionary();
		}

		protected function generateSuffix():String {
			var len:int = 20;
			var result:Array = new Array(20);
			while (len--) {
				result[len] = CHARACTERS.charAt(Math.floor(Math.random() * 26));
			}
			return result.join('');
		}

		public function defineProxy(proxiedClass:Class, methodInvocationInterceptorClass:Class = null, applicationDomain:ApplicationDomain = null):ClassProxyInfo {
			applicationDomain = (applicationDomain != null) ? applicationDomain : ApplicationDomain.currentDomain;
			if (_domains[applicationDomain] == null) {
				_domains[applicationDomain] = [];
			}
			var infos:Array = _domains[applicationDomain] as Array;
			var info:ClassProxyInfo = new ClassProxyInfo(proxiedClass, methodInvocationInterceptorClass);
			infos[infos.length] = info;
			return info;
		}

		public function loadProxies(applicationDomain:ApplicationDomain = null):void {
			for (var domain:* in _domains) {
				var infos:Array = _domains[domain] as Array;
				for each (var info:ClassProxyInfo in infos) {
					buildProxy(info, domain);
				}
			}
		}

		protected function buildProxy(classProxyInfo:ClassProxyInfo, applicationDomain:ApplicationDomain):void {
			var className:String = ClassUtils.getFullyQualifiedName(classProxyInfo.proxiedClass);
			if (classProxyInfo.proxyAll == true) {
				reflectMembers(classProxyInfo, className, applicationDomain);
			}
			var classParts:Array = className.split(MultinameUtil.DOUBLE_COLON);
			var packageBuilder:IPackageBuilder = _abcBuilder.definePackage(classParts[0] + MultinameUtil.PERIOD + generateSuffix());
			packageBuilder.defineClass(classParts[1], className);
		}

		protected function reflectMembers(classProxyInfo:ClassProxyInfo, className:String, applicationDomain:ApplicationDomain):void {
			var type:Type;
			if (ByteCodeType.getTypeProvider().getTypeCache().contains(className)) {
				type = ByteCodeType.forName(className, applicationDomain);
			} else {
				type = Type.forName(className, applicationDomain);
			}
			var isProtected:Boolean;
			var vsb:NamespaceKind;
			for each (var method:Method in type.methods) {
				isProtected = false;
				if (method is ByteCodeMethod) {
					vsb = ByteCodeMethod(method).visibility;
					if (!isPublicOrProtected(vsb)) {
						return;
					}
					isProtected = (vsb === NamespaceKind.PROTECTED_NAMESPACE);
				}
				classProxyInfo.proxyMethod(method.name, method.namespaceURI, isProtected);
			}
			for each (var accessor:Accessor in type.accessors) {
				isProtected = false;
				if (accessor is ByteCodeAccessor) {
					vsb = ByteCodeAccessor(accessor).visibility;
					if (!isPublicOrProtected(vsb)) {
						return;
					}
					isProtected = (vsb === NamespaceKind.PROTECTED_NAMESPACE);
				}
				classProxyInfo.proxyAccessor(accessor.name, accessor.namespaceURI, isProtected);
			}
			for each (var variable:Variable in type.variables) {
				isProtected = false;
				if (variable is ByteCodeVariable) {
					vsb = ByteCodeVariable(variable).visibility;
					if (!isPublicOrProtected(vsb)) {
						return;
					}
					isProtected = (vsb === NamespaceKind.PROTECTED_NAMESPACE);
				}
				classProxyInfo.proxyProperty(variable.name, variable.namespaceURI, isProtected);
			}
		}

		protected function isPublicOrProtected(vsb:NamespaceKind):Boolean {
			return ((vsb !== NamespaceKind.PACKAGE_NAMESPACE) && (vsb !== NamespaceKind.PROTECTED_NAMESPACE));
		}

	}
}