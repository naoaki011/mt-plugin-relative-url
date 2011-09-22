#MTRelativeURL 1.01


The built-in URL tags, such as MTEntryPermalink or MTArchiveLink create canonical URLs in the form of http://www.domain.com/blog/index.htm and http://www.domain.com/blog/archives/Photos.htm. Sometimes it is convenient to use relative URLs in the form of index.htm and archives/Photos.htm. This plugin contains tags and a filter that allow you to build relative URLs.

`MTRelativeURLVersion`

+ Return the version number of the MTRelativeURL plugin.

`MTRelativeURLBase`

- Container tag that let's you specify the URL of the current document. This allows the other MTRelativeURL tags to create URLs that are relative to this page. If no MTRelativeURLBase is specified, URLs will be created relative to the blog server.
- For example, in an archive template, you should specify the URL of the current document like so:
    
    
        <MTRelativeURLBase><$MTArchiveLink$></MTRelativeURLBase>
    
    
`MTRelativeURL`

+ Container tag that converts its contents into a relative URL, if possible. The URL will be relative to MTRelativeURLBase, if specified. Otherwise it will be relative to the blog server (i.e. it will begin with "/").
+ For example, in an index template, you could have relative links to individual entries like so:
    
    
        <MTEntries>
            <a href="<MTRelativeURL><MTEntryPermalink></MTRelativeURL>"><MTEntryTitle></a>
            <br />
        </MTEntries>
    
    
`relative_url="1"`

+ The relative_url attribute converts the contents of a URL tag to a relative path, similar to the MTRelativeURL tag.
+ The same example as before, using this filter would look like so:
    
    
        <MTEntries>
            <a href="<MTEntryPermalink relative_url="1">"><MTEntryTitle></a>
            <br />
        </MTEntries>
    
    
##About Links and URLs

When an HTML tag contain a link attribute (such as the href attribute in an a tag or the src attribute of an img tag) the URL in the link attribute can be either absolute (starting with the protocol, such as "http://"), relative to the server's root directory (startting with "/") or relative to the document in which it is located (starting with anything else).

An absolute link is independent of the server or the document in which it is located. The URL http://www.domain.com/blog/index.htm always refers to the same document.

A link that's relative to the server's root directory will be located on the server where the document that contains it is located, independent of where on the server the document that contains it is. For example, the following link:

<a href="/blog/index.htm">Link</a>

will refer to http://www.domain.com/blog/index.htm from within any document on www.domain.com. It will refer to http://www.nonplus.net/blog/index.htm from within any document on www.nonplus.net.

Finally, a link that is relative to a document will depend on the server as well as the location of the document that contains it. For example, the following link:

<a href="index.htm">Link</a>

will refer to http://www.nonplus.net/index.htm within all documents located in the root directory of www.nonplus.net. The same link will refer to http://www.nonplus.net/blog/index.htm from all documents located in the blog directory of www.nonplus.net.
