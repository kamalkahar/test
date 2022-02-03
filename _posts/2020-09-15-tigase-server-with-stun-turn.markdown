---
layout: post
title:  "Using STUN & TURN server with Tigase XMPP Server with XEP-0215 (External Service Discovery)"
date:   September 15, 2020
image: assets/img/blog/b3.jpg
categories: jekyll update
tags: ["server", "installation", "stun", "turn", "audio-video", "calls", "VOIP"]
texttag : Communication with your family and
---
Communication with your family and friends is not only about instant chats. Audio and Video calls are quite important and sometimes, under unfavourable network configurations establishing a call may prove difficult. Luckily, with the help of <a href="https://en.wikipedia.org/wiki/STUN" style="color:#5a66e8;" target="_blank">STUN (Session Traversal Utilities for NAT)</a> and <a href="https://en.wikipedia.org/wiki/Traversal_Using_Relays_around_NAT" style="color:#5a66e8;" target="_blank">TURN (Traversal Using Relays around NAT)</a> servers it&#8217;s no longer a problem

In the following guide we will show how to setup TURN and STUN servers with Tigase XMPP Server, so that compatible XMPP clients will be able to use them. Our <a href="https://xmpp.cloud/" style="color:#5a66e8;" target="_blank">xmpp.cloud installation</a> supports not only them, but also <a href="https://tigase.net/tigase-im-mix/" style="color:#5a66e8;" target="_blank">XMPP MIX</a>

<h3><b>Assumptions</b></h3>

We are assuming that you have installed your preferred TURN server and created an account on the TURN server for use by your XMPP server users and that you have installed and configured Tigase XMPP Server.<br>

At the end of the article there is a short guide hot to quickly setup CoTURN server.<br>

<h3><b>Enabling external service discovery <i>(required only for Tigase XMPP Server 8.1.0 and earlier)</i></b></h3>

First you need to edit <mark style="background-color&#x3a; &num;f5f2f0;">etc/config.tdsl</mark> file and:<br>
<ol start="1">
<li><b>Add following line in the main section of the file:</b></li><br>
<mark style="background-color&#x3a; &num;f5f2f0;">ext-disco&apos; () &#123;&#125;</mark>
<br><br>
<li><b>Add following line in the <mark style="background-color&#x3a; &num;f5f2f0;">sess-man</mark> section of the file:</b></li><br>
<mark style="background-color&#x3a; &num;f5f2f0;">ext-disco&apos; () &#123;&#125;</mark>
</ol>
so that your config file would look like this:<br>
<pre>
&#8217;ext-disco&#8217; ()
 {
  }
&#8217;sess-man&#8217; () {
    &#8217;urn:xmpp:extdisco:2&#8217; () {}
    ...
}
...
</pre>

<h3><b>Start Tigase XMPP Server</b></h3>
After applying changes mentioned above, you need to start Tigase XMPP Server or, in case if it was running, restart it.

<h3><b>Open Admin UI</b></h3>

Open web browser and head to <mark style="background-color&#x3a; &num;f5f2f0;">http://&lt;your-xmpp-server-and-port&gt;/admin/</mark> (for example: <a href="https://localhost:8080" style="color:#5a66e8;" target="_blank">https://localhost:8080</a>). When promped, log in by providing admin user credentials: bare JID (i.e.: <mark style="background-color&#x3a; &num;f5f2f0;">user@domain</mark>) as the user and related password. Afterwards you&#8217;ll see main Web AdminUI screen:

<center><img src="{{ site.url }}assets/img/blog/web-admin-main-page.png" style="width:50%;"><br><br></center><br>

and on that screen open <b>Configuration</b> group on the left by clicking on it.

<h3><b>Add external TURN service</b></h3>

After opening <b>Configuration</b> group (1) click on <b>Add New Item</b> (2) position which has <b>ext-disco@...</b> in its subtitle.<br>

In the opened form you need to provide following detail:<br>

<center><img src="{{ site.url }}assets/img/blog/web-admin-add-new-turn-item.png" style="width:50%;"><br><br></center><br>

