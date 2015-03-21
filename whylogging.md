# Why another logging framework? #
Of course we know (maybe better than anyone else) that as3commons is just one of many solutions out there to do logging. For us this question is easy: We want a solution without compromises. Our goal is to provide logging so you never need to think about choosing something else. We took our time and feel confident to have some fine piece of software waiting for you. And here is why:

## Performance ##
When we prepared the release 2.0 of the logging framework we built it from ground up new having one main goal: Become the fastest and smallest logging library.

Doing that is not an easy thing! For an idea of the extent we have thought this through, it is better to go into examples:

  * **We use the method signature "info(message:`*`, args:Array=null)" instead of "info(message:`*`, ...args:Array)".**<br>In case you have no parameters to pass its about 10x faster since no array has to be instantiated.<br>
<ul><li><b>We do not create unnecessary object instances during logging.</b><br> There is no <a href='http://help.adobe.com/de_DE/AS3LCR/Flex_4.0/mx/logging/LogEvent.html'>LogEvent</a> class that gets instantiated or polluted. This result in the fact that we need to pass down all properties to targets but its as fast as it gets.<br>
</li><li><b>We do not compare levels!</b><br>A level comparison is quite a bit slower than the null check for a reference. We check each level seperately for its target, therefore we not just have a failsafe but also a very fast way of logging.<br>
</li><li><b>We do not iterate through a list of appenders!</b><br> If you have just one appender (a quite common case) then iterating through a list is overhead. We have a special linked list called <a href='http://as3commons.org/as3-commons-logging/asdoc/index.html?org/as3commons/logging/setup/target/MergedTarget.html&org/as3commons/logging/setup/target/class-list.html'>MergedTarget</a> that sends out log requests at a very high speed in case you need more than one target to send to.<br>
</li><li><b>Most classes are final.</b><br>Final classes are faster than non final ones. We designed our code that most of the classes you will get in touch with are final and stripped down so much that there is no good reason why you would want to extend them.</li></ul>

And that are just the basics. You can find similar, not always intuitive, performance tricks all over the library.<br>
<br>
<h2>Size</h2>
AS3 projects usually run in the web and not just <a href='http://en.wikipedia.org/wiki/JavaScript'>JavaScript</a> libraries need to reduce their carbon footprint. In fact most <a href='http://en.wikipedia.org/wiki/ActionScript#ActionScript_3.0'>ActionScript 3</a> projects transfer much bigger .swfs through our wires.<br>
<br>
We are now at a "silent" configuration size of ~2kb. Other libraries managed to be smaller than as3commons. But we came to the conclusion that it is hard to do that without seriously sacrificing either performance or functionality. Yet we always keep an eye open and if we catch a bit that can be removed here or there, you can be sure it will be gone in the next release.<br>
<br>
To keep the codebase small we make a excessive use of "function" and "constant" files. Many <a href='http://en.wikipedia.org/wiki/ActionScript#ActionScript_3.0'>ActionScript 3</a> developers seem not to be aware of it but constant files are actually Singleton constructs. They are smaller than writing function files.<br>
<br>
As our most prominent example we have <code>LOGGER_FACTORY</code>. Okay, its a little uncommon to use a constant like this, but: In case someone just wants to use the class <code>LoggerFactory</code> then the singleton logic will not be compiled into the final swf and therefore automatically stripped out.<br>
<br>
So: Unless your setup or configuration actually needs a certain part of code, its not included. This helps us keep our library slim and tender!<br>
<br>
<h2>Super-Easy</h2>
Aside from regular access to our loggers, which is very fast and good for developers who know what they do. We also have a simple way to access our logging system.<br>
<br>
With calls like <code>info("hi");</code> you directly have a set of methods that you can use with one measly <code>import org.as3commons.logging.simple.*</code>. This way even designers can use the logging system without bothering too much about performance. And in case you wonder where the log statements are, we even offer a way to display the class/file position for you to find it easily (as it takes quite a bit performance to implement that, its not activated by default).<br>
<br>
We also designed the system in a way that no exceptions are thrown and null references should never be a problem. Setups have to work even if you misstyped something or if some connection is dropped or a process returns null. That way you are a little protected against people to make mistakes with it.<br>
<br>
<h2>Quality to the detail</h2>
What is a framework good for if you could write it in 2 minutes by yourself? There are a couple of details that take a long time to do by yourself.<br>
<br>
Take for example the <code>FirebugTarget</code>: We not just send out a string over the <code>ExternalInterface</code>. Every property that you assigned in your message string is converted to a object so it stays inspectable for you. It took us a while to get there, and very few (if any?) of our competition actually thought that far.<br>
<br>
Aside for well-thought-out implementations, like the former mentioned, we also have a good set of utils that can improve your daily life a lot like the tiny util <code>captureUncaughtErrors(loaderInfo);</code>. Once applied it will send all errors that were not caught by your application to the logging system.<br>
<br>
We have a big set of unit tests for many parts of our libraries. However  - we are humans and errors happen but if they do we usually answer and/or fix bugs <b>within a day</b>.<br>
<br>
Documentation is tough and we are not masters but our asdoc is a lot more thorough than your average flash project. Most classes have meaningful and useful documentation. Take a peek for yourself:<a href='http://as3commons.org/as3-commons-logging/asdoc/index.html'>Online API Docs</a>

<h2>Flexibility in configuration</h2>
Our setup process is quite minimalistic yet offers a great deal of flexibility.<br>
<br>
Within our setup process we have super-low-footprint setups that just propagate to one specific target. Log4j-like systems can be found in our<br>
.swc as well. But to be honest we are much more comfortable with our one process that is far more flexible than this antiquated approach and implemented a regular expression based setup.<br>
<br>
<h2>Integrations</h2>
<b>Outputs</b><br>There are many, awesome logging and debugging panels out there. Therefore we decided to not implement our own panel, instead you can choose out of the box in as3commons of the output panel of your choice, may it be MonsterDebugger, Alcon or Arthropod.<br>
<br>
<b>Independence</b><br>You might wonder why we took the time to implement connectors to so many other logging frameworks. Well the reason is simple. You might use one or another framework right now, and to make it easy for you to catch all those other frameworks we created targets in both directions. That way you can use the configuration in as3commons or in the logging framework of your choice. We already offer connections to all the big players in the flash market like Flex or Swizframework.<br>
<br>
<h2>Future</h2>
Sure, we are not yet were we want to be. There are a lot of ideas how to make this system better. Some of our plan you can find in our issue tracker <a href='http://code.google.com/p/as3-commons/issues/list?can=2&q=label%3ASubProject-logging%20label%3AType-Enhancement'>Future Enhancements</a> I you have any idea or want to help, feel free to contact us.