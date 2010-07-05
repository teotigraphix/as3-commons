package org.mockito.asmock.framework {
	import org.mockito.asmock.StubOptions;
	import org.mockito.asmock.framework.expectations.IExpectation;
	import org.mockito.asmock.framework.impl.IMethodRecorder;
	import org.mockito.asmock.framework.impl.IMockState;
	import org.mockito.asmock.framework.impl.IRecordMockState;
	import org.mockito.asmock.framework.impl.MockedObject;
	import org.mockito.asmock.framework.impl.dynamicMock.DynamicRecordMockState;
	import org.mockito.asmock.framework.impl.strict.StrictRecordMockState;
	import org.mockito.asmock.framework.impl.stub.StubRecordMockState;
	import org.mockito.asmock.framework.methodRecorders.OrderedMethodRecorder;
	import org.mockito.asmock.framework.methodRecorders.ProxyMethodExpectationsDictionary;
	import org.mockito.asmock.framework.methodRecorders.UnorderedMethodRecorder;
	import org.mockito.asmock.framework.proxy.IInterceptor;
	import org.mockito.asmock.framework.proxy.IInvocation;
	import org.mockito.asmock.framework.proxy.IProxyRepository;
	import org.mockito.asmock.framework.proxy.ProxyRepositoryImpl;
	import org.mockito.asmock.reflection.MethodInfo;
	import org.mockito.asmock.reflection.PropertyInfo;
	import org.mockito.asmock.reflection.Type;
	import org.mockito.asmock.util.StringBuilder;

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	use namespace asmock_internal;
	
	/**
	 * Creates and manages mock objects 
	 * @author Richard Szalay 
	 */	
	public class MockRepository
	{
		private var _repeatableMethods : ProxyMethodExpectationsDictionary;
		
		private var _mockObjects : Array = new Array();
		private var _mockObjectStates : Dictionary = new Dictionary();
		private var _stubbedPropertyValues : Dictionary = new Dictionary(true);
		private var _stubbedProperties : Dictionary = new Dictionary(true);
		
		private var _recorders : Array;
		private var _proxyRepository : IProxyRepository;
		
		private static var _defaultProxyRepository : IProxyRepository = new ProxyRepositoryImpl();
		private static var _proxyMockRepositories : Dictionary = new Dictionary(true);
		
		/**
		 * Gets or sets the last used MockRepository
		 * @private
		 */
		[Exclude]
		asmock_internal static var lastRepository : MockRepository;
		
		private var _lastMockedObject : Object;
		
		/**
		 * @private
		 */
		public function get lastMockedObject() : Object { return _lastMockedObject; }
		
		/**
		 * @private
		 */
		public function set lastMockedObject(value : Object) : void { _lastMockedObject = value; }
		
		/**
		 * Creates a new instance of MockRepository, which will track 
		 * the state of mocks it creates through createStub, createDynamic,
		 * and createStrict.
		 * @param proxyRepository Optionally provides the proxy repository to 
		 * use for preparation/creation of mocks. If null, uses 
		 * MockRepository.defaultProxyRepository, which is shared across all instances 
		 * of MockRepository.
		 */
		public function MockRepository(proxyRepository : IProxyRepository = null)
		{
			_proxyRepository = proxyRepository || _defaultProxyRepository;
			_recorders = new Array();
			
			_repeatableMethods = new ProxyMethodExpectationsDictionary();
			_recorders.push(new UnorderedMethodRecorder(_repeatableMethods));
		}
		
		/**
		 * Asynchronously prepares mocks of the classes and interfaces 
		 * supplied in the classes argument. Objects cannot be mocked until they 
		 * have been prepared.  
		 * 
		 * <p>Users of supported <a href="http://asmock.sourceforge.net/integration.htm" target="_blank">testing frameworks</a> 
		 * can use an example base class to skip this step.</p>
		 * @param classes A list of classes to be prepared (separately) for mocking
		 * @return An IEventDispatcher that will dispatch the Event.COMPLETE event
		 * when it is finished.
		 * @includeExample MockRepository_prepare.as
		 * 
		 */		
		public function prepare(classes : Array) : IEventDispatcher
		{
			var applicationDomain : ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			
			return _proxyRepository.prepare(classes, applicationDomain);
		}
		
		/**
		 * Creates an instance of the mock for the class specified by 
		 * cls. The class supplied must be prepared by using the prepare 
		 * method, or by using an <a href="http://asmock.sourceforge.net/integration.htm">framework 
		 * integration</a> class.
		 * @param cls The class or interface to create a mock for
		 * @return An instance of the type specified by cls
		 * @throws ArgumentException Thrown if cls has not been prepared
		 * @see prepare
		 */		
		[Deprecated(replacement="createStrict")]
		public function create(cls : Class, args : Array = null) : Object
		{
			return createStrict(cls, args);
		}
		
		/**
		 * Creates an instance of the mock for the class specified by 
		 * cls. The class supplied must be prepared by using the prepare 
		 * method, or by using an <a href="http://asmock.sourceforge.net/integration.htm">framework 
		 * integration</a> class. Strict mocks throw ExpectationViolationError errors when an unexpected
		 * method occurs (one that hasn't been setup using SetupResult.forCall or Expect.call). 
		 * @param cls The class or interface to create a mock for
		 * @return An instance of the type specified by cls
		 * @throws ArgumentException Thrown if cls has not been prepared
		 * @see prepare
		 */
		public function createStrict(cls : Class, constructorArguments : Array = null) : Object
		{
			constructorArguments = constructorArguments || [];
			
			var mockObject : IMockedObject = new MockedObject();
			
			var interceptor : IInterceptor = new ASMockInterceptor(this, mockObject);
			
			var obj : Object = _proxyRepository.create(cls, constructorArguments, interceptor);
			
			_mockObjects.push(obj);
			_mockObjectStates[obj] = new StrictRecordMockState(obj, this);
			
			return obj;
		}
		
		/**
		 * Creates an instance of the mock for the class specified by 
		 * cls. The class supplied must be prepared by using the prepare 
		 * method, or by using an <a href="http://asmock.sourceforge.net/integration.htm">framework 
		 * integration</a> class. Dynamic mocks call the original method when an 
		 * method occurs (one that hasn't been setup using SetupResult.forCall or Expect.call).  
		 * For this reason, createDynamic can only be used with concrete classes (not interfaces).
		 * @param cls The class or interface to create a mock for
		 * @return An instance of the type specified by cls
		 * @throws ArgumentException Thrown if cls has not been prepared
		 * @see prepare
		 */
		public function createDynamic(cls : Class, constructorArguments : Array = null) : Object
		{
			if (Type.getType(cls).isInterface)
			{
				throw new ArgumentError("dynamic mocks can only be created for concrete classes. Use createStrict or createStub");
			}
			
			constructorArguments = constructorArguments || [];
			
			var mockObject : IMockedObject = new MockedObject();
			
			var interceptor : IInterceptor = new ASMockInterceptor(this, mockObject);
			
			var obj : Object = _proxyRepository.create(cls, constructorArguments, interceptor);
			
			_mockObjects.push(obj);
			_mockObjectStates[obj] = new DynamicRecordMockState(obj, this);
			
			return obj;
		}
		
		/**
		 * Creates an instance of the mock for the class specified by 
		 * cls. The class supplied must be prepared by using the prepare 
		 * method, or by using an <a href="http://asmock.sourceforge.net/integration.htm">framework 
		 * integration</a> class. Dynamic mocks call the original method when an 
		 * method occurs (one that hasn't been setup using SetupResult.forCall or Expect.call).  
		 * For this reason, createDynamic can only be used with concrete classes (not interfaces).
		 * @param cls The class or interface to create a mock for
		 * @param stubOptions Specifies whether to stub properties or events. Defaults to StubOptions.All (both properties and events)
		 * @param constructorArguments The arguments to pass to the concrete class's constructor (can be left null when stubbing interfaces)
		 * @return An instance of the type specified by cls
		 * @throws ArgumentException Thrown if cls has not been prepared
		 * @see prepare
		 */
		public function createStub(cls : Class, stubOptions : StubOptions = null, constructorArguments : Array = null) : Object
		{
			constructorArguments = constructorArguments || [];
			
			stubOptions = stubOptions || StubOptions.ALL;
			
			var mockObject : IMockedObject = new MockedObject();
			
			var interceptor : IInterceptor = new ASMockInterceptor(this, mockObject);
			
			var obj : Object = _proxyRepository.create(cls, constructorArguments, interceptor);
			
			_mockObjects.push(obj);
			_mockObjectStates[obj] = new StubRecordMockState(obj, this);
			
			if (stubOptions.stubProperties)
			{
				stubAllProperties(obj);
			}
			
			if (stubOptions.stubEvents)
			{
				var eventDispatcher : IEventDispatcher = obj as IEventDispatcher;
				
				if (eventDispatcher != null)
				{
					stubEvents(eventDispatcher);
				}
			}
			
			return obj;
		}
		
		private function createRecordMockState(mockObj : Object) : IMockState
		{
			return new StrictRecordMockState(mockObj, this);
		}
		
		private function createDynamicRecordMockState(mockObj : Object) : IMockState
		{
			throw new IllegalOperationError("Not implemented");
			//return new DynamicRecordMockState(mockObj);
		}
		
		private function createStubRecordMockState(mockObj : Object) : IMockState
		{
			throw new IllegalOperationError("Not implemented");
			//return new StubRecordMockState(mockObj);
		}
		
		/**
		 * Registers a method call from a mock object 
		 * @param invocation The current method invocation
		 * @param target The object the invocation was made on
		 * @param method The method represented by the invocation
		 * @param arguments The arguments sent to the method 
		 * @return The value to return from the method
		 * @private
		 */
		asmock_internal function methodCall(invocation : IInvocation, target : Object, method : MethodInfo, arguments : Array) : *
		{
			if (invocation.property != null && isPropertyStubbed(target, invocation.property.name))
			{
				if (arguments.length > 0)
				{
					this.asmock_internal::setMockProperty(target, invocation.property.name, arguments[0]);
					return null;
				}
				else
				{
					return this.asmock_internal::getMockProperty(target, invocation.property.name);
				}
			}
			
			var state : IMockState = _mockObjectStates[target];
			
			if (state == null)
			{
				throw new ArgumentError("The supplied object is not a mock object");
			}
			
			return state.methodCall(invocation, method, arguments);
		}
		
		/**
		 * Sets the mock object into replay mode. All further method calls on the 
		 * object will be matched against any recorded expectations.
		 * @param mock The object to set to replay 
		 */		
		public function replay(mock : Object) : void
		{
			replayCore(mock, true);
		}
		
		private function replayCore(mock : Object, checkInsideOrdering : Boolean) : void
		{
			if (checkInsideOrdering)
			{
				if (this._recorders.length > 1)				
				{
					throw new IllegalOperationError("Cannot replay within an ordered() or unordered() call");
				}
			}
			
			isMockObjectFromThisRepository(mock);
			
			_mockObjectStates[mock] = IMockState(_mockObjectStates[mock]).replay();
		}
		
		/**
		 * Sets all mock objects created by this repository into replay mode. 
		 * All further calls on any mock object will be matched against 
		 * any recorded expectations.
		 */
		public function replayAll() : void
		{
			//for (var mockStar : * in _mockObjectStates)
			for each(var mock : Object in _mockObjects) 
			{
				//var mock : Object = mockStar as Object;
				
				if (_mockObjectStates[mock].canReplay)
				{
					replay(mock as Object);
				}
			}
		}
		
		/**
		 * Moves the specified mock object back into record mode. Further 
		 * calls to the object will be recorded as expectations.
		 * @param mock The object to move to record
		 */
		public function backToRecord(mock : Object) : void
		{
			isMockObjectFromThisRepository(mock);
			
			var rootRecorder : IMethodRecorder = IMethodRecorder(_recorders[0]);
			
			for each(var expectation : IExpectation in rootRecorder.getAllExpectationsForProxy(mock))
			{
				rootRecorder.removeExpectation(expectation);				
			}
			
			rootRecorder.removeAllRepeatableExpectationsForProxy(mock);
			
			_mockObjectStates[mock] = IMockState(_mockObjectStates[mock]).backToRecord();
		}
		
		/**
		 * Moves all mock objects created by this repository back into 
		 * record mode. Further calls to the object will be recorded 
		 * as expectations. Any previous expectations on the objects are not cleared.
		 */
		public function backToRecordAll() : void
		{
			//for (var mockStar : * in _mockObjectStates)
			for each(var mock : Object in _mockObjects) 
			{
				//replay(mockStar as Object);
				replay(mock);
			}
		}
		
		/**
		 * Verifies that all expectations on the specified mock object 
		 * have been satisfied. This method (or verifyAll) should be 
		 * called at the end of each test. 
		 * @param mock The mock object to verify.
		 * @throws ExpectationViolationException Thrown if any expectation has not been satisfied.
		 */		
		public function verify(mock : Object) : void
		{
			isMockObjectFromThisRepository(mock);
			
			try
			{
				IMockState(_mockObjectStates[mock]).verify();
			}
			finally
			{
				_mockObjectStates[mock] = IMockState(_mockObjectStates[mock]).verifyState;
			}
		}
		
		/**
		 * Verifies that all expectations on all mock objects 
		 * created by this repository have been satisfied. 
		 * This method (or verify) should be called at the 
		 * end of each test.
		 * @throws ExpectationViolationException Thrown if any expectation has not been satisfied.
		 */		
		public function verifyAll() : void
		{
			var errorMessage : StringBuilder = new StringBuilder();
			
			//for (var mockStar : * in _mockObjectStates)
			for each (var mock : Object in _mockObjects)
			{
				//var mock : Object = mockStar as Object;
				
				if (_mockObjectStates[mock].canVerify)
				{
					try
					{
						this.verify(mock);
					}
					catch(err : ExpectationViolationError)
					{
						errorMessage.appendLine(err.message);
					}
				}
			}
			
			if (errorMessage.length > 0)
			{
				throw new ExpectationViolationError(errorMessage.toString());
			}
		}
		
		/**
		 * Changes the mode to ordered during the execution of the callback function. 
		 * @param callback The function that contains all the calls to record as ordered expectations
		 * @includeExample MockRepository_ordered.as
		 */		
		public function ordered(callback : Function) : void
		{
			var newRecorder : IMethodRecorder = new OrderedMethodRecorder(this._repeatableMethods, this.asmock_internal::recorder);
			this.asmock_internal::recorder.addRecorder(newRecorder);
			this.pushRecorder(newRecorder);
			
			try
			{
				callback();
			}
			finally
			{
				this.asmock_internal::recorder.moveToPreviousRecorder();
				this.popRecorder();
			}
		}
		
		/**
		 * Changes the mode to unordered during the execution of the callback function. The default 
		 * mode is unordered, so this call is only necessary to include unordered expectations while 
		 * in ordered mode. 
		 * @param callback The function that contains all the calls to record as unordered expectations
		 * @includeExample MockRepository_unordered.as
		 */	
		public function unordered(callback : Function) : void
		{
			var currentRecorder : IMethodRecorder = this.asmock_internal::recorder;
			var newRecorder : IMethodRecorder = new UnorderedMethodRecorder(this._repeatableMethods, currentRecorder);
			currentRecorder.addRecorder(newRecorder);
			this.pushRecorder(newRecorder);
			
			try
			{
				callback();
			}
			finally
			{
				currentRecorder.moveToPreviousRecorder();
				this.popRecorder();
			}
		}
		
		private function pushRecorder(newRecorder : IMethodRecorder) : void
		{
			_recorders.push(newRecorder);
		}
		
		private function popRecorder() : void
		{
			if (_recorders.length > 1)
			{
				_recorders.pop();
			}
		}
		
		
		
		/**
		 * @private
		 */
		[Exclude]
		asmock_internal function get recorder() : IMethodRecorder
		{
			return _recorders[_recorders.length - 1] as IMethodRecorder;
		}
		
		/**
		 * @private
		 */
		[Exclude]
		asmock_internal function get replayer() : IMethodRecorder
		{
			return _recorders[0] as IMethodRecorder;
		}
		
		/**
		 * @private
		 */
		[Exclude]
		asmock_internal function lastMethodCall(mockedInstance : Object) : IMethodOptions
		{
			this.isMockObjectFromThisRepository(mockedInstance);
			
			return IMockState(this._mockObjectStates[mockedInstance]).getLastMethodOptions();
		}
		
		/**
		 * Determines whether the property, specified by name, has already been stubbed. 
		 * @param mock The object, created by one of the create methods, that contains the property
		 * @param propertyName The name of the property to check 
		 * @includeExample MockRepository_stubProperty.as
		 */
		public function isPropertyStubbed(mock : Object, propertyName : String) : Boolean
		{
			isMockObjectFromThisRepository(mock);
			
			return getStubbedProperties(mock)[propertyName] as Boolean;
		}
		
		/**
		 * Stubs the property, specified with an actual call to the property, so that 
		 * it's value can be assigned/retrieved. After calling stubProperty, no expectations 
		 * can be made on it.
		 * @param notUsed The actual property (not it's name) of the property to stub
		 * @includeExample MockRepository_stubProperty.as
		 */
		public function stubProperty(notUsed : *) : void
		{
			var mock : Object = _lastMockedObject;
			
			if (mock == null)
			{
				throw new IllegalOperationError("Value passed to stubProperty was not a property or did not belong to an object created by this repository");
			}
			
			var recordMockState : IRecordMockState = 
				_mockObjectStates[mock] as IRecordMockState;
			
			if (recordMockState == null)
			{
				throw new IllegalOperationError("Cannot stub properties after replay");
			}
			
			var lastExpectation : IExpectation = recordMockState.lastExpectation; 
			
			if (lastExpectation == null ||
				lastExpectation.originalInvocation.property == null)
			{
				throw new IllegalOperationError("Value passed to stubProperty was not a property or did not belong to an object created by this repository"); 
			}
			
			var propertyName : String = lastExpectation.originalInvocation.property.name;
			
			asmock_internal::recorder.removeExpectation(lastExpectation);
			recordMockState.lastExpectation = null;
			
			stubPropertyByName(mock, propertyName);
		}
		
		/**
		 * Stubs the property, specified by it's name, so that 
		 * it's value can be assigned/retrieved. After calling stubPropertyByName, no expectations 
		 * can be made on that property.
		 * @param notUsed The name of the property to stub
		 * @includeExample MockRepository_stubPropertyByName.as
		 */
		public function stubPropertyByName(mock : Object, propertyName : String) : void
		{
			isMockObjectFromThisRepository(mock);
			
			var property : PropertyInfo = Type.getType(mock).getProperty(propertyName, false);
			
			if (property == null)
			{
				throw new ArgumentError("Supplied object does not contain a property named '" + propertyName + "'");
			}
			
			if (!isPropertyValidForStubbing(property))
			{
				throw new ArgumentError("Cannot stub property '" + propertyName + "' because it is not read/write");
			}
			
			var stubbedProperties : Dictionary = getStubbedProperties(mock);
			
			if (stubbedProperties[propertyName] == true) 
			{
				throw new IllegalOperationError("Property '" + propertyName + "' is already stubbed");
			}
						
			stubbedProperties[propertyName] = true;
			getStubbedPropertyValues(mock)[propertyName] = null;
		}
		
		/**
		 * Stubs all the properties on the specified mock so each property's value  
		 * value can be assigned/retrieved. After calling stubAllProperties, no expectations 
		 * can be made on any of the mock's properties.
		 * @param notUsed The name of the property to stub
		 * @includeExample MockRepository_stubPropertyByName.as
		 */
		public function stubAllProperties(mock : Object) : void
		{
			isMockObjectFromThisRepository(mock);
			
			var properties : Array = Type.getType(mock).getProperties(false, true);
			
			for each(var property : PropertyInfo in properties)
			{
				var isValidProperty : Boolean = isPropertyValidForStubbing(property);
				
				if (isValidProperty && !isPropertyStubbed(mock, property.name))
				{
					this.stubPropertyByName(mock, property.name);
				}
			}
		}
		
		/**
		 * @private
		 */
		[Exclude]
		asmock_internal function getMockProperty(mock : Object, propertyName : String) : Object
		{
			isMockObjectFromThisRepository(mock);
			
			return getStubbedPropertyValues(mock)[propertyName]; 
		}
		
		/**
		 * @private
		 */
		[Exclude]
		asmock_internal function setMockProperty(mock : Object, propertyName : String, propertyValue : Object) : void
		{
			isMockObjectFromThisRepository(mock);
			
			getStubbedPropertyValues(mock)[propertyName] = propertyValue; 
		}
		
		private function getStubbedProperties(mock : Object) : Dictionary
		{
			var properties : Dictionary = _stubbedProperties[mock];
			
			if (properties == null)
			{
				properties = new Dictionary(true);
				_stubbedProperties[mock] = properties;
			}
			
			return properties;
		}
		
		private function isPropertyValidForStubbing(property : PropertyInfo) : Boolean
		{
			return property.canRead && property.canWrite;
		}
		
		private function getStubbedPropertyValues(mock : Object) : Dictionary
		{
			var properties : Dictionary = _stubbedPropertyValues[mock];
			
			if (properties == null)
			{
				properties = new Dictionary(true);
				_stubbedPropertyValues[mock] = properties;
			}
			
			return properties;
		}
		
		/**
		 * Stubs all the IEventDispatcher events to a real event dispatcher so that 
		 * events are wired up. After using this method, expectations cannot be put on 
		 * IEventDispatcher methods.
		 * @param eventDispatcher The IEventDispatcher mock to handle IEventDispatcher methods for
		 * @includeExample MockRepository_stubEvents.as
		 */
		public function stubEvents(eventDispatcher : IEventDispatcher) : void
		{
			var dispatcherProxy : EventDispatcher = new EventDispatcher(eventDispatcher);
			
			SetupResult.forCall(eventDispatcher.addEventListener(null, null, false, 0, false))
				.ignoreArguments().doAction(function(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void    
			{
				dispatcherProxy.addEventListener(type, listener, useCapture, priority, useWeakReference);
			});
			
			SetupResult.forCall(eventDispatcher.removeEventListener(null, null, false))
				.ignoreArguments().doAction(function(type : String, listener : Function, useCapture : Boolean = false) : void    
			{
				dispatcherProxy.removeEventListener(type, listener, useCapture);
			});
			
			SetupResult.forCall(eventDispatcher.dispatchEvent(null))
				.ignoreArguments().doAction(function(event : Event) : Boolean    
			{
				return dispatcherProxy.dispatchEvent(event);
			});
			
			SetupResult.forCall(eventDispatcher.hasEventListener(null))
				.ignoreArguments().doAction(function(type : String) : Boolean    
			{
				return dispatcherProxy.hasEventListener(type);
			});
			
			SetupResult.forCall(eventDispatcher.willTrigger(null))
				.ignoreArguments().doAction(function(type : String) : Boolean    
			{
				return dispatcherProxy.willTrigger(type);
			});
		}
		
		private function isMockObjectFromThisRepository(obj : Object) : void
		{
			if (_mockObjectStates[obj] == null)
			{
				throw new MockError("The object is not a mock object created by this repository");
			}
		}
		
		/**
		 * @private
		 */
		[Exclude]
		asmock_internal static function setVerifyError(proxy : Object, error : Error) : void
		{
			var repository : MockRepository = _proxyMockRepositories[proxy];
			
			if (repository != null)
			{
				var state : IMockState = repository._mockObjectStates[proxy] as IMockState;
			
				if (state != null)
				{
					state.setVerifyError(error);
				}
			}
		}
		
		public static function get defaultProxyRepository() : IProxyRepository
		{
			return _defaultProxyRepository;
		}
	}
}