<ul>
<li>Service - ID of the service which will be used for identification by Tigase XMPP Server (ie. turn@example.com)</li>
<li>Service name - name of the service which may be presented to the user (ie. TURN server)</li>
<li>Host - fully qualified domain name of the TURN server or its IP address (ie. turn.example.com)</li>
<li>Port - port at which TURN server listens (ie. 3478)</li>
<li>Type - type of the server, enter turn</li>
<li>Transport - type of transport used for communication with the server udp or tcp (usually udp)</li>
<li>Requires username and password - for notifying XMPP client that this service requires its username and password for XMPP service (leave unchecked)</li>
<li>Username - username required for authentication for TURN server (ie. turn-user)</li>
<li>Password - password required for authentication for TURN server (ie. turn-password)</li>

</ul>
After filling out the form, press Submit button (3) to send form and add a TURN server to external services for your server.<br> Admin UI will 
confirm that service was added with the following result<br>

<center><img src="{{ site.url }}assets/img/blog/web-admin-add-new-item-confirmation.png" style="width:50%;"><br><br></center><br>

<h3><b>Add external STUN service</b></h3>

While adding a TURN server is usually all what you need, in some cases you may want to allow your users to use also STUN. Steps are quite similar like on TURN server - after opening <b>Configuration</b> group (1) click on <b>Add New Item</b> (2) position which has <b>ext-disco@...</b> in its subtitle and in the opened form you need to provide following detail:

<center><img src="{{ site.url }}assets/img/blog/web-admin-add-new-stun-item.png" style="width:50%;"><br><br></center><br>

<ul>
<li>Service - ID of the service which will be used for identification by Tigase XMPP Server (ie. stun@example.com)</li>
<li>Service name - name of the service which may be presented to the user (ie. STUN server)</li>
<li>Host - fully qualified domain name of the STUN server or its IP address (ie. stun.example.com)</li>
<li>Port - port at which TURN server listens (ie. 3478)</li>
<li>Type - type of the server, enter turn</li>
<li>Transport - type of transport used for communication with the server udp or tcp (usually udp)</li>
<li>Requires username and password - for notifying XMPP client that this service requires its username and password for XMPP service (leave unchecked)</li>
<li>Username - username required for authentication for STUN server (if required)</li>
<li>Password - password required for authentication for STUN server (if required)</li>

</ul>

<h3><b>Note</b></h3>

If you are using the same server for STUN and TURN (you usually will as TURN servers usually contain STUN functionality) you will fill the following form with almost the same details *(only use different <b>Service</b> field value, <b>Type</b> will be stun and most likely you will skip passing <b>Username</b> and <b>Password</b> - leaving them empty, the rest of the field values will be the same).<br>

After filling out the form, press Submit button (3) to send form and add a STUN server to external services for your server. Admin UI will confirm that service was added with the following result

<center><img src="{{ site.url }}assets/img/blog/web-admin-add-new-item-confirmation.png" style="width:50%;"><br><br></center><br>

<h3><b>And now what?</b></h3>

Now you have fully configured your STUN/TURN server for usage with Tigase XMPP Server allowing XMPP clients connected to your server and compatible with <a href="https://xmpp.org/extensions/xep-0215.html" style="color:#5a66e8;" target="_blank">XEP-0215: External Service Discovery</a> to take full advantage of your STUN/TURN server ie. by providing better VoIP experience.

<h3><b>CoTURN installation</b></h3>

You can quickly setup CoTURN server using Docker. Please follow Docker installation on your operating system and then install CoTURN using <a href="https://hub.docker.com/r/instrumentisto/coturn" style="color:#5a66e8;" target="_blank">Docker Hub</a> (instrumentisto/coturn). The bare minimum required to run it looks like that (please update realm with your domain and external-ip with IP on which server should be accessible):

<mark style="background-color&#x3a; &num;f5f2f0;">sudo docker run --name coturn -d --network=host --restart always  instrumentisto/coturn -n --log-file=stdout --min-port=49160 --max-port=49200 --realm=awesomexmpp.net --external-ip=&lt;external_ip&gt; -a'</mark><br>

Subsequently, add user to CoTURN with password and domain:<br>

<mark style="background-color&#x3a; &num;f5f2f0;">sudo docker exec -i -t coturn turnadmin -a -u tigase -r awesomexmpp.net -p Ajbk7Ck38nIobLVl</mark>