# os-website

Step by Step Tutorial for adding Blog

=======
Posts
=======

Blog posts live in a folder called _posts. The filename for posts have a special format: the publish date, then a title, followed by an extension.

Create your first post at _posts/2020-09-04-beagleim-4.0-and-siskin-6.0-released.md with the following content:

---
layout: post
title:  "BeagleIM 4.0 and SiskinIM 6.0 released"
date:   September 04, 2020
image: assets/img/blog/b4.png
categories: jekyll update
tags: ["release", "beagleIM", "siskinIM", "MIX", "VOIP", "Jingle"]
texttag : New versions of XMPP clients for Apple&#8217;s mobile and desktop platforms
---
New versions of XMPP clients for Apple&#8217;s mobile and desktop platforms have been released. The biggest change is introduction of XMPP MIX - the modern way of chatting in groups (if you are looking for a server where you can use this new feature be sure to check our<a href="" style="color:#5a66e8;" target="_blank"> xmpp.cloud installation</a>). It also significantly improves on audio/video calls.

<h3><b>Common changes</b></h3>
<h3>New XEPs:</h3>
<ul>
<li>Added support for <a href="https://xmpp.org/extensions/xep-0369.html" style="color:#5a66e8;" target="_blank">XEP-0369: Mediated Information eXchange (MIX)</a> - significant improvement over group chats offered by MUC - less traffic and better delivery</li>
<li>Improved VoIP connectivity by adding <a href="https://xmpp.org/extensions/xep-0353.html" style="color:#5a66e8;" target="_blank">XEP-0353: Jingle Message Initiation</a> (now compatible with Jingle Message Initiation used by Conversations)</li>
<li>Added support for <a href="https://xmpp.org/extensions/xep-0308.html" style="color:#5a66e8;" target="_blank">XEP-0308: Last Message Correction</a> - editing sent message (relies on client compatibility)</li>
<li>Added support for <a href="https://xmpp.org/extensions/xep-0424.html" style="color:#5a66e8;" target="_blank">XEP-0424: Message Retraction</a> - deleting sent messages (relies on client compatibility)</li>
<li>Added support for quick replies - quoting messages to improve conversation flow</li>
<li>Added support for <a href="https://xmpp.org/extensions/xep-0158.html#register" style="color:#5a66e8;" target="_blank">XEP-0158: CAPTCHA Forms: Extended In-Band Registration</a> - some server may ask for additional information or verification during registration - with this feature it&#8217;s possible to sign up with those servers as well</li>
</ul>
---------------------------------------

=======
Layout
=======

The post layout already exists at _layout/post.html; It has the format similar to the below mentioned code:

{% include head.html %}
<section class="wrapper bg-soft-primary">
    <div class="container pt-10 pb-19 pt-md-14 pb-md-20 text-center">
        <div class="row">
            <div class="col-md-10 col-xl-8 mx-auto">
                <div class="post-header">

                   
                    <h1 class="display-1 mb-4">{{page.title}}</h1>
                    <ul class="post-meta mb-5">
                        <li class="post-date"><i class="uil uil-calendar-alt"></i><span>{{ page.date | date: "%b %d, %Y" }}</span></li>

                    </ul>
                    
                </div>
               
            </div>
           
        </div>
        
    </div>
   
</section>

<section class="wrapper bg-light">
    <div class="container pb-14 pb-md-16">
        <div class="row">
            <div class="col-lg-10 mx-auto">
                <div class="blog single mt-n17">
                    <div class="card">
                        <div class="card-body">
                            {{ content }}
                        </div>
                    </div>
                    
                </div>
                
            </div>
            
        </div>
      
    </div>
    
</section>

{% include footer.html %}

------------------------------------------------
==========
List posts
==========

There’s currently no way to navigate to the blog post. Typically a blog has a page which lists all the posts, let’s do that next.

Jekyll makes posts available at site.posts.

Create blog.html in your root (_include/blog.html) with the following content:

<div class="row">
            {% for post in site.posts %}
            <div class="col-md-4" style="padding:0 0%;">
                <div class="item">
                    <div class="item-inner">
                        <article>
                            <div class="card" style="border:0; box-shadow:0 0;">
                                <figure class="card-img-top overlay overlay1 hover-scale">
                                    <a href="{{ post.url }}"> <img src="{{ post.image }}" alt="" /></a>
                                    <figcaption>
                                        <h5 class="from-top mb-0">Read More</h5>
                                    </figcaption>
                                </figure>
                               
                                <div class="card-body">
                                    <div class="post-header">
                                        <ul class="post-meta d-flex mb-0">
                                            <li class="post-date"><i class="uil uil-calendar-alt"></i><span>{{ post.date | date: '%B %d, %Y' }}</span></li>

                                        </ul>
                                       
                                        <h2 class="post-title h3 mt-1 mb-3"><a class="link-dark" href="{{ post.url }}">{{ post.title }}</a></h2>

                                    </div>
                                    
                                    <div class="post-content">
                                        <p>{{post.texttag}} . . .</p>
                                    </div>
                                    
                                </div>
                              
                            </div>
                            
                        </article>
                        
                    </div>
                   
                </div>
            </div>
            {% endfor %}
        </div>
		

Post.url is automatically set by Jekyll to the output path of the post
post.title is pulled from the post filename and can be overridden by setting title in front matter
