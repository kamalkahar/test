---
layout: post
title:  "Publishing and Subscribing with Halcyon"
date:   September 24, 2020
image: assets/img/blog/b2.jpg
categories: jekyll update
tags: ["client", "library", "halcyon", "kotlin", "kotlin-multiplatform", "native", "js", "javascript", "android", "pubsub", "XEP-00600"]
texttag : As you recall, Halcyon is multiplatform XMPP library written in Kotlin
---
<h3>Publishing and Subscribing with Halcyon</h3>

As you recall, Halcyon is multiplatform XMPP library written in Kotlin. In a previous article: 'A look at Halcyon' we had a look at basic concepts in library and we created a simple client.<br>

This time we will dive into more complex stuff. We will create simple solution to monitoring temperature at home :-) In this article we will not focus on measuring temperature. We will create a command-line tool to publish temperature provided as parameter.<br>

First letter in XMPP acronym is from the word 'eXtensible'. There is a lot of extensions for the XMPP protocol. One of them is <a href="https://xmpp.org/extensions/xep-0060.html" style="color:#5a66e8;" target="_blank">XEP-0060: Publish-Subscribe</a> - specification for publish-subscribe functionality. We will use it to create our temperature monitor.<br>

You need to use XMPP Server with PubSub component. You can use your deployment (for example Tigase <a href="https://github.com/tigase/tigase-server/" style="color:#5a66e8;" target="_blank">XMPP Server</a> or use one of the publicly available servers, for example sure.im and its PubSub component pubsub.sure.im. A PubSub node with unique name (to avoid conflicts) will have to be created in the PubSub component. Please note that node created with default configuration is open, which means that everyone can subscribe to it (but only you will be able to publish data there).<br>

<h3>Data structure</h3>
First of all we have to create data structure. In our case, it will be as simple as possible:<br><br>
<b>&lt;temperature timestamp="1597946187562"&gt;23.8&lt;/temperature&gt;</b><br>

timestamp is time represented as a number of milliseconds after January 1, 1970 00:00:00 GMT.<br>

We can use DSL (defined in Halcyon) to create such XML fragment:<br>

<pre><b>val payload = element("temperature") {
attributes["timestamp"] = (Date()).time.toString()
+temperature.toString()
}</b></pre>

<h3>Publisher</h3>

Publisher is a simple XMPP client that connects to the server, sends information to PubSub component and immediately disconnects.<br>

First of all, lets define global values to keep node name and PubSUB JID:<br>

<pre><b>val PUBSUB_JID = "pubsub.tigase.org".toJID()
val PUBSUB_NODE = "temperature_in_my_house"</b></pre>

It cannot be called a good practice, but is good enough for us right now :-)<br>

In the previous article we explained how to create a simple client. Now we will focus on PubSubModule. This module allows publishing and receiving events as well as managing PubSub nodes and subscriptions.<br>

This is the main code that publishes events:<br>

<pre><b>pubSubModule.publish(PUBSUB_JID, PUBSUB_NODE, null, payload).handle {
success { request, iq, result ->
println("YAY! Published with id=${result!!.id}")
}
error { request, iq, errorCondition, s ->
System.err.println("ERROR $errorCondition! $s")
}
}.send()
</b></pre>
But what if the PubSub node does&#8217;t exist (e.g. it was&#8217;t created yet)? It&#8217;s simple: we have to create it using method<br>
create():

The question is&#x3a; under what conditions we should call this part of code and automatically create the node? One of the possibilities would be moment when item publishing fails with error <mark style="background-color&#x3a; &num;f5f2f0;">item-not-found.</mark><br>

