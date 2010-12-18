package org.as3commons.bytecode.proxy {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.bytecode.emit.impl.AbcBuilder;
	import org.as3commons.lang.ClassUtils;

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
			var classParts:Array = className.split('::');
			var packageBuilder:IPackageBuilder = _abcBuilder.definePackage(classParts[0] + '.' + generateSuffix());
			packageBuilder.defineClass(classParts[1], className);
		}
	}
}