<pre><b>
pubSubModule.publish(PUBSUB_JID, PUBSUB_NODE, null, payload).handle {<br>
            success { request, iq, result -><br>
            println("YAY! Published with id=${result!!.id}")<br>    }<br>
            error { request, iq, errorCondition, s -><br>
            if (errorCondition == ErrorCondition.ItemNotFound) {<br>
            println("Node not found! We need to create it!")<br>
            pubSubModule.create(PUBSUB_JID, PUBSUB_NODE).handle {<br>
        success { _&#x3a; IQRequest, _&#x3a; IQ, _&#x3a; Unit? -> println("Got it! Node created!") }<br>
      error { _&#x3a; IQRequest, _&#x3a; IQ?, errorCondition&#x3a; ErrorCondition, msgs&#x3a; String? -><br>
                    println(
                        "OOPS! Cannot create node $errorCondition $msgs"
                    )<br>                } <br>            }.send() <br>        } else System.err.println("ERROR $errorCondition! $s")<br>    }<br>}.send()
                    </b></pre><br>

To simplify the code, publishing will not be repeated after node creation.<br>
It is good to use <mark style="background-color&#x3a; &num;f5f2f0;">client.waitForAllResponses()</mark> before <mark style="background-color&#x3a; &num;f5f2f0;">disconnect()</mark>, to not break connection before all responses comes back.<br>

<h3>Listner</h3>

Listener is also a client (it should works on different account) that subscribes to receiving events from specific nodes of PubSub component. PubSub items received by <mark style="background-color&#x3a; &num;f5f2f0;">PubSubModule</mark> are distributed in the client as <mark style="background-color&#x3a; &num;f5f2f0;">PubSubEventReceivedEvent</mark> in Event Bus. To receive those events you have to register an events listener&#x3a;<br>

<pre><b>

client.eventBus.register(PubSubEventReceivedEvent.TYPE) {
    if (it.pubSubJID == PUBSUB_JID && it.nodeName == PUBSUB_NODE) {
        it.items.forEach { item ->
            val publishedContent = item.getFirstChild("temperature")!!
            val date = Date(publishedContent.attributes["timestamp"]!!.toLong())
            val value = publishedContent.value!!
            println("Received update: $date :: $value<sup>o</sup>C")
        }
    }
}</b></pre>

Note, that this listener will be called on every received PubSub event (like OMEMO keys distribution, PEP events, etc). That&#8217;s why you need to check node name and JabberID of PubSub component.<br>

Your client will not receive anything from PubSub if it does not subscribe to specific node. Because subscription is persistent (at least with default node configuration), client doesn&#8217;t need to subscribe every time it connects to the server. Though, it should be able to check if it&#8217;s subscribed to the specific node or not. For that, you need to retrieve list of subscribers and see if the JabberID of the client is on the list:<br>

<pre><b>
val myOwnJID = client.getModule(BindModule.TYPE)!!.boundJID!!
pubSubModule.retrieveSubscriptions(PUBSUB_JID, PUBSUB_NODE).response {
if (!it.get()!!.any { subscription -> subscription.jid.bareJID == myOwnJID.bareJID })
  {
    println("We have to subscribe")
    pubSubModule.subscribe(PUBSUB_JID, PUBSUB_NODE, myOwnJID).send()
  }
}.send()
</b></pre>

NOTE: In this example we intentionally skipped checking response errors.<br>

PubSub component can keep some history of published elements. We can retrieve that list easily:<br>

<pre><b>
pubSubModule.retrieveItem(PUBSUB_JID, PUBSUB_NODE).response {
    when (it) {
        is IQResult.Success -> {
            println("Previously published temperatures:")
            it.get()!!.items.forEach {
                val date = Date(it.content!!.attributes["timestamp"]!!.toLong())
                val value = it.content!!.value!!
                println(" - $date :: $value<sup>o</sup>C")
            }
        }
        is IQResult.Error -> println("OOPS! Error " + it.error)
    }
}.send()
</b></pre>

Length of the history is defined in node configuration.<br>

<h3>Sample output</h3>

Submitting new temperature in <mark style="background-color&#x3a; &num;f5f2f0;">Publisher </mark>...&#x3a;<br>

<center><img src="{{ site.url }}assets/img/blog/halcyon-pubsub-publisher-run.png" style="width:50%;"><br><br></center><br>

yields receiving notifications in <mark style="background-color&#x3a; &num;f5f2f0;">Listener:</mark><br>

<center><img src="{{ site.url }}assets/img/blog/halcyon-pubsub-listener-listen.png" style="width:50%;"><br><br></center><br>

<h3>Summary</h3>
We presented a simple way to create a PubSub publisher and consumer. You can extend it: for example you can run publisher on Raspberry Pi connected to some meteo-sensors. Possible applications of PubSub component are limited only by your imagination.<br>

All source codes for this article can be found in <a href="https://github.com/tigase/halcyon-examples/tree/master/article-pubsub" style="color:#5a66e8;" target="_blank">GitHub repository</a